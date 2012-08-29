def sync_epo
  
  DBI.connect('dbi:ODBC:DRIVER=FreeTDS;TDS_Version=8.0;SERVER=SERVERNAME;DATABASE=DBNAME;Port=1433;uid=USERNAME;pwd=PASSWORD;') do |db|
  
    query = "
    SELECT 	LOWER([EPOComputerProperties].[IPHostName]) AS fqdn,
     	      [EPOComputerProperties].[CPUSpeed] AS cpu_speed,
            [EPOComputerProperties].[CPUType] AS ep_cpu_type,
            ([EPOComputerProperties].[TotalPhysicalMemory]/1024/1024 -
     	       [EPOComputerProperties].[FreeMemory]/1024/1204) AS mem_used,
           	[EPOComputerProperties].[IPV4x] AS ip_int,
           	[EPOComputerProperties].[NetAddress] AS mac,
           	[EPOComputerProperties].[NumOfCPU] AS cpu_count,
           	[EPOComputerProperties].[OSBitMode] AS os_64,
           	[EPOComputerProperties].[OSType] AS ep_os_type,
           	[EPOComputerProperties].[OSServicePackVer] AS ep_os_sp,
           	[EPOComputerProperties].[OSVersion] AS ep_os_version,
            [EPOComputerProperties].[TotalPhysicalMemory]/1024/1024 AS mem_total,
           	[EPOComputerProperties].[UserName] as ep_last_logged_on,
           	[EPOLeafNode].[LastUpdate] as ep_last_update,
           	[EPOComputerProperties].[TotalDiskSpace] as total_disk,
           	[EPOComputerProperties].[FreeDiskSpace] as free_disk,
            [EPOProdPropsView_VIRUSCAN].[DATVer] AS ep_dat_version
     	FROM    [EPOLeafNode]
     		LEFT JOIN [EPOProdPropsView_VIRUSCAN]
     		ON        [EPOLeafNode].[AutoID] = [EPOProdPropsView_VIRUSCAN].[LeafNodeID]
     			LEFT JOIN [EPOComputerProperties]
     			  ON        [EPOLeafNode].[AutoID] = [EPOComputerProperties].[ParentID]
     	WHERE (
     	      ([EPOLeafNode].[ParentID] IN (
     		SELECT  [EndAutoID]
     		FROM    [EPOBranchNodeEnum]
     		WHERE   [StartAutoID] = N'534' UNION SELECT N'534'))
     	OR    ([EPOLeafNode].[ParentID] IN (
     		SELECT  [EndAutoID]
   			FROM    [EPOBranchNodeEnum]
   			WHERE   [StartAutoID] = N'506' UNION SELECT N'506'))
     	OR    ([EPOLeafNode].[ParentID] IN (
     		SELECT  [EndAutoID]
   			FROM    [EPOBranchNodeEnum]
   			WHERE   [StartAutoID] = N'2554' UNION SELECT N'2554'))
   		OR    ([EPOLeafNode].[ParentID] IN (
     		SELECT  [EndAutoID]
   			FROM    [EPOBranchNodeEnum]
   			WHERE   [StartAutoID] = N'2497' UNION SELECT N'2497'))
   		OR    ([EPOLeafNode].[ParentID] IN (
     		SELECT  [EndAutoID]
   			FROM    [EPOBranchNodeEnum]
   			WHERE   [StartAutoID] = N'2556' UNION SELECT N'2556'))
 			OR    ([EPOLeafNode].[ParentID] IN (
     		SELECT  [EndAutoID]
   			FROM    [EPOBranchNodeEnum]
   			WHERE   [StartAutoID] = N'2618' UNION SELECT N'2618'))
   		) 
   		AND [EPOComputerProperties].[IPHostName] <> ''
   		AND [EPOComputerProperties].[IPHostName] LIKE '%.%.%'
    "
    
    dat_query = "
    SELECT CAST(LEFT(ProductVersion, 4) AS INT) AS dat_version
    FROM EPOMasterCatalog
    WHERE ProductName = 'DAT'
    "
    
    row = db.select_one(dat_query)
    current_dat_version = row.to_h["dat_version"].to_i if row

    db.select_all(query) do |row|
      r = row.to_h
      
      ep_os_version = r.delete("ep_os_version")
      
      r["cpu_name"] = r.delete("ep_cpu_type").gsub(/Quad-Core |\(r\)|\(tm\)|CPU|@|Processor|\d\.\d\dGhz/i, '').squeeze(" ")
      
      if ep_os_type = r.delete("ep_os_type")
        if ep_os_type[/Windows/]
          r["os_name"] = "Windows"
          r["os_vendor"] = "Microsoft"
          r["os_version"] = ep_os_type[/(2000|2003|2008|XP)/i, 1]
          if r["os_version"] == "2008" && ep_os_version == "6.1"
            r["os_version"] = "2008 R2"
          end
        end
      end
     
      r["ep_dat_version"] = r["ep_dat_version"].to_i
      
      r["os_sp"] = r.delete("ep_os_sp")[/service pack (\d)/i, 1]
      
      r["last_logged_on"] = r.delete("ep_last_logged_on")[/([^\\]+)$/, 1]
      
      r["ep_dat_outdated"] = current_dat_version - r["ep_dat_version"] if current_dat_version
      
      
      r["in_epo"] = true
      computer = Computer.find_or_create_by_fqdn(r["fqdn"])
      computer.update_attributes(r)
    end
  end
end
