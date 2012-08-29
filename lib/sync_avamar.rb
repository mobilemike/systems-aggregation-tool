def sync_avamar
  [['RMRSERVERNAME', 'FVE%'], ['FVESERVERNAME', '/RMR%']].each do |host|
    DBI.connect("dbi:Pg:database=DBNAME;host=#{host[0]};port=5555", 'USERNAME', 'PASSWORD') do |db|

      query = "
      SELECT
        lower(a.client_name) AS fqdn,
        regexp_replace(dataset, '/', '') AS av_dataset,
        retention_policy AS av_retention,
        schedule AS av_schedule,
        started_ts AS av_started_at,
        completed_ts AS av_completed_at,
        num_of_files AS av_file_count,
        bytes_scanned/1024/1204 AS av_scanned,
        bytes_new/1024/1024 AS av_new,
        bytes_modified/1024/1024 AS av_modified,
        bytes_excluded/1024/1024 AS av_excluded,
        bytes_skipped/1024/1024 AS av_skipped,
        num_files_skipped AS av_file_skipped_count,
        status_code_summary AS av_status,
        error_code_summary AS av_error
      FROM v_activities_2 AS a
      INNER JOIN (
        SELECT v_activities_2.cid, MAX(v_activities_2.completed_ts) AS recent_completed_ts
        FROM v_activities_2
        WHERE (v_activities_2.type LIKE '%Backup%') AND
          (expiration_ts >= extract( epoch from now()) OR
          expiration_ts is null) AND
          (client_name like '%.%.%')
        GROUP BY v_activities_2.cid) AS b
      ON (a.cid = b.cid AND a.completed_ts = b.recent_completed_ts)
      INNER JOIN v_clients_2 AS c
      ON a.cid = c.cid
      WHERE (c.full_domain_name NOT LIKE '#{host[1]}')
        AND (c.full_domain_name NOT LIKE '/MC_RETIRED%')
        AND (c.enabled = TRUE)
      "
  
      db.select_all(query) do |row|
        r = row.to_h
        
        r["in_avamar"] = true
        computer = Computer.find_or_create_by_fqdn(r["fqdn"])
        computer.update_attributes(r)
      end
      
    end
  end
  
end