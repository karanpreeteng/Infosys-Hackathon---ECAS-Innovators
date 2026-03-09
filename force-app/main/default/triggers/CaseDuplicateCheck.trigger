trigger CaseDuplicateCheck on Case (before insert) {
 
   // Collect Pin Codes and Hazard Types from incoming records
  Set<String> pinCodes = new Set<String>();
  Set<String> hazardTypes = new Set<String>();
 
   for (Case c : Trigger.new) {
       if (c.Disaster_Zipcode__c!= null && c.Type!= null) {
          pinCodes.add(c.Disaster_Zipcode__c);
          hazardTypes.add(c.Type);
       }
   }
 
   if (pinCodes.isEmpty() || hazardTypes.isEmpty()) return;
 
   // Query existing original (non-duplicate) cases with matching fields
   Map<String, Case> existingCaseMap = new Map<String, Case>();
 
   for (Case c : [
       SELECT Id, Disaster_Zipcode__c, Type,parentid
       FROM Case
       WHERE Disaster_Zipcode__c IN :pinCodes
         AND Type IN :hazardTypes
         AND isDuplicate__c = false
       ORDER BY CreatedDate ASC
   ]) {
       String key = c.Disaster_Zipcode__c + '|' + c.Type;
       if (!existingCaseMap.containsKey(key)) {
          existingCaseMap.put(key, c);
       }
   }
 
   // Mark duplicates and assign parent
   for (Case newCase : Trigger.new) {
     //  if (newCase.Disaster_Zipcode__c == null || newCase.Type ==
//null) continue;
 
       String key = newCase.Disaster_Zipcode__c + '|' + newCase.Type;
 
       if (existingCaseMap.containsKey(key)) {
          newCase.isDuplicate__c = true;
          newCase.ParentId = existingCaseMap.get(key).Id;
          newCase.status = 'Closed-Duplicate';
         // newCase.Duplicate_Of__c = existingCaseMap.get(key).Id;
       }
   }
}