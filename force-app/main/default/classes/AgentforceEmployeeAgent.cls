@RestResource (urlMapping='/AgentAPIDefault/*')
global class AgentforceEmployeeAgent {
    @HttpPost
    global static void invokeAgentAPI(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<String, Object> responseMap = new Map<String, Object>();
        
        String requestBody = req.requestBody.toString();
        Map<String, Object> payloadMap = (Map<String, Object>)JSON.deserializeUntyped(requestBody);
        
        String userMessage = (String)payloadMap.get('userMessage');
        String sessionId;
        if(payloadMap.containsKey('sessionId')){
            sessionId = (String)payloadMap.get('sessionId');
        }
        
        Invocable.Action action = Invocable.Action.createCustomAction('generateAiAgentResponse', 'Copilot_for_Salesforce');
        action.setInvocationParameter('userMessage', userMessage);
        if(sessionId != null) {
            action.setInvocationParameter('sessionId', sessionId);
        }
        
        List<Invocable.Action.Result> results = action.invoke();
        Invocable.Action.Result result = results[0];
        //string apexFormat = apexFormat.formatLeadData(String.valueOf(result.getOutputParameters().get('sessionId')));
        
        if(result.isSuccess()){
            responseMap.put('sessionId', result.getOutputParameters().get('sessionId'));
            responseMap.put('agentResponse', result.getOutputParameters().get('agentResponse'));
            //responseMap.put('apexFormat', apexFormat);
            res.statusCode = 200;
        }
        else{
            responseMap.put('error', result.getErrors());
            res.statusCode = 500;
        }
        res.responseBody = Blob.valueOf(JSON.serialize(responseMap));
    }
    
}