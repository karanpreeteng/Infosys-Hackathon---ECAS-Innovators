public class FEMASync {
    public static void syncDisasterData() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.fema.gov/api/open/v2/DisasterDeclarationsSummaries');
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            // Parse JSON response
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            List<Object> disasters = (List<Object>) results.get('DisasterDeclarationsSummaries');
            //InvokeDataCloud
            syncDataInDataCloud(disasters);
        }
    }
    
    public static void syncDataInDataCloud(List<Object> disasters) {
        // Define the Ingestion API endpoint (replace with your actual endpoint)
        String endpoint = 'https://CDP2-AWS-PROD8-CACENTRAL1.ingestion.api.salesforce.com/v1/streams/FEMA_DisasterDeclaration/data';
        
        // Prepare payload for Data Cloud
        List<Map<String, Object>> payload = new List<Map<String, Object>>();
        for (Object disaster : disasters) {
            Map<String, Object> record = (Map<String, Object>) disaster;
            payload.add(new Map<String, Object>{
                'county__c' => record.get('designatedArea'),
                    'declarationDate__c' => record.get('declarationDate'),
                    'declarationType__c' => record.get('declarationType'),
                    'disasterNumber__c' => record.get('disasterNumber'),
                    'incidentBeginDate__c' => record.get('incidentBeginDate'),
                    'incidentEndDate__c' => record.get('incidentEndDate'),
                    'incidentType__c' => record.get('incidentType'),
                    'lastRefresh__c' => record.get('lastRefresh'),
                    'programDeclared__c' => record.get('paProgramDeclared'),
                    'state__c' => record.get('state')
                    });
        }
        
        // Serialize the payload to JSON
        String jsonBody = JSON.serialize(payload);
        
        // Set up the HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId()); // Use session ID for simplicity
        req.setBody(jsonBody);
        
        // Send the HTTP request
        Http http = new Http();
        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                System.debug('Data sent successfully: ' + res.getBody());
            } else {
                System.debug('Error: ' + res.getStatusCode() + ' - ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }
    
}