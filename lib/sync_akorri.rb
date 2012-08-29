def sync_akorri
  DBI.connect('dbi:Mysql:DBNAME:SERVERNAME', 'USERNAME', 'PAASSWORD') do |db|
    
    query = "
    SELECT ct.alarmState AS health_ak_cpu,
           ct.lastUpdate AS ak_cpu_last_modified,
           st.alarmState AS health_ak_storage,
           st.lastUpdate AS ak_storage_last_modified,
           mt.alarmState AS health_ak_mem,
           mt.lastUpdate AS ak_mem_last_modified,
           s.osType AS ak_os_type,
           s.osVersion AS ak_os_version,
           s.serverType AS ak_server_type,
           s.memoryAmount AS mem_total,
           s.swapAmount AS mem_swap,
           s.numCPUs AS cpu_count,
           s.cpuSpeed AS cpu_speed,
           LOWER(eah.host) AS fqdn,
           LOWER(s.hostname) AS ak_esx_fqdn,
           sgs.percentCpuReady AS cpu_ready,
           sgs.memReservation AS mem_reservation,
           sgs.cpuReservation AS cpu_reservation,
           sgs.memBalloonKB / 1024 AS mem_balloon,
           sgs.memUsedTotal	AS mem_vm_host_used,
           sgs.vcpuUsed AS vcpu_used,
           sgs.vcpuEfficiency AS vcpu_efficiency
      FROM      Server s
      LEFT JOIN Trend st
        ON      st.objectId = s.serverId
      LEFT JOIN Trend ct
        ON      ct.objectId = s.serverId
      LEFT JOIN Trend mt
        ON      mt.objectId = s.serverId
      LEFT JOIN ElementAccessHandle eah
        ON      s.name = eah.elementAccessHandleName
      LEFT JOIN ServerGuestStats sgs
        ON      sgs.serverId = s.serverId
        AND     sgs.timestamp = (SELECT MAX(TIMESTAMP) FROM ServerGuestStats sgs WHERE sgs.timeScale = 0 AND sgs.serverId = s.serverId)
        AND     sgs.timescale = 0
      WHERE     s.serverType != 6
        AND     st.type=3
        AND     mt.type=2
        AND     ct.type=1
      GROUP BY s.serverId
    "

    db.select_all(query) do |row|
      r = row.to_h
      
      ak_esx_fqdn = r.delete("ak_esx_fqdn")
    
      case r.delete("ak_os_type")
        when 1 || 7
          r["os_name"] = "Linux"
        when 3
          r["os_name"] = "Windows"
          r["os_vendor"] = "Microsoft"
        when 6 
          r["os_name"] = "ESX"
          r["os_vendor"] = "VMware"
          r["fqdn"] = ak_esx_fqdn
      end
      
      if ak_os_version = r.delete("ak_os_version")
        r["os_version"] = ak_os_version[/(^\d\.\d\.\d.*|2008 R2|200[0|3|8]|XP)/i, 1]
        r["os_edition"] = ak_os_version[/(standard|enterprise|datacenter)/i, 1]
        r["os_sp"] = ak_os_version[/sp\s(\d)/i, 1]
      end

      case r.delete("ak_server_type")
        when 1
          r["guest"] = false
          r["host"] = false
        when 2
          r["guest"] = false
          r["host"] = true
        when 3 || 6
          r["guest"] = true
          r["host"] = false
      end
      
      r["in_akorri"] = true
      computer = Computer.find_or_create_by_fqdn(r["fqdn"])
      computer.update_attributes(r)
    end
  end
end

# 2.6.18-128.1.6.el5
# 2.6.18-6-686-bigmem
# 2.6.24-19-server
# 2.6.26.8-57.fc8
# 2.6.32-31-server
# 2.6.9-67.ELsmp
# 2000 Server - SP 4 (5.0.2195)
# 3.0.2 Build-77863
# 3.5.0 Build-226117
# 4.1.0 Build-260247
# 4.1.0 Build-348481
# Server 2003, Enterprise Edition - SP 2 (5.2.3790)
# Server 2003, Standard Edition - SP 2 (5.2.3790)
# Server 2008 Enterprise without Hyper-V - SP 1 (6.0.6001)
# Server 2008 Enterprise without Hyper-V - SP 2 (6.0.6002)
# Server 2008 R2 Datacenter - SP 1 (6.1.7601)
# Server 2008 R2 Enterprise -  (6.1.7600)
# Server 2008 R2 Enterprise - SP 1 (6.1.7601)
# Server 2008 R2 Standard -  (6.1.7600)
# Server 2008 Standard without Hyper-V - SP 2 (6.0.6002)
# XP Professional - SP 2 (5.1.2600)
# XP Professional - SP 3 (5.1.2600)
# XP Professional - SP 3, v.5938 (5.1.2600)
# XP Professional - SP 3, v.6055 (5.1.2600)