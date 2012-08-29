def sync_wsus_fve

  DBI.connect('dbi:ODBC:DRIVER=FreeTDS;TDS_Version=8.0;SERVER=SERVERNAME;DATABASE=DBNAME;uid=USERNAME;pwd=PASSWORD;') do |db|
  
    approved_hash = Hash.new
    guids = ['422E8ABE-B310-4ECD-8889-276918AC61EA','D5EA5F7E-E4DC-41C9-AA0F-3099EA6B7153',
             'D2F97BD2-AABB-482B-8B91-42E65A674883','FF39E677-A2D3-443D-B83F-5852A41826BB',
             '3DD0F891-8617-442A-A834-6044A5C5E863','9AE387B6-8A34-4CF7-B934-6DEE86D2F928',
             'F51C71B6-9768-464B-BBEB-7F8A58064CB3','C849EE38-BED8-4A0A-B30D-99F6100D219E',
             'A0A08746-4DBE-4A37-9ADF-9E7652C0B421','FE932B86-2C70-4E51-B8AA-A774D1BCB5E8',
             'F95E076C-D280-4CAF-B933-AAA150F8E67F','DD99DA39-310F-4100-8DAD-BC9E14636062',
             '2747E0D6-EEE5-45B5-9738-C2C686AC2D70']
    guids_string = guids.map {|guid| "'#{guid}'"}.join(',')
    
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
      CAST(ctd.BiosReleaseDate AS date) AS bios_date,
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
      AND tg.TargetGroupID IN (#{guids_string})
      AND ct.FullDomainName LIKE '%.%.%'
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
        when 1 then "7"
        end
      end
      
      
      r["us_approved"] = approved_hash[r.delete("us_computer_hash")] || 0
    
      r["in_wsus"] = true
      pc = Pc.find_or_create_by_fqdn(r["fqdn"])
      pc.update_attributes(r)
    end

  end
end


# B73CA6ED-5727-47F3-84DE-015E03F6A88A  Unassigned Computers
#   422E8ABE-B310-4ECD-8889-276918AC61EA  8a_All - KIOSKs
#   D5EA5F7E-E4DC-41C9-AA0F-3099EA6B7153  7_MD_to_MN - Workstations
#   D2F97BD2-AABB-482B-8B91-42E65A674883  4_MA - Workstations
#   FF39E677-A2D3-443D-B83F-5852A41826BB  9_TN_to_WY - Workstations
#   3DD0F891-8617-442A-A834-6044A5C5E863  6_GA_to_LA - Workstations
#   9AE387B6-8A34-4CF7-B934-6DEE86D2F928  2_Test - Laptops
#   F51C71B6-9768-464B-BBEB-7F8A58064CB3  5a_Computers - All Others
#   C849EE38-BED8-4A0A-B30D-99F6100D219E  1_Test - Workstations
#   A0A08746-4DBE-4A37-9ADF-9E7652C0B421  All Computers
#   FE932B86-2C70-4E51-B8AA-A774D1BCB5E8  5_AL_to_DE - Workstations
#   F95E076C-D280-4CAF-B933-AAA150F8E67F  3_Test - KIOSKs
#   DD99DA39-310F-4100-8DAD-BC9E14636062  8_NV_to_SC - Workstations
#   2747E0D6-EEE5-45B5-9738-C2C686AC2D70  9a_All - Laptops