public class apexFormat {
    
    public static String formatLeadData(String jsonString) {
        // Deserialize the JSON string into a Map
        Map<String, Object> leadData = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        String valueString = (String) leadData.get('value');
        
        // Initialize a map to store key-value pairs
        Map<String, String> structuredData = new Map<String, String>();
        
        // Split the value string into lines and parse key-value pairs
        for (String line : valueString.split('\n')) {
            if (line.startsWith('- ')) {
                List<String> parts = line.replace('- ', '').split(': ', 2);
                if (parts.size() == 2) {
                    structuredData.put(parts[0].trim(), parts[1].trim());
                }
            }
        }
        
        // Format the output dynamically
        String formattedOutput = 'Lead Data Summary:\n\n';
        for (String key : structuredData.keySet()) {
            String value = structuredData.get(key);
            // Apply special formatting for specific fields
            if (key.contains('date') || key.contains('Date')) {
                value = formatDateTime(value);
            } else if (key.contains('revenue') || key.contains('Revenue')) {
                try {
                    Decimal revenue = Decimal.valueOf(value);
                    value = '$' + String.valueOf(revenue.format());
                } catch (Exception e) {
                    // Keep original value if not a number
                }
            }
            formattedOutput += key + ': ' + value + '\n';
        }
        
        return formattedOutput;
    }
    
    // Helper method to format ISO 8601 datetime to a more readable format
    private static String formatDateTime(String isoDateTime) {
        if (String.isBlank(isoDateTime)) return '';
        try {
            Datetime dt = (Datetime) JSON.deserialize('"' + isoDateTime + '"', Datetime.class);
            return dt.format('yyyy-MM-dd hh:mm:ss a');
        } catch (Exception e) {
            return isoDateTime; // Return original if not a valid datetime
        }
    }
    
    // Example usage
    public static void printFormattedLeadData(String jsonInput) {
        try {
            String formattedText = formatLeadData(jsonInput);
            System.debug(formattedText);
        } catch (Exception e) {
            System.debug('Error formatting lead data: ' + e.getMessage());
        }
    }
    
    // Test method for demonstration
    public static void testDynamicFormatting() {
        String jsonInput = '{"type":"Text","value":"Here is the summary of the lead data retrieved from the Data Cloud:\\n\\n- Data timestamp: 12:45:04:324\\n- Variable assignment: leadDataCloud\\n- City: Burlington\\n- Data source object type: Lead\\n- Record ID: 00QgK000000ObbOUAS\\n- Last modified date: 2025-06-06T00:13:32.000Z\\n- Data source ID: Salesforce_Home\\n- Annual revenue: 350000000\\n- Created date: 2025-03-28T21:59:24.000Z\\n- Lead source: Web"}';
        
        printFormattedLeadData(jsonInput);
        
        // Test with different dynamic content
        String dynamicJsonInput = '{"type":"Text","value":"Here is the summary of the lead data retrieved from the Data Cloud:\\n\\n- Name: John Doe\\n- Email: john.doe@example.com\\n- Close Date: 2025-12-01T15:30:00.000Z\\n- Revenue: 500000\\n- Status: Open"}';
        
        printFormattedLeadData(dynamicJsonInput);
    }
    
}