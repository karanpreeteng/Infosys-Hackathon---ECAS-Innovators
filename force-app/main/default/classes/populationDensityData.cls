public class populationDensityData {
    
    @InvocableMethod
    public static List<String> syncPopulationData(List<String> zipCode) {
        String API_KEY ='fb22b98b2af5421fa066239d46bee573';
        List<String> responses = new List<String>();
        String EndpointURL = 'https://global.metadapi.com/zipc/v1/zipcodes/'+zipCode[0];
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(EndpointURL);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Ocp-Apim-Subscription-Key', API_KEY);
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            // Create Prompt Input Parameter Variables
            ConnectApi.WrappedValue inputValueMapSubject = new ConnectApi.WrappedValue();
            inputValueMapSubject.value = res.getBody();
            
            //Add Prompt input variables to a Map
            Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();        
            inputParams.put('Input:Population_Info', inputValueMapSubject);
            
            
            //Invoke the Prompt 
            String response = PromptUtils.invokePrompt('populationDensity', inputParams);
            responses.add(response); 
        }
        return responses;
    }
    
}