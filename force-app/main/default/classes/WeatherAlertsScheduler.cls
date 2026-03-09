global class WeatherAlertsScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        try {
            Datetime tomorrow = Datetime.now().addDays(1);
            
            // Format in ISO8601 UTC (e.g., 2026-03-09T04:07:39Z)
            String tomorrowStr = tomorrow.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            String endpoint = 'https://api.weather.gov/alerts?severity=Extreme&urgency=Future&certainty=Possible&limit=5&start=' + EncodingUtil.urlEncode(tomorrowStr, 'UTF-8');
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Accept', 'application/ld+json');
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            if (res.getStatusCode() == 200) {
                // System.debug('Weather Alerts: ' + res.getBody());
                ConnectApi.WrappedValue inputValueMapSubject = new ConnectApi.WrappedValue();
                inputValueMapSubject.value = res.getBody();
                
                //Add Prompt input variables to a Map
                Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();        
                inputParams.put('Input:Hazard', inputValueMapSubject);
                
                
                //Invoke the Prompt 
                String response = PromptUtils.invokePrompt('Get_Future_Hazard_Info', inputParams);
                if(response != null && !response.containsIgnoreCase('null')){
                    System.debug('My Full List as JSON: ' + JSON.serialize(response));
                    WeatherAlertsSync.syncDisasterData(response);
                }
                
            } else {
                System.debug('Error Fetching Weather Alerts: ' + res.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }
}