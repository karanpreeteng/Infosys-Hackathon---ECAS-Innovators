public with sharing class SlackMessagePost {

    @InvocableMethod(label='Post Slack Message' description='Posts a message to a specific Slack channel and returns success status')
    public static List<Boolean> postMessageToSlack(List<SlackMessageRequest> requests) {
        List<Boolean> results = new List<Boolean>(); // To store success/failure for each request
        String hardcodedChannelId = 'C0AK115A9D1'; // Hardcoded Channel ID

        for (SlackMessageRequest request : requests) {
            Boolean isSuccess = false; // Default to false
            try {
                //String endpoint = 'https://slack.com/api/chat.postMessage';
                String endpoint = 'https://slack.com/api/chat.postMessage';
                HttpRequest req = new HttpRequest();
                req.setEndpoint(endpoint);
                req.setMethod('POST');
                req.setHeader('Authorization', 'Bearer xoxp-10657024347844-10647036556883-10637989308295-ec5dbc6f4a6dd1d2083bf15059073e76'); // Replace with a secure token in production
                req.setHeader('Content-Type', 'application/json; charset=utf-8');
                req.setHeader('scope', 'chat:write:bot');
                //"scope": "chat:write"

                // Construct the request body with the hardcoded channel ID
                String body = JSON.serializePretty(new Map<String, Object>{
                    'channel' => hardcodedChannelId,
                    'text' => request.messageText
                });
                req.setBody(body);

                // Send the request and capture the response
                HttpResponse res = new Http().send(req);
                Map<String, Object> responseBody = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
System.debug('1**'+responseBody);
                // Check if the response indicates success
                if (responseBody.containsKey('ok') && (Boolean)responseBody.get('ok') == true) {
                    isSuccess = true; // Message sent successfully
                } else if (responseBody.containsKey('error')) {
                    System.debug('Slack API Error for channel ' + hardcodedChannelId + ': ' + responseBody.get('error'));
                }

            } catch (Exception ex) {
                System.debug('Error occurred: ' + ex.getMessage());
                // isSuccess remains false if an exception occurs
            }
            results.add(isSuccess); // Add the success status for this request
        }

        return results; // Return the list of results
    }

    // Define the input class for Invocable Apex
    public class SlackMessageRequest {
        @InvocableVariable(required=true label='Message Text' description='The message to post in Slack')
        public String messageText;
    }
}