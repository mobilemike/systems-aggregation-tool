def sync_wsus_sonesta

  DBI.connect('dbi:ODBC:DRIVER=FreeTDS;TDS_Version=8.0;SERVER=SERVERNAME;DATABASE=DBNAME;uid=USERNAME;pwd=PASSWORD;') do |db|
  
    approved_hash = Hash.new
    guids = []
  
    guids << all_computers_guid = 'A0A08746-4DBE-4A37-9ADF-9E7652C0B421'
  
    guids.each do |guid|
      query = "exec spRMRGetSummariesPerComputer @updateScopeXml=N'<?xml version=\"1.0\" encoding=\"utf-16\"?><UpdateScope ApprovedStates=\"-1\" UpdateTypes=\"-1\" FromArrivalDate=\"01-01-1753 00:00:00.000\" ToArrivalDate=\"12-31-9999 23:59:59.997\" IncludedInstallationStates=\"-1\" ExcludedInstallationStates=\"0\" IsWsusInfrastructureUpdate=\"0\" FromCreationDate=\"01-01-1753 00:00:00.000\" ToCreationDate=\"12-31-9999 23:59:59.997\" UpdateApprovalActions=\"-1\" UpdateSources=\"1\" ExcludeOptionalUpdates=\"0\"><UpdateApprovalScope><ComputerTargetGroups><TargetGroupID>#{guid}</TargetGroupID></ComputerTargetGroups></UpdateApprovalScope></UpdateScope>',@preferredCulture=N'en',@computerTargetScopeXml=N'<?xml version=\"1.0\" encoding=\"utf-16\"?><ComputerTargetScope FromLastSyncTime=\"01-01-1753 00:00:00.000\" ToLastSyncTime=\"12-31-9999 23:59:59.997\" FromLastReportedStatusTime=\"01-01-1753 00:00:00.000\" ToLastReportedStatusTime=\"12-31-9999 23:59:59.997\" IncludedInstallationStates=\"109\" ExcludedInstallationStates=\"0\" ComputerTargetGroups=\"&lt;root&gt;&lt;TargetGroupID&gt;#{guid}&lt;/TargetGroupID&gt;&lt;/root&gt;\" IncludeSubgroups=\"1\" IncludeDownstreamComputerTargets=\"1\" />',@apiVersion=204800"
      approved_hash.merge!(Hash[*db.select_all(query).flatten])
    end
  
    query = "
    SELECT
      ct.FullDomainName AS fqdn,
      ct.LastSyncTime AS us_last_sync,
      ct.LastReportedRebootTime AS boot_time,
      ct.IPAddress AS ip,
      ct.ComputerID AS us_computer_hash,
      ctd.OSMajorVersion AS us_os_major,
      ctd.OSMinorVersion AS us_os_minor,
      ctd.OSServicePackMajorNumber AS os_sp,
      ctd.ComputerMake AS make,
      ctd.ComputerModel AS model,
      ctd.BiosVersion AS bios_ver,
      ctd.BiosName AS bios_name,
      ctd.BiosReleaseDate AS bios_date,
      csmu.Unknown AS us_unknown,
      csmu.NotInstalled AS us_not_installed,
      csmu.Downloaded AS us_downloaded,
      csmu.Installed AS us_installed,
      csmu.Failed AS us_failed,
      csmu.InstalledPendingReboot AS us_pending_reboot,
      tg.Name AS us_group_name
    FROM
      tbComputerTarget AS ct
      LEFT OUTER JOIN tbComputerTargetDetail AS ctd ON ct.TargetID = ctd.TargetID
      LEFT OUTER JOIN tbComputerSummaryForMicrosoftUpdates AS csmu ON ct.TargetID = csmu.TargetID 
      LEFT OUTER JOIN tbExpandedTargetInTargetGroup AS ettg ON ct.TargetID = ettg.TargetID
      JOIN tbTargetGroup AS tg ON ettg.TargetGroupID = tg.TargetGroupID
    WHERE
      ettg.IsExplicitMember = 1
      AND tg.ParentGroupID = '#{all_computers_guid}'
    "
  
    db.select_all(query) do |row|
      r = row.to_h
      
      us_os_major = r.delete("us_os_major")
      us_os_minor = r.delete("us_os_minor")
      
      r["os_version"] = case us_os_major
      when 5
        case us_os_minor
        when 0 then "2000"
        when 1 then "XP"
        when 2 then "2003"
        end
      when 6
        case us_os_minor
        when 0 then "2008"
        end
      end
      
      r["os_vendor"] = "Microsoft"
      r["os_name"] = "Windows"
      
      r["us_approved"] = approved_hash[r.delete("us_computer_hash")] || 0
    
      r["in_wsus"] = true
      computer = Computer.find_or_create_by_fqdn(r["fqdn"])
      computer.update_attributes(r)
    end

  end
end
