def sync_row_idc(r)
  
  if vm_os = r.delete("vm_os")
    case vm_os
    when /64/i
      r["os_64"] = true
    when /ubuntu/i
      r["os_vendor"] = "Ubuntu"
    when /rhel/i
      r["os_vendor"] = "RedHat"
    when /2000/i
      r["os_version"] = "2000"
    when /xppro/i
      r["os_version"] = "XP"
    when /netenterprise/i
      r["os_version"] = "2003"
      r["os_edition"] = "Enterprise"
    when /netstandard/i
      r["os_version"] = "2003"
      r["os_edition"] = "Standard"
    end
  end
  
  if vm_os_family = r.delete("vm_os_family")
    case vm_os_family
    when /windows/
      r["os_vendor"] = "Microsoft"
      r["os_name"] = "Windows"
    when /linux/
      r["os_name"] = "Linux"
    end
  end
  
  if vm_host_fqdn = r.delete("vm_host_fqdn")
    r["host_computer_id"] = Computer.find_or_create_by_fqdn(vm_host_fqdn).id
  end
  
  if vm_cpu_type = r.delete("vm_cpu_type")
    r["cpu_name"] = vm_cpu_type.gsub(/Quad-Core |\(r\)|\(tm\)|CPU|@|Processor|\d\.\d\dGhz/i, '').squeeze(" ")
  end
  

  computer = Computer.find_or_create_by_fqdn(r["fqdn"])
  computer.update_attributes(r)
end

def sync_vcenter_idc

  DBI.connect('dbi:ODBC:DRIVER=FreeTDS;TDS_Version=8.0;SERVER=SERVERNAME;DATABASE=DBNAME;Port=62684;uid=USERNAME;pwd=PASSWORD;') do |db|

    query_guests = "
    SELECT  VPX_VM.POWER_STATE AS power,
            VPX_VM.GUEST_OS AS vm_os,
            VPX_VM.GUEST_FAMILY AS vm_os_family,
            VPX_VM.MEM_SIZE_MB AS mem_total,
            VPX_VM.NUM_VCPU AS cpu_count,
            LOWER(VPX_VM.DNS_NAME) AS fqdn,
            VPX_VM.IP_ADDRESS AS ip,
            VPX_VM.TOOLS_STATUS AS health_vm_vtools,
            VPX_VM.TOOLS_VERSION AS vtools_ver, 
            VPX_VM.BOOT_TIME AS boot_time,
            LOWER(VPX_HOST.DNS_NAME) AS vm_host_fqdn,
            VPX_HOST.CPU_MODEL AS vm_cpu_type,
            1 AS guest
    FROM    VPX_VM
            JOIN VPX_HOST
              ON VPX_VM.HOST_ID = VPX_HOST.ID
    WHERE   VPX_VM.IS_TEMPLATE = 0
            AND VPX_VM.DNS_NAME LIKE '%.%.%'
    "

    query_hosts = "
      SELECT  LOWER(VPX_HOST.DNS_NAME) AS fqdn,
              VPX_HOST.IP_ADDRESS AS ip,
              VPX_HOST.HOST_MODEL AS model,
              VPX_HOST.CPU_MODEL AS vm_cpu_type,
              VPX_HOST.BOOT_TIME AS boot_time,
              1 AS host
      FROM    VPX_HOST
    ORDER BY  VPX_HOST.DNS_NAME
    "

    db.select_all(query_guests) do |row|
      r = row.to_h
      r["in_esx"] = true
      
      sync_row_idc(r)
    end

    db.select_all(query_hosts) do |row|
      sync_row_idc(row.to_h)
    end

  end
end