def sync_wsus

  DBI.connect('dbi:ODBC:DRIVER=FreeTDS;TDS_Version=8.0;SERVER=SERVERNAME;DATABASE=DBNAME;uid=USERNAME;pwd=PASSWORD;') do |db|
  
    approved_hash = Hash.new
    guids = []
  
    servers_guid = '8F14C327-7CBF-4BA3-845C-965CE55EE770'
    guids << servers_test_guid = 'CFC2E992-FC44-4A44-B837-9A089E02FC51'
    guids << servers_neverrelease_guid = '772A5C14-CC5A-469B-939B-4F53987DF115'
    guids << servers_timberline_guid = '3BCAC581-B7E5-49AA-8603-53E469EB348A'
    guids << servers_sun2am_guid = '6A4C99D6-77C1-4873-A6E8-9223B58EFC7B'
    guids << servers_tue2am_guid = 'EBB4B0DA-EB51-4342-9B8A-932D056F9BD5'
    guids << servers_manual_guid = '5BB8CF27-3828-4C4E-9F15-9244B3A823E2'
    guids << servers_3rdmon2am_guid = 'B08F3412-CF2A-4506-97DD-F184112815DC'
    guids << servers_mon2am_guid = '75D60F77-DCCC-4A21-BCF4-77059C60418E'
  
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
      AND (tg.ParentGroupID = '#{servers_guid}'
        OR tg.TargetGroupID = '#{servers_neverrelease_guid}'
        OR tg.TargetGroupID = '#{servers_timberline_guid}')
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


# All Computers           A0A08746-4DBE-4A37-9ADF-9E7652C0B421
#   Unassigned Computers    B73CA6ED-5727-47F3-84DE-015E03F6A88A
#   Downstream Servers      D374F42A-9BE2-4163-A0FA-3C86A401B7A7
#   Servers - NeverRelease  772A5C14-CC5A-469B-939B-4F53987DF115
#   Servers - Timberline    3BCAC581-B7E5-49AA-8603-53E469EB348A
#   Servers                 8F14C327-7CBF-4BA3-845C-965CE55EE770
#     Servers - Mon 2AM       75D60F77-DCCC-4A21-BCF4-77059C60418E
#     Servers - Sun 2AM       6A4C99D6-77C1-4873-A6E8-9223B58EFC7B
#     Servers - Manual        5BB8CF27-3828-4C4E-9F15-9244B3A823E2
#     Servers - Tue 2AM       EBB4B0DA-EB51-4342-9B8A-932D056F9BD5
#     Servers - Test          CFC2E992-FC44-4A44-B837-9A089E02FC51
#     Servers - 3rdMon 2AM    B08F3412-CF2A-4506-97DD-F184112815DC