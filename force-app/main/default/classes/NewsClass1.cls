public class NewsClass1 {
    public static List<RSSObjData> getGoogleRSSObjects(String theUrl) {
        List<RSSObjData> returnList = new List<RSSObjData>();
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();        
        req.setEndpoint(theUrl);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        
        Dom.Document doc = res.getBodyDocument();
        Dom.XMLNode feed = doc.getRootElement();
        String namespace = feed.getNamespace();
        
        for(Dom.XMLNode child : feed.getChildElements()) {
            if(child.getName() == 'entry') {
                RSSObjData returnListItem = new RSSObjData(
                    child.getChildElement('title', namespace).getText().unescapeHtml4(),
                    child.getChildElement('link', namespace).getAttribute('href', ''),                    
                    child.getChildElement('content', namespace).getText().unescapeHtml4(),
                    child.getChildElement('published', namespace).getText()
                );
                System.debug(returnListItem);
                returnList.add(returnListItem);
            }
            System.debug(returnList);
        }
        return returnList;        
    }
}