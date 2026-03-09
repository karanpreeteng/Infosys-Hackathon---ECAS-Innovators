public class WeatherAlertsSync {
    public static void syncDisasterData(String hazardJSON) {
        List<TornadoAlert> alerts = (List<TornadoAlert>) JSON.deserialize(hazardJSON, List<TornadoAlert>.class);
        if(alerts != null && alerts.size()>0){
            List<Case> lastCase = new List<Case>();
            for(TornadoAlert alert : alerts){
                Case c = new case();
                c.Origin ='Automation';
                c.Description =alert.description;
                c.Disaster_Zipcode__c =alert.zipCodes;
                c.Priority ='High';
                c.Subject =alert.headline;
                c.Type=alert.event;
                lastCase.add(c);
                
            }
            if(lastCase.size()>0){
                Insert lastCase;
            }
        }
        
    }
    public class TornadoAlert {
        public String description { get; set; }
        public String effective { get; set; }
        public String expires { get; set; }
        public String severity { get; set; }
        public String certainty { get; set; }
        public String urgency { get; set; }
        public String event { get; set; }
        public String headline { get; set; }
        public String zipCodes { get; set; }
    }
}