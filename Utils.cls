/**
 * @description       :
 * @author            :
 * @group             :
 * @last modified on  : 05-22-2023
 * @last modified by  : 05-06-2023 Stefano Bassotti ECU_offerCondition__c = "PV_NON_ADERENTE" e offer catalog di tipo cross selling non devono andare in errore
 * @last modified by  : 13-07-2023 Stefano Bassotti RET-23027
 * @last modified by  : 24-08-2023 Stefano Bassotti RET-23027 modificata chiamata a Nexi
 * @last modified by  : 12-09-2023 Stefano Bassotti Hotfix-220 modificata Log
 * @last modified by  : 26-09-2023 Stefano Bassotti RET-23030 Oil non Oil
 * @last modified by  : 10-11-2023 Fabrizio Fiorentini CLU-23018
 * @last modified by  : 22-01-2024 Stefano Bassotti RET-24005 Promo Sanremo
 * @last modified by  : 28-02-2024 Stefano Bassotti RET-23069 CJ con Apple Car Play e Mastercard
 * @last modified by  : 16-02-2024 Stefano Bassotti CLU-23019 pre registrazione wave2 (in prod 17-04-2024)
 * @last modified by  : 20-03-2024 Stefano Bassotti Hotfix-283 Riallineamento Classe
 * @last modified by  : 09-04-2024 Giuseppe Pastore hotfix_293
 **/
global without sharing class Utils{
    public static final String EXCEPTION_CODE = 'EXC';
    public static final String INFO_CODE = 'INF';
    private static Boolean isProd = null;
    private static Map<String, String> kpiMap = null;
    private static Map<Id, Offer_Catalog__c> welOfferCatalogMap1234 = null;
    private static Map<Id, Offer_Catalog__c> welOfferCatalogMapAB = null;
    private static Map<Id, Offer_Catalog__c> mastOfferCatalogMap = null;
    private static Map<String, type_of_voucher__c> voucherTypesMap = null;
    Map<String,ELP_OfferListLoyalty__c> loyOfferMap = ELP_OfferListLoyalty__c.getAll(); //modifiche 19/10/2023 Giuseppe Mario Pastore RET 23033

    private static String crossSelling = null; //Stefano Bassotti 05-06-2023

    //EN: utilizzo Custom Metadata per creare mappa Refuelling Mode -> Range di valori
    @TestVisible
    private static Map<String, String> refuellingModeMap{
        get{

            if (refuellingModeMap == null){

                refuellingModeMap = new Map<String, String>();
                for (Refuelling_Mode_Mapping__mdt mdtRec : [SELECT Refuelling_Mode__c, Refuelling_Mode_Range_Values__c
                                                            FROM Refuelling_Mode_Mapping__mdt]){

                    refuellingModeMap.put(mdtRec.Refuelling_Mode__c, mdtRec.Refuelling_Mode_Range_Values__c);

                }
            }
            return refuellingModeMap;
        }

        set;
    }

    // EN: Mappa RecordTypeDeveloperName+SObjectType=>RecordTypeId
    private static Map<String, Id> recordTypeDeveloperNameToIdMap;
    // EN: Mappa RecordTypeId=>RecordTypeDeveloperName
    private static Map<Id, String> recordTypeIdToDeveloperNameMap;
    //Method that inserts log records in the database
    public static Void generateLogs(List<Log> logObjs, String logType){
        try{

            if (Utils__c.getOrgdefaults().LogEnabled__c || logType == EXCEPTION_CODE){

                //List of Log__c sObject for insert
                List<Log__c> logs = new List<Log__c>();

                //cycles through the list of logs received and adds them to the logs list
                for (Log l : logObjs){
                    Log__c log = new Log__c();
                    log.Level__c = l.Level;
                    log.Origin__c = l.Origin;
                    log.ResultCode__c = l.ResultCode;
                    log.SystemException__c = l.SystemException;
                    log.TransmittedMessage__c = l.TransmittedMessage;
                    log.EventId__c = l.EventId;
                    log.Transaction__c = l.TransactionId;
                    log.EVENT_TYPE__c = l.EventType;
                    log.Fiscal_Code__c = l.FiscalCode;
                    log.Card_Code__c = l.CardCode;
                    log.Product_Type__c = l.ProductType;
                    log.Liters__c = l.Liters;
                    log.Amount__c = l.Amount;
                    log.Total_Points__c = l.TotalPoints;
                    log.Refuelling_Mode__c = l.RefuellingMode;
                    log.Vat_Number__c = l.VatNumber;
                    log.Plate__c = l.Plate;
                    log.Customer_Type__c = l.CustomerType;
                    log.Credit_Card_Type__c = l.CreditCardType;
                    log.ENL_Id_Convenzione_EniParking__c = l.IdConvenzione;
                    log.ECU_Promo_Code__c = l.promoCode;
                    log.ECU_Email__c = l.email;

                    logs.add(log) ;
                }


                //if the generated list of logs isn't empty it inserts the records in the DataBase
                if (!logs.isEmpty()){
                    insert logs;
                }
            }
            if (Test.isRunningTest()){

                throw new ECU_APC_CustomException('Exception');

            }
        } catch (Exception e){
            system.debug('Exception generated in class Utils method generateLogs with error: ' + e.getMessage() + ', line number: ' + e.getLineNumber());
        }
    }

    //Method that inserts 1 log record in the database
    public static Void generateLogs(Log logObj, String logType){
        List<Log> logObjs = new List<Log>();
        logObjs.add(logObj);
        generateLogs(logObjs, logType);
    }

    //Method that sends emails
    public static Void sendMail(String subject, String messageBody, String displayName, String receiver){
        System.debug('send Email function');

        Utils.sendMail(subject, messageBody, displayName, receiver, null);
    }

    //Method that sends emails with CC
    public static Void sendMail(String subject, String messageBody, String displayName, String receiver, String carbonCopy){
        System.debug('send Email with CC function');

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setSenderDisplayName(displayName);
        mail.setSubject(subject);
        mail.setSaveAsActivity(false);
        mail.setPlainTextBody(messageBody);
        mail.setToAddresses(new String[]{ receiver });
        if (!String.isEmpty(carbonCopy)){
            mail.setCcAddresses(new String[]{ carbonCopy });
        }
        System.debug('### MAIL: ' + mail);

        if (!Test.isRunningTest()){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        }
    }

    //Method that sends emails with CC
    public static Void sendMail(String subject, String messageBody, String displayName, String[] receiver, String[] carbonCopy){
        System.debug('send Email with CC function');

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setSenderDisplayName(displayName);
        mail.setSubject(subject);
        mail.setSaveAsActivity(false);
        mail.setPlainTextBody(messageBody);
        mail.setToAddresses(receiver);
        if (carbonCopy != null){
            mail.setCcAddresses(carbonCopy);
        }
        System.debug('### TO: ' + receiver + ' CC: ' + carbonCopy);
        System.debug('### MAIL: ' + mail);

        if (!Test.isRunningTest()){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        }
    }

    public static Void sendMailHTML(String subject, String messageBody, String displayName, String receiver, String carbonCopy){
        System.debug('send Email with CC function');

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setSenderDisplayName(displayName);
        mail.setSubject(subject);
        mail.setSaveAsActivity(false);
        mail.setPlainTextBody(messageBody);
        mail.setHtmlBody(messageBody);
        mail.setToAddresses(new String[]{ receiver });
        if (!String.isEmpty(carbonCopy))
            mail.setCcAddresses(new String[]{ carbonCopy });
        System.debug('### MAIL: ' + mail);

        if (!Test.isRunningTest()){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        }
    }

    /**
     * @author: AM
     * @date: 18/01/2021
     * @description: Metodo che verifica la condizione di un'offerta rispetto una transazione
     * @param t Transazione
     * @param cond Condizione
     * @param c Contatto
     * @param o Offerta attualmente in corso
     * @param writeLog Booleano per inibire scrittura Log
     * @return Boolean
     */
    public static ENL_APC_CheckTransactionWrapper checkTransaction(Transaction__c t, ENL_Condition_Catalog__c cond, Contact c, Offer_Catalog__c o, Boolean writeLog){
        ENL_APC_CheckTransactionWrapper checkObj;
        //EN: gestione log per eleggibilità transazioni

        System.debug('Utils-checkTransaction Inizio Check per Offer Catalog: ' + o.Name);

        Log l = new Log();
        l.Level = 'DEBUG';
        l.Origin = 'Utils.checkTransaction';
        l.EventId = t.EVENT_ID__c;
        l.ResultCode = 'ELIGIBLE';
        l.TransactionId = t.Id;
        l.EventType = t.EVENT_TYPE__c;
        l.TransmittedMessage = JSON.serialize(new Map<String, String>{ 'Transaction_Id' => t.Id, 'Offer Id' => o.Id, 'Offer Name' => o.Name, 'Condition Id' => cond.Id, 'Condition Name' => cond.Name, 'Contact Id' => c.Id, 'Contact Code' => c.Contact_code__c });
        l.fiscalCode = c.Fiscal_code__c; // stefano.bassotti@webresults.it CLU-23019

        /*if (cond.ENL_Service_Category__c != null && t.ENL_Service_Type__c != cond.ENL_Service_Category__c) {
         l.Level = 'DEBUG';
         l.ResultCode = '1';
         l.SystemException = '1 --> Tipologia Servizio differenti:\n ' +
         '(Transaction) ENL_Service_Type__c -> '+t.ENL_Service_Type__c+
         ', (Condition Catalog) ENL_Service_Category__c -> '+cond.ENL_Service_Category__c;
         if (writeLog)
         generateLogs(l, '');
         return false;
         }*/

        // Check su Transazione che non partecipa alla IW e alla Promo Rifornimento
        
        //Inizio modifiche 08/11/2023 Giuseppe Mario Pastore RET 23033
        Boolean isLoyaltyOffer = isLoyaltyOffer(o.Offer_Code__c); 
        Map<String,ELP_LoyaltyCondition__c> promoCondition = ELP_LoyaltyCondition__c.getAll();
        ELP_CustomSettingsConfigurations__c loyaltyCs = ELP_CustomSettingsConfigurations__c.getOrgDefaults();
        List<String> acceptedValues = promoCondition.get(loyaltyCs.Product_Type__c)?.ConditionList__c?.split(',');
        List<String> acceptedParkValues = promoCondition.get('Product_Type_Park')?.ConditionList__c?.split(',');
        List<String> acceptedEventValues = promoCondition.get(loyaltyCs.Product_Type__c)?.Event_Type__c?.split(',');
        Double amount = t.Amount__c != null ? t.Amount__c : 0;
        Double penalita = t.ENL_Importo_Penalita__c != null ? t.ENL_Importo_Penalita__c : 0;
        Double resultAmount = amount - penalita;
        System.debug('resultAmount ************************** ' + resultAmount);
        //Fine modifiche 08/11/2023 Giuseppe Mario Pastore RET 23033

        if (cond.ENL_Payment_Type__c != null && ((t.EniStation_APP_payment__c && cond.ENL_Payment_Type__c == '1') || (!t.EniStation_APP_payment__c && cond.ENL_Payment_Type__c == '0'))){
            l.Level = 'DEBUG';
            l.ResultCode = '2';
            l.SystemException = '2 --> Tipologia pagamento differenti:\n ' + 
                                '(Transaction) EniStation_APP_payment__c -> ' + t.EniStation_APP_payment__c + 
                                ', (Condition Catalog) ENL_Payment_Type__c -> ' + cond.ENL_Payment_Type__c;
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;
            //generateLogs(l, '');
            return checkObj;
        }
        //EN: modificato controllo sull'amount - se amount transazione maggiore dell'end amount definito nella condition
        //04/03/2021
        if (  !(t.Product_Type__c == 'Power' &&  isLoyaltyOffer && resultAmount > cond.ENL_Amount__c ) && //modifiche 12/12/2023 Giuseppe Mario Pastore RET 23033
                (cond.ENL_Amount__c != 0 || cond.ENL_Amount__c != null) &&  !(t.Amount__c >= cond.ENL_Amount__c && t.Amount__c <= cond.ENL_End_Amount__c) //modifiche 09/04/2024 giuseppe Pastore hotfix_293
            ){
            l.Level = 'DEBUG';
            l.ResultCode = '3';
            l.SystemException = '3 --> Amount superiore alla soglia prevista:\n ' + 
                                '(Transaction) Amount__c ->' + t.Amount__c + 
                                '(Condition Catalog) ENL_End_Amount__c ->' + cond.ENL_End_Amount__c + 
                                ', (Condition Catalog) ENL_Amount__c -> ' + cond.ENL_Amount__c;
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;
            //generateLogs(l, '');
            return checkObj;
        }
                //Inizio modifiche 20-09-2023 giuseppemario.pastore@webresults.it RET-23037 - HOTFIX
        if (cond.Payment_mode__c != null && t.EniStation_App_Payment_Mode__c != null){
            List<String> payModeArray = cond.Payment_mode__c.split(';');
            Boolean flag = false;
            for (String paymentMode : payModeArray){
                if (t.EniStation_App_Payment_Mode__c.equalsIgnoreCase(paymentMode))
                    flag = true;
            }
            if(!flag){
                l.Level = 'DEBUG';
                l.ResultCode = '4';
                l.SystemException = '4 --> Modo di pagamento differente:\n ' + 
                                    '(Transaction) EniStation_App_Payment_Mode__c -> ' + t.EniStation_App_Payment_Mode__c + 
                                    ', (Condition Catalog) Payment_Mode__c -> ' + cond.Payment_mode__c;
                checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
                if (writeLog)
                    checkObj.logRecord = l;
                //generateLogs(l, '');
                return checkObj;
            }

        }
        //Fine modifiche 20-09-2023 giuseppemario.pastore@webresults.it RET-23037 - HOTFIX
        if ((cond.ENL_Liters__c != 0 || cond.ENL_Liters__c != null) && t.Liters__c < cond.ENL_Liters__c){
            l.Level = 'DEBUG';
            l.ResultCode = '5';
            l.SystemException = '5 --> Litri inferiori alla soglia prevista:\n ' + 
                                '(Transaction) Liters__c -> ' + t.Liters__c + 
                                ', (Condition Catalog) ENL_Liters__c ->' + cond.ENL_Liters__c;
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;
            //generateLogs(l, '');
            return checkObj;
        }
        if ((cond.ENL_kWh__c != 0 || cond.ENL_kWh__c != null) && t.Kwh__c < cond.ENL_kWh__c){
            l.Level = 'DEBUG';
            l.ResultCode = '6';
            l.SystemException = '6 --> Kwh inferiori alla soglia prevista::\n ' + 
                                '(Condition Catalog) ENL_kWh__c-> ' + cond.ENL_kWh__c + 
                                ', (Transaction) Kwh__c-> ' + t.Kwh__c;
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;
            //generateLogs(l, '');
            return checkObj;
        }
        /*if ((cond.Product_type__c != null) && !cond.Product_type__c.containsIgnoreCase(t.Product_Type__c)){
         l.Level = 'DEBUG';
         l.ResultCode = '7';
         l.SystemException = '7 --> Tipologia Prodotto differente:\n ' +
         '(Condition Catalog) Product_Type__c-> '+cond.Product_type__c +
         ', (Transaction) Product_Type__c-> '+t.Product_Type__c;
         if (writeLog)
         generateLogs(l, '');
         return false;
         }*/
        if ((cond.ENL_Parking_Time__c != 0 || cond.ENL_Parking_Time__c != null) && t.Time__c < cond.ENL_Parking_Time__c){
            l.Level = 'DEBUG';
            l.ResultCode = '8';
            l.SystemException = '8 --> Durata inferiore alla soglia prevista:\n ' + 
                                '(Transaction) Time__c -> ' + t.Time__c + 
                                ',(Condition Catalog) ENL_Parking_Time__c -> ' + cond.ENL_Parking_Time__c;
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;
            //generateLogs(l, '');
            return checkObj;
        }
        // if (cond.Refuelling_mode__c != null && !t.Refueling_Mode__c.containsIgnoreCase(cond.Refuelling_mode__c)) {
        if (cond.Refuelling_mode__c != null){
            String[] refModeArray = cond.Refuelling_mode__c.split(';');
            Boolean flag = false;
            for (String r : refModeArray){
                if (t.Refueling_mode__c.containsIgnoreCase(r))
                    flag = true;
            }

            if (!flag){
                l.Level = 'DEBUG';
                l.ResultCode = '9';
                l.SystemException = '9 --> Refuelling mode non consentito:\n ' + 
                                    '(Condition Catalog) Refuelling_mode__c -> ' + cond.Refuelling_mode__c + 
                                    ', (Transaction) Refuelling_mode__c -> ' + t.Refueling_Mode__c;
                checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
                if (writeLog)
                    checkObj.logRecord = l;
                //generateLogs(l, '');
                return checkObj;
            }


        }

        if (o.ENL_Gender__c != null && !o.ENL_Gender__c.containsIgnoreCase(c.Gender__c)){

            l.Level = 'DEBUG';
            l.ResultCode = '10';
            l.SystemException = '10 --> Gender del contatto diverso dal gender della offerta:\n ' + 
                                '(Contact) Gender__c-> ' + c.Gender__c + 
                                ', (Offer Catalog) ENL_Gender__c ->' + o.ENL_Gender__c;
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;
            //generateLogs(l, '');
            return checkObj;

        }

        if (cond.ENL_Days_Validity__c != null && !cond.ENL_Days_Validity__c.contains(t.Transaction_Date__c.format('u'))){

            l.Level = 'DEBUG';
            l.ResultCode = '11';
            l.SystemException = '11 --> Giorno validità non conforme:\n ' + 
                                '(Condition Catalog) ENL_Days_Validity__c-> ' + cond.ENL_Days_Validity__c + 
                                ', (Transaction) Transaction_Date__c-> ' + t.Transaction_Date__c.format('u');
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;
            //generateLogs(l, '');
            return checkObj;

        }
        if ((cond.ENL_Start_Time_Validity__c != null && cond.ENL_Start_Time_Validity__c > t.TransactionFormulaTime__c) || (cond.ENL_End_Time_Validity__c != null && cond.ENL_End_Time_Validity__c < t.TransactionFormulaTime__c)){

            l.Level = 'DEBUG';
            l.ResultCode = '12';
            l.SystemException = '12 --> Range orario validità non conforme:\n ' + 
                                '(Condition Catalog) ENL_Start_Time_Validity__c-> ' + cond.ENL_Start_Time_Validity__c + 
                                ', (Transaction) Transaction_Date__c-> ' + t.Transaction_Date__c.time();
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;
            //generateLogs(l, '');
            return checkObj;

        }
        if (o.Customer_Type__c != null && (o.Customer_Type__c != c.Customer_Type__c)){

            l.Level = 'DEBUG';
            l.ResultCode = '13';
            l.SystemException = '13 --> Customer type non conforme:\n ' + 
                                '(Offer Catalog) Customer_Type__c-> ' + o.Customer_Type__c + 
                                ', (Contact) Customer_Type__c-> ' + c.Customer_Type__c;
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;
            //generateLogs(l, '');
            return checkObj;

        }
        if (o.ENL_clusterAccept__c != null && String.isNotBlank(o.ENL_clusterAccept__c)){

            Boolean accept = false;

            String clusterAcc = o.ENL_clusterAccept__c;
            List<String> cluAccept = clusterAcc.split(';');

            if (c.Cluster__c != null && String.isNotBlank(c.Cluster__c)){
                for (String clu : cluAccept){

                    if (clu.containsOnly(c.Cluster__c)){

                        accept = true;

                    }

                }
            }

            if (accept == false){


                l.Level = 'DEBUG';
                l.ResultCode = '14';
                l.SystemException = '14 --> Cluster cliente differente:\n ' + 
                                    '(Offer Catalog) ENL_Customer_Cluster__c-> ' + o.ENL_Customer_Cluster__c + 
                                    ', (Contact) Cluster__c-> ' + c.Cluster__c;
                checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
                if (writeLog)
                    checkObj.logRecord = l;
                return checkObj;
            }

        }
        if (o.ENL_City__c != null && ((t.Service_Station__c != null && t.Service_Station__r.CC_SS_Municipality__c != o.ENL_City__c) || (t.ENL_Parking__c != null && t.ENL_Parking__r.CCP_Municipality__c != o.ENL_City__c))){
            l.Level = 'DEBUG';
            l.ResultCode = '15';
            l.SystemException = '15 --> Comune differente:\n ' + 
                                '(Offer Catalog) ENL_City__c-> ' + o.ENL_City__c + 
                                ', (Transaction) Service_Station__r.CC_SS_Municipality__c-> ' + t.Service_Station__r.CC_SS_Municipality__c + 
                                ', (Transaction) ENL_Parking__r.CCP_Municipality__c-> ' + t.ENL_Parking__r.CCP_Municipality__c;
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;
            //generateLogs(l, '');
            return checkObj;
        }
        if (o.ENL_Province__c != null && ((t.Service_Station__c != null && t.Service_Station__r.CC_SS_Province__c != o.ENL_Province__c) || (t.ENL_Parking__c != null && t.ENL_Parking__r.CCP_Province__c != o.ENL_Province__c))){
            l.Level = 'DEBUG';
            l.ResultCode = '16';
            l.SystemException = '16 --> Provincia differente:\n ' + 
                                '(Offer Catalog) ENL_Province__c-> ' + o.ENL_Province__c + 
                                ', (Transaction) Service_Station__r.CC_SS_Province__c-> ' + t.Service_Station__r.CC_SS_Province__c + 
                                ', (Transaction) ENL_Parking__r.CCP_Province__c-> ' + t.ENL_Parking__r.CCP_Province__c;
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;
            //generateLogs(l, '');
            return checkObj;
        }
        if (o.ENL_Region__c != null && ((t.Service_Station__c != null && t.Service_Station__r.CC_SS_Region__c != o.ENL_Region__c) || (t.ENL_Parking__c != null && t.ENL_Parking__r.CCP_Region__c != o.ENL_Region__c))){
            l.Level = 'DEBUG';
            l.ResultCode = '17';
            l.SystemException = '17 --> Regione differente:\n ' + 
                                '(Offer Catalog) ENL_Region__c-> ' + o.ENL_Region__c + 
                                ', (Transaction) Service_Station__r.CC_SS_Region__c-> ' + t.Service_Station__r.CC_SS_Region__c + 
                                ', (Transaction) ENL_Parking__r.CCP_Region__c-> ' + t.ENL_Parking__r.CCP_Region__c;
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;
            //generateLogs(l, '');
            return checkObj;
        }
        if (o.ENL_Country__c != null && ((t.Service_Station__c != null && t.Service_Station__r.CC_SS_State__c != o.ENL_Country__c) || (t.ENL_Parking__c != null && t.ENL_Parking__r.CCP_State__c != o.ENL_Country__c))){
            l.Level = 'DEBUG';
            l.ResultCode = '18';
            l.SystemException = '18 --> Nazione differente:\n ' + 
                                '(Offer Catalog) ENL_Country__c-> ' + o.ENL_Country__c + 
                                ', (Transaction) Service_Station__r.CC_SS_State__c-> ' + t.Service_Station__r.CC_SS_State__c + 
                                ', (Transaction) ENL_Parking__r.CCP_State__c-> ' + t.ENL_Parking__r.CCP_State__c;
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;
            //generateLogs(l, '');
            return checkObj;
        }

        //giuseppemario.pastore@webresults.it - Promo Rolling - 19/05/2023 - START
        if ( (o.Offer_code__c == 'R03' || o.Offer_code__c == 'R08' || o.Offer_code__c == 'R16') && (c.Customer_Type__c != '2'  || c.Enabled__c == false || c.Cancellation_Date__c != null) ){
            l.Level = 'DEBUG';
            l.ResultCode = '19';
            l.fiscalCode = c.Fiscal_code__c;
            l.SystemException = '19 --> Contatto inattivo o senza consenso privacy:\n ' + 
                                '(Offer Catalog) Offer_code__c-> ' + o.Offer_code__c + 
                                ', (Contact) Contact.Flag_Privacy_ENI__c -> ' + c.Flag_Privacy_ENI__c + 
                                ', (Contact) Contact.Enabled__c-> ' + c.Enabled__c;
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;
            //generateLogs(l, '');
            return checkObj;
        }
        //giuseppemario.pastore@webresults.it - Promo Rolling - 19/05/2023 - START

        // Inizio stefano.bassotti@webresults.it RET-23027
        System.debug('Utils-checkTransaction Send Nexi: ' + o.ENL_Send_Nexi__c);
        if (o.ENL_Send_Nexi__c) {
            System.debug('Utils-checkTransaction Cluster Type: ' + o.ENL_Cluster_Type__c);
            // Member per promozione Sconto Euro litro
            if ('0'.equals(o.ENL_Cluster_Type__c)) {  // stefano.bassotti@webresults.it RET-23030
                System.debug('Utils-checkTransaction Cluster Member: ' + o.ENL_Cluster_Member__c);
                if (o.ENL_Cluster_Member__c != null) {
                    Integer numCluster = [select count() from ENL_Cluster_Member__c where ENL_Cluster__c = :o.ENL_Cluster_Member__c and ENL_Member__c = :t.Contact__c];
                    System.debug('Utils-checkTransaction numCluster: ' + numCluster);
                    if (numCluster == 0) {
                        l.Level = 'DEBUG';
                        l.ResultCode = '20';
                        l.fiscalCode = c.Fiscal_code__c;
                        l.SystemException = '20 --> Contatto non trovato nel cluster:\n ' +
                                ', (Contact ID) -> ' + t.Contact__c +
                                '(Offer Catalog) Offer_code__c-> ' + o.Offer_code__c;
                        checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
                        if (writeLog)
                            checkObj.logRecord = l;
                        //generateLogs(l, '');
                        return checkObj;
                    }
                } else {
                    l.Level = 'DEBUG';
                    l.ResultCode = '21';
                    l.fiscalCode = c.Fiscal_code__c;
                    l.SystemException = '21 --> Cluster Member non valorizzato\n ' +
                            '(Offer Catalog) Offer_code__c-> ' + o.Offer_code__c;
                    checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
                    if (writeLog)
                        checkObj.logRecord = l;
                    //generateLogs(l, '');
                    return checkObj;
                }
            }
            // Service Station Caffe per promozione Oil non Oil
            if ('1'.equals(o.ENL_Cluster_Type__c)) {  // stefano.bassotti@webresults.it RET-23030
                if (o.ENL_Cluster_Service_Station__c == null) {  // stefano.bassotti@webresults.it RET-23030
                    System.debug('Utils-checkTransaction Cluster Member: NON Trovato');    // stefano.bassotti@webresults.it RET-23030
                    Integer numServiceStation = [select count() from CC_Service_Station__c where ENL_Eni_Cafe__c = true and Id = :t.Service_Station__c];
                    if (numServiceStation == 0) {
                        l.Level = 'DEBUG';
                        l.ResultCode = '22';
                        l.fiscalCode = c.Fiscal_code__c;
                        l.SystemException = '22 --> Service Station non Eni:\n ' +
                                ', (Service Station) -> ' + t.Service_Station__c +
                                '(Offer Catalog) Offer_code__c-> ' + o.Offer_code__c;
                        checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
                        if (writeLog)
                            checkObj.logRecord = l;
                        //generateLogs(l, '');
                        return checkObj;
                    }
                // Inizio stefano.bassotti@webresults.it RET-23030
                } else {
                    System.debug('Utils-checkTransaction Cluster Member: Trovato');
                    Integer numCluster = [select count() from ENL_Cluster_Member__c where ENL_Cluster__c = :o.ENL_Cluster_Service_Station__c and ENL_Service_Station__c = :t.Service_Station__c];
                    if (numCluster == 0) {
                        l.Level = 'DEBUG';
                        l.ResultCode = '23';
                        l.fiscalCode = c.Fiscal_code__c;
                        l.SystemException = '23 --> Service Station Eni Caffe non trovato nel cluster:\n ' +
                                ', (Contact ID) -> ' + t.Contact__c +
                                '(Offer Catalog) Offer_code__c-> ' + o.Offer_code__c;
                        checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
                        if (writeLog)
                            checkObj.logRecord = l;
                        //generateLogs(l, '');
                        return checkObj;
                    }
                }
                // Fine stefano.bassotti@webresults.it RET-23030
            }
            // Service Station Emporium per promozione Oil non Oil
            if ('2'.equals(o.ENL_Cluster_Type__c)) {  // stefano.bassotti@webresults.it RET-23030
                if (o.ENL_Cluster_Service_Station__c == null) {  // stefano.bassotti@webresults.it RET-23030
                    System.debug('Utils-checkTransaction Cluster Member: NON Trovato');    // stefano.bassotti@webresults.it RET-23030
                    Integer numServiceStation = [select count() from CC_Service_Station__c where ENL_Emporium__c = true and Id = :t.Service_Station__c];
                    if (numServiceStation == 0) {
                        l.Level = 'DEBUG';
                        l.ResultCode = '24';
                        l.fiscalCode = c.Fiscal_code__c;
                        l.SystemException = '24 --> Service Station non Eni Empotium:\n ' +
                                ', (Service Station) -> ' + t.Service_Station__c +
                                '(Offer Catalog) Offer_code__c-> ' + o.Offer_code__c;
                        checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
                        if (writeLog)
                            checkObj.logRecord = l;
                        //generateLogs(l, '');
                        return checkObj;
                    }
                // Inizio stefano.bassotti@webresults.it RET-23030
                } else {
                    System.debug('Utils-checkTransaction Cluster Member: Trovato');
                    Integer numCluster = [select count() from ENL_Cluster_Member__c where ENL_Cluster__c = :o.ENL_Cluster_Service_Station__c and ENL_Service_Station__c = :t.Service_Station__c];
                    if (numCluster == 0) {
                        l.Level = 'DEBUG';
                        l.ResultCode = '25';
                        l.fiscalCode = c.Fiscal_code__c;
                        l.SystemException = '25 --> Service Station Eni Emporium non trovato nel cluster:\n ' +
                                ', (Contact ID) -> ' + t.Contact__c +
                                '(Offer Catalog) Offer_code__c-> ' + o.Offer_code__c;
                        checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
                        if (writeLog)
                            checkObj.logRecord = l;
                        //generateLogs(l, '');
                        return checkObj;
                    }
                }
                // Fine stefano.bassotti@webresults.it RET-23030
            }
        }
        System.debug('Utils-checkTransaction Superati i Check dell Offer Catalog: ' + o.Name);
        // Fine stefano.bassotti@webresults.it RET-23027


        //Inizio modifiche 07-08-2023 giuseppemario.pastore@webresults.it RET-23037
        if(o.Offer_code__c == System.Label.PromoPaypal23037){
            Map<String,ENL_PromoValidity__c> promoValidities = ENL_PromoValidity__c.getAll();
            ENL_PromoValidity__c payPalPromo = promoValidities.get(System.Label.PromoPaypal23037);
            String exclusionReason = '';
            Boolean createCustomerOffer = false;
            if(payPalPromo.ENL_isActive__c == true) {
                if(c.APP_created_date__c == null){
                    exclusionReason = 'Contatto ancora non presente sull\'APP ';
                } else if (c.APP_created_date__c > payPalPromo.ENL_PromoEndDate__c || c.APP_created_date__c < payPalPromo.ENL_PromoStartDate__c){
                    exclusionReason = 'Contatto creato al di fuori del range dell\' iniziativa';
                } else if (t.Transaction_Date__c > payPalPromo.ENL_PromoEndDate__c || t.Transaction_Date__c < payPalPromo.ENL_PromoStartDate__c){
                    exclusionReason = 'Transazione effettuata al di fuori del range dell\' iniziativa';
                } else if (('PV_NON_ADERENTE'.equals(t.ECU_offerCondition__c))){
                    exclusionReason = 'Punto vendita non aderente - la Transazione non partecipa alla promo';
                } else if (c.Customer_Type__c != '2'  || c.Enabled__c == false || c.Cancellation_Date__c != null ) {
                    exclusionReason = 'Contatto inattivo o Customer Type non conforme all\' iniziativa';
                } else {
                    createCustomerOffer = true;
                }

                if(!createCustomerOffer){
                    l.Level = 'DEBUG';
                    l.ResultCode = '26';
                    l.fiscalCode = c.Fiscal_code__c;
                    l.SystemException = '26 --> ' + exclusionReason + ' :\n ' +
                                        '(Offer Catalog) Offer_code__c-> ' + o.Offer_code__c + 
                                        ', (Contact) Contact.APP_created_date__c -> ' + c.APP_created_date__c + 
                                        ', (Transaction) Transaction.CreatedDate -> ' + t.CreatedDate + 
                                        ', (Contact) Contact.Customer_Type__c -> ' + c.Customer_Type__c + 
                                        ', (Contact) Contact.Enabled__c-> ' + c.Enabled__c;
                    checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
                    if (writeLog)
                        checkObj.logRecord = l;
                    //generateLogs(l, '');
                    return checkObj;
                }
            }

        }
        //Fine modifiche 07-08-2023 giuseppemario.pastore@webresults.it RET-23037

        //Inizio modifiche 24/08/2023 giuseppemario.pastore@webresults.it RET-23046
        if (
            (
                o.Offer_code__c != System.Label.PromoPaypal23037 &&
                !( isLoyaltyOffer &&  ( acceptedValues != null && acceptedValues.contains(t.Product_Type__c) ) ) //modifiche 13/10/2023 Giuseppe Mario Pastore RET 23033
            ) &&  t.ENL_Disabled_Service_Station__c != false 
       ){
            l.Level = 'DEBUG';
            l.ResultCode = '27';
l.fiscalCode = c.Fiscal_code__c; //modifiche 06/02/2024 Giuseppe Mario Pastore RET 23033 - Hotfix_266
            l.SystemException = '27 --> La Transazione non è elegibile distributore non abilitato :\n ' +
                                '(Offer Catalog) ECU_Type_Elegibility__c-> ' + o.ECU_Type_Elegibility__c + 
                                ', (Transaction) ENL_Disabled_Service_Station__c-> ' + t.ENL_Disabled_Service_Station__c + 
                                ', (Transaction) ECU_offerCondition__c-> ' + t.ECU_offerCondition__c;
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);

            if (writeLog)
                checkObj.logRecord = l;
            return checkObj;
        }
        //Fine modifiche 24/08/2023 giuseppemario.pastore@webresults.it RET-23046


        //Inizio modifiche 13/10/2023 Giuseppe Mario Pastore RET 23033
       
        if (
            (o.ENL_Customer_Cluster__c == '0' &&  c.ELP_Loyalty_2024_Accepted__c == false) ||
            (o.ENL_Customer_Cluster__c == '1' &&  c.ELP_Loyalty_2024_Accepted__c == true)
        ){
            if(isLoyaltyOffer){
                l.Level = 'DEBUG';
                l.ResultCode = '28';
l.fiscalCode = c.Fiscal_code__c; //modifiche 06/02/2024 Giuseppe Mario Pastore RET 23033 - Hotfix_266
                String customerCluster = o.ENL_Customer_Cluster__c == '0' ? 'Loyalty' : o.ENL_Customer_Cluster__c == '1' ? 'Non Loyalty' : ''; 
                l.SystemException = '28 --> Il prodotto ha Customer Cluster di tipo ' + customerCluster + '   e il flag loyalty è = ' + c.ELP_Loyalty_2024_Accepted__c ;
                checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
    
                if (writeLog)
                    checkObj.logRecord = l;
                return checkObj;
            }
        }

        if ( t.Product_Type__c == 'Power' &&  isLoyaltyOffer ){
                        if(resultAmount < cond.ENL_Amount__c){
                l.Level = 'DEBUG';
                l.ResultCode = '29';
l.fiscalCode = c.Fiscal_code__c; //modifiche 06/02/2024 Giuseppe Mario Pastore RET 23033 - Hotfix_266
                l.SystemException = '29 --> Il total Amount della transazione --> ' + resultAmount + ' è minore della soglia minima settata sul condition catalog: ' + cond.ENL_Amount__c ;
                checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
    
                if (writeLog)
                    checkObj.logRecord = l;
                return checkObj;
            }
        }

        if (acceptedParkValues != null && acceptedParkValues.contains(t.Product_Type__c) && acceptedEventValues!= null && !acceptedEventValues.contains(t.EVENT_TYPE__c)){
            l.Level = 'DEBUG';
            l.ResultCode = '30';
            l.fiscalCode = c.Fiscal_code__c; //modifiche 06/02/2024 Giuseppe Mario Pastore RET 23033 - Hotfix_266
            l.SystemException = '30 --> L\'Event Type: ' + t.EVENT_TYPE__c + ' non è tra quelli previsti per questo tipo di prodotto: ' + t.Product_Type__c;
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);

            if (writeLog)
                checkObj.logRecord = l;
            return checkObj;
        }
        //FINE modifiche 13/10/2023 Giuseppe Mario Pastore RET 23033

        //Inizio stefano.bassotti@webresults.it CLU-23019
        if ( ('0'.equals(t.ENL_System_Source__c)) && (o.Check_Transaction_Preregistrati__c == false) ) {
            l.Level = 'DEBUG';
            l.ResultCode = '31';
            l.SystemException = '31 --> Check Transaction Preregistrati = False questa transazione è di fortec non deve essere gestita';
            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);

            if (writeLog)
                checkObj.logRecord = l;
            return checkObj;
        }
        //Fine stefano.bassotti@webresults.it CLU-23019

        System.debug('Utils-checkTransaction Fine Superati i Check per Offer Catalog: ' + o.Name);  // stefano.bassotti@webresults.it RET-23030

        checkObj = new ENL_APC_CheckTransactionWrapper(true, null);
        if (writeLog)
            checkObj.logRecord = l;
        return checkObj;
    }

    //metodo per controllare i campi della customer offer
    public static ENL_APC_CheckTransactionWrapper checkTransactionCO(Transaction__c t, ENL_Condition_Catalog__c cond, Contact c, Offer_Catalog__c o, Boolean writeLog, Customer_Offer__c customerOff){
        ENL_APC_CheckTransactionWrapper checkObj;
        
        //Inizio modifiche 08/11/2023 Giuseppe Mario Pastore RET 23033
        Boolean isLoyaltyOffer = isLoyaltyOffer(o.Offer_Code__c); 
        Map<String,ELP_LoyaltyCondition__c> promoCondition = ELP_LoyaltyCondition__c.getAll();
        ELP_CustomSettingsConfigurations__c loyaltyCs = ELP_CustomSettingsConfigurations__c.getOrgDefaults();
        List<String> acceptedValues = promoCondition.get(loyaltyCs.Product_Type__c)?.ConditionList__c?.split(',');
        //Fine modifiche 08/11/2023 Giuseppe Mario Pastore RET 23033

        System.debug('Utils-checkTransactionCO Inizio Check per Offer Catalog: ' + o.Name);  // stefano.bassotti@webresults.it RET-23030

        //Stefano Bassotti 05-06-2023 inizio
        if (crossSelling == null) {
            ENL_CustomerOffer__c customerOffer = ENL_CustomerOffer__c.getOrgDefaults();
            crossSelling = (String) customerOffer.OfferCatalogCrossSelling__c;
        }
        System.debug('Utils-checkTransactionCO CrossSelling: '+ crossSelling);
        //Stefano Bassotti 05-06-2023 fine

        //EN: gestione log per eleggibilità transazioni
        Log l = new Log();
        l.Level = 'DEBUG';
        l.Origin = 'Utils.checkTransactionCO';
        l.EventId = t.EVENT_ID__c;
        l.ResultCode = 'ELIGIBLE';
        l.TransactionId = t.Id;
        l.EventType = t.EVENT_TYPE__c;
        l.TransmittedMessage = JSON.serialize(new Map<String, String>{ 'Transaction_Id' => t.Id, 'Offer Id' => o.Id, 'Offer Name' => o.Name, 'Condition Id' => cond.Id, 'Condition Name' => cond.Name, 'Contact Id' => c.Id, 'Contact Code' => c.Contact_code__c });

        //controllo per offerta di tipo compleanno
        if (cond.ENL_Service_Category__c == '6'){

            if (customerOff != null){

                if (c.Birthdate < customerOff.CreatedDate || c.Birthdate > customerOff.ECU_Deathline__c){
                    l.Level = 'DEBUG';
                    l.ResultCode = '19';

                    l.SystemException = '19 --> Compleanno non compreso:\n ' + 
                                        '(Contact) Birthdate ->' + c.Birthdate + 
                                        ' (Customer Offer) CreatedDate->' + customerOff.CreatedDate + 
                                        ' (Customer Offer) ECU_Deathline__c->' + customerOff.ECU_Deathline__c;

                    checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
                    if (writeLog)
                        checkObj.logRecord = l;
                    return checkObj;
                }

            } else{
                if (c.Birthdate < System.today() || c.Birthdate > System.today().addDays((Integer) o.ECU_Timing_completamento_missione__c)){
                    l.Level = 'DEBUG';
                    l.ResultCode = '19';
                    l.SystemException = '19 --> Compleanno non compreso:\n ' + 
                                        '(Contact) Birthdate ->' + c.Birthdate + 
                                        ' (Customer Offer) CreatedDate->' + System.today() + 
                                        ' (Customer Offer) ECU_Deathline__c->' + System.today().addDays((Integer) o.ECU_Timing_completamento_missione__c);
                    checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
                    if (writeLog)
                        checkObj.logRecord = l;
                    return checkObj;
                }
            }
        }
        //PV_NON_ADERENTE PER IW
//      if ((t.ECU_offerCondition__c == 'PV_NON_ADERENTE')){ //Stefano Bassotti 05-06-2023
        System.debug('Utils-checkTransactionCO Offer Condition: '+ t.ECU_offerCondition__c+' Offer Code: '+ o.Offer_code__c); //Stefano Bassotti 05-06-2023
        
        if ( 
                ('PV_NON_ADERENTE'.equals(t.ECU_offerCondition__c)) && (
                    !crossSelling.contains(o.Offer_code__c) &&
                    !( isLoyaltyOffer &&  ( acceptedValues != null && acceptedValues.contains(t.Product_Type__c) ) ) //modifiche 13/10/2023 Giuseppe Mario Pastore RET 23033
                ) 
            ) { //Stefano Bassotti 05-06-2023
           l.Level = 'DEBUG';
            l.ResultCode = '20';
            l.SystemException = '20 --> La Transazione non partecipa alla promo rifornimento e non partecipa alla IW :\n ' + 
                                '(Transaction) ECU_offerCondition__c-> ' + t.ECU_offerCondition__c;

            checkObj = new ENL_APC_CheckTransactionWrapper(false, null);
            if (writeLog)
                checkObj.logRecord = l;

            System.debug('Utils-checkTransactionCO PV_NON_ADERENTE true'); //Stefano Bassotti 05-06-2023
            return checkObj;
        }
        System.debug('Utils-checkTransactionCO PV_NON_ADERENTE false'); //Stefano Bassotti 05-06-2023


        // Check su Transazione che non partecipa alla IW

        if (o.ENL_clusterAccept__c != null && String.isNotBlank(o.ENL_clusterAccept__c)){

            Boolean accept = false;

            String clusterAcc = o.ENL_clusterAccept__c;
            List<String> cluAccept = clusterAcc.split(';');

            if (c.Cluster__c != null && String.isNotBlank(c.Cluster__c)){
                for (String clu : cluAccept){

                    if (clu.containsOnly(c.Cluster__c)){

                        accept = true;

                    }

                }
            }

            if (
                ( 
                    o.Offer_code__c != System.Label.PromoPaypal23037 && //modifiche 07-08-2023 giuseppemario.pastore@webresults.it RET-23046
                    !( isLoyaltyOffer  &&  ( acceptedValues != null && acceptedValues.contains(t.Product_Type__c) ) ) //modifiche 13/10/2023 Giuseppe Mario Pastore RET 23033
                ) 
                && (accept == false || t.ENL_Disabled_Service_Station__c != false) && (t.ECU_offerCondition__c == null || String.isBlank(t.ECU_offerCondition__c)) 
               /**&& (o.ECU_Type_Elegibility__c != 'Cross-Selling' && String.isNotBlank(o.ECU_Type_Elegibility__c) modifiche 07-08-2023 giuseppemario.pastore@webresults.it RET-23046**/
            ){
                l.Level = 'DEBUG';
                l.ResultCode = '21';
                l.SystemException = '21 --> La Transazione non partecipa alla IW :\n ' + 
                                    '(Offer Catalog) ECU_Type_Elegibility__c-> ' + o.ECU_Type_Elegibility__c + 
                                    ', (Transaction) ENL_Disabled_Service_Station__c-> ' + t.ENL_Disabled_Service_Station__c + 
                                    ', (Transaction) ECU_offerCondition__c-> ' + t.ECU_offerCondition__c;
                checkObj = new ENL_APC_CheckTransactionWrapper(false, null);

                if (writeLog)
                    checkObj.logRecord = l;
                return checkObj;
            }
        }

        System.debug('Utils-checkTransactionCO Fine Superati i Check per Offer Catalog: ' + o.Name);  // stefano.bassotti@webresults.it RET-23030

        checkObj = new ENL_APC_CheckTransactionWrapper(true, null);
        if (writeLog)
            checkObj.logRecord = l;
        //generateLogs(l, '');
        return checkObj;
    }

    /**
     * @author: AM
     * @date: 20/01/2021
     * @description: Metodo predisposto alla creazione di una mappa JSON per il batch ENL_APB_CustomerOfferBatch
     * @param conds Lista delle condizioni
     * @param steps Lista degli step
     * @return JSON String
     */
    public static String createJSONmap(List<ENL_Condition_Catalog__c> conds, List<ENL_Step_Catalog__c> steps){
        Map<String, Map<String, Map<String, Integer>>> stepMap = new Map<String, Map<String, Map<String, Integer>>>();
        for (ENL_Step_Catalog__c step : steps){
            for (ENL_Condition_Catalog__c cond : conds){
                if (cond.ENL_Step_Catalog__r.Name == step.Name){


                    if (!stepMap.containsKey(step.Name)){
                        stepMap.put(step.Name, new Map<String, Map<String, Integer>>{ cond.Name => new Map<String, Integer>{ 'total' => (Integer) cond.ENL_Purchase_Number__c, 'partial' => 0, 'IW' => (Integer) cond.ENL_IW_Partecipations__c } });
                    } else{
                        stepMap.get(step.Name).put(cond.Name, new Map<String, Integer>{ 'total' => (Integer) cond.ENL_Purchase_Number__c, 'partial' => 0, 'IW' => (Integer) cond.ENL_IW_Partecipations__c });
                    }


                }
            }
        }
        System.debug('<<<<<<<<<JsonMap' + JSON.serialize(stepMap));
        return JSON.serialize(stepMap);
    }

    /**
     * @author: AM
     * @date: 21/01/2021
     * @description: Metodo che aggiorna mappa JSON con acquisto dello step passato in argomento
     * @param j Mappa JSON
     * @param s Step da aggiornare
     * @param c Condizione da incrementare
     * @return JSON String
     */
    public static String updateJSONMap(String j, String s, String c){

        Map<String, Map<String, Map<String, Integer>>> m = new Map<String, Map<String, Map<String, Integer>>>();
        Integer partial;
        String result;

        if (Test.isRunningTest()){
            result = JSON.serialize(m);
        }

        m = (Map<String, Map<String, Map<String, Integer>>>)JSON.deserialize(j, Map<String, Map<String, Map<String, Integer>>>.class);

        if (!Test.isRunningTest()){
            partial = (Integer) m.get(s).get(c).get('partial');


            if (partial == m.get(s).get(c).get('total')){
                return JSON.serialize(m);
            } else{
                m.get(s).get(c).put('partial', partial + 1);
                return JSON.serialize(m);
            }


        }


        return result;
    }

    //metodo per aggiornare il parziale della customer offer
    public static Integer updatePartial(String j, String s, String c){

        Map<String, Map<String, Map<String, Integer>>> m = new Map<String, Map<String, Map<String, Integer>>>();
        Integer partial;
        String result;

        result = JSON.serialize(m);

        m = (Map<String, Map<String, Map<String, Integer>>>)JSON.deserialize(j, Map<String, Map<String, Map<String, Integer>>>.class);

        if (!Test.isRunningTest()){

            partial = (Integer) m.get(s).get(c).get('partial');
        }
        //Inizio stefano.bassotti@webresults.it RET-23027
        else{
            partial = 0;
        }
        //Fine stefano.bassotti@webresults.it RET-23027

        System.debug('<<<<<PARTIAL' + partial);

        return partial;
    }

    /**
     * @author: AM
     * @date: 21/01/2021
     * @description: Metodo che controlla se rispetto alla mappa JSON degli step e delle condizioni un'offerta è completa
     * @param j Mappa JSON da controllare
     * @return Boolean
     */
    public static Boolean checkOfferComplete(String j){
        Boolean resultCondGlobal = true;


        Map<String, Map<String, Map<String, Integer>>> m = (Map<String, Map<String, Map<String, Integer>>>)JSON.deserialize(j, Map<String, Map<String, Map<String, Integer>>>.class);
        for (String s : m.keySet()){
            Boolean resultCond = false;
            for (String c : m.get(s).keySet()){

                if (m.get(s).get(c).get('partial') == m.get(s).get(c).get('total')){
                    resultCond = true;
                    break;
                }

            }
            if (!resultCond){
                resultCondGlobal = false;
                break;
            }
        }


        return resultCondGlobal;
    }

    /**
     * @author: AM
     * @date: 05/03/2021
     * @description: Metodo che controlla se la condizione della Customer Offer è verificato
     * @param jsonMap Mappa JSON da controllare
     * @param condition Condizione da verificare
     * @param step Step della Condizione
     * @return Boolean
     */
    public static Boolean checkConditionComplete(String jsonMap, String condition, String step){


        Map<String, Map<String, Map<String, Integer>>> m = (Map<String, Map<String, Map<String, Integer>>>)JSON.deserialize(jsonMap, Map<String, Map<String, Map<String, Integer>>>.class);

        if (!Test.isRunningTest()){
            if (m.get(step).get(condition).get('partial') == m.get(step).get(condition).get('total')){
                return true;
            } else{
                return false;
            }

        }

        return null;
    }

    /**
     * @author: AM
     * @date: 09/03/2021
     * @description: Metodo che controlla se la condizione della Customer Offer è verificato
     * @param jsonMap Mappa JSON da controllare
     * @return Boolean
     */
    public static Integer getIWPartecipation(String jsonMap){
        Map<String, Map<String, Map<String, Integer>>> m = (Map<String, Map<String, Map<String, Integer>>>)JSON.deserialize(jsonMap, Map<String, Map<String, Map<String, Integer>>>.class);
        Integer IWpartecipation = 0;
        for (String s : m.keySet()){
            for (String c : m.get(s).keySet()){

                if (m.get(s).get(c).get('partial') == m.get(s).get(c).get('total')){
                    IWpartecipation += (Integer) m.get(s).get(c).get('IW');
                }


            }
        }
        return IWpartecipation;
    }

    /**
     * @author: AM
     * @date: 21/01/2021
     * @description: How to generate a version 4 GUID (random):
     1. Generate 128 random bits
     2. Set the version: Take the 7th byte perform an AND operation with 0x0f followed by an OR operation of 0x40.
     3. Set the variant: Take the 9th byte perform an AND operation with 0x3f followed by an OR operation of 0x80.
     4. Convert the data to hex and add dashes
     */
    public static List<String> NewGuid(){

        List<String> guidList = new List<String>();

        String randomStringAsHex = EncodingUtil.ConvertTohex(Crypto.GenerateAESKey(128));

        String versionHexBits = randomStringAsHex.SubString(14, 16); // 7th bit
        String variantHexBits = randomStringAsHex.SubString(18, 20); // 9th bit

        Integer versionIntBits = convertHexToInt(versionHexBits);
        Integer variantIntBits = convertHexToInt(variantHexBits);

        Integer versionShiftedIntBits = versionIntBits & 15 | 64;  // (i & 0x0f) | 0x40
        Integer variantShiftedIntBits = variantIntBits & 63 | 128; // (i & 0x3f) | 0x80

        String versionShiftedHexBits = convertIntToHex(versionShiftedIntBits); // Always begins with 4
        String variantShiftedHexBits = convertIntToHex(variantShiftedIntBits); // Always begins with one of 8,9,a,b

        String guid = randomStringAsHex.SubString(0, 8) + '-' + randomStringAsHex.SubString(8, 12) + '-' + versionShiftedHexBits + randomStringAsHex.SubString(14, 16) + '-' + variantShiftedHexBits + randomStringAsHex.SubString(18, 20) + '-' + randomStringAsHex.substring(20);
        guidList.add(guid);
        return guidList;
    }

    //metodo per generazione ENL_Operation_Id per la creazione delle customer offer loyalty tramite flow
    @InvocableMethod(label = 'New Guid')
    public static List<String> NewGuidFlow(List<Id> ids){

        List<String> guidList = new List<String>();

        for (Id id : ids){

            String randomStringAsHex = EncodingUtil.ConvertTohex(Crypto.GenerateAESKey(128));

            String versionHexBits = randomStringAsHex.SubString(14, 16); // 7th bit
            String variantHexBits = randomStringAsHex.SubString(18, 20); // 9th bit

            Integer versionIntBits = convertHexToInt(versionHexBits);
            Integer variantIntBits = convertHexToInt(variantHexBits);

            Integer versionShiftedIntBits = versionIntBits & 15 | 64;  // (i & 0x0f) | 0x40
            Integer variantShiftedIntBits = variantIntBits & 63 | 128; // (i & 0x3f) | 0x80

            String versionShiftedHexBits = convertIntToHex(versionShiftedIntBits); // Always begins with 4
            String variantShiftedHexBits = convertIntToHex(variantShiftedIntBits); // Always begins with one of 8,9,a,b

            String guid = randomStringAsHex.SubString(0, 8) + '-' + randomStringAsHex.SubString(8, 12) + '-' + versionShiftedHexBits + randomStringAsHex.SubString(14, 16) + '-' + variantShiftedHexBits + randomStringAsHex.SubString(18, 20) + '-' + randomStringAsHex.substring(20);
            guidList.add(guid);
        }

        return guidList;
    }

    public static Integer convertHexToInt(String hex){

        List<String> hexMap = new List<String>{ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

        Integer d0 = hexMap.IndexOf(hex.Substring(1, 2));
        Integer d1 = hexMap.IndexOf(hex.Substring(0, 1));

        Integer intval = d0 + (d1 * 16);
        return intval;
    }

    public static String convertIntToHex(Integer intval){

        List<String> hexMap = new List<String>{ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

        // https://stackoverflow.com/a/13465128
        String hs0 = hexMap.Get(intval & 15); // i & 0x0f
        String hs1 = hexMap.Get(((intval >> 4) & 15)); //(i >> 4) & 0x0f
        return hs1 + hs0;
    }

    //Method to test string value into path
    public static Boolean isParamValid(String label, String param){

        Pattern p = Pattern.compile(label);
        Matcher m = p.matcher(param);
        if (!m.matches()){
            return false;
        }
        return true;
    }

    //Evaluates Expiration Time for Customer Offers
    public static DateTime expirationTimeConverter(DateTime endDate, String expTime){
        Date ret = endDate.date();
        switch  on expTime{
            when '1 Day'{
                ret = ret.addDays(1);
            }
            when '7 Days'{
                ret = ret.addDays(7).toStartOfWeek();
            }
            when '1 Month'{
                ret = ret.addMonths(1).toStartOfMonth();
            }
            when '2 Months'{
                ret = ret.addMonths(2).toStartOfMonth();
            }
            when '1 Year'{
                ret = Date.newInstance(ret.year() + 1, 1, 1);
            }
            when '2 Years'{
                ret = Date.newInstance(ret.year() + 2, 1, 1);
            }
            when 'Never'{
                ret = Date.newInstance(4000, 1, 1);
            }
        }
        return ((DateTime) ret).addSeconds(-1);
    }

    //Evaluates Expiration Time for Customer Offers
    public static Boolean expirationTimeInterpreter(DateTime lastProgDate, String expTime){
        switch  on expTime{
            when '1 Day'{
                return (lastProgDate.date() == system.today());
            }
            when '7 Days'{
                return (lastProgDate.date() >= system.today().toStartOfWeek());
            }
            when '1 Month'{
                return (lastProgDate.date().month() == system.today().month() && lastProgDate.date().year() == system.today().year());
            }
            when '2 Months'{
                return (lastProgDate.date().month() >= system.today().month() - 1 && lastProgDate.date().year() == system.today().year());
            }
            when '1 Year'{
                return (lastProgDate.date().year() == system.today().year());
            }
            when '2 Years'{
                return (lastProgDate.date().year() >= system.today().year() - 1);
            }
            when 'Never'{
                return true;
            }
            when else{
                return false;
            }
        }
    }

    //Gets kpi ApiName from a really big Map
    public static String getKpiApiName(String key){
        key = key.toUpperCase();
        if (kpiMap == null)
            kpiMap = (Map<String, String>)System.JSON.deserialize([SELECT Id, Body
                                                                   FROM StaticResource
                                                                   WHERE Name = 'kpiMap'
                                                                   LIMIT 1].Body.toString(), Map<String, String>.class);
        system.debug('kpiMap : ' + kpiMap);
        if (kpiMap.containsKey(key)){
            system.debug('kpiMap.get(key) : ' + kpiMap.get(key));
            return kpiMap.get(key);
        } else{
            system.debug('[ERROR] Utils.getKpiApiName(String key) : key not found in kpiMap');
            return '[ERROR] Utils.getKpiApiName(String key) : key not found in kpiMap';
        }
    }

    //Gets kpi ApiName from a really big Map
    public static String getKpiApiName(KpiWrapper kpiKey){
        if (String.isBlank(kpiKey.kpiField.TimeUnit)){
            if (kpiKey.kpiField.TimeAdjective == 'Previous'){
                kpiKey.kpiField.TimeUnit = 'Month';
            }
            if (kpiKey.kpiField.TimeAdjective == 'Last'){
                kpiKey.kpiField.TimeUnit = 'Months';
            }
        }
        String key = kpiKey.kpiField.TimeAdjective + '_' + kpiKey.kpiField.TimeUnit + '_' + kpiKey.kpiField.Type + '_' + kpiKey.kpiField.FuelType + '_' + kpiKey.kpiField.RefuellingMode;
        key = key.toUpperCase();
        system.debug('getKpiApiName : ' + key);
        return getKpiApiName(key);
    }

    //Returns a piece of query with simple conditions based on Kpis
    public static String simpleKpiConditionInterpreter(List<KpiWrapper> conditions){
        String queryWhereString = '';
        for (KpiWrapper kw : conditions){
            if (kw.KpiField.TimeAdjective.toUpperCase() == 'LAST'){
                return null;
            }
            if (queryWhereString != ''){
                queryWhereString += ' AND ';
            }
            String result = getKpiApiName(kw);
            if (result.contains('ERROR')){
                system.debug(result);
                return result;
            }
            system.debug('queryWhereString : ' + queryWhereString);
            queryWhereString += getKpiApiName(kw) + ' ' + kw.Operator + ' ' + kw.Value;
        }
        return queryWhereString;
    }

    //Evaluates complex Kpi expressions
    //rimosso per dismissione loyalty card
    /*
     public static Boolean complexKpiConditionInterpreter(List<KpiWrapper> conditions, loyalty_card__c loy){
     String kpiFieldName = null;
     Decimal thresholdNumber = 0;
     List<String> yearPerMonthKpiParser = new List<String>();
     for (KpiWrapper kw : conditions){
     kpiFieldName = getKpiApiName(kw);
     if (kpiFieldName != null){
     System.debug(kpiFieldName);
     thresholdNumber = 0;
     if (kw.KpiField.TimeAdjective.toUpperCase() == 'LAST' && (!String.isBlank(String.valueOf(loy.get(kpiFieldName))))){
     yearPerMonthKpiParser = (List<String>)(String.valueOf(loy.get(kpiFieldName))).split(';');
     for (Integer i = 0; i < math.min((Decimal) kw.KpiField.TimeUnitNumber, decimal.valueOf(yearPerMonthKpiParser.size())); i++){
     thresholdNumber += decimal.valueOf(yearPerMonthKpiParser[i]);
     }
     } else{
     thresholdNumber = (Decimal) loy.get(kpiFieldName);
     }
     switch  on (kw.Operator){
     when '<'{
     if (thresholdNumber >= kw.Value)
     return false;
     }
     when '<='{
     if (thresholdNumber > kw.Value)
     return false;
     }
     when '>'{
     if (thresholdNumber <= kw.Value)
     return false;
     }
     when '>='{
     if (thresholdNumber < kw.Value)
     return false;
     }
     when '='{
     if (thresholdNumber != kw.Value)
     return false;
     }
     when '!='{
     if (thresholdNumber == kw.Value)
     return false;
     }
     when else{
     return false; //technically should never happen
     }
     }
     }
     }
     return true;
     }
     */
    //Evaluates if a Customer Offer has reached the end of the current Step Catalogue branch
    /*public static Boolean hasReachedEndOfBranch (Customer_Offer__c coff, List<ENL_Condition_Catalog__c> steps) {
     for (ENL_Condition_Catalog__c s : steps) {
     if ((s.Step__c > coff.Partial_step__c && s.Previous_Step__c == null ) || s.Previous_Step__c == coff.Step_Catalogue__c) { return false; }
     }
     return true;
     }*/
    //Checks if environement is Production ORG (true) or Sandbox (false)
    public static Boolean isProductionOrg(){
        if (isProd == null)
            isProd = ![SELECT IsSandbox
                       FROM Organization
                       LIMIT 1].IsSandbox;
        return isProd;
    }

    //URL encrypt main
    public static String getEncryptedUrl(String name, String surname, String email, String voucherId){

        Blob key = isProductionOrg() ? Blob.valueOf(Utils__c.getOrgdefaults().AES128_CryptoKey_Production__c) : Blob.valueOf(Utils__c.getOrgdefaults().AES128_CryptoKey_eniloydev__c);
        String payloadStr = '{"nome":"' + name + '","cognome":"' + surname + '","email":"' + email + '","voucher":"' + voucherId + '"}';
        //payloadStr = Utils.pkcs5_pad(payloadStr);
        Blob payload = Blob.valueof(payloadStr);

        Blob encIV = isProductionOrg() ? Blob.valueOf(Utils__c.getOrgdefaults().AES128_InitVector_Production__c) : Blob.valueOf(Utils__c.getOrgdefaults().AES128_InitVector_eniloydev__c);
        Blob encryptedPayload = Crypto.encrypt('AES128', key, encIV, payload);
        String bs64 = EncodingUtil.base64Encode(encryptedPayload);
        System.debug('>>> ' + bs64);

        return bs64;
    }

    //URL encrypt utils
    public static String pkcs5_pad(String text){
        Integer blocksize = 16;
        Integer pad = blocksize - Math.mod(text.length(), blocksize);

        String ret = text;
        for (Integer i = 0; i < pad; i++){
            ret += String.fromCharArray(new integer[]{ pad });
        }

        return ret;
    }

    //URL decrypt utils
    public static String pkcs5_unpad(String text){
        Integer pad = text.charAt(text.length() - 1);
        if (pad > text.length()){
            return 'FALSE';
        } else{
            Integer[] subtext = text.substring(pad).getChars();
            for (Integer i : subtext){
                if (i != pad){
                    return 'FALSE';
                }
            }
        }

        return text.left(text.length() - pad);
    }

    //function that generates request voucher and customer offer for mastercard
    public static Boolean generateMastercardOffer(Request_Voucher__c voucher, Customer_Offer__c offer, Contact con){
        //   try{

        //test if Contact has already received Mastercard voucher
        if (!con.Mastercard_voucher_recieved__c){

            DateTime now = DateTime.now();
            Set<Id> mastercardOfferIds = new Set<Id>();
            mastercardOfferIds.add(Utils__c.getOrgdefaults().MastercardOfferId__c);
            mastercardOfferIds.add(Utils__c.getOrgdefaults().MastercardOfferId2__c);

            if (mastOfferCatalogMap == null)
                mastOfferCatalogMap = new Map<Id, Offer_Catalog__c>([SELECT Id, Active__c, Validity_start_date__c, Validity_end_date__c, Promo_Mobile_Push_Page__c, App_Visibility_Days__c
                                                                     FROM Offer_Catalog__c
                                                                     WHERE Id IN:mastercardOfferIds]);
            initVoucherTypes();

            if (mastOfferCatalogMap.size() > 0){
                if (con.Cluster__c == '2'){
                    // Non loyalty customer
                    if (!mastOfferCatalogMap.containsKey(Utils__c.getOrgdefaults().MastercardOfferId__c) || !checkActiveOffer(mastOfferCatalogMap.get(Utils__c.getOrgdefaults().MastercardOfferId__c))){
                        offer.Note_Interne__c = 'NO';
                        return true;
                    }
                    offer.Offer_code__c = Utils__c.getOrgdefaults().MastercardOfferId__c;
                } else{
                    // loyalty customer
                    if (!mastOfferCatalogMap.containsKey(Utils__c.getOrgdefaults().MastercardOfferId2__c) || !checkActiveOffer(mastOfferCatalogMap.get(Utils__c.getOrgdefaults().MastercardOfferId2__c))){
                        offer.Note_Interne__c = 'NO';
                        return true;
                    }
                    offer.Offer_code__c = Utils__c.getOrgdefaults().MastercardOfferId2__c;
                }
                offer.Contact_code__c = con.Id;
                //offer.Offer_code__c = Utils__c.getOrgdefaults().MastercardOfferId__c;
                offer.Name = 'MASTERCARD';
                offer.Start_date__c = DateTime.now();
                offer.End_date__c = DateTime.now().addDays((Integer) mastOfferCatalogMap.get(offer.Offer_code__c).App_Visibility_Days__c);
                offer.Partial_step__c = 1;
                offer.ENL_Operation_ID__c = Utils.generateOperationIdFromDateTime();
                offer.Last_Progression_Date__c = DateTime.now();
                offer.URL_mobile_push_page__c = String.isBlank(mastOfferCatalogMap.get(offer.Offer_code__c).Promo_Mobile_Push_Page__c) ? '' : mastOfferCatalogMap.get(offer.Offer_code__c).Promo_Mobile_Push_Page__c + '?subkey=' + con.Id;

                voucher = generateVoucher(voucher, con, 'Mastercard');

                // GC set this value only on SUCCESS from BE EP+ can cause gnerated multiple voucher mastercard until response ok from BE EP+
                con.Mastercard_voucher_recieved__c = true;

                System.debug('offer : ' + offer);

                return true;

            } else{
                return false;
            }
        } else{
            return false;
        }
    }

    //function that generates customer offer for welcome
    public static Boolean generateWelcomeOffer(Customer_Offer__c offer, Contact con){
        system.debug('con : ' + con);
        try{
            DateTime now = DateTime.now();
            Set<Id> welcomeOfferIds1234 = new Set<Id>();
            welcomeOfferIds1234.add(Utils__c.getOrgdefaults().WelcomeOfferId__c);
            welcomeOfferIds1234.add(Utils__c.getOrgdefaults().WelcomeOfferId2__c);
            welcomeOfferIds1234.add(Utils__c.getOrgdefaults().WelcomeOfferId3__c);
            welcomeOfferIds1234.add(Utils__c.getOrgdefaults().WelcomeOfferId4__c);

            if (welOfferCatalogMap1234 == null)
                welOfferCatalogMap1234 = new Map<Id, Offer_Catalog__c>([SELECT Id, Active__c, Validity_start_date__c, Validity_end_date__c, Promo_Mobile_Push_Page__c
                                                                        FROM Offer_Catalog__c
                                                                        WHERE Id IN:welcomeOfferIds1234 AND Validity_start_date__c != null AND Validity_start_date__c <= :now AND Validity_end_date__c != null AND Validity_end_date__c >= :now AND Active__c = true]);
            system.debug('welOfferCatalogMap1234 : ' + welOfferCatalogMap1234);
            //initVoucherTypes();

            if (welOfferCatalogMap1234.size() > 0){
                // && !allInactive) { // controllo inutile
                // TODO: Togliere fitro sulla mastercard e modificare switch su due soli scenari Loyalty o non Loyalty
                String condition = (string.valueOf(con.Credit_Card_Type__c.toUppercase() == 'MASTERCARD') + '|' + string.valueOf(con.Cluster__c != '2')).toUpperCase();

                Map<String, Id> welcomeConditionMapping = new Map<String, Id>();
                welcomeConditionMapping.put('TRUE|TRUE', Utils__c.getOrgdefaults().WelcomeOfferId__c);
                welcomeConditionMapping.put('FALSE|TRUE', Utils__c.getOrgdefaults().WelcomeOfferId2__c);
                welcomeConditionMapping.put('TRUE|FALSE', Utils__c.getOrgdefaults().WelcomeOfferId3__c);
                welcomeConditionMapping.put('FALSE|FALSE', Utils__c.getOrgdefaults().WelcomeOfferId4__c);

                if (welcomeConditionMapping.get(condition) != null && welOfferCatalogMap1234.containsKey(welcomeConditionMapping.get(condition))){
                    offer.Offer_code__c = welcomeConditionMapping.get(condition);
                } else{
                    return false;
                }

                offer.URL_mobile_push_page__c = String.isBlank(welOfferCatalogMap1234.get(offer.Offer_code__c).Promo_Mobile_Push_Page__c) ? '' : welOfferCatalogMap1234.get(offer.Offer_code__c).Promo_Mobile_Push_Page__c + '?subkey=' + con.Id;
                offer.Contact_code__c = con.Id;
                offer.Name = 'WELCOME';
                offer.Start_date__c = con.APP_created_date__c;
                offer.End_date__c = con.APP_created_date__c.addDays(10);
                offer.Partial_step__c = 1;
                offer.Last_Progression_Date__c = DateTime.now();


                system.debug('offer : ' + offer);
                //voucher = generateVoucher(con, 'Welcome');
                return true;

            } else{
                Set<Id> welcomeOfferIdsAB = new Set<Id>();
                welcomeOfferIdsAB.add(Utils__c.getOrgdefaults().WelcomeOfferIdA__c);
                welcomeOfferIdsAB.add(Utils__c.getOrgdefaults().WelcomeOfferIdB__c);

                if (welOfferCatalogMapAB == null)
                    welOfferCatalogMapAB = new Map<Id, Offer_Catalog__c>([SELECT Id, Active__c, Validity_start_date__c, Validity_end_date__c, Promo_Mobile_Push_Page__c
                                                                          FROM Offer_Catalog__c
                                                                          WHERE Id IN:welcomeOfferIdsAB AND Validity_start_date__c != null AND Validity_start_date__c <= :now AND Validity_end_date__c != null AND Validity_end_date__c >= :now AND Active__c = true]);
                system.debug('welOfferCatalogMapAB : ' + welOfferCatalogMapAB);
                if (welOfferCatalogMapAB.size() > 0){
                    if (con.Cluster__c != '2'){
                        if (welOfferCatalogMapAB.containsKey(Utils__c.getOrgdefaults().WelcomeOfferIdA__c)){
                            offer.Offer_code__c = Utils__c.getOrgdefaults().WelcomeOfferIdA__c;
                        } else{
                            return false;
                        }
                    } else{
                        if (welOfferCatalogMapAB.containsKey(Utils__c.getOrgdefaults().WelcomeOfferIdB__c)){
                            offer.Offer_code__c = Utils__c.getOrgdefaults().WelcomeOfferIdB__c;
                        } else{
                            return false;
                        }
                    }
                    offer.URL_mobile_push_page__c = String.isBlank(welOfferCatalogMapAB.get(offer.Offer_code__c).Promo_Mobile_Push_Page__c) ? '' : welOfferCatalogMapAB.get(offer.Offer_code__c).Promo_Mobile_Push_Page__c + '?subkey=' + con.Id;
                    offer.Contact_code__c = con.Id;
                    offer.Name = 'WELCOME';
                    offer.Start_date__c = con.APP_created_date__c;
                    offer.End_date__c = con.APP_created_date__c.addDays(10);
                    offer.Partial_step__c = 1;
                    offer.Last_Progression_Date__c = DateTime.now();

                    system.debug('offer : ' + offer);
                    //voucher = generateVoucher(con, 'Welcome');
                    return true;
                }

            }

            if (Test.isRunningTest()){

                throw new ECU_APC_CustomException('Exception');

            }

        } catch (Exception e){
            system.debug('Error during the generation of Welcome Offer. Error: ' + e.getMessage() + 
                                               ' #' + e.getLineNumber());
        }
        system.debug('cilecca');
        return false;
    }

    public static boolean checkMastercardActive(){
        DateTime now = DateTime.now();
        Set<Id> mastercardOfferIds = new Set<Id>();
        mastercardOfferIds.add(Utils__c.getOrgdefaults().MastercardOfferId__c);
        mastercardOfferIds.add(Utils__c.getOrgdefaults().MastercardOfferId2__c);
        if (mastOfferCatalogMap == null)
            mastOfferCatalogMap = new Map<Id, Offer_Catalog__c>([SELECT Id, Active__c, Validity_start_date__c, Validity_end_date__c, Promo_Mobile_Push_Page__c, App_Visibility_Days__c
                                                                 FROM Offer_Catalog__c
                                                                 WHERE Id IN:mastercardOfferIds AND Validity_start_date__c != null AND Validity_start_date__c <= :now AND Validity_end_date__c != null AND Validity_end_date__c >= :now AND Active__c = true]);
        system.debug('mastOfferCatalogMap = ' + mastOfferCatalogMap);
        system.debug('mastOfferCatalogMap.size() = ' + mastOfferCatalogMap.size());
        return mastOfferCatalogMap.size() > 0;
    }

    public static boolean checkActiveOffer(Offer_Catalog__c oc){
        DateTime now = DateTime.now();
        if (oc.Validity_start_date__c != null && oc.Validity_start_date__c <= now && oc.Validity_end_date__c != null && oc.Validity_end_date__c >= now && oc.Active__c == true){
            return true;
        }
        return false;
    }

    //Checks if environement is Production ORG (true) or Sandbox (false)
    public static void initVoucherTypes(){
        if (voucherTypesMap == null){
            voucherTypesMap = new Map<String, type_of_voucher__c>();
            for (type_of_voucher__c vt : [SELECT Id, Name, CreatedDate, LastModifiedDate, Type__c, Description__c, Voucher_amount__c, Voucher_code__c, Origin__c
                                          FROM type_of_voucher__c
                                          ORDER BY LastModifiedDate ASC]){
                voucherTypesMap.put(vt.Name, vt);
            }
        }
    }

    public static Request_Voucher__c generateVoucher(Request_Voucher__c voucher, Contact con, String type){
        initVoucherTypes();
        type_of_voucher__c tov = voucherTypesMap.get(type) ;

        Datetime now = Datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime local = now.addSeconds(offset / 1000);
        String operationId = String.valueOf(local.getTime());

        voucher.Name = con.FirstName + ' ' + con.LastName + ' ' + tov.Name.toUpperCase();
        voucher.Type__c = tov.Name;
        voucher.Contact_code__c = con.Id;
        voucher.Operation_ID__c = operationId;
        voucher.First_name__c = con.FirstName;
        voucher.Last_name__c = con.LastName;
        voucher.Phone__c = con.MobilePhone;
        voucher.Email__c = con.Email;
        voucher.ENL_Serial_Number__c = Math.round((Math.random() * (900000) + 100000));
        voucher.ENL_Date_Use__c = DateTime.now();
        voucher.Fiscal_code__c = con.Fiscal_code__c;
        voucher.Voucher_amount__c = tov.Voucher_amount__c;
        voucher.Voucher_code__c = (tov.Voucher_code__c == null || tov.Voucher_code__c == 'Codice univoco per cliente') //????????????????? MC 03/04/2019
         ? operationId : tov.Voucher_code__c;

        return voucher;
    }

    //Removes trailing char(s)
    public static String removeTrailingChar(String text, String removeMe){
        while (text.endsWith(removeMe))
            text = text.left(text.length() - 1);
        return text;
    }

    //Updates Transfers data to Contact for reconciliation
    public static Void reconciliationContactUpdate(Contact toBeUpdated, Contact toBeDeleted){

        if (toBeUpdated.Contact_code__c == toBeUpdated.Fiscal_code__c){
            toBeUpdated.Activation_date__c = toBeDeleted.Activation_date__c;
            toBeUpdated.APP_created_date__c = toBeDeleted.APP_created_date__c;
            toBeUpdated.APP_loyalty_customer__c = toBeDeleted.APP_loyalty_customer__c;
            toBeUpdated.Birthdate = toBeDeleted.Birthdate;
            toBeUpdated.Blacklist__c = toBeDeleted.Blacklist__c;
            toBeUpdated.Contact_code__c = toBeDeleted.Contact_code__c;
            toBeUpdated.Email = toBeDeleted.Email;
            toBeUpdated.Employee_Type__c = toBeDeleted.Employee_Type__c;
            toBeUpdated.Enabled__c = toBeDeleted.Enabled__c;
            toBeUpdated.FirstName = toBeDeleted.FirstName;
            toBeUpdated.Fiscal_code__c = toBeDeleted.Fiscal_code__c;
            toBeUpdated.Flag_Privacy_Analysis__c = toBeDeleted.Flag_Privacy_Analysis__c;
            toBeUpdated.Flag_Privacy_ENI__c = toBeDeleted.Flag_Privacy_ENI__c;
            toBeUpdated.Flag_Privacy_Partner__c = toBeDeleted.Flag_Privacy_Partner__c;
            toBeUpdated.Gender__c = toBeDeleted.Gender__c;
            toBeUpdated.House_number__c = toBeDeleted.House_number__c;
            toBeUpdated.Last_update__c = toBeDeleted.Last_update__c;
            toBeUpdated.LastName = toBeDeleted.LastName;
            toBeUpdated.MailingCity = toBeDeleted.MailingCity;
            toBeUpdated.MailingPostalCode = toBeDeleted.MailingPostalCode;
            toBeUpdated.MailingState = toBeDeleted.MailingState;
            toBeUpdated.MailingStreet = toBeDeleted.MailingStreet;
            toBeUpdated.Phone = toBeDeleted.Phone;
            toBeUpdated.Privacy_GEO__c = toBeDeleted.Privacy_GEO__c;
            toBeUpdated.Profession__c = toBeDeleted.Profession__c;
            toBeUpdated.Push_notification__c = toBeDeleted.Push_notification__c;
            toBeUpdated.Web_created_date__c = toBeDeleted.Web_created_date__c;
        }

        toBeDeleted.Contact_code__c += '_OLD';
        toBeDeleted.Sync_with_marketing_cloud__c = false;
    }

    //DateTime to Date Util
    public static String dateTime2Date(DateTime dt){
        if (dt == null)
            return '';
        return String.valueOf(dt).left(10);
    }

    public class MCtokenResponseWrapper{
        String access_token;
        String token_type;
        Integer expires_in;
        String scope;
        String soap_instance_url;
        String rest_instance_url;
    }

    //MCUtils Response Result Handler
    public static List<Log> MCResponseResultHandler(String responseBody, String OriginClass){
        Dom.Document doc = new Dom.Document();
        doc.load(responseBody);

        Dom.XmlNode root = doc.getRootElement();//Lettura root (envelope)
        List<Dom.Xmlnode> content = root.getChildElements();//Content: header+body
        List<Dom.Xmlnode> body = content[1].getChildElements();//Lettura body
        List<Dom.Xmlnode> createresponse = body[0].getChildElements();//lettura contenuto di "createresponse"
        Dom.Xmlnode overallStatus = createresponse[createresponse.size() - 1];

        List<Log> logList = new List<Log>();
        System.debug('overallStatus.getText().trim() : ' + overallStatus.getText().trim());
        if (overallStatus.getText().trim() == 'Error' || overallStatus.getText().trim() == 'Has Errors'){
            System.debug('>>>MCResponseResultHandler : ERROR');
            Log l = new Log();
            l.Level = 'ERROR';
            l.Origin = OriginClass;
            l.TransmittedMessage = String.valueOf(createresponse).abbreviate(32000);

        } else{
            System.debug('>>>MCResponseResultHandler : SUCCESS');
        }

        return logList;
    }

    public static Map<String, Object> MC_Login(Boolean UseProduction){
        Map<String, String> responseMap = new Map<String, String>();
        MC_Utils__c csMC_Utils = MC_Utils__c.getOrgDefaults();
        String Auth_Endpoint = UseProduction ? csMC_Utils.Auth_Endpoint_PROD__c : csMC_Utils.Auth_Endpoint_TEST__c;
        String Auth_Client_Id = UseProduction ? csMC_Utils.Auth_Client_Id_PROD__c : csMC_Utils.Auth_Client_Id_TEST__c;
        String Auth_Client_Secret = UseProduction ? csMC_Utils.Auth_Client_Secret_PROD__c : csMC_Utils.Auth_Client_Secret_TEST__c;

        Http httpLogin = new Http();
        HttpRequest loginRequest = new HttpRequest();

        loginRequest.setEndpoint(Auth_Endpoint);
        loginRequest.setMethod('POST');
        loginRequest.setHeader('Content-Type', 'application/json');
        loginRequest.setHeader('Accept', 'application/json');

        String authJSONbody = '{' + 
                           '"grant_type": "client_credentials",' + 
                           '"client_id": "' + Auth_Client_Id + '",' + 
                           '"client_secret": "' + Auth_Client_Secret + '"' + 
                           '}';
        loginRequest.setBody(authJSONbody);

        Map<String, Object> loginResponse = new Map<String, Object>();

        //system.debug(httpRes.getHeaderKeys());
        //system.debug('json ' + JSON.deserializeUntyped(httpRes.getbody()));
        if (!Test.isRunningTest()){
            HttpResponse httpRes = httpLogin.send(loginRequest);
            loginResponse = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getbody());
        } else{
            loginResponse.put('access_token', (Object) 'accessTK');
        }

        return loginResponse;
    }

    //EN: callout verso MC per innesco MobilePush
    public static List<Log> sendMobilePush(List<String> subscriberKeys, Mc_Utils__c mcUtils, String ovverridePushMessageID, String codiceFiscale){

        String XRequestIdValue = CC_APC_MWCallouts.getRandomUUID();
        List<Log> logs = new List<Log>();
        String authJSONbody = '';
        String messageID = !String.isBlank(ovverridePushMessageID) ? ovverridePushMessageID : mcUtils.ENL_Push_Message_ID__c;
        try{
            system.debug(mcUtils.ENL_Push_Message_ID__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token_Part_2__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token_Part_3__c);
            Http httpSend = new Http();
            HttpRequest httpReq = new HttpRequest();
            httpReq.setEndpoint(mcUtils.ENL_Send_Mobile_Push_Endpoint__c.replace('{0}', messageID));
            httpReq.setMethod('POST');
            httpReq.setHeader('Content-Type', 'application/json;charset=UTF-8');
            httpReq.setHeader('Authorization', 'Bearer ' + mcUtils.ENL_Last_Login_MC_Token__c + mcUtils.ENL_Last_Login_MC_Token_Part_2__c + mcUtils.ENL_Last_Login_MC_Token_Part_3__c);

            //TO DELETE
            System.debug('Utils.sendMobilePush subscriberKeys invio PUSH ' + subscriberKeys);

            authJSONbody = '{' + 
                         '"subscriberKeys": [' + 
                         '"' + String.join(subscriberKeys, '","') + '"' + 
                         ']}';
            
            System.debug('Utils.sendMobilePush authJSONbody: ' + authJSONbody);
            
            httpReq.setBody(authJSONbody);
            system.debug(authJSONbody);
            system.debug(httpReq.getBody());
            Map<String, Object> sendResponse = new Map<String, Object>();

            if (!Test.isRunningTest()){
                HttpResponse httpRes = httpSend.send(httpReq);
                sendResponse = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getbody());
                system.debug(sendResponse);
            } else{
                sendResponse.put('tokenId', (Object) 'tokenId');
            }

            Log l = new Log();
            l.Level = 'INFO';
            l.fiscalCode = codiceFiscale;
            l.EventId = XRequestIdValue;
            l.EventType = 'MC-sendMobilePush';
            l.ResultCode = JSON.serialize(sendResponse);
            l.TransmittedMessage = authJSONbody;
            logs.add(l);


        } catch (Exception e){
            Log l = new Log();
            l.Level = 'ERROR';
            l.Origin = 'Utils.sendMobilePush';
            l.fiscalCode = codiceFiscale;
            l.EventId = XRequestIdValue;
            l.EventType = 'MC-sendMobilePush';
            l.ResultCode = e.getStackTraceString();
            l.TransmittedMessage = authJSONbody;
            l.SystemException = 'Error callout Send Mobile Push: ' + e.getMessage();
            logs.add(l);
        }

        return logs;
    }

    //NA HOT FIX 28/06/2019
    //@future (callout=true)
    public static Void contactTriggerDeleteHandler(Set<Id> toDeleteIds){
        system.debug('sono entrato in Utils.contactTriggerDeleteHandler() conil set di id: ' + toDeleteIds);

        MC_Utils__c csMC_Utils = MC_Utils__c.getOrgDefaults();
        //String Auth_Endpoint = csMC_Utils.Auth_Endpoint_PROD__c;
        //String Auth_Client_Id = csMC_Utils.Auth_Client_Id_PROD__c;
        //String Auth_Client_Secret = csMC_Utils.Auth_Client_Secret_PROD__c;
        String Service_Rest_Endpoint = csMC_Utils.Service_Rest_Endpoint_PROD__c;

        String accessToken = '';

        Http httpDelete = new Http();
        HttpRequest deleteRequest = new HttpRequest();
        //request.setEndpoint('https://mc355dny0trf51zl9x84brywb2w0.rest.marketingcloudapis.com/contacts/v1/contacts/actions/delete?type=keys');
        deleteRequest.setEndpoint(Service_Rest_Endpoint);
        deleteRequest.setMethod('POST');
        deleteRequest.setHeader('Content-Type', 'application/json;charset=UTF-8');

        // Set the body as a JSON object
        Organization org = [SELECT IsSandbox, InstanceName
                            FROM Organization];

        ECU_Organization_Istance__c checkActiveSend = ECU_Organization_Istance__c.getValues(org.InstanceName);
        if (checkActiveSend != null && checkActiveSend.ECU_Active__c){
            system.debug('sono entrato in Utils.contactTriggerDeleteHandler() + deleteBody. String JSON: ' + JSON.serialize(toDeleteIds));
            //List<String> toDeleteIds = new List<String>();

            String deleteBody = '{ "ContactTypeId": 0,' + 
                                '  "values": ';

            deleteBody += JSON.serialize(toDeleteIds) + ', ' + 
                                                        ' "DeleteOperationType": "ContactAndAttributes"}';

            deleteRequest.setBody(deleteBody);

            deleteRequest.setHeader('Authorization', 'Bearer ' + MC_Login(true).get('access_token'));

            // Parse the JSON response
            //System.debug(deleteResponse.getBody());

            Map<String, Object> deleteMap = new Map<String, Object>();
            if (!Test.isRunningTest()){
                HttpResponse deleteResponse = httpDelete.send(deleteRequest);
                system.debug('inviato delete ');
                deleteMap = (Map<String, Object>)JSON.deserializeUntyped(deleteResponse.getBody());
            } else{
                deleteMap.put('hasErrors', (Object) 'false');
            }
            String emailBody = 'Risultati chiamata di cancellazione: \n\n';

            if (Boolean.valueOf(deleteMap.get('hasErrors'))){

                emailBody += '----- Errori cancellazione \n';
                emailBody += '----- resultMessages ' + deleteMap.get('resultMessages') + '\n';
                emailBody += '----- responseDateTime ' + deleteMap.get('responseDateTime') + '\n';

                emailBody += 'Contatti eliminati da Salesforce: \n';
                for (String contactId : toDeleteIds){
                    //con.addError('La chiamata API per la cancellazione dei Contatti da Marketing Cloud ha dato esito negativo. L\'operazione e\' stata annullata');
                    emailBody += contactId + '\n';
                }

            } else{
                emailBody += '----- Informazioni cancellazione \n';
                emailBody += '----- operationID ' + deleteMap.get('operationID') + '\n';
                emailBody += '----- operationInitiated ' + deleteMap.get('operationInitiated') + '\n';
                emailBody += '----- requestServiceMessageID ' + deleteMap.get('requestServiceMessageID') + '\n';
                emailBody += '----- serviceMessageID ' + deleteMap.get('serviceMessageID') + '\n\n';

                emailBody += 'Contatti eliminati da Salesforce: \n';
                for (String contactId : toDeleteIds){
                    emailBody += contactId + '\n';
                }
            }

            //Utils.sendMail('Marketing Cloud delete results', emailBody, 'Marketing Cloud API delete', Utils__c.getOrgDefaults().LogRecipient__c);
        }
    }

    /**
     * @author: Gianluca Campagnoli
     * @date : 29/06/2019
     * @description : init Utils__c Settings
     * @param : none
     * @return : none
     */
    public static void initUtilsSettings(){

        Utils__c utilsSettings = new Utils__c();

        utilsSettings.BatchSizeKPIBlockedTransaction__c = 200;
        utilsSettings.BatchSizeLoyaltyCardMonthlyKPIUpdate__c = 200;
        utilsSettings.BatchSizePreviousPoints__c = 200;

        insert utilsSettings;
    }

    /**
     * @author: Enrico Notaro
     * @date: 21/08/2019
     * @description: Ricava il record type ID dal developer Name e il tipo di SObject in ingresso
     * @param developerName
     * @param sobjType
     * @return record type id

     */
    public static Id getRecordTypeId(String developerName, String sobjType){

        if (recordTypeDeveloperNameToIdMap == null)
            fillRecordTypeMaps();
        return recordTypeDeveloperNameToIdMap.get((developerName + sobjType).toUpperCase());
    }

    /**
     * @author: Enrico Notaro
     * @date: 21/08/2019
     * @description: Ricava il record type name dal record type ID
     * @param recordTypeId
     * @return record type developer name
     */
    public static String getDeveloperName(Id recordTypeId){

        if (recordTypeIdToDeveloperNameMap == null)
            fillRecordTypeMaps();
        return recordTypeIdToDeveloperNameMap.get(recordTypeId);
    }

    /**
     * @author: Enrico Notaro
     * @date: 21/08/2019
     * @description: Popola le mappe recordTypeDeveloperNameToIdMap e recordTypeIdToDeveloperNameMap.
     */
    private static void fillRecordTypeMaps(){

        recordTypeDeveloperNameToIdMap = new Map<String, Id>();
        recordTypeIdToDeveloperNameMap = new Map<Id, String>();
        for (RecordType rt : [SELECT Id, DeveloperName, SobjectType
                              FROM RecordType]){

            recordTypeDeveloperNameToIdMap.put((rt.DeveloperName + rt.SobjectType).toUpperCase(), rt.Id);
            recordTypeIdToDeveloperNameMap.put(rt.Id, rt.DeveloperName);
        }
    }

    /**
     * @author: Enrico Notaro
     * @date: 23/09/2019
     * @description: Metodo che ritorna un numero randomico da un range di valori
     * @param startNum, endNum
     * @return random integer
     */
    public static Integer generateRandomFromRange(integer startNum, integer endNum){
        Integer returnValue;
        //Logic- first we will generate random boolean value which will decide if we want to
        //add the random number from startNum or will subtract random number from endNum
        Integer randomNumber = Integer.valueof((math.random() * 10));
        boolean addSubFlag = math.mod(randomNumber, 2) == 0 ? true : false;

        integer diffInRange = endNum - startNum;
        //Now find random number staring from 0 to diffInRange
        Integer randomNum = Math.mod(Math.round(Math.random() * diffInRange + 1), diffInRange);

        //If addSubFlag is true, we will add random number generated between 0 and diffInRange from start number
        //else we will subtract random number from end number
        if (addSubFlag){
            if (diffInRange > 1){
                returnValue = startNum + randomNum;
            } else{
                returnValue = startNum;
            }
        } else{
            if (diffInRange > 1){
                returnValue = endNum - randomNum;
            } else{
                returnValue = endNum;
            }
        }
        return returnValue;
    }

    /**
     * @author: GC
     * @date: 30/11/2020
     * @description: Metodo che effettua l'anonimizzazionde dei dati sensibili di un Cliente nel rispettivo Contact
     *               ENICCM-137 [RET20012] Cancellazione Cliente
     * @param Contact
     * @return Contact
     */
    public static Contact contactAnonymization(Contact contactToAnonymize){

        contactToAnonymize.Contact_Code__c = Utils.generateOperationIdFromDateTime();
        contactToAnonymize.Fiscal_code__c = 'CRM ANONYMOUS';
        contactToAnonymize.Firstname = 'CRM ANONYMOUS';
        contactToAnonymize.Lastname = 'CRM ANONYMOUS';
        contactToAnonymize.Email = 'crm@anonymous.com';
        contactToAnonymize.Phone = '0';
        contactToAnonymize.MobilePhone = '0';
        contactToAnonymize.Plate__c = 'CRM ANONYMOUS';
        contactToAnonymize.Business_Name__c = 'CRM ANONYMOUS';
        contactToAnonymize.Billing_First_Name__c = 'CRM ANONYMOUS';
        contactToAnonymize.Billing_Fiscal_Code__c = 'CRM ANONYMOUS';
        contactToAnonymize.Billing_Last_Name__c = 'CRM ANONYMOUS';
        contactToAnonymize.Billing_Address__c = 'CRM ANONYMOUS';
        contactToAnonymize.PEC_Email__c = 'crm@anonymous.com';
        contactToAnonymize.SDI_Code__c = '1234567';
        contactToAnonymize.VAT_Number__c = '1234567';
        //andrea.fancello@webresults.it - Hotfix-222 - 26-10-23 -START
        contactToAnonymize.Billing_Street_Number__c = 'CRM ANONYMOUS';
        contactToAnonymize.Billing_City__c          = 'CRM ANONYMOUS';
        contactToAnonymize.Billing_Region__c        = '00';
        contactToAnonymize.Billing_Country__c       = '00';
        contactToAnonymize.Billing_Postal_Code__c   = '00000';
        contactToAnonymize.Billing_Email__c         = 'crm@anonymous.com';
        //andrea.fancello@webresults.it - Hotfix-222 - 26-10-23 -END
        return contactToAnonymize;
    }

    /**
     * @author: GC
     * @date: 30/11/2020
     * @description: Metodo che effettua l'anonimizzazionde dei dati sensibili di un Cliente nel rispettivo Account
     *               ENICCM-137 [RET20012] Cancellazione Cliente
     * @param List<Account>
     * @return List<Account>
     */
    public static List<Account> accountAnonymization(List<Account> accountListToAnonymize){

        for (Account acc : accountListToAnonymize){
            acc.Contact_Code__c = Utils.generateOperationIdFromDateTime();
            acc.Name = 'CRM ANONYMOUS';
            acc.VAT_Number__c = '0';
        }
        return accountListToAnonymize;
    }

    /**
     * @author: GC
     * @date: 09/12/2020
     * @description: Metodo che ritorna un codice numerico (lenght 13) che rappresenta il numero di millisecondi dell'oggetto DateTime
     * @param
     * @return String
     */
    public static String generateOperationIdFromDateTime(){

        Datetime now = Datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime local = now.addSeconds(offset / 1000);
        String operationId = String.valueOf(local.getTime());

        return operationId;
    }

    /**
     * @author: GC
     * @date: 15/12/2020
     * @description: Metodo che gestisce la cancellazione del Contact a fronte di un evento di "Cancellazione Cliente" (Customer/Business) inbound dal Backend dell'App
     *               ENICCM-137 [RET20012] Cancellazione Cliente
     * @param Contact, String, String
     * @return Contact
     */
    public static Contact contactCancellation(Contact contactToCancel, String cancellationType, String originCancRequest){

        //CancellationType values:
        //0 = Cancellazione dalla loyalty; 1 = Cancellazione dall'app; 2 = Diritto all’oblio

        switch  on cancellationType{
            when '0'{
                contactToCancel.Enabled__c = FALSE;
                contactToCancel.Sync_with_marketing_cloud__c = FALSE;
            }
            when '1'{
                contactToCancel.EniStation_APP_payment__c = FALSE;
                contactToCancel.Enabled__c = FALSE;
                contactToCancel.Sync_with_marketing_cloud__c = FALSE;
            }
            when '2'{
                Utils.contactAnonymization(contactToCancel);
                contactToCancel.Enabled__c = FALSE;
                contactToCancel.Sync_with_marketing_cloud__c = FALSE;
            }
            when else{
                //throw exception (Tipologia cancellazione non prevista) //technically should never happen

            }
        }

        return contactToCancel;
    }

    /**
     * @author: GC
     * @date: 10/02/2021
     * @description: Metodo che riceve un array di String e restituisce una String unica con i valori dell'array concatenati da \n per visualizzazione su TextArea
     *               ENICCM-146 RET20015 Nuova Loyalty
     * @param String[]
     * @return String
     */
    public static String fromStringArrayToString(List<String> arrayStrings){

        String result = '';

        if (arrayStrings != NULL && arrayStrings.size() > 0){
            for (String str : arrayStrings){
                result += str + '\n';
            }
            result = result.removeEnd('\n');
        }

        return result;
    }

    /**
     * @author: GN
     * @date: 24/03/2021
     * @description: Metodo che inizializza i contatti che stanno effettuando la riconciliazione,
     * richiamato nell'inizializzazione dell'evento 7 mdofica dati cliente del WS_ENIInteract, modifiche App Unica.
     */
    public static Contact initializeReconciliation(String riconciliazione, String tipologiaUtente, String codiceFiscale){
        Contact resultContact = null;
        List<Contact> contactToUpdateFrom = new List<Contact>();
        List<Contact> contactToDisable = new List<Contact>();
        List<Contact> contactsList = new List<Contact>();
        String recordTypeCC = Utils.getRecordTypeId('CC_RT_Customer', 'Contact');
        String customerTypeReconciliation = '';
        Id recordTypeCustomer = Utils.getRecordTypeId('Customer', 'Contact');
        Id recordTypeBusiness = Utils.getRecordTypeId('Business', 'Contact');
        List<Id> recordTypeLoyalty = new List<Id>();
        recordTypeLoyalty.add(recordTypeCustomer);
        recordTypeLoyalty.add(recordTypeBusiness);


        if (riconciliazione == '0'){
            for (Contact con : [SELECT Id, RecordTypeId, Fiscal_code__c, Contact_code__c, FirstName, LastName, Email, Customer_type__c,
                    ENL_Tipo_Multicard_1__c, ENL_Tipo_Multicard_2__c, ENL_Data_Inserimento_Multicard_1__c, ENL_Data_Inserimento_Multicard_2__c,
                    Credit_Card_Type__c, Credit_card_association__c, Contact.AccountId, Cluster__c, Flag_Loyalty__c, Privacy_GEO__c, Flag_Term_Cond__c,
                    Flag_Clause_Spec__c, Flag_Privacy_Policy__c, Flag_Privacy_Analysis__c, Flag_Privacy_Policy_Source__c, Flag_Privacy_Policy_DateChange__c,
                    Flag_Profilazione__c, Business_Name__c, isBusiness__c, Riconciliazione_Customer_Type__c, Flag_Privacy_ENI__c, Flag_Privacy_ENI_Source__c,
                    Flag_Privacy_ENI_DateChange__c, Flag_Privacy_Partner__c, Flag_Privacy_Partner_Source__c, Flag_Privacy_Partner_DateChange__c,
                    Push_notification__c, MobilePhone, Phone, Billing_Email__c, Consumer_Billing_Address__c, Consumer_Billing_City__c,
                    Consumer_Billing_First_Name__c, Consumer_Billing_Last_Name__c, Consumer_Billing_Postal_Code__c, Consumer_Billing_Region__c,
                    Consumer_Billing_Street_Number__c, MailingPostalCode, MailingCity, MailingState, Billing_Address__c, Billing_Street_Number__c,
                    Billing_Region__c, Billing_Country__c, MailingStreet, ENL_Canale_Registrazione__c, Plate__c, Billing_City__c, Flag_Entry_Gift__c,
                    Billing_Postal_Code__c, Billing_First_Name__c, Flag_Entry_Offer__c, Billing_Last_Name__c, PEC_Email__c, SDI_Code__c, VAT_Number__c,
                    isConsumer__c, Flag_Multi_Easy__c, Multicard__c, Multicard_Wa__c, Billing_Fiscal_Code__c, Gender__c, Reconciliation__c,
                    ELP_Loyalty_2024_Accepted__c, // stefano.bassotti@webresults.it CLU-23019
                    (select Id, ContactId from Cases)
                                FROM Contact 
                                WHERE Fiscal_code__c = :codiceFiscale AND RecordTypeId IN:recordTypeLoyalty]){
                contactsList.add(con);
            }

            if (contactsList.size() == 1){
                resultContact = contactsList.get(0);
                resultContact.Reconciliation__c = riconciliazione;
                resultContact.isConsumer__c = true;
                resultContact.Customer_Type__c = '2';
                resultContact.RecordTypeId = Utils.getRecordTypeId('Customer', 'Contact');
                resultContact.Riconciliazione_Customer_Type__c = tipologiaUtente;
                resultContact.Sync_with_marketing_cloud__c = true;
                system.debug('Effettuata riconciliazione col precedente profilo unico per il contatto ' + codiceFiscale);
            } else if (contactsList.size() > 1){
                system.debug('tipo utente ' + tipologiaUtente);
                if (tipologiaUtente == '2'){
                    for (Contact con : contactsList){
                        if (con.Customer_Type__c == '0' || (con.Customer_Type__c == '2' && con.Riconciliazione_Customer_Type__c == '0')){
                            resultContact = con;
                        } else{
                            contactToUpdateFrom.add(con);
                        }
                    }

                    if (resultContact != null && contactToUpdateFrom.size() > 0){
                        for (Contact c : contactToUpdateFrom){
                            resultContact.Business_Name__c = c.Business_Name__c;
                            resultContact.Billing_Address__c = c.Billing_Address__c;
                            resultContact.Billing_City__c = c.Billing_City__c;
                            resultContact.Billing_Country__c = c.Billing_Country__c;
                            resultContact.Billing_First_Name__c = c.Billing_First_Name__c;
                            resultContact.Billing_Fiscal_Code__c = c.Billing_Fiscal_Code__c;
                            resultContact.Billing_Last_Name__c = c.Billing_Last_Name__c;
                            resultContact.Billing_Postal_Code__c = c.Billing_Postal_Code__c;
                            resultContact.Billing_Region__c = c.Billing_Region__c;
                            resultContact.Billing_Street_Number__c = c.Billing_Street_Number__c;
                            resultContact.VAT_Number__c = c.VAT_Number__c;
                            resultContact.SDI_Code__c = c.SDI_Code__c;
                            resultContact.PEC_Email__c = c.PEC_Email__c;
                            resultContact.Reconciliation__c = riconciliazione;
                            resultContact.isConsumer__c = true;
                            resultContact.Customer_Type__c = '2';
                            resultContact.Enabled__c = true;
                            resultContact.Sync_with_marketing_cloud__c = true;
                            resultContact.Riconciliazione_Customer_Type__c = tipologiaUtente;

                        }
                        system.debug('esecuzione riconciliazione contatto consumer ' + resultContact);
                    }
                } else{
                    for (Contact con : contactsList){
                        if (con.Riconciliazione_Customer_Type__c != null)
                            customerTypeReconciliation = con.Riconciliazione_Customer_Type__c;
                        else
                            customerTypeReconciliation = con.Customer_Type__c;
                        if (customerTypeReconciliation == tipologiaUtente){
                            resultContact = con;
                            resultContact.isConsumer__c = true;
                            resultContact.Reconciliation__c = riconciliazione;
                            resultContact.Enabled__c = true;
                            resultContact.Sync_with_marketing_cloud__c = true;
                            resultContact.Riconciliazione_Customer_Type__c = tipologiaUtente;
                            resultContact.Customer_Type__c = '2';
                            resultContact.RecordTypeId = Utils.getRecordTypeId('Customer', 'Contact');
                        } else{
                            if (tipologiaUtente == '0'){
                                con.isConsumer__c = false;
                                con.Reconciliation__c = '2';
                                con.Customer_Type__c = '1';
                                contactToDisable.add(con);
                            }
                            if (tipologiaUtente == '1'){
                                con.isConsumer__c = false;
                                con.Reconciliation__c = '2';
                                con.Customer_Type__c = '0';
                                contactToDisable.add(con);
                            }
                        }
                    }
                    try{
                        TriggerManager.skipTrigger('ContactTrigger');
                        update contactToDisable;
                        TriggerManager.unskipTrigger('ContactTrigger');

                    } catch (Exception e){

                        system.debug('Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber());
                        Log l = new Log('ERROR', 'Utils.initializeReconciliation', 'Execution failed', 'Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber(), '', '', '', null);

                        Utils.generateLogs(l, '');


                    }
                }
            }
            //ciclo i contatti e aggiorno i campi del consumer + relazioni transaction,case,loyalty_card
            //dopo l'update del contatto fare delete di account e contatto business
            //aggiornare flag isBusinness= true

        }
        //    if(riconciliazione == '1'){
        //        //la riconciliazione in questo caso è stata posticipata e si intende attivare solo uno dei contatti
        //        //select del contatto con customer_type che viene passato e lo ritorna'evento 7
        //        for(Contact con :[SELECT Id, RecordTypeId, Fiscal_code__c, Contact_code__c, FirstName, LastName,
        //                            Customer_type__c,Credit_Card_Type__c,
        //                            Business_Name__c, isBusiness__c,
        //                            Billing_Address__c,Billing_Street_Number__c,Billing_City__c,Billing_Region__c,
        //                            Billing_Country__c,Billing_Postal_Code__c,Billing_First_Name__c,
        //                            Billing_Last_Name__c,PEC_Email__c,SDI_Code__c,VAT_Number__c, isConsumer__c,
        //                            Billing_Fiscal_Code__c,(select Id, ContactId from Cases),Reconciliation__c
        //                            FROM Contact WHERE Fiscal_code__c = :codiceFiscale ]) {
        //                 if( con.Customer_Type__c == tipologiaUtente){
        //                 resultContact = con;
        //                 resultContact.isConsumer__c = true;
        //                 resultContact.Reconciliation__c = '1';
        //                 resultContact.Enabled__c = true;
        //                 resultContact.Sync_with_marketing_cloud__c = true;
        //                 }
        //                 // else{
        //                 //     contactToDisable.add(con);
        //                 // }
        //         }

        //     //     if(resultContact != null && contactToDisable.size()>0){
        //     //        for(Contact c : contactToDisable){
        //     //         c.isConsumer__c = false;
        //     //     }
        //     //     //update contactToDisable;
        //     // }
        // }
        if (riconciliazione == '1'){
            //select del contatto con customer_type che mi viene passato e lo ritorna all'evento 7
            //gli altri eventuali contatti vanno o aggoirnati a enabled (metodo anonimizzazione) o cancellati
            //nel caso di anonimizzazione il contact_code si può aggiornare col solo codice fiscale
            // nel caso in cui decida di mantenere il contatto business aggiornare il flag isBusiness = true
            for (Contact con : [SELECT Id, RecordTypeId, Fiscal_code__c, Contact_code__c, FirstName, LastName, Email, Customer_type__c, ENL_Tipo_Multicard_1__c, ENL_Tipo_Multicard_2__c, ENL_Data_Inserimento_Multicard_1__c, ENL_Data_Inserimento_Multicard_2__c, Credit_Card_Type__c, Credit_card_association__c, Contact.AccountId, Cluster__c, Flag_Loyalty__c, Privacy_GEO__c, Flag_Term_Cond__c, Flag_Clause_Spec__c, Flag_Privacy_Policy__c, Flag_Privacy_Analysis__c, Flag_Privacy_Policy_Source__c, Flag_Privacy_Policy_DateChange__c, Flag_Profilazione__c, Business_Name__c, isBusiness__c, Riconciliazione_Customer_Type__c, Flag_Privacy_ENI__c, Flag_Privacy_ENI_Source__c, Flag_Privacy_ENI_DateChange__c, Flag_Privacy_Partner__c, Flag_Privacy_Partner_Source__c, Flag_Privacy_Partner_DateChange__c, Push_notification__c, MobilePhone, Phone, Billing_Email__c, Consumer_Billing_Address__c, Consumer_Billing_City__c, Consumer_Billing_First_Name__c, Consumer_Billing_Last_Name__c, Consumer_Billing_Postal_Code__c, Consumer_Billing_Region__c, Consumer_Billing_Street_Number__c, MailingPostalCode, MailingCity, MailingState, Billing_Address__c, Billing_Street_Number__c, Billing_Region__c, Billing_Country__c, MailingStreet, ENL_Canale_Registrazione__c, Plate__c, Billing_City__c, Flag_Entry_Gift__c, Billing_Postal_Code__c, Billing_First_Name__c, Flag_Entry_Offer__c, Billing_Last_Name__c, PEC_Email__c, SDI_Code__c, VAT_Number__c, isConsumer__c, Flag_Multi_Easy__c, Multicard__c, Multicard_Wa__c, Billing_Fiscal_Code__c, Gender__c, Reconciliation__c,
                                 (select Id, ContactId from Cases)
                                FROM Contact
                                WHERE Fiscal_code__c = :codiceFiscale AND RecordTypeId IN:recordTypeLoyalty]){
                if (con.Riconciliazione_Customer_Type__c != null)
                    customerTypeReconciliation = con.Riconciliazione_Customer_Type__c;
                else
                    customerTypeReconciliation = con.Customer_Type__c;
                if (customerTypeReconciliation == tipologiaUtente){
                    resultContact = con;
                    resultContact.isConsumer__c = true;
                    resultContact.Reconciliation__c = '1';
                    resultContact.Enabled__c = true;
                    resultContact.Sync_with_marketing_cloud__c = true;
                    resultContact.Riconciliazione_Customer_Type__c = tipologiaUtente;
                    resultContact.Customer_Type__c = '2';
                    resultContact.RecordTypeId = Utils.getRecordTypeId('Customer', 'Contact');
                    system.debug('contatto da riconciliare con cancellazione ' + con);
                }
            }
        }

        return resultContact;
    }

    //commentate le logiche sulla loyalty card per dismissione delle stesse
    public static void executeReconciliation(String riconciliazione, String tipologiaUtente, String codiceFiscale, Id conId, Id accId){
        List<Contact> contactToUpdateFrom = new List<Contact>();
        List<Contact> contactToDelete = new List<Contact>();
        List<Contact> contactToDisable = new List<Contact>();
        List<Contact> contactsList = new List<Contact>();
        List<Transaction__c> transactionToUpdate = new List<Transaction__c>();
        List<Case> caseToUpdate = new List<Case>();
        //List<Loyalty_Card__c> loyaltyCardToUpdate = new List<Loyalty_Card__c>();
        //List<Loyalty_Card__c> loyaltyCardOnlyBusiness = new List<Loyalty_Card__c>();
        List<Account> accountToDelete = new List<Account>();
        Set<Id> accIdToDeleteSet = new Set<Id>();
        String recordTypeCC = Utils.getRecordTypeId('CC_RT_Customer', 'Contact');
        Id recordTypeCustomer = Utils.getRecordTypeId('Customer', 'Contact');
        Id recordTypeBusiness = Utils.getRecordTypeId('Business', 'Contact');
        List<Id> recordTypeLoyalty = new List<Id>();
        recordTypeLoyalty.add(recordTypeCustomer);
        recordTypeLoyalty.add(recordTypeBusiness);
        //aggiungere l'aggiornamento dell'accountId del case con l'account Id del nuovo contatto
        //Contact newContact =[SELECT Id, Fiscal_code__c, Contact_code__c,accountId from Contact where id = :conId];

        if (riconciliazione == '0'){

            for (Contact con : [SELECT Id, RecordTypeId, Fiscal_code__c, Contact_code__c, ENL_Tipo_Multicard_1__c, ENL_Tipo_Multicard_2__c, ENL_Data_Inserimento_Multicard_1__c, ENL_Data_Inserimento_Multicard_2__c, FirstName, LastName, Customer_type__c, Credit_Card_Type__c, Flag_Privacy_ENI__c, Business_Name__c, isBusiness__c, Cluster__c, Flag_Loyalty__c, Flag_Entry_Gift__c, Billing_Address__c, Billing_Street_Number__c, Billing_City__c, Billing_Region__c, Billing_Country__c, Billing_Postal_Code__c, Billing_First_Name__c, Flag_Entry_Offer__c, Flag_Multi_Easy__c, Billing_Last_Name__c, PEC_Email__c, SDI_Code__c, VAT_Number__c, isConsumer__c, Billing_Fiscal_Code__c, Reconciliation__c, accountId,                                                                                       /* (select Id, Contact__c, Name, Card_code__c, RecordTypeId
             from Loyalty_Cards__r),*/(select Id, Contact__c
                                       from Transactions_c__r), (select Id, ContactId, accountId
                                                                 from Cases)
                                FROM Contact 
                                WHERE Fiscal_code__c = :codiceFiscale AND RecordTypeId IN:recordTypeLoyalty]){
                contactsList.add(con);
                /*
                 if (tipologiaUtente == '1' && con.Loyalty_Cards__r.size() > 0)
                 loyaltyCardOnlyBusiness.addAll(con.Loyalty_Cards__r);
                 */
            }
            //blocco da eseguire solo se ci sono più profili per lo stesso utente
            if (contactsList.size() > 1 && tipologiaUtente == '2'){
                Id checkAccountId = null;
                Boolean flagAccount = true;
                Boolean flagLoyalty = true;
                for (Contact con : contactsList){
                    if (con.id != conId){
                        /*
                         If (con.Loyalty_Cards__r.size() > 0)
                         loyaltyCardToUpdate.addAll(con.Loyalty_Cards__r);
                         */
                        If (con.Transactions_c__r.size() > 0)
                            transactionToUpdate.addAll(con.Transactions_c__r);
                        If (con.Cases.size() > 0)
                            caseToUpdate.addAll(con.Cases);
                        //accIdToDeleteSet.add(con.AccountId);

                        contactToDelete.add(con);
                        system.debug('esecuzione riconciliazione contatto ' + con);
                        //system.debug('esecuzione riconciliazione loy ' + loyaltyCardToUpdate);
                        system.debug('esecuzione riconciliazione transaction ' + transactionToUpdate);
                        system.debug('esecuzione riconciliazione case ' + caseToUpdate);
                    }
                    //controllo se i due contatti condividono lo stesso account
                    //    if(checkAccountId == null){
                    //        checkAccountId = con.AccountId;
                    //    }
                    //    else{
                    //        if(checkAccountId == con.AccountId)
                    //         flagAccount = false;
                    //    }
                }

                for (Transaction__c t : transactionToUpdate){
                    t.Contact__c = conId;
                    system.debug('esecuzione riconciliazione transazione ' + t);
                }
                for (Case ca : caseToUpdate){
                    ca.ContactId = conId;
                    ca.AccountId = accId;
                    system.debug('esecuzione riconciliazione case ' + ca);
                }
                //ciclo di controllo per verificare la presenza di eventuali loyalty_card business
                /*
                 for (Loyalty_Card__c lc : loyaltyCardToUpdate){
                 if (lc.RecordTypeId == Utils.getRecordTypeId('Without_Card', 'Loyalty_card__c') && lc.Card_code__c == codiceFiscale + '_BUSINESS'){
                 flagLoyalty = false;
                 }

                 }
                 for (Loyalty_Card__c lc : loyaltyCardToUpdate){
                 lc.Contact__c = conId;
                 if (lc.RecordTypeId == Utils.getRecordTypeId('Without_Card', 'Loyalty_card__c') && lc.Card_code__c != codiceFiscale + '_BUSINESS' && flagLoyalty){
                 lc.Name = codiceFiscale + '_BUSINESS';
                 lc.Card_code__c = codiceFiscale + '_BUSINESS';
                 flagLoyalty = false;
                 }
                 system.debug('esecuzione riconciliazione card ' + lc);
                 }
                 */
                // if(flagAccount){
                // for(Account ac :[SELECT Id
                // FROM Account WHERE Id IN : accIdToDeleteSet ]) {
                // accountToDelete.add(ac);
                // system.debug('esecuzione riconciliazione account ' + ac);
                //     }
                //}

                try{
                    TriggerManager.skipTrigger('TransactionTrigger');
                    update transactionToUpdate;
                    TriggerManager.unskipTrigger('TransactionTrigger');
                    TriggerManager.skipTrigger('CC_APT_CaseTrigger');
                    update caseToUpdate;
                    TriggerManager.unskipTrigger('CC_APT_CaseTrigger');
                    //update loyaltyCardToUpdate;
                    delete contactToDelete;

                } catch (Exception e){

                    system.debug('Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber());
                    Log l = new Log('ERROR', 'Utils.executeReconciliation', 'Execution failed', 'Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber(), '', '', '', null);


                    Utils.generateLogs(l, '');


                }
                //            if(flagAccount)
                //                delete accountToDelete;

                system.debug('esecuzione riconciliazione transazione ' + transactionToUpdate);
                system.debug('esecuzione riconciliazione contatto ' + contactToDelete);


                //ciclo i contatti e aggiorno i campi del consumer + relazioni transaction,case,loyalty_card
                //dopo l'update del contatto fare delete di account e contatto business
                //aggiornare flag isBusinness= true
            }
            //un solo profilo business
            /*
             else if (contactsList.size() == 1 && tipologiaUtente == '1'){
             Boolean flag = false;
             for (Loyalty_Card__c lc : loyaltyCardOnlyBusiness){
             if (lc.RecordTypeId == Utils.getRecordTypeId('Without_Card', 'Loyalty_card__c')){
             if (lc.Card_code__c != codiceFiscale + '_BUSINESS'){
             lc.Name = codiceFiscale + '_BUSINESS';
             lc.Card_code__c = codiceFiscale + '_BUSINESS';
             } else
             flag = true;
             system.debug('esecuzione riconciliazione card solo Business ' + lc);
             }
             }
             if (!flag)
             try{
             update loyaltyCardOnlyBusiness;
             if (Test.isRunningTest()){

             throw new ECU_APC_CustomException('Exception');

             }
             } catch (Exception e){

             system.debug('Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber());
             Log l = new Log('ERROR', 'Utils.executeReconciliation', 'Execution failed', 'Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber(), '', '', '', null);


             Utils.generateLogs(l, '');


             }

             }
             */
        }
        //    if(riconciliazione == '1'){
        //        //la riconciliazione in questo caso è stata posticipata e si intende attivare solo uno dei contatti
        //        //select del contatto con customer_type che viene passato e lo ritorna all'evento 7
        //         for(Contact con :[SELECT Id, Fiscal_code__c, Contact_code__c,
        //                             Customer_type__c,
        //                             isConsumer__c
        //                             FROM Contact WHERE Fiscal_code__c = :codiceFiscale ANd Id <> :conId ]) {
        //                     con.isConsumer__c = false;
        //                     con.Reconciliation__c = '3';
        //                     contactToDisable.add(con);

        //         }
        //         update contactToDisable;

        // }
        if (riconciliazione == '1'){
            //    gli altri eventuali contatti vanno o aggoirnati a enabled (metodo anonimizzazione) o cancellati
            for (Contact con : [SELECT Id, Fiscal_code__c, Contact_code__c, ENL_Tipo_Multicard_1__c, ENL_Tipo_Multicard_2__c, ENL_Data_Inserimento_Multicard_1__c, ENL_Data_Inserimento_Multicard_2__c, Customer_type__c, isConsumer__c
                                FROM Contact
                                WHERE Fiscal_code__c = :codiceFiscale AND RecordTypeId IN:recordTypeLoyalty]){
                if (con.Id == conId){
                    con.Reconciliation__c = '0';
                    contactsList.add(con);
                } else{
                    con.isConsumer__c = false;
                    con.Reconciliation__c = '1';
                    con.Enabled__c = false;
                    con.Sync_with_marketing_cloud__c = false;
                    contactToDisable.add(con);
                }
            }
            try{
                TriggerManager.skipTrigger('ContactTrigger');
                update contactsList;
                update contactToDisable;
                TriggerManager.unskipTrigger('ContactTrigger');
                System.debug('contatto cancellato logicamente ' + contactToDisable);
                if (Test.isRunningTest()){

                    throw new ECU_APC_CustomException('Exception');

                }
            } catch (Exception e){

                system.debug('Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber());
                Log l = new Log('ERROR', 'Utils.executeReconciliation', 'Execution failed', 'Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber(), '', '', '', null);


                Utils.generateLogs(l, '');


            }
        }
    }

    /**
     * @author: GC
     * @date: 03/07/2021
     * @description: Metodo che restituisce la mappa delle Customer_Offer__c a aprtire dal Contact a fronte di un evento di "Cancellazione Cliente" (Customer/Business) inbound dal Backend dell'App
     * @modify Fabrizio Fiorentini esclusione customer offer una tantum
     * @param List<Contact>, Set<Id>, DateTime
     * @return Map<Id, List<Customer_Offer__c>>
     */
    public static Map<Id, List<Customer_Offer__c>> getCustomerOfferMapFromContactList(List<Contact> listContact, Set<Id> offerSet, String startDate){
//Inizio stefano.bassotti@webresults.it RET-23069
/*
        String unaTantum = ENL_APC_ConstantClass.OFFC_TIME_UNA_TANTUM;
        Map<Id, List<Customer_Offer__c>> customerOfferMapOnContact = new Map<Id, List<Customer_Offer__c>>();
        List<Customer_Offer__c> cOfferList = Database.query('SELECT Id, Name, Offer_code__c, Start_date__c, URL_mobile_push_page__c,Offer_code__r.ENL_Time_Eligibility__c, Banner_id__c, ' + 
                                                            'Contact_code__c, Date_Goal_Achieved__c, Registration_Date__c, Offer_name__c, Last_Progression_Date__c, ' + 
                                                            'URL_voucher__c, ENL_Status__c, ENL_JSON_Conditions_Purchase__c, ENL_Lottery_Code__c, ENL_TAP_Number__c, ' + 
                                                            'ENL_End_Time_Button__c, ENL_Service_Station__c, ENL_Operation_ID__c, ENL_Condition_Code__c, ECU_Deathline__c ' + 
                                                            'FROM Customer_Offer__c ' + 
                                                            'WHERE (Offer_code__c IN :offerSet AND Contact_code__c IN :listContact AND Offer_code__r.ENL_Time_Eligibility__c =: unaTantum) OR (Offer_code__c IN :offerSet AND Contact_code__c IN :listContact AND Offer_code__r.ENL_Time_Eligibility__c !=: unaTantum AND Start_Date__c = ' + startDate + ')');
        for (Customer_Offer__c co : cOfferList){

            if (customerOfferMapOnContact.containsKey(co.Contact_code__c)){
                customerOfferMapOnContact.get(co.Contact_code__c).add(co);
            } else{
                customerOfferMapOnContact.put(co.Contact_code__c, new List<Customer_Offer__c>{ co });
            }
        }
*/
        String timePromo = ENL_APC_ConstantClass.OFFC_TIME_TIME_PROMO;
        String unaTantum = ENL_APC_ConstantClass.OFFC_TIME_UNA_TANTUM;

        List<Customer_Offer__c> cOfferList;
        Map<Id, List<Customer_Offer__c>> customerOfferMapOnContact = new Map<Id, List<Customer_Offer__c>>();

         if (timePromo.equalsIgnoreCase(startDate)) {
            cOfferList = Database.query('SELECT Id, Name, Offer_code__c, Start_date__c, URL_mobile_push_page__c,Offer_code__r.ENL_Time_Eligibility__c, Banner_id__c, ' +
         'Contact_code__c, Date_Goal_Achieved__c, Registration_Date__c, Offer_name__c, Last_Progression_Date__c, ' +
         'URL_voucher__c, ENL_Status__c, ENL_JSON_Conditions_Purchase__c, ENL_Lottery_Code__c, ENL_TAP_Number__c, ' +
         'ENL_End_Time_Button__c, ENL_Service_Station__c, ENL_Operation_ID__c, ENL_Condition_Code__c, ECU_Deathline__c, ' +
                    'CreatedDate, Offer_code__r.Active__c, Offer_code__r.Validity_start_date__c, Offer_code__r.Validity_end_date__c ' +
                    'FROM Customer_Offer__c ' +
                    'WHERE Offer_code__c IN :offerSet AND Contact_code__c IN :listContact' );

            for (Customer_Offer__c co : cOfferList){

//              if (co.Offer_code__r.Active__c == true && co.Offer_code__r.Validity_start_date__c >= co.CreatedDate && co.Offer_code__r.Validity_end_date__c < co.CreatedDate){
                if (co.Offer_code__r.Active__c == true && co.Offer_code__r.Validity_start_date__c <= co.CreatedDate && co.Offer_code__r.Validity_end_date__c > co.CreatedDate){
                    if (customerOfferMapOnContact.containsKey(co.Contact_code__c)){
                        customerOfferMapOnContact.get(co.Contact_code__c).add(co);
                    } else {
                        customerOfferMapOnContact.put(co.Contact_code__c, new List<Customer_Offer__c>{ co });
                    }
                }
            }

        } else {

            cOfferList = Database.query('SELECT Id, Name, Offer_code__c, Start_date__c, URL_mobile_push_page__c,Offer_code__r.ENL_Time_Eligibility__c, Banner_id__c, ' +
                                            'Contact_code__c, Date_Goal_Achieved__c, Registration_Date__c, Offer_name__c, Last_Progression_Date__c, ' +
                                            'URL_voucher__c, ENL_Status__c, ENL_JSON_Conditions_Purchase__c, ENL_Lottery_Code__c, ENL_TAP_Number__c, ' +
                                            'ENL_End_Time_Button__c, ENL_Service_Station__c, ENL_Operation_ID__c, ENL_Condition_Code__c, ECU_Deathline__c ' +
                                        'FROM Customer_Offer__c ' +
                                        'WHERE (Offer_code__c IN :offerSet AND Contact_code__c IN :listContact AND Offer_code__r.ENL_Time_Eligibility__c =: unaTantum) OR ' +
                                            '(Offer_code__c IN :offerSet AND Contact_code__c IN :listContact AND Offer_code__r.ENL_Time_Eligibility__c !=: unaTantum AND Start_Date__c = ' + startDate + ')');

            for (Customer_Offer__c co : cOfferList){

                if (customerOfferMapOnContact.containsKey(co.Contact_code__c)){
                    customerOfferMapOnContact.get(co.Contact_code__c).add(co);
                } else {
                    customerOfferMapOnContact.put(co.Contact_code__c, new List<Customer_Offer__c>{ co });
                }
            }

        }

        //Fine stefano.bassotti@webresults.it RET-23069
        return customerOfferMapOnContact;
    }

    public static List<Log> sendChristmasVoucher(List<ENL_APC_ChristmasVoucherInfos> infos, Mc_Utils__c mcUtils, String ovverridePushMessageID){

        String XRequestIdValue = CC_APC_MWCallouts.getRandomUUID();
        List<Log> logs = new List<Log>();
        String authJSONbody = '';
        String messageID = !String.isBlank(ovverridePushMessageID) ? ovverridePushMessageID : mcUtils.ENL_Push_Message_ID__c;
        try{
            system.debug(mcUtils.ENL_Push_Message_ID__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token_Part_2__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token_Part_3__c);
            Http httpSend = new Http();
            HttpRequest httpReq = new HttpRequest();
            httpReq.setEndpoint(mcUtils.ENL_Voucher_Natale_EndPoint__c);
            httpReq.setMethod('POST');
            httpReq.setHeader('Content-Type', 'application/json;charset=UTF-8');
            httpReq.setHeader('Authorization', 'Bearer ' + mcUtils.ENL_Last_Login_MC_Token__c + mcUtils.ENL_Last_Login_MC_Token_Part_2__c + mcUtils.ENL_Last_Login_MC_Token_Part_3__c);
            for (ENL_APC_ChristmasVoucherInfos info : infos){
                //ci
                authJSONbody = '{' + 
                             '"ContactKey":"' + info.getContactId() + '",' + 
                             '"EventDefinitionKey":"' + Label.ENL_EventDefinitionKeyDev1 + '",' + 
                             '"Data": {' + 
                             '"ContactId":"' + info.getContactId() + '",' + 
                             '"Email":"' + info.getEmail() + '",' + 
                             '"Voucher":"' + info.getVoucherCode() + '",' + 
                             '"VoucherId":"' + info.getVoucherId() + '",' + 
                             '"FirstName":"' + info.getFirstName() + '"' + 

                             '}' + 
                             '}';
                httpReq.setBody(authJSONbody);
                system.debug(authJSONbody);
                system.debug(httpReq.getBody());
                Map<String, Object> sendResponse = new Map<String, Object>();

                if (!Test.isRunningTest()){
                    HttpResponse httpRes = httpSend.send(httpReq);
                    sendResponse = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getbody());
                    system.debug(sendResponse);
                } else{
                    sendResponse.put('tokenId', (Object) 'tokenId');
                }

                Log l = new Log();
                l.EventId = XRequestIdValue;
                l.EventType = 'MC-sendChristmasVoucher';
                l.ResultCode = JSON.serialize(sendResponse);
                l.TransmittedMessage = authJSONbody;
                logs.add(l);
            }
            if (Test.isRunningTest()){

                throw new ECU_APC_CustomException('Exception');

            }

        } catch (Exception e){
            Log l = new Log();
            l.Level = 'ERROR';
            l.Origin = 'Utils.sendChristmasVoucher';
            l.EventId = XRequestIdValue;
            l.EventType = 'MC-sendChristmasVoucher';
            l.ResultCode = e.getStackTraceString();
            l.TransmittedMessage = authJSONbody;
            l.SystemException = 'Error callout Send Mobile Push: ' + e.getMessage();
            logs.add(l);
        }

        return logs;
    }

    /**
     * @author: Christian Niro
     *@data: 04/07/2022
     */
    public static List<Log> sendEnjoyVoucher(List<Contact> contacts, Mc_Utils__c mcUtils){

        String XRequestIdValue = CC_APC_MWCallouts.getRandomUUID();
        List<Log> logs = new List<Log>();
        String authJSONbody = '';

        String contactId;
        Integer i = 0;


        try{
            system.debug(mcUtils.ENL_Push_Message_ID__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token_Part_2__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token_Part_3__c);
            Http httpSend = new Http();
            HttpRequest httpReq = new HttpRequest();
            httpReq.setEndpoint(mcUtils.ECU_Voucher_Enjoy_Endpoint__c);// set endpoint enjoy
            httpReq.setMethod('POST');
            httpReq.setHeader('Content-Type', 'application/json');
            httpReq.setHeader('Authorization', 'Bearer ' + mcUtils.ENL_Last_Login_MC_Token__c + mcUtils.ENL_Last_Login_MC_Token_Part_2__c + mcUtils.ENL_Last_Login_MC_Token_Part_3__c);

            //ordine lista
            contacts.sort ();

            for (Contact singol : contacts){


                if (contactId != singol.Id){

                    authJSONbody = '{' +                                                                                                                                                                                                                                                                                                                                                                                                                                                                      // field su contact
                    '"ContactKey":"' + singol.Id + '",' + '"EventDefinitionKey":"' + mcUtils.ECU_EventDefinitionKeyEnjoy__c + '",' + 
                                 '"Data": {' + 
                                 '"SubscriberKey":"' + singol.Id + '",' + 
                                 '"Email":"' + singol.Email + '",' + 
                                 '"FirstName":"' + singol.FirstName + '",' + 
                                 '"ECU_Iscrizione_Enjoy_Completa__c":"' + singol.ECU_Iscrizione_Enjoy_Completa__c + '"' + 

                                 '}' + 
                                 '}';

                    httpReq.setBody(authJSONbody);
                    system.debug(authJSONbody);
                    system.debug(httpReq.getBody());
                    Map<String, Object> sendResponse = new Map<String, Object>();

                    if (!Test.isRunningTest()){
                        HttpResponse httpRes = httpSend.send(httpReq);
                        sendResponse = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getbody());
                        system.debug(sendResponse);
                    } else{
                        sendResponse.put('tokenId', (Object) 'tokenId');
                    }

                    Log l = new Log();
                    l.EventId = XRequestIdValue;
                    l.EventType = 'MC-sendEnjoyVoucher';
                    l.FiscalCode = singol.Fiscal_Code__c;
                    l.ResultCode = JSON.serialize(sendResponse);
                    l.TransmittedMessage = authJSONbody;
                    logs.add(l);
                }

                contactId = singol.Id;
            }

            if (Test.isRunningTest()){

                throw new ECU_APC_CustomException('Exception');

            }

        } catch (Exception e){


            Log l = new Log();
            l.Level = 'ERROR';
            l.Origin = 'Utils.sendEnjoyVoucher';
            l.EventId = XRequestIdValue;
            l.EventType = 'MC-sendEnjoyVoucher';
            l.FiscalCode = contacts[i].Fiscal_Code__c;
            l.ResultCode = e.getStackTraceString();
            l.TransmittedMessage = authJSONbody;
            l.SystemException = 'Error Voucher Enjoy: ' + e.getMessage();
            logs.add(l);

        }
        i++;

        return logs;
    }

    /**
     * @author: Christian Niro
     * @data: 18/07/2022
     */
    public static List<Log> sendCrossSelling(List<String> contactsCode, Mc_Utils__c mcUtils, List<Customer_Offer__c> customerOffers){

        String XRequestIdValue = CC_APC_MWCallouts.getRandomUUID();
        List<Log> logs = new List<Log>();
        String authJSONbody = '';

        String contactId;

        Integer i = 0;
        system.debug('contactsCode ' + contactsCode);
        List<Contact> contacts = [SELECT Id, FirstName, LastName, Email, Fiscal_Code__c, Contact_code__c
                                  FROM Contact
                                  WHERE Id IN:contactsCode];


        try{
            system.debug(mcUtils.ENL_Push_Message_ID__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token_Part_2__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token_Part_3__c);
            Http httpSend = new Http();
            HttpRequest httpReq = new HttpRequest();


            httpReq.setEndpoint(mcUtils.ECU_CrossSelling_EndPoint__c);// set endpoint enjoy
            httpReq.setMethod('POST');
            httpReq.setHeader('Content-Type', 'application/json');
            httpReq.setHeader('Authorization', 'Bearer ' + mcUtils.ENL_Last_Login_MC_Token__c + mcUtils.ENL_Last_Login_MC_Token_Part_2__c + mcUtils.ENL_Last_Login_MC_Token_Part_3__c);

            //ordine lista
            contacts.sort ();
            customerOffers.sort ();


            for (Contact singol : contacts){

                for (Customer_Offer__c c : customerOffers){


                    if (contactId != singol.Id){

                        authJSONbody = '{' +                                                                                                                                                                                                                                                                                                                                                                                                                                                                      // field su contact
                        '"ContactKey":"' + singol.Id + '",' + '"EventDefinitionKey":"' + mcUtils.ECU_CrossSelling_EventDefinitionKey__c + '",' + 
                                     '"Data": {' + 
                                     '"SubscriberKey":"' + singol.Id + '",' + 
                                     '"partial_step":"' + c.Partial_step__c + '",' + 
                                     '"total_step":"' + c.Number_of_total_steps__c + '",' + 
                                     '"code":"' + c.Offer_Code_F__c + '",' + 
                                     '"name":"' + singol.FirstName + '",' + 
                                     '"email":"' + singol.Email + '"' + 

                                     '}' + 
                                     '}';

                        httpReq.setBody(authJSONbody);
                        system.debug(authJSONbody);
                        system.debug(httpReq.getBody());
                        Map<String, Object> sendResponse = new Map<String, Object>();

                        if (!Test.isRunningTest()){

                            //TO DELETE
                            System.debug('Utils.sendCrossSelling invio PUSH ' + singol.Id);

                            HttpResponse httpRes = httpSend.send(httpReq);
                            sendResponse = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getbody());
                            system.debug('CHECK-CALLOUT! ' + sendResponse);
                        } else{
                            sendResponse.put('tokenId', (Object) 'tokenId');
                        }

                        Log l = new Log();
                        l.EventId = XRequestIdValue;
                        l.Level = 'INFO';
                        l.EventType = 'MC-sendCrossSelling';
                        l.ResultCode = JSON.serialize(sendResponse);
                        l.promoCode = c.Offer_Code_F__c;
                        l.FiscalCode = c.Fiscal_Code__c;
                        l.TransmittedMessage = authJSONbody;
                        logs.add(l);
                    }


                }

                contactId = singol.Id;
            }

            if (Test.isRunningTest()){

                throw new ECU_APC_CustomException('Exception');

            }

        } catch (Exception e){


            Log l = new Log();
            l.Level = 'ERROR';
            l.Origin = 'Utils.sendCrossSelling';
            l.EventId = XRequestIdValue;
            l.EventType = 'MC-sendCrosslling';
            l.ResultCode = e.getStackTraceString();
            l.TransmittedMessage = authJSONbody;
            l.FiscalCode = contacts[i].Fiscal_Code__c;
            l.SystemException = 'Error Send Crosselling: ' + e.getMessage();
            logs.add(l);

        }

        i++;

        return logs;
    }

    public static void insertLogRegistrationError(String codeError, String errorMessage, String originClass, String type, String exceptionReg, String Email){
        Log__c log = new Log__c();
        log.Level__c = type;
        log.Origin__c = originClass;
        log.ResultCode__c = codeError;
        log.SystemException__c = exceptionReg;
        log.TransmittedMessage__c = errorMessage;
        log.EVENT_TYPE__c = System.Label.ECU_RegType;
        log.ECU_Email__c = Email;
        insert log;
    }

    /**
     * @author: Christian Niro
     * @data: 18/09/2022
     */
    public static List<Log> calloutTariffaIntegrata(Customer_Offer__c c){


        List<Log> logs = new List<Log>();
        String req = '';
        String eventId = Utils.generateOperationIdFromDateTime();


        Set<Id> cf = new Set<Id>();


        ENL_APC_Servicemod.technicalHeader th = new ENL_APC_Servicemod.technicalHeader();
        ENL_APC_Mwcrmadapter.processEventIntegratedRate pe = new ENL_APC_Mwcrmadapter.processEventIntegratedRate();
        ENL_APC_Mwcrmadapter.processEventIntegratedRateResponse per = new ENL_APC_Mwcrmadapter.processEventIntegratedRateResponse();
        ENL_APC_MwcrmadapterV1.MWCRMAdapterServiceSOAP soapReq = new ENL_APC_MwcrmadapterV1.MWCRMAdapterServiceSOAP();

        try{

            if (c.Transaction__r.ENL_Service_Type__c == '0' || c.Transaction__r.ENL_Service_Type__c == 'Rifornimento'){


                soapReq.technicalHeader = th;

                pe.fiscalCode = c.Fiscal_Code__c;
                pe.promoCode = c.Offer_Code_F__c;
                pe.transactionCode = c.Offer_Code_F__c;
                pe.transactionId = c.Id;
                pe.operationID = eventId;
                pe.requestId = c.Transaction__r.ENL_Transaction_Code__c;
                pe.requestId = c.Id;

                //pe.Uniqueid = uniqueIdMap.get(c.Transaction__r.Contact__c) != null ? uniqueIdMap.get(c.Transaction__r.Contact__c) : null;
                system.debug(' the request ' + pe);
                per = soapReq.processEventIntegratedRate(pe);
                system.debug(' the response ' + per);


                req = 'Dati callout:\nOPERATION_ID: ' + eventId + '\nFISCALCODE: ' + c.Fiscal_Code__c + '\nPROMO_CODE: ' + c.Offer_Code_F__c + '_' + '\nREQUEST_ID: ' + pe.requestId;
                //EN: invio busta SOAP

                Log l = new Log();
                if (per.toString().containsignorecase('SUCCESS')){
                    l.Level = 'INFO';
                } else{
                    l.Level = 'DEBUG';
                }
                l.EventId = pe.operationID;
                l.EventType = 'ECU-221';
                l.promoCode = c.Offer_Code_F__c;
                l.FiscalCode = c.Fiscal_Code__c;
                l.ResultCode = req;
                l.TransmittedMessage = per.toString();
                logs.add(l);


            }


        } catch (Exception e){

            System.debug('Utils.calloutTariffaIntegrata ## EXCEPTION = ' + e.getMessage() + ' - ' + e.getStackTraceString());
            Log l = new Log();
            l.Level = 'ERROR';
            l.Origin = 'Utils.calloutTariffaIntegrata';
            l.EventId = pe.operationID;
            l.FiscalCode = c.Fiscal_Code__c;
            l.promoCode = c.Offer_Code_F__c;
            l.TransmittedMessage = e.getStackTraceString();
            l.SystemException = 'Error callout tariffaIntegrata: ' + e.getMessage();
            //l.SystemException = 'Error callout tariffaIntegrata: You have uncommitted work pending. Please commit or rollback before calling out';
            logs.add(l);

            if (l.SystemException == 'Error callout tariffaIntegrata: You have uncommitted work pending. Please commit or rollback before calling out'){


                ID jobID = AsyncApexFramework.submitQueueable(new ECU_APQ_QueueErrorTarfIntegrata(pe, eventId), 99, true);
            }
        }
        return logs;
    }

    /**
     * @author: Christian Niro
     * @data: 02/09/2022
     */
    //Inizio andrea.riondino@eng.it FIX scrittura log 
    public static List<Log> sendElegibilityEnjoy(Customer_Offer__c c){

        List<Log> logs = new List<Log>();

        String Uniqueid = c.Transaction__r.Contact__c;
        String fiscalCode = c.Fiscal_Code__c;
        String promoCode = c.Offer_Code_F__c;
        String idCustomerOffer = c.Id;
        String eventId;
        String response = '';
        List<Log> logsFromResponse= new List<Log>();
        List<Log> inserimentoLogFinal= new List<Log>();

        try{

            String body = '{"UniqueId": "' + Uniqueid + '","fiscalCode": "' + fiscalCode + '","promoCode": "' + promoCode + '","idCustomerOffer": "' + idCustomerOffer + '"}';
            System.debug('<<<<<<<<<<<<<<<<BODY' + body);


            ECU_ApiSetting__c apsett = [SELECT Name, ECU_Url__c, ECU_userName__c, ECU_Password__c
                                        FROM ECU_ApiSetting__c
                                        WHERE Name = 'ElegibilityEnjoy'];

            String urlModify = apsett.ECU_Url__c;

            if (!Test.isRunningTest()){
                ECU_APC_DynamicCallOut.WrapperResponse wrResponse= ECU_APC_DynamicCallOut.getCalloutResponseContentsPost201(apSett.ECU_Url__c, apSett.ECU_userName__c, apSett.ECU_Password__c, body, 'Utils');
                response = wrResponse.response;
                    logsFromResponse.addAll(wrResponse.logList);
                System.debug('<<<wrResponse.logList: ' + wrResponse.logList);
                System.debug('<<<logsFromResponse: ' + logsFromResponse);
                System.debug('<<<Response: ' + response);
            }

            /* if (Test.isRunningTest()){
             response = '{"data": [{"System": "ENJOY","code": "502","message": "System error","CustomerId": null},{"System": "ENILIVE","code": 0,"message": "Success","CustomerId": 119516}]}';
             }*/

            Log l = new Log();
            l.EventId = c.ENL_Operation_ID__c;
            l.EventType = 'sendElegibilityEnjoy';
            l.promoCode = c.Offer_Code_F__c;

            l.FiscalCode = c.Fiscal_Code__c;
            l.ResultCode = response;
            //logs.add(l);
            inserimentoLogFinal.add(l);
            eventId = c.ENL_Operation_ID__c;


        } catch (Exception e){

            System.debug('Utils.sendElegibilityEnjoy ## EXCEPTION = ' + e.getMessage() + ' - ' + e.getStackTraceString());
            Log l = new Log();
            l.Level = 'ERROR';
            l.Origin = 'Utils.sendElegibilityEnjoy';
            l.EventId = c.ENL_Operation_ID__c;
            l.FiscalCode = c.Fiscal_Code__c;
            l.promoCode = c.Offer_Code_F__c;
            l.TransmittedMessage = e.getStackTraceString();
            l.SystemException = 'Error callout sendElegibilityEnjoy : ' + e.getMessage();
            //logs.add(l);
            inserimentoLogFinal.add(l);
        }

        if(logsFromResponse == null || logsFromResponse.isEmpty()){
            logs.addAll(inserimentoLogFinal);
            System.debug('<<<logs fine 2 if inserimentoLogFinal: ' + logs);
        }else{
            logs.addAll(logsFromResponse);
            System.debug('<<<logs fine 1 if logsFromResponse: ' + logs);
        }
        System.debug('<<<logs: ' + logs);
        //Fine andrea.riondino@eng.it FIX scrittura log
        return logs;
    }

    /**
     * @description       : updateVoucherGenerationResults
     * @author            : Christian Niro
     * @group             :
     * @last modified on  : 05-22-2023
     * @last modified by  :
     **/
    public static void updateCustOffVoucherResult(Set<Id> contacts){

        List<Customer_Offer__c> coff = [SELECT Id, Name, Offer_name__c, ECU_Voucher_Generation_Result__c, Contact_code__c
                                        FROM Customer_Offer__c
                                        WHERE Contact_code__c IN:contacts
                                        LIMIT 9000];


        for (Customer_Offer__c c : coff){

            c.ECU_Voucher_Generation_Result__c = 'true';


        }

        Database.SaveResult[] SR = Database.update (coff, false);
    }

    /**
     * @description       : method to update user registration type new & old
     * @author            : Christian Niro
     * @group             :
     * @last modified on  : 05-22-2023
     * @last modified by  :
     **/
    public static void updateRegistrationType(String usId, String type){

        List<Contact> contacts = new List<Contact>();


        List<User> users = [SELECT Id, FirstName, LastName, Email, Username, ECU_Old_RegistrationType__c, ECU_Registration_Type__c, Contact.FirstName, Contact.Id, Contact.ECU_Registration_Type__c, Contact.ECU_Old_RegistrationType__c
                            FROM User
                            WHERE Id = :usId];

        for (User us : users){
            us.ECU_Old_RegistrationType__c = us.ECU_Registration_Type__c;
            us.Contact.ECU_Old_RegistrationType__c = us.ECU_Registration_Type__c;
            contacts.add(us.Contact);
            us.ECU_Registration_Type__c = type;
            us.Contact.ECU_Registration_Type__c = type;

        }

        if (contacts.size() > 0){

            Database.SaveResult[] sr = Database.update (contacts, false);
        }

        if (users.size() > 0){


            Database.SaveResult[] sr2 = Database.update (users, false);
        }
    }

    /**
     * @description       : method to revoke third party social user
     * @author            : Christian Niro
     * @group             :
     * @last modified on  : 05-22-2023
     * @last modified by  :
     **/
    public static Boolean deleteThirdParty(String usId){

        Boolean isSuccess = false;

        List<ThirdPartyAccountLink> accountLink = [SELECT Id, RemoteIdentifier, UserId, SsoProvider.id, Provider
                                                   FROM ThirdPartyAccountLink
                                                   WHERE UserId = :usId];

        if (accountLink.size() > 0){

            for (Integer i = 0, j = accountLink.size(); i < j; i++){

                ThirdPartyAccountLink trd = accountLink[i];


                isSuccess = Auth.AuthToken.revokeAccess(trd.SsoProvider.id, trd.Provider, trd.UserId, trd.RemoteIdentifier);
                System.debug('<<<<<<<<RESP' + isSuccess);


            }
        }

        return isSuccess;
    }

    /**
     * @description       : method to delete account
     * @author            : Christian Niro
     * @group             :
     * @last modified on  : 05-22-2023
     * @last modified by  :
     **/
    public static void deleteAccount(Set<Id> lstContact, Set<String> emailCon, List<Account> lstAccount){
        String errorAccount;
        List<String> errorField;
        Map<Id, Case> caseNNDuplicate = new Map<Id, Case>();
        Map<Id, EmailMessageRelation> emailRelNNDuplicate = new Map<Id, EmailMessageRelation>();
        List<Case> casUpd = new List<Case>();
        
        System.debug('<<<<<<<<<<<<<< Lista dei contatc in Utils prima della query: ' + lstContact);
        System.debug('<<<<<<<<<<<<<< Lista dei contatc in Utils prima della query size: ' + lstContact.size());

        
        List<Case> cas = [SELECT Id, Status, AccountId, ContactId
                          FROM Case
                          WHERE ContactId IN:lstContact];

		System.debug('<<<<<<<<<<<<<< Lista dei case in Utils: ' + cas);
        System.debug('<<<<<<<<<<<<<< Lista dei case in Utils size: ' + cas.size());

        try{
            
            if (cas.size() > 0){
                for (Case c : cas){
                    //c.Status = 'Closed'; Modifiche Giuseppe Mario Pastore 11-03-2024 ENICUN-1708
                    c.ContactId = null;
                    c.AccountId = null;
                    casUpd.add(c);
                    caseNNDuplicate.putAll(casUpd);
                }
                TriggerManager.skipTrigger('CC_APT_CaseTrigger');
                Database.SaveResult[] sr = Database.update (caseNNDuplicate.values(), false);
                TriggerManager.unskipTrigger('CC_APT_CaseTrigger');
                  for (Database.SaveResult sr1 : sr){
                    if (sr1.isSuccess()){
                        System.debug('Successfully caseNNDuplicate: ' + sr1.getId());
                    } else{
                        for (Database.Error err : sr1.getErrors()){
                            errorAccount = err.getStatusCode() + ': ' + err.getMessage();
                            errorField = err.getFields();
                            System.debug('The following caseNNDuplicate.' + err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('caseNNDuplicate fields that affected this error: ' + err.getFields());
                        }
                    }
        		}
            }
    	}catch(Exception e){
        	system.debug('Errore ' + e.getMessage() + ' ' + e.getStackTraceString() + ' #' + e.getLineNumber());

        }
        // eliminazione relazione emailRelation con contact(rende impossibile eliminazione altrimenti)


        List<Contact> contactsR = [SELECT Id, FirstName, LastName, Email
                                   FROM Contact
                                   WHERE Id IN:lstContact];
        
        System.debug('<<<<<<<<<<<<<< Lista dei contatc in Utils contactsR: ' + contactsR);
        System.debug('<<<<<<<<<<<<<< Lista dei contatc in Utils contactsR size: ' + contactsR.size());



        for (Contact c : contactsR){
            emailCon.add(c.email);
        }

        List<EmailMessageRelation> emailsRelation = [SELECT ID, EmailMessageId, RelationId, RelationType, RelationAddress, RelationObjectType, CreatedDate, CreatedById, SystemModstamp, IsDeleted
                                                     FROM EmailMessageRelation
                                                     WHERE RelationAddress IN:emailCon AND RelationObjectType = 'Contact'];
        System.debug('<<<<<<<<<<<<<< emailsRelation: ' + emailsRelation);

        for (Contact c : contactsR){
            for (EmailMessageRelation e : emailsRelation){

                if (c.Email == e.RelationAddress){

                    e.RelationId = NULL;
                    emailRelNNDuplicate.putAll(emailsRelation);

                }

            }


        }
        
            
            if (emailsRelation.size() > 0){

                TriggerManager.skipTrigger('CC_APT_TaskTrigger');
                System.debug('<<<<<Dentro emailsRelation per vedere il size' + emailsRelation);
                Database.SaveResult[] sr = Database.update (emailRelNNDuplicate.values(), false);
                System.debug('<<<<<Dentro emailsRelation per vedere il valore di Database.SaveResult[]' + sr);
    
                TriggerManager.unskipTrigger('CC_APT_TaskTrigger');
        	}



        System.debug('<<<<<LISTACCOUNT' + lstAccount);
        //Elimina gli Account
        Database.DeleteResult[] srList = Database.delete (lstAccount, false);
        
		System.debug('<<<<<srList' + srList);

        // Iterate through each returned result

        for (Database.DeleteResult sr : srList){
            if (sr.isSuccess()){
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            } else{
                // Operation failed, so get all errors
                for (Database.Error err : sr.getErrors()){
                    errorAccount = err.getStatusCode() + ': ' + err.getMessage();
                    errorField = err.getFields();
                    System.debug('The following error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }
    }

    /**
     * @author Christian Niro
     * @description Method to new Session
     */
    public static void retryBatch(String userId){

        Boolean isRetry = true;
        Database.executeBatch(new ECU_BatchSocial(isRetry, userId), 100);
    }

    /**
     * @author Christian Niro
     * @description Method to dynamic query for update childObject's fields
     */
    public static list<SObject> dynamicQuery(List<String> istanceObjects, String queryFields, String conditions, String fieldToUpdate, Object fieldValue){
        List<SObject> childObjectsToUpdate = new List<SObject>();
        for (String obj : istanceObjects){
            List<SObject> childObjects = Database.query('SELECT ' + queryFields + 'FROM ' + obj + ' WHERE ' + conditions);
            for (SObject childObject : childObjects){
                childObject.put(fieldToUpdate, fieldValue);
                childObjectsToUpdate.add(childObject);
            }
        }
        return childObjectsToUpdate;
    }

    /**
     * @author Christian Niro
     * @description Method to SOQL dynamic from dynamic object with 'IN' clause
     */
    public static List<SObject> getObjInstance(String obj, List<String> queryFields, Set<Object> ids, string conditions){
        String query = 'SELECT ' + String.join(queryFields, ',') + ' FROM ';
        String whereClause = ' WHERE ' + conditions;
        List<SObject> objList = Database.query(query + obj + whereClause);
        System.debug('Lista obj' + objList);
        return objList;
    }

    /**
     * @author Christian Niro
     * @description Check if contact fiscal code already exist in salesforce
     * @param contacts list of Contact to check
     * @return Map<String, Contact>
     */
    public static Map<String, Contact> checkContactFiscalCode(List<Contact> contacts){
        system.debug('contacts: ' + contacts);
        Map<String, Contact> contactMap = new Map<String, Contact>();
        List<Contact> existingContact = new List<Contact>();
        Id recordTypeCustomer = getRecordTypeId('Customer', 'Contact');
        Id recordTypeBusiness = getRecordTypeId('Business', 'Contact');
        Id recordTypeLead = getRecordTypeId('ENL_Lead_Gestore', 'Contact');
        List<Id> recordTypeLoyalty = new List<Id>();
        recordTypeLoyalty.add(recordTypeCustomer);
        recordTypeLoyalty.add(recordTypeBusiness);
        recordTypeLoyalty.add(recordTypeLead);

        for (Contact con : contacts){
            contactMap.put(con.Fiscal_code__c, con);
        }
        system.debug('Utils-checkContactFiscalCode contactMap: ' + contactMap);

        for (Contact con : [SELECT Id, Fiscal_code__c, email, APP_loyalty_customer__c, AccountId
                            FROM Contact
                            WHERE Fiscal_code__c IN:contactMap.keyset() AND APP_loyalty_customer__c <> '0' AND RecordTypeId IN:recordTypeLoyalty]){
            String cf = con.Fiscal_code__c;
system.debug('cf: ' + cf);
            if (contactMap.containsKey(cf)){
                contactMap.remove(cf);
	            system.debug('Utils-checkContactFiscalCode Codice Fiscale Presente da rimuovere: ' + cf);
            }
        }

        return contactMap;
    }

// fabrizio.fiorentini@webresults.it - CLU-23018 - 10/11/2023 - START
    public static Map<String, Contact> checkContactEmail(List<Contact> contactList) {
        system.debug('contactList: ' + contactList);
        Map<String, Contact> contactMap = new Map<String, Contact>();
        Id recordTypeCustomer = getRecordTypeId('Customer', 'Contact');
        Id recordTypeBusiness = getRecordTypeId('Business', 'Contact');
        Id recordTypeLead = getRecordTypeId('ENL_Lead_Gestore', 'Contact');
        List<Id> recordTypeLoyalty = new List<Id>();
        recordTypeLoyalty.add(recordTypeCustomer);
        recordTypeLoyalty.add(recordTypeBusiness);
        recordTypeLoyalty.add(recordTypeLead);

        for (Contact contact : contactList){
            // contactMap.put(contact.Email, contact); //stefano.bassotti@webresilts.it hotfix-283
            contactMap.put(contact.Email + '.CE', contact); //stefano.bassotti@webresilts.it hotfix-283
        }
        system.debug('contactMap: ' + contactMap);

        for (Contact contact : [SELECT Id, Fiscal_code__c, Email, APP_loyalty_customer__c, AccountId FROM Contact 
                                //WHERE Email IN :contactMap.keyset() AND APP_loyalty_customer__c <> '0' AND RecordTypeId IN :recordTypeLoyalty]) { // stefano.bassotti@webresilts.it hotfix-283
                                WHERE Contact_Code__c IN :contactMap.keyset() AND APP_loyalty_customer__c <> '0' AND RecordTypeId IN :recordTypeLoyalty AND Cancellation_Date__c = null]) {   // stefano.bassotti@webresilts.it hotfix-283
            system.debug('contactEmail: ' + contact.Email);
            if (contactMap.containsKey(contact.Email)){
                contactMap.remove(contact.Email);
            }
        }
        return contactMap;
    }
    // fabrizio.fiorentini@webresults.it - CLU-23018 - 10/11/2023 - START

    /**
     * @author Christian Niro
     * @description use this method for deserialize json in your custom object
     * @param contacts list of Contact to check
     * @return  List<Map<String,Object>>
     */
    public static List<Map<String, Object>> getCustomData(Object obj){
        List<Object> jsonList = (List<Object>)obj;
        List<Map<String, Object>> listMapJson = new List<Map<String, Object>>();

        for (Object ob : jsonList){
            listMapJson.add((Map<String, Object>)ob);

        }


        return listMapJson;
    }

    /**
     * @author Christian Niro
     * @description use this method for create new Account
     * @param contacts list of Contact to check

     */
    public static void newAccount(Map<String, Contact> contactsToInsert){
        Map<String, Account> accountsToInsert = New Map<String, Account>();

        for (Contact c : contactsToInsert.values()){
            System.debug('cri test' + c.AccountId);

            if (c.AccountId == null){


                String accountName = c.firstname + ' ' + c.lastname;

                String code = String.isBlank(c.Fiscal_code__c) ? c.email.toUpperCase() : c.Fiscal_code__c;

                String vatNumber = String.isBlank(c.VAT_Number__c) ? '' : c.VAT_Number__c;

                Account a = new Account(Name = accountName, Contact_code__c = code, VAT_Number__c = vatNumber);
                accountsToInsert.put(code, a);
            } else{
                continue;
            }
        }

        if (!accountsToInsert.isEmpty()){
            insert accountsToInsert.values();
        }

        for (Contact c : contactsToInsert.values()){

            String code = String.isBlank(c.Fiscal_code__c) ? c.email.toUpperCase() : c.Fiscal_code__c;

            if (accountsToInsert.containsKey(code)){
                c.AccountId = accountsToInsert.get(code).Id;
            }

        }
    }

    /**
     * @author Christian Niro
     * @description use this method for create string unique alfanumeric

     * @return  String
     */
    public static String writeUnique(){
        String uniqueCode = '';
        String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        Integer charactersLength = characters.length();
        System.debug('<<<<<<LENGHT' + charactersLength);
        for (Integer i = 0; i < 10; i++){


            Integer index = Integer.valueOf(Math.floor(Math.random() * charactersLength));
            uniqueCode += characters.substring(index, index + 1);
        }
        return uniqueCode;
    }
    //Inizio andrea.riondino@eng.it FIX scrittura log
    public static List<Log> newSendElegibility(Customer_Offer__c c){

        List<Log> logs = new List<Log>();
        String operationId = c.ENL_Operation_ID__c;
        String fiscalCode = c.Fiscal_Code__c;
        String body = '';
        String response = '';
        String customerType = '2';
        String promoCode = c.ENL_F_Service_Station_Offer_Code__c + '_' + c.ENL_Condition_Code__c;
        List<Log> logsFromResponse= new List<Log>();
        List<Log> inserimentoLogFinal= new List<Log>();

        try{
            String requestId = CC_APC_MWCallouts.getRandomUUID();
            Integer tapNumber = Integer.valueOf(c.ENL_TAP_Number__c);
            Datetime endTimeButton = c.ENL_End_Time_Button__c;
            String endTimeConv = String.valueOf(c.ENL_End_Time_Button__c);
            String endTimeFinal = endTimeConv.replace(' ', 'T') + 'Z';
            String lotteryCode = c.ENL_Lottery_Code__c;
            String serviceStationCode = c.ENL_Service_Station_Code__c;
            

            body = '{"operation_id": "' + operationId + '", "request_id": "' + requestId + '", "fiscalcode": "' + fiscalCode + '", "promo_code": "' + promoCode + '", "tap_number": "' + tapNumber + '", "end_time_button": "' + endTimeFinal + '", "lottery_code": "' + lotteryCode + '", "service_station_code": "' + serviceStationCode + '", "customer_type": "' + customerType + '"}';
            System.debug('<<<BODY: ' + body);

            ECU_ApiSetting__c apSett = [SELECT Name, ECU_Url__c, ECU_userName__c, ECU_Password__c
                                        FROM ECU_ApiSetting__c
                                        WHERE Name = 'SendElegibility'];

            if (!Test.isRunningTest()){
                ECU_APC_DynamicCallOut.WrapperResponse wrResponse= ECU_APC_DynamicCallOut.getCalloutResponseContentsPost201(apSett.ECU_Url__c, apSett.ECU_userName__c, apSett.ECU_Password__c, body, 'Utils');
                response = wrResponse.response;
                    logsFromResponse.addAll(wrResponse.logList);
                System.debug('<<<wrResponse.logList: ' + wrResponse.logList);
                System.debug('<<<logsFromResponse: ' + logsFromResponse);
                System.debug('<<<Response: ' + response);
            }

            if(response.contains('"message": "Success"') && response.contains('"code": "0"')){

                Log l = new Log();
                l.Level = 'INFO';
                l.Origin = 'Utils.newSendElegibility';
                l.EventId = operationId;
                l.EventType = 'ENL-CER-009';
                l.FiscalCode = fiscalCode;
                l.CustomerType= customerType;
                l.promoCode= promoCode;
                l.ResultCode = response;
                l.TransmittedMessage = body;
                //logs.add(l);
                inserimentoLogFinal.add(l);
                System.debug('inserimentoLogFinal ' + inserimentoLogFinal);
            } else{

                Log l = new Log();
                //l.Level = 'DEBUG';
                l.Level = 'ERROR';
                l.Origin = 'Utils.newSendElegibility';
                l.EventId = operationId;
                l.EventType = 'ENL-CER-009';
                l.FiscalCode = fiscalCode;
                l.CustomerType= customerType;
                l.promoCode= promoCode;
                l.ResultCode = response;
                l.TransmittedMessage = body;
                //logs.add(l);
                inserimentoLogFinal.add(l);
                System.debug('inserimentoLogFinal' + inserimentoLogFinal);
            }  

        } catch (Exception e){

            System.debug('Utils.newSendElegibility ## EXCEPTION = ' + e.getMessage() + ' - ' + e.getStackTraceString());
            Log l = new Log();
            l.Level = 'ERROR';
            l.Origin = 'Utils.newSendElegibility';
            l.EventId = operationId;
            l.EventType = 'ENL-CER-009';    // Inizio stefano.bassotti@webresults.it HOTFIX-220
            l.FiscalCode = fiscalCode;
            l.ResultCode = response;
            l.CustomerType= customerType;
            l.promoCode= promoCode;
            l.TransmittedMessage = body;
            l.SystemException = 'Error Callout New Send Elegibility: ' + e.getMessage() + ' - ' + e.getStackTraceString();
            //logs.add(l);
            inserimentoLogFinal.add(l);
            System.debug('inserimentoLogFinal ' + inserimentoLogFinal);
        }
        
        if(logsFromResponse == null || logsFromResponse.isEmpty()){
            logs.addAll(inserimentoLogFinal);
            System.debug('<<<logs fine 2 if inserimentoLogFinal: ' + logs);
        }else{
            logs.addAll(logsFromResponse);
            System.debug('<<<logs fine 1 if logsFromResponse: ' + logs);
        }
        System.debug('<<<logs: ' + logs);
        //Fine andrea.riondino@eng.it FIX scrittura log
        return logs;
    }
    //Inizio andrea.riondino@eng.it FIX scrittura log
    public static List<Log> newCalloutTariffaIntegrata(Customer_Offer__c c){


        List<Log> logs = new List<Log>();
        String operationId = c.ENL_Operation_ID__c;
        String requestId = CC_APC_MWCallouts.getRandomUUID();
        String fiscalCode = c.Fiscal_Code__c;
        String promoCode = c.Offer_Code_F__c;
        String body = '';
        String response = '';
        List<Log> logsFromResponse= new List<Log>();
        List<Log> inserimentoLogFinal= new List<Log>();
        // manca transaction id e transaction code

        Set<Id> cf = new Set<Id>();

        try{
            system.debug(c.transaction__c);
            system.debug(c.transaction__r.ENL_Service_Type__c);
            if (c.Transaction__r.ENL_Service_Type__c == '0' || c.Transaction__r.ENL_Service_Type__c == 'Rifornimento'){

                ECU_ApiSetting__c apSett = [SELECT Name, ECU_Url__c, ECU_userName__c, ECU_Password__c
                                            FROM ECU_ApiSetting__c
                                            WHERE Name = 'NewCalloutTariffaIntegrata'];

                body = '{"operationId": "' + operationId + '", "requestId": "' + requestId + '", "fiscalCode": "' + fiscalCode + '", "promoCode": "' + promoCode + '"}';
                System.debug('<<<BODY: ' + body);


                if (!Test.isRunningTest()){
                    ECU_APC_DynamicCallOut.WrapperResponse wrResponse= ECU_APC_DynamicCallOut.getCalloutResponseContentsPost201(apSett.ECU_Url__c, apSett.ECU_userName__c, apSett.ECU_Password__c, body, 'Utils');
                    response = wrResponse.response;
                    logsFromResponse.addAll(wrResponse.logList);
                System.debug('<<<wrResponse.logList: ' + wrResponse.logList);
                System.debug('<<<logsFromResponse: ' + logsFromResponse);
                System.debug('<<<Response: ' + response);
            }

                if(response.contains('"message": "Success"') && response.contains('"code": "0"')){

                    Log l = new Log();
                    l.Level = 'INFO';
                    l.EventId = operationId;
                    l.EventType = 'ECU-CER-221';
                    l.FiscalCode = fiscalCode;
                    l.ResultCode = response;
                    l.TransmittedMessage = body;
                    //logs.add(l);
                    inserimentoLogFinal.add(l);
                } else{

                    Log l = new Log();
                    //l.Level = 'DEBUG';
                    l.Level = 'ERROR';
                    l.Origin = 'Utils.newCalloutTariffaIntegrata';
                    l.EventId = operationId;
                    l.EventType = 'ECU-CER-221';
                    l.FiscalCode = fiscalCode;
                    l.ResultCode = response;
                    l.TransmittedMessage = body;
                    //logs.add(l);
                    inserimentoLogFinal.add(l);
                }
            }

        } catch (Exception e){

            System.debug('Utils.NewCalloutTariffaIntegrata ## EXCEPTION = ' + e.getMessage() + ' - ' + e.getStackTraceString());
            Log l = new Log();
            l.Level = 'ERROR';
            l.Origin = 'Utils.NewCalloutTariffaIntegrata';
            l.EventId = operationId;
            l.EventType = 'ECU-CER-221';
            l.FiscalCode = fiscalCode;
            l.ResultCode = response;
            l.TransmittedMessage = body;
            l.SystemException = 'Error callout tariffaIntegrata: ' + e.getMessage();
            /*   if (l.SystemException == 'Error callout tariffaIntegrata: You have uncommitted work pending. Please commit or rollback before calling out'){


             ID jobID = AsyncApexFramework.submitQueueable(new ECU_APQ_QueueErrorTarfIntegrata(pe, eventId), 99, true);
             }*/
            //logs.add(l);
            inserimentoLogFinal.add(l);
        }
        if(logsFromResponse == null || logsFromResponse.isEmpty()){
            logs.addAll(inserimentoLogFinal);
            System.debug('<<<logs fine 2 if inserimentoLogFinal: ' + logs);
        }else{
            logs.addAll(logsFromResponse);
            System.debug('<<<logs fine 1 if logsFromResponse: ' + logs);
        }
        System.debug('<<<logs: ' + logs);
        //Fine andrea.riondino@eng.it FIX scrittura log
        return logs;
    }

    //Inizio stefano.bassotti@webresults.it RET-24005
    public static List<Log> calloutNexiGeneric(Customer_Offer__c custOff){

        List<Log> logs = new List<Log>();
        String response = '';

        Datetime dt = DateTime.now();
        String requestTimestamp = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS') + 'Z';

        try{
            system.debug('Utils.calloutNexiGeneric Transaction: ' + custOff.transaction__c);

            ECU_ApiSetting__c apSett = [SELECT Name, ECU_Url__c, ECU_userName__c, ECU_Password__c
            FROM ECU_ApiSetting__c
            WHERE Name = 'CalloutNexi'];

            String promo = custOff.Name;

            List<SObject> objList = new List<SObject>();
            objList.add(custOff);

            String body = ECU_APC_DynamicsConditionGeneric.creaBodySistema(promo, objList);

            System.debug('Utils.calloutNexiGeneric BODY: ' + body);

            response = ECU_APC_DynamicCallOut.getCalloutResponseContentsPost100(apSett.ECU_Url__c, apSett.ECU_userName__c, apSett.ECU_Password__c, body, 'Utils');
            System.debug('Utils.calloutNexiGeneric Response: ' + response);

            if(response.containsIgnoreCase('"message": "Success"') && response.contains('"code": "0"')){

                Log l = new Log();
                l.Level = 'INFO';
                l.Origin = 'Utils.calloutNexiGeneric';
                l.EventId = custOff.ENL_Operation_ID__c;
                l.EventType = 'ENL-CER-100';  // stefano.bassotti@webresults.it RET-23030
                l.FiscalCode = custOff.Fiscal_code__c;
                l.ResultCode = response;
                l.TransmittedMessage = body;
                logs.add(l);
            } else{

                Log l = new Log();
                l.Level = 'DEBUG';
                l.Origin = 'Utils.calloutNexiGeneric';
                l.EventId = custOff.ENL_Operation_ID__c;
                l.EventType = 'ENL-CER-100';  // stefano.bassotti@webresults.it RET-23030
                l.FiscalCode = custOff.Fiscal_code__c;
                l.ResultCode = response;
                l.TransmittedMessage = body;
                logs.add(l);
            }

        } catch (Exception e){

            System.debug('Utils.calloutNexiGeneric ## EXCEPTION = ' + e.getMessage() + ' - ' + e.getStackTraceString());
            Log l = new Log();
            l.Level = 'ERROR';
            l.Origin = 'Utils.calloutNexiGeneric';
            l.EventId = custOff.ENL_Operation_ID__c;
            l.EventType = 'ENL-CER-100';  // stefano.bassotti@webresults.it RET-23030
            l.FiscalCode = custOff.Fiscal_code__c;
            l.ResultCode = response;
            l.SystemException = 'Error callout Nexi: ' + e.getMessage();
            logs.add(l);
        }
        return logs;
    }
    //Fine stefano.bassotti@webresults.it RET-24005
    
    //Inizio stefano.bassotti@webresults.it RET-23027
    public static List<Log> calloutNexi(Customer_Offer__c c){

        List<Log> logs = new List<Log>();
        String reason;      //stefano.bassotti@webresults.it RET-23030
        Integer importo;    //stefano.bassotti@webresults.it RET-23030

        Datetime dt = DateTime.now();
        String requestTimestamp = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS') + 'Z';

        String voucherType = c.Type_of_reward__c;
        String operationId = c.ENL_Operation_ID__c;

        String partnerType = 'CR';

        //Inizio stefano.bassotti@webresults.it RET-23030
        if ('0'.equals(c.Offer_code__r.ENL_Cluster_Type__c)) {  //Sconto euro litro
            reason = 'eurolitro2023';
            importo = (Integer) c.ENL_ScontoPerLitro__c;
        }
        if ('1'.equals(c.Offer_code__r.ENL_Cluster_Type__c)) {  //Oil non Oil Caffe
            reason = 'oilnonoilcaffe2023';
            importo = 0;
        }
        if ('2'.equals(c.Offer_code__r.ENL_Cluster_Type__c)) {  //Oil non Oil Emporium
            reason = 'oilnonoilempor2023';
            importo = 0;
        }
        //Fine stefano.bassotti@webresults.it RET-23030

        String fiscalCode = c.Fiscal_Code__c;
        Datetime dStartDate = c.ENL_OC_Validity_start_date__c;
        Datetime dEndDate = c.ENL_OC_Validity_end_date__c;

        String startDate = dStartDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS') + 'Z';
        String endDate = dEndDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS') + 'Z';

        String body = '';
        String response = '';

        try{
            system.debug('Utils.calloutNexi Transaction: ' + c.transaction__c);
            system.debug('Utils.calloutNexi Transaction ENL_Service_Type__c: ' + c.transaction__r.ENL_Service_Type__c);

            ECU_ApiSetting__c apSett = [SELECT Name, ECU_Url__c, ECU_userName__c, ECU_Password__c
            FROM ECU_ApiSetting__c
            WHERE Name = 'CalloutNexi'];

            body = '{"operationId": "' + operationId +
                        '", "partnerType": "' + partnerType +
                        '", "requestTimestamp": "' + requestTimestamp +
                        '", "voucherType": "' + voucherType +
                        '", "fiscalCode": "' + fiscalCode +
                        '", "reason": "' + reason +
                        '", "startDate": "' + startDate +
                        '", "endDate": "' + endDate +
                        '", "amount": "' + importo + '"}';

            System.debug('Utils.calloutNexi BODY: ' + body);


 //           if (!Test.isRunningTest()){
                response = ECU_APC_DynamicCallOut.getCalloutResponseContentsPost100(apSett.ECU_Url__c, apSett.ECU_userName__c, apSett.ECU_Password__c, body, 'Utils');
                System.debug('Utils.calloutNexi Response: ' + response);
//            }

            if(response.containsIgnoreCase('"message": "Success"') && response.contains('"code": "0"')){

                Log l = new Log();
                l.Level = 'INFO';
                l.EventId = operationId;
                l.EventType = 'ENL-CER-100';  // stefano.bassotti@webresults.it RET-23030
                l.FiscalCode = fiscalCode;
                l.ResultCode = response;
                l.TransmittedMessage = body;
                logs.add(l);
            } else{

                Log l = new Log();
                l.Level = 'DEBUG';
                l.EventId = operationId;
                l.EventType = 'ENL-CER-100';  // stefano.bassotti@webresults.it RET-23030
                l.FiscalCode = fiscalCode;
                l.ResultCode = response;
                l.TransmittedMessage = body;
                logs.add(l);
            }

        } catch (Exception e){

            System.debug('Utils.CalloutNexi ## EXCEPTION = ' + e.getMessage() + ' - ' + e.getStackTraceString());
            Log l = new Log();
            l.Level = 'ERROR';
            l.Origin = 'Utils.CalloutNexi';
            l.EventId = operationId;
            l.EventType = 'ENL-CER-100';  // stefano.bassotti@webresults.it RET-23030
            l.FiscalCode = fiscalCode;
            l.ResultCode = response;
            l.TransmittedMessage = body;
            l.SystemException = 'Error callout Nexi: ' + e.getMessage();
            logs.add(l);
        }
        return logs;
    }
    //Fine stefano.bassotti@webresults.it RET-23027
    /**
    * @author       Gennaro Cirillo (Gennaro.Cirillo@webresults.it)
    * @date         Maggio 23, 2023
    * @Description  Metodo usato per effettuare la Callout verso Mule, Sviluppato per fronteggiare il bisogno della Promo Rolling  
    * @params       La Customer Offer da inviare
    * @return       I log creati dalla Callout
    */    
    public static List<Log> newCalloutTariffaIntegrata2(Customer_Offer__c c){
        //Inizio andrea.riondino@eng.it FIX scrittura log  
        System.debug('newCalloutTariffaIntegrata2');
        List<Log> logs = new List<Log>();
        String operationId = c.ENL_Operation_ID__c;
        String requestId = CC_APC_MWCallouts.getRandomUUID();
        String fiscalCode = c.Fiscal_Code__c;
        String promoCode = c.Offer_Code_F__c;
        String body = '';
        String response = '';
        String transactionCode = c.Offer_Code_F__c;
        String transactionId = c.Id;
        List<Log> logsFromResponse= new List<Log>();
        List<Log> inserimentoLogFinal= new List<Log>();
        System.debug('newCalloutTariffaIntegrata2 Assegnato variabili');
        
        // manca transaction id e transaction code
        
        Set<Id> cf = new Set<Id>();
        
        try{
            System.debug('newCalloutTariffaIntegrata2 Entrato nel try');
            
            system.debug(c.transaction__c);
            system.debug(c.transaction__r.ENL_Service_Type__c);
            if (c.Transaction__r.ENL_Service_Type__c == '0' || c.Transaction__r.ENL_Service_Type__c == 'Rifornimento'){
                System.debug('newCalloutTariffaIntegrata2 Nel If');
                
                ECU_ApiSetting__c apSett = [SELECT Name, ECU_Url__c, ECU_userName__c, ECU_Password__c
                                            FROM ECU_ApiSetting__c
                                            WHERE Name = 'NewCalloutTariffaIntegrata'];
                
                body = '{"operation_id": "' + operationId + '", "request_id": "' + requestId + '", "fiscalcode": "' + fiscalCode + '", "promo_code": "' + promoCode + '", "transaction_code": "' + transactionCode + '", "transaction_id": "' + transactionId + '"}';
                System.debug('<<<BODY newCalloutTariffaIntegrata2: ' + body);
                
                
                if (!Test.isRunningTest()){
                    ECU_APC_DynamicCallOut.WrapperResponse wrResponse= ECU_APC_DynamicCallOut.getCalloutResponseContentsPost201(apSett.ECU_Url__c, apSett.ECU_userName__c, apSett.ECU_Password__c, body, 'Utils');
                    response = wrResponse.response;
                    logsFromResponse.addAll(wrResponse.logList);
                System.debug('<<<wrResponse.logList: ' + wrResponse.logList);
                System.debug('<<<logsFromResponse: ' + logsFromResponse);
                System.debug('<<<Response: ' + response);
            }
                
                if(response.contains('"message": "Success"') && response.contains('"code": "0"')){
                    System.debug('secondo if');
                    Log l = new Log();
                    l.Level = 'INFO';
                    l.EventId = operationId;
                    l.EventType = 'ECU-CER-221';
                    l.FiscalCode = fiscalCode;
                    l.ResultCode = response;
                    l.TransmittedMessage = body;
                    //logs.add(l);
                    inserimentoLogFinal.add(l);
                } else{
                    System.debug('secondo else');
                    
                    Log l = new Log();
                    //l.Level = 'DEBUG';
                    l.Level = 'ERROR';
                    l.Origin = 'Utils.newCalloutTariffaIntegrata2';
                    l.EventId = operationId;
                    l.EventType = 'ECU-CER-221';
                    l.FiscalCode = fiscalCode;
                    l.ResultCode = response;
                    l.TransmittedMessage = body;
                    //logs.add(l);
                    inserimentoLogFinal.add(l);
                }
            }
            
        } catch (Exception e){
            
            System.debug('Utils.NewCalloutTariffaIntegrata ## EXCEPTION = ' + e.getMessage() + ' - ' + e.getStackTraceString());
            Log l = new Log();
            l.Level = 'ERROR';
            l.Origin = 'Utils.NewCalloutTariffaIntegrata2';
            l.EventId = operationId;
            l.EventType = 'ECU-CER-221';
            l.FiscalCode = fiscalCode;
            l.ResultCode = response;
            l.TransmittedMessage = body;
            l.SystemException = 'Error callout tariffaIntegrata: ' + e.getMessage();
            /*   
            if (l.SystemException == 'Error callout tariffaIntegrata: You have uncommitted work pending. Please commit or rollback before calling out'){
                ID jobID = AsyncApexFramework.submitQueueable(new ECU_APQ_QueueErrorTarfIntegrata(pe, eventId), 99, true);
            }*/
            
            //logs.add(l);
            inserimentoLogFinal.add(l);
        }
        System.debug('Return: ' + logs);
        
        if(logsFromResponse == null || logsFromResponse.isEmpty()){
            logs.addAll(inserimentoLogFinal);
            System.debug('<<<logs fine 2 if inserimentoLogFinal: ' + logs);
        }else{
            logs.addAll(logsFromResponse);
            System.debug('<<<logs fine 1 if logsFromResponse: ' + logs);
        }
        System.debug('<<<logs: ' + logs);
        //Fine andrea.riondino@eng.it FIX scrittura log
        return logs;
        
    }


    /**
     * @author: Christian Niro (T.B.)
     *@data: 04/04/2023
     */
    public static List<Log> sendPromoOneShot(List<String> con, Mc_Utils__c mcUtils){

        Savepoint sp = null;

        String requestId = CC_APC_MWCallouts.getRandomUUID();
        List<Log> logs = new List<Log>();
        String authJSONbody = '';
        Integer i = 0;
        List<Contact> conUpdate = new List<Contact>();

        List<Contact> contacts = [SELECT Id, FirstName, LastName, Email, ENL_OneShot2023__c, Fiscal_Code__c, Contact_code__c
                                  FROM Contact
                                  WHERE Id IN:con];


        try{
            system.debug(mcUtils.ENL_Push_Message_ID__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token_Part_2__c);
            system.debug(mcUtils.ENL_Last_Login_MC_Token_Part_3__c);
            Http httpSend = new Http();
            HttpRequest httpReq = new HttpRequest();
            httpReq.setEndpoint(mcUtils.ENL_PromoOneShot_Endpoint__c);
            httpReq.setMethod('POST');
            httpReq.setHeader('Content-Type', 'application/json');
            httpReq.setHeader('Authorization', 'Bearer ' + mcUtils.ENL_Last_Login_MC_Token__c + mcUtils.ENL_Last_Login_MC_Token_Part_2__c + mcUtils.ENL_Last_Login_MC_Token_Part_3__c);


            for (Contact c : contacts){


                authJSONbody = '{' +                                                                                                                                                                                                                                                                                                                                                                                                                                                                                // field su contact
                '"ContactKey":"' + c.Id + '",' + '"EventDefinitionKey":"' + mcUtils.ENL_PromoOneShot_EventDefinitionKey__c + '",' + 
                             '"Data": {' + 
                             '"contactid":"' + c.Id + '",' + 
                             '"Email":"' + c.Email + '",' + 
                             '"FirstName":"' + c.FirstName + '"' + 
                             '}' + 
                             '}';

                httpReq.setBody(authJSONbody);
                system.debug(authJSONbody);
                system.debug(httpReq.getBody());
                Map<String, Object> sendResponse = new Map<String, Object>();

                if (!Test.isRunningTest()){
                    HttpResponse httpRes = httpSend.send(httpReq);
                    sendResponse = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getbody());
                    system.debug(sendResponse);
                } else{
                    sendResponse.put('tokenId', (Object) 'tokenId');
                }

                if (sendResponse.containsKey('eventInstanceId')){
                    c.ENL_OneShot2023__c = 'Voucher Ricevuto';
                    conUpdate.add(c);

                }

                Log l = new Log();
                l.EventId = requestId;
                l.EventType = 'MC-sendPromoOneShot';
                l.level = 'INFO';
                l.FiscalCode = c.Fiscal_Code__c;
                l.ResultCode = JSON.serialize(sendResponse);
                l.TransmittedMessage = authJSONbody;
                logs.add(l);
                i++;
            }


            //setPointRollback
            sp = Database.setSavepoint();


            if (conUpdate.size() > 0){
                Database.SaveResult[] sr = Database.update (conUpdate, false);


            }


        } catch (Exception e){


            Log l = new Log();
            l.Level = 'ERROR';
            l.Origin = 'Utils.sendPromoOneShot';
            l.EventId = requestId;
            l.EventType = 'MC-sendPromoOneShot';
            l.FiscalCode = contacts[i].Fiscal_Code__c;
            l.ResultCode = e.getStackTraceString();
            l.TransmittedMessage = authJSONbody;
            l.SystemException = 'Error Voucher oneSHot: ' + e.getMessage();
            logs.add(l);
            if (sp != null){
                Database.rollback(sp);
            }
        }
        i++;

        return logs;
    }


    //Inizio modifiche 19/10/2023 Giuseppe Mario Pastore RET 23033
    /**
	* @author       Giuseppe Mario Pastore (giuseppemario.pastore@webresults.it)
	* @date         19-10-2023
	* @Description  metodo per controllare se l'Offer Code è incluso nel custom Setting ELP_OfferListLoyalty__c, e quindi l'offerta è di tipo Loyalty
    * @return       String offerCode --> l'Offer Code dell'offerta
	*/
    private static Boolean isLoyaltyOffer(String offerCode){
        Map<String,ELP_OfferListLoyalty__c> loyOfferMap = ELP_OfferListLoyalty__c.getAll();
        for(String key : loyOfferMap.keySet()){
            if(loyOfferMap?.get(key)?.Offer_Code_List__c?.split(';')?.contains(offerCode)){
                return true;
            }
        }
        return false;
    }
    // Fine modifiche 19/10/2023 Giuseppe Mario Pastore RET 23033

    public static List<Log__c> getLogsByParams(Map<String, Object> params) {
        List<Log__c> logList = null;
        String email = String.valueOf(params.get('email'));
        String fiscalCode = String.valueOf(params.get('fiscalCode'));
        String origin = String.valueOf(params.get('origin'));
        String level = String.valueOf(params.get('level'));
        String startDateStr = String.valueOf(params.get('startDate'));
        String endDateStr = String.valueOf(params.get('endDate'));
        Date startDate = Date.valueOf(startDateStr);
        Date endDate = Date.valueOf(endDateStr);
        DateTime startDateTime = DateTime.newInstanceGmt(startDate.year(), startDate.month(), startDate.day(), 0, 0, 0);
        DateTime endDateTime = DateTime.newInstanceGmt(endDate.year(), endDate.month(), endDate.day(), 23, 59, 59);

        ECU_LogFieldExtraction__c extractionObj = ECU_LogFieldExtraction__c.getValues('logFields');
        String queryStr = 'SELECT ' + extractionObj.ECU_Extraction_Field__c + ' FROM Log__c ';
        queryStr += 'WHERE CreatedDate > :startDateTime AND CreatedDate < :endDateTime ';

        if (String.isNotBlank(origin)) {
            queryStr += 'AND Origin__c = :origin ';
        }
        if (String.isNotBlank(email)) {
            queryStr += 'AND ECU_Email__c = :email ';
        }
        if (String.isNotBlank(fiscalCode)) {
            queryStr += 'AND Fiscal_Code__c = :fiscalCode ';
        }
        if (String.isNotBlank(level)) {
            queryStr += 'AND Level__c = :level ';
        }
        System.debug('>>>queryStr: ' + queryStr);
        return logList = Database.query(queryStr);
    }

}