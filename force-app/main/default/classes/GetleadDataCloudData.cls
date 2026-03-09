public class GetleadDataCloudData {
    @InvocableMethod
    public static List<String> syncDisasterData(List<String> abc) {
        List<ssot__Lead__dlm> leadDataCloud= [SELECT Id, KQ_Id__c, rel_1757006130576_end__c, ssot__AnnualRevenue__c, ssot__City__c, ssot__ConvertedDate__c, ssot__CountryId__c, ssot__CreatedDate__c, ssot__DataSourceId__c, 
                                              ssot__DataSourceObjectId__c, ssot__Description__c, ssot__Id__c, ssot__IndustryId__c, ssot__LastModifiedDate__c, 
                                              ssot__Lead_PartnerAccountId_map_Account_Id_N_1__c, ssot__Lead_PartyId_map_Party_Id_N_1__c, ssot__LeadSourceId__c, ssot__StateProvinceId__c, ssot__Title__c FROM ssot__Lead__dlm];
        List<String> leadDataCloudCount = new List<String>();
        for(ssot__Lead__dlm ss: leadDataCloud){
            leadDataCloudCount.add(ss.ssot__LeadSourceId__c +'-'+ss.ssot__StateProvinceId__c+'-'+ss.ssot__Title__c);
        }
        
        return leadDataCloudCount;
    }
}