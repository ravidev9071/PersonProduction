public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String direction) {
        String query = 'SELECT Name ,Phone,AccountNumber,Description,AnnualRevenue,AccountSource,CreatedDate ' +
                       'FROM Account ' +
                       'ORDER BY Name ' + direction;
        List<Account> accounts = Database.query(query);
        return accounts;
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getContactsByAccountId(String searchkey) {
    
         string searchKeyword = '%' + searchkey + '%';

      list<Account> accList = new list<Account>();
     
	  
        for(Account conObj : [SELECT Name ,Phone,AccountNumber,Description,AnnualRevenue,AccountSource,CreatedDate 
                       FROM Account  
                       Where Name LIKE : searchKeyword])
                       {
           accList.add(conObj);
        }
        
      return accList;  
         
        
    }
      @AuraEnabled(cacheable=true)
   public static List<Contact> displayAccounts(){
       return [select Id,LastName,Department,IsRecall__c from Contact];
   }
   @AuraEnabled
   public static List<Contact> updateRecord(String accId){
       System.debug('@@@@AccountId@@@'+accId);
       Contact acc=[select Id,LastName,Department,IsRecall__c from Contact where Id=:accId];
       acc.Department='Approved';
       acc.LastName=acc.LastName+' updated';
       acc.IsRecall__c=false;
       try{
           update acc;
       }
	   catch (Exception e) {
           System.debug('unable to update the record due to'+e.getMessage());
       }
       return displayAccounts();
   }
}