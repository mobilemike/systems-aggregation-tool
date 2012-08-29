def sync_sccm

  DBI.connect('dbi:ODBC:DRIVER=FreeTDS;TDS_Version=8.0;SERVER=SERVERNAME;DATABASE=DBNAME;Port=65193;uid=USERNAME;pwd=PASSWORD;') do |db|

    query = "
    SELECT 
          LOWER(RS.Name0 + '.' + GSS.Domain0) AS fqdn,
          GSCS.CurrentTimeZone0 AS time_zone_offset,
          GSCS.Manufacturer0 AS make,
          GSCS.Model0 AS model,
          GSCS.NumberOfProcessors0 AS cpu_count,
          GSOS.Caption0 AS cm_os_name, 
          GSOS.CSDVersion0 AS cm_os_sp,
          GSOS.InstallDate0 AS install_date,
          GSOS.LastBootUpTime0 AS boot_time,
          GSOS.TotalVirtualMemorySize0 AS mem_swap,
          GSOS.TotalVisibleMemorySize0 AS mem_total,
          GSPCB.SerialNumber0 AS serial_number,
          GSP.MaxClockSpeed0 AS cpu_speed,
          GSNAC.IPAddress0 AS cm_ip,
          GSNAC.DHCPEnabled0 AS dhcp,
          GSNAC.IPSubnet0 AS cm_subnet_mask,
          GSNAC.DefaultIPGateway0 as cm_default_gateway,
          GSNAC.MACAddress0 AS cm_mac,
          AD.AgentTime as cm_last_heartbeat
          FROM v_R_System AS RS
          JOIN v_GS_COMPUTER_SYSTEM AS GSCS
            ON RS.ResourceID = GSCS.ResourceID
          JOIN v_GS_OPERATING_SYSTEM AS GSOS
            ON RS.ResourceID = GSOS.ResourceID
          JOIN v_GS_PC_BIOS AS GSPCB
            ON RS.ResourceID = GSPCB.ResourceID
          JOIN v_GS_PROCESSOR AS GSP
            ON RS.ResourceID = GSP.ResourceID
          JOIN v_GS_SYSTEM AS GSS
            ON RS.ResourceID = GSS.ResourceID
          OUTER APPLY (SELECT TOP 1 AgentTime
                       FROM v_AgentDiscoveries AS AD
                       WHERE AD.AgentName = 'Heartbeat Discovery'
                         AND RS.ResourceID = AD.ResourceId
                       ORDER BY AgentTime DESC) AS AD
          OUTER APPLY (SELECT TOP 1 IPAddress0, DHCPEnabled0, IPSubnet0, DefaultIPGateway0, MACAddress0
                       FROM v_GS_NETWORK_ADAPTER_CONFIGUR AS GSNAC
                       WHERE IPAddress0 LIKE '10.%'
                         AND RS.ResourceID = GSNAC.ResourceID
                       ORDER BY GSNAC.IPAddress0) AS GSNAC
          OUTER APPLY (SELECT TOP 1 System_OU_Name0
                       FROM System_System_OU_Name_ARR AS SSOU
                       WHERE RS.ResourceID = SSOU.ItemKey
                       ORDER BY SSOU.System_OU_Name0 DESC) AS SSOU
          WHERE ISNULL(RS.Obsolete0, 0) <> 1 AND ISNULL(RS.Decommissioned0, 0) <> 1 AND RS.Client0 = 1
          AND GSP.DeviceID0 = 'CPU0'
          AND GSS.Domain0 IS NOT NULL
"
  
    db.select_all(query) do |row|
      r = row.to_h
      
      # if cm_cpu_name = r.delete("cm_cpu_name")
      #   r["cpu_name"] = cm_cpu_name.gsub(/Quad-Core |\(r\)|\(tm\)|CPU|@|Processor|\d\.\d\dGhz/i, '').squeeze(" ").strip
      # end
            
      if cm_mac = r.delete("cm_mac")
        r["mac"] = cm_mac.gsub(':','')
      end
      
      if cm_os_name = r.delete("cm_os_name")
        r["os_version"] = cm_os_name[/ (2008 R2|200[0|3|8]|XP|7)/i, 1]
        r["os_edition"] = cm_os_name[/(standard|enterprise|professional|ultimate|datacenter)/i, 1]
      end
      
      if cm_os_sp = r.delete("cm_os_sp")
        r["os_sp"] = cm_os_sp[/service pack (\d)/i, 1]
      end
      
      if cm_ip = r.delete("cm_ip")
        r["ip"] = cm_ip.split(", ").grep(/([1-9]|[1-9][0-9]|[1-9][0-9][0-9]).\d{1,3}\.\d{1,3}\.\d{1,3}/).first
      end
      
      if cm_subnet_mask = r.delete("cm_subnet_mask")
        r["subnet_mask"] = cm_subnet_mask.split(", ").grep(/([1-9]|[1-9][0-9]|[1-9][0-9][0-9]).\d{1,3}\.\d{1,3}\.\d{1,3}/).first
      end
      
      if cm_default_gateway = r.delete("cm_default_gateway")
        r["default_gateway"] = cm_default_gateway.split(", ").grep(/([1-9]|[1-9][0-9]|[1-9][0-9][0-9]).\d{1,3}\.\d{1,3}\.\d{1,3}/).first
      end
      
      r["in_sccm"] = true
      pc = Pc.find_by_fqdn(r["fqdn"])
      
      pc.update_attributes(r) if pc
    end

  end
end

# Microsoft Windows 2000 Professional
# Microsoft Windows 2000 Server
# Microsoft Windows 7 Enterprise
# Microsoft Windows 7 Professional
# Microsoft Windows 7 Ultimate
# Microsoft Windows Server 2008 R2 Enterprise
# Microsoft Windows Server 2008 R2 Standard
# Microsoft Windows XP Professional
# Microsoft(R) Windows(R) Server 2003, Enterprise Edition
# Microsoft(R) Windows(R) Server 2003, Standard Edition
# Microsoft® Windows Server® 2008 Enterprise without Hyper-V
# Microsoft® Windows Server® 2008 Standard without Hyper-V
