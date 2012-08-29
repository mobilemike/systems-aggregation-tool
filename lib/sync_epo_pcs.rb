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
           	[EPOComputerProperties].[OSType] AS ep_os_type,
           	[EPOComputerProperties].[OSServicePackVer] AS ep_os_sp,
            [EPOComputerProperties].[TotalPhysicalMemory]/1024/1024 AS mem_total,
           	[EPOComputerProperties].[UserName] as ep_last_logged_on,
           	[EPOLeafNode].[LastUpdate] as ep_last_update,
           	[EPOComputerProperties].[TotalDiskSpace] as disk_total,
           	[EPOComputerProperties].[FreeDiskSpace] as disk_free,
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
     		WHERE   [StartAutoID] = N'2413' UNION SELECT N'2413'))
     	OR    ([EPOLeafNode].[ParentID] IN (
     		SELECT  [EndAutoID]
   			FROM    [EPOBranchNodeEnum]
   			WHERE   [StartAutoID] = N'214' UNION SELECT N'214'))
     	OR    ([EPOLeafNode].[ParentID] IN (
     		SELECT  [EndAutoID]
   			FROM    [EPOBranchNodeEnum]
   			WHERE   [StartAutoID] = N'210' UNION SELECT N'210'))
   		OR    ([EPOLeafNode].[ParentID] IN (
     		SELECT  [EndAutoID]
   			FROM    [EPOBranchNodeEnum]
   			WHERE   [StartAutoID] = N'556' UNION SELECT N'556'))
   		OR    ([EPOLeafNode].[ParentID] IN (
     		SELECT  [EndAutoID]
   			FROM    [EPOBranchNodeEnum]
   			WHERE   [StartAutoID] = N'114' UNION SELECT N'114'))
 			OR    ([EPOLeafNode].[ParentID] IN (
     		SELECT  [EndAutoID]
   			FROM    [EPOBranchNodeEnum]
   			WHERE   [StartAutoID] = N'215' UNION SELECT N'215'))
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
      
      r["cpu_name"] = r.delete("ep_cpu_type").gsub(/Quad-Core |\(r\)|\(tm\)|CPU|@|Processor|\d\.\d\dGhz/i, '').squeeze(" ")
      
      if ep_os_type = r.delete("ep_os_type")
        if ep_os_type[/Windows/]
          r["os_version"] = ep_os_type[/(2000|2003|2008|XP|7)/i, 1]
        end
      end
     
      r["ep_dat_version"] = r["ep_dat_version"].to_i
      
      r["os_sp"] = r.delete("ep_os_sp")[/service pack (\d)/i, 1]
      
      r["last_logged_on"] = r.delete("ep_last_logged_on")[/([^\\]+)$/, 1]
      
      r["ep_dat_outdated"] = current_dat_version - r["ep_dat_version"] if current_dat_version
      
      
      r["in_epo"] = true
      pc = Pc.find_or_create_by_fqdn(r["fqdn"])
      pc.update_attributes(r)
    end
  end
end
