def sync_wsus_rmr
  
  DBI.connect('dbi:ODBC:DRIVER=FreeTDS;TDS_Version=8.0;SERVER=SERVERNAME;DATABASE=DBNAME;uid=USERNAME;pwd=PASSWORD;') do |db|

    approved_hash = Hash.new
    guids = ['E6B9511A-EF9B-4A26-94C3-0F1731A31B01', '025F5CF0-B81F-4E9B-AF03-39226A12E324',
             'A7741FCF-94B3-443C-B2AE-5016A5FEC66C', '75A59D90-4F0F-4FC4-94CD-AA42955EB857',
             '74B7E3B4-648D-49BF-86E4-C50DA6DAECC2', '39CE7295-43E1-44C1-9C23-C977E7E65EEC',
             '1F7F3266-7A05-4962-B74A-D44C6F80BDFC']
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


# A0A08746-4DBE-4A37-9ADF-9E7652C0B421  All Computers
#   B73CA6ED-5727-47F3-84DE-015E03F6A88A  Unassigned Computers
#   E6B9511A-EF9B-4A26-94C3-0F1731A31B01  PC - Manual
#   025F5CF0-B81F-4E9B-AF03-39226A12E324  KIOSK - Test
#   A7741FCF-94B3-443C-B2AE-5016A5FEC66C  PC - Laptop
#   75A59D90-4F0F-4FC4-94CD-AA42955EB857  Laptop - Test
#   74B7E3B4-648D-49BF-86E4-C50DA6DAECC2  PC - Desktop
#   39CE7295-43E1-44C1-9C23-C977E7E65EEC  PC - KIOSK
#   1F7F3266-7A05-4962-B74A-D44C6F80BDFC  PC - Test