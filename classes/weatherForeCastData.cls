public class weatherForeCastData {
    @InvocableMethod
    public static List<Response> syncDisasterData(List<String> zipCode) {
        List<Response> responses = new List<Response>();
        
        String EndpointURL = 'http://api.weatherstack.com/current?access_key=643f1bf1b69113c0554dfa789ca38d78&query='+zipCode[0];
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(EndpointURL);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            // Create Prompt Input Parameter Variables
            ConnectApi.WrappedValue inputValueMapSubject = new ConnectApi.WrappedValue();
            inputValueMapSubject.value = res.getBody();
            
            //Add Prompt input variables to a Map
            Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();        
            inputParams.put('Input:Weather_Info', inputValueMapSubject);
            
            
            //Invoke the Prompt 
            String response = PromptUtils.invokePrompt('Get_Weather_Data', inputParams);
            Response resp = new Response();
            resp.weatherData = response;
            
            responses.add(resp); 
        }
        return responses;
    }
    
    public class Response {
        @InvocableVariable
        public String weatherData;
        
    }
}