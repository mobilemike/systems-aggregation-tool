def sync_scom

  DBI.connect('dbi:ODBC:DRIVER=FreeTDS;TDS_Version=8.0;SERVER=SERVERNAME;DATABASE=DBNAME;Port=1433;uid=USERNAME;pwd=PASSWORD;') do |db|

    query = "
    SELECT
      MTC.BaseManagedEntityID AS sc_bme,
      MTC.IPAddress AS sc_ip,
      MTC.LogicalProcessors AS cpu_count,
      LOWER (MTC.DNSName) AS fqdn,
      CAST(SV.HealthState AS INT) AS health_sc_state,
      MTVHP.Model_A14810C3_AA91_31C4_6864_D897E7B7BE48 AS model,
      MTVHP.SerialNumber_A14810C3_AA91_31C4_6864_D897E7B7BE48 AS serial_number,
      MTVHP.SystemFirmware_A14810C3_AA91_31C4_6864_D897E7B7BE48 AS sc_bios_ver,
      MTVHP.ManagementVersion_A14810C3_AA91_31C4_6864_D897E7B7BE48 AS sc_hp_mgmt_ver,
      MTVHP.InsightLightsOut_52CCB151_362E_1B40_728E_1E495D3D348B AS sc_ilo_ip,
      MTVOS.InstallDate_66DD9B43_3DC1_3831_95D4_1B03B0A6EA13 AS install_date,
      MTVOS.PhysicalMemory_66DD9B43_3DC1_3831_95D4_1B03B0A6EA13/1024 AS mem_total,
      MTVOS.OSVersionDisplayName_66DD9B43_3DC1_3831_95D4_1B03B0A6EA13 as sc_os_name,
      CAST (FLOOR(MTVOS.ServicePackVersion_66DD9B43_3DC1_3831_95D4_1B03B0A6EA13) AS INT) as os_sp
    FROM MT_Computer MTC WITH (NOLOCK)
    INNER JOIN StateView SV WITH (NOLOCK)
      ON MTC.BaseManagedEntityId = SV.BaseManagedEntityId
    LEFT JOIN dbo.BaseManagedEntity BME WITH (NOLOCK)
      ON BME.BaseManagedEntityId = MTC.BaseManagedEntityId
    LEFT JOIN MTV_HPProLiantServer MTVHP WITH (NOLOCK)
      ON MTC.PrincipalName = MTVHP.PrincipalName
    LEFT JOIN MTV_OperatingSystem MTVOS WITH (NOLOCK)
      ON MTC.PrincipalName = MTVOS.PrincipalName
    WHERE BME.BaseManagedTypeId = 'EA99500D-8D52-FC52-B5A5-10DCD1E9D2BD'
      AND SV.ParentMonitorId IS NULL
      AND (MTC.OrganizationalUnit LIKE '%ou=member servers%'
           OR MTC.OrganizationalUnit LIKE '%ou=domain controllers%')
    "
  
    db.select_all(query) do |row|
      r = row.to_h
      
      if sc_hp_mgmt_ver = r.delete("sc_hp_mgmt_ver")
        r["hp_mgmt_ver"] = sc_hp_mgmt_ver.scan(/([\d\.]+)/).join(' / ')
      end
      
      if sc_os_name = r.delete("sc_os_name")
        r["os_version"] = sc_os_name[/(2008 R2|200[0|3|8]|XP)/i, 1]
        r["os_edition"] = sc_os_name[/(standard|enterprise|datacenter)/i, 1]
        r["os_vendor"] = sc_os_name[/(microsoft)/i, 1]
        r["os_name"] = sc_os_name[/(windows)/i, 1]
      end
      
      if sc_bios_ver = r.delete("sc_bios_ver")
        r["bios_ver"] = sc_bios_ver[/^(\w+)/i, 1]
        r["bios_date"] = sc_bios_ver[/-(.+)$/i, 1]
      end
      
      if sc_ip = r.delete("sc_ip").split(", ").grep(/([1-9]|[1-9][0-9]|[1-9][0-9][0-9]).\d{1,3}\.\d{1,3}\.\d{1,3}/).first
        r["ip"] = sc_ip
      end
      
      if sc_ilo_ip = r.delete("sc_ilo_ip")
        r["ilo_ip"] = sc_ilo_ip unless sc_ilo_ip == "Unavailable"
      end
      
      r["in_scom"] = true
      
      computer = Computer.find_or_create_by_fqdn(r["fqdn"])
      computer.update_attributes(r)
    end

  end
end


# NULL
# Microsoft Windows 2000 Server
# Microsoft Windows Server 2008 R2 Datacenter 
# Microsoft Windows Server 2008 R2 Enterprise 
# Microsoft Windows Server 2008 R2 Standard 
# Microsoft Windows XP Professional
# Microsoft(R) Windows(R) Server 2003, Enterprise Edition
# Microsoft(R) Windows(R) Server 2003, Standard Edition
# Microsoftr Windows Serverr 2008 Enterprise without Hyper-V 
# Microsoftr Windows Serverr 2008 Standard without Hyper-V