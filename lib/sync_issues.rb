require 'nokogiri'

def replace_params(alert_string, alert_params)
  
  alert_string = alert_string || ''
  
  doc = Nokogiri::XML(alert_params)
  
  params = doc.xpath('//AlertParameters').children.children.map {|param| param.to_s}
  
  alert_string.gsub!(/\{.\}/) do |placeholder|
    params[placeholder[/\d/].to_i]
  end
end

def sync_issues

  DBI.connect('dbi:ODBC:DRIVER=FreeTDS;TDS_Version=8.0;SERVER=SERVERNAME;DATABASE=DBNAME;Port=1433;uid=USERNAME;pwd=PASSWORD;') do |db|

    query = "
    SELECT
      LOWER(BME.Name) AS is_fqdn,
      AV.AlertStringName + ': ' + AV.MonitoringObjectDisplayName as identifier,
      AV.Description AS is_description,
      CAST(AV.Severity AS INT) AS sc_severity,
      AV.AlertStringDescription AS is_alert_string,
      AV.AlertParams AS is_alert_params
    FROM [OperationsManager].[dbo].[AlertView] AS AV
    JOIN BaseManagedEntity AS BME ON AV.TopLevelHostEntityId = BME.BaseManagedentityID
    WHERE ResolutionState != 255
      AND BME.BaseManagedTypeId = 'EA99500D-8D52-FC52-B5A5-10DCD1E9D2BD'
      AND MonitoringObjectInMaintenanceMode = 0
    "
    
    issues = []
    
    db.select_all(query) do |row|
       r = row.to_h
       
       description = replace_params(r.delete('is_alert_string'), r.delete('is_alert_params')).try(:split, /\n+/).try(:join, "\n")
       
       r['description'] = description || r.delete('is_description').try(:split, /\n+/).try(:join, "\n")
       r['computer'] = Computer.find_or_create_by_fqdn(r.delete('is_fqdn'))
       r['source'] = 'SCOM'
       r['severity'] = r.delete('sc_severity') + 1

       issues << Issue.find_or_init(r['computer'],
                                    r['severity'],
                                    'SCOM',
                                    r['identifier'],
                                    r['description'])
    end
    
    issues.each {|i| i.update_attributes(:updated_at => Time.now)}
    
  end
  
end