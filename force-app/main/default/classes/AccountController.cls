/**
 * @name AccountController
 * @description 
 *  This Apex controller is used to retrieve and update Account and Contact records.
 *  It supports Lightning components via @AuraEnabled methods.
 * 
 * @author Ravi kumar
 * @date 2025-06-15
 */
public with sharing class AccountController {

    /**
     * @name getAccounts
     * @description 
     *  Returns a list of Accounts ordered by Name in ascending or descending order
     *  based on the input parameter 'direction'.
     *
     * @param direction Sorting direction ('ASC' or 'DESC')
     * @return List<Account> A list of Account records sorted by Name
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String direction) {
        String query = 'SELECT Name, Phone, AccountNumber, Description, AnnualRevenue, AccountSource, CreatedDate ' +
                       'FROM Account ' +
                       'ORDER BY Name ' + direction;
        List<Account> accounts = Database.query(query);
        return accounts;
    }

    /**
     * @name getContactsByAccountId
     * @description 
     *  Returns a list of Accounts where the Name matches the provided search key.
     *  Useful for implementing search/filter functionality.
     *
     * @param searchkey Partial or full name of the Account to search for
     * @return List<Account> A list of matching Account records
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> getContactsByAccountId(String searchkey) {
        String searchKeyword = '%' + searchkey + '%';
        List<Account> accList = new List<Account>();

        for (Account acc : [
            SELECT Name, Phone, AccountNumber, Description, AnnualRevenue, AccountSource, CreatedDate 
            FROM Account  
            WHERE Name LIKE :searchKeyword
        ]) {
            accList.add(acc);
        }
        return accList;      
    }

    /**
     * @name displayAccounts
     * @description 
     *  Returns a list of all Contacts with selected fields: Id, LastName, Department, and IsRecall__c.
     *
     * @return List<Contact> A list of Contact records
     */
    @AuraEnabled(cacheable=true)
    public static List<Contact> displayAccounts() {
        return [SELECT Id, LastName, Department, IsRecall__c FROM Contact];
    }

    /**
     * @name updateRecord
     * @description 
     *  Updates the specified Contact record’s Department, LastName, and IsRecall__c fields.
     *  Then returns the updated list of all Contacts.
     *
     * @param accId The Id of the Contact to update
     * @return List<Contact> A list of Contact records after the update
     */
    @AuraEnabled
    public static List<Contact> updateRecord(String accId) {
        Contact acc = [
            SELECT Id, LastName, Department, IsRecall__c 
            FROM Contact 
            WHERE Id = :accId
        ];
//changed
        acc.Department = 'Approved';
        acc.LastName = acc.LastName + ' updated1';
        acc.LastName = acc.LastName + ' updated';
        acc.IsRecall__c = false;

        try {
            update acc;
        } catch (Exception e) {
            System.debug('Unable to update the record due to: ' + e.getMessage());
        }

        return displayAccounts();
    }
}
