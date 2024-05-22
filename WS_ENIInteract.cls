/**
 * @description       :
 * @author            :
 * @group             :
 * @last modified on  : 11-15-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified by  : 06-09-2023 Stefano Bassotti HOTFIX-198 Modificato select Offer_Catalog__c campo Validity_end_date__c eliminato =
 * @last modified by  : 14-09-2023 Stefano Bassotti HOTFIX-198 V1 modifica where delle offer catalog
 **/
global class WS_ENIInteract{
    static Set<String> eventTypes = new Set<String>{ '1', '2', '3', '4', '5', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19' };
    //GC Map<String, String> successMap = new Map<String, String>();
    static Map<String, String> successMap1 = new Map<String, String>();
    static Map<String, String> successMap4 = new Map<String, String>();
    static Map<String, String> successPIVAMap = new Map<String, String>();
    static Map<String, String> successMap7 = new Map<String, String>();
    static Map<String, String> successMap8 = new Map<String, String>();
    static Map<String, String> successMap9 = new Map<String, String>();
    static Map<String, String> successMap10 = new Map<String, String>();
    static Map<String, String> successMap11 = new Map<String, String>();
    static Map<String, String> successMap11ToUpdate = new Map<String, String>();
    static Map<String, String> successMap12 = new Map<String, String>();
    static Map<String, String> successMap12ToUpdate = new Map<String, String>();
    static Map<String, String> successMap13 = new Map<String, String>();
    static Map<String, String> successMap14 = new Map<String, String>();
    static Map<String, String> successMap16 = new Map<String, String>();
    static Map<String, String> successMap18 = new Map<String, String>();
    static Map<String, String> successMap7Reconciliation = new Map<String, String>();
    //GC
    static Map<String, String> transactionsSucessMap = new Map<String, String>();
    static Map<String, String> transactionsSucessMapOld = new Map<String, String>();
    static Map<String, String> transactionsSucessMapEvent17 = new Map<String, String>();
    static Map<String, String> transactionsSucessMapEvent19 = new Map<String, String>();
    static Map<String, String> loyaltyCardNumbers = new Map<String, String>();
    static Map<String, Contact> existingContactsByEmail = new Map<String, Contact>();
    static Map<String, Contact> existingLeadsByEmail = new Map<String, Contact>();
    static Map<String, Contact> existingContactsLead = new Map<String, Contact>();
    static Map<String, Contact> existingLead = new Map<String, Contact>();
    static set<String> conFicalCodeToStartBatch = new set<String>();
    static set<String> contactEntryGift = new set<String>();
    static set<String> contactMulticardEasy = new set<String>();
    static set<Id> contactVoucherChristmas = new set<Id>();
    static List<Contact> contactVoucherEnjoy = new List<Contact>();
    static Map<String, Contact> existingContacts = new Map<String, Contact>();
    static Map<String, Contact> existingContactsOld = new Map<String, Contact>();
    //commentato per dismissione loyalty_card 24/02/23
    //static Map<String, Loyalty_card__c> existingCards = new Map<String, Loyalty_card__c>();
    //static Map<String, Loyalty_card__c> existingCardsOld = new Map<String, Loyalty_card__c>();
    static Map<String, Transaction__c> existingTransactions = new Map<String, Transaction__c>();
    static Map<String, Transaction__c> existingTransactionsOld = new Map<String, Transaction__c>();
    static Map<String, Customer_Offer__c> existingCustomerOffer = new Map<String, Customer_Offer__c>();
    static Map<String, Transaction__c> transactionMorosaToBeLinked = new Map<String, Transaction__c>();
    static Map<String, Transaction__c> transactionProdEmpRitirAnnullati = new Map<String, Transaction__c>();
    static Map<String, Transaction__c> transactionIntegrataToBeLinked = new Map<String, Transaction__c>();
    static Map<String, Contact> event1Contacts = new Map<String, Contact>();
    static Map<String, Contact> event4Contacts = new Map<String, Contact>();
    static Map<String, Contact> event7ContactsToUpdate = new Map<String, Contact>();
    static Map<String, Contact> event8ContactsToUpdate = new Map<String, Contact>();
    static Map<String, Contact> event9ContactsToUpdate = new Map<String, Contact>();
    static Map<String, Contact> event7ContactsToReconcile = new Map<String, Contact>();
    static Map<String, Contact> event11ContactsToInsert = new Map<String, Contact>();
    static Map<String, Contact> event11ContactsToUpdate = new Map<String, Contact>();
    static Map<String, Contact> event12ContactsToInsert = new Map<String, Contact>();
    static Map<String, Contact> event12ContactsToUpdate = new Map<String, Contact>();
    static Map<String, Contact> event13Contacts = new Map<String, Contact>();
    static Map<String, Contact> event14Contacts = new Map<String, Contact>();
    static Map<String, Contact> event16ContactsToUpdate = new Map<String, Contact>();
    static Map<String, Contact> event18ContactsToInsert = new Map<String, Contact>();
    static Map<String, String> eventIdMap = new Map<String, String>();
    static Map<String, Enl_Prodotti_emporium__c> event19Prodotti = new Map<string, Enl_Prodotti_emporium__c>();
    //nuova mappa per controllo cluster gestori
    static Map<String, ENL_Anagrafica_Gestori__c> existingAnagraficaGestori = new Map<String, ENL_Anagrafica_Gestori__c>();
    //mappa per le service_station di pre-registrazione
    static Map<String, CC_Service_Station__c> ssMap = new Map<String, CC_Service_Station__c>();
    //mappe per recuperare le transazioni da lead a customer
    static Set<String> contactIdsMapWithTrans = new Set<String>();
    static Set<String> contactIdsMapWithTransBatch = new Set<String>();
    //mappa per la creazione delle customer_offer di iscrizione utilizzata nell'evento 1 e nell'evento 7
    static Set<Id> contactToCreateCustomerOffer = new Set<Id>();
    static List<Voucher__c> vouchersToInsert = new List<Voucher__c>();
    static Map<String, Customer_Offer__c> event10CustomerOfferToUpdate = new Map<String, Customer_Offer__c>();
    static List<Account> event8AccountsToUpdate = new List<Account>();
    //EN: lista per eventi clienti Partita IVA
    static Map<String, Contact> eventPIVAContacts = new Map<String, Contact>();
    //Map<String,Contact> eventPIVAContactsToUpdate = new Map<String,Contact>();
    //EN: utilizzo mappa per gestione errore per eventuali duplicati
    static Map<String, Contact> otherContacts = new Map<String, Contact>();
    static Map<String, Contact> otherContactsOld = new Map<String, Contact>();
    //static Map<String, Contact> otherContactsEvent17 = new Map<String, Contact>();
    //EN: utilizzo mappa per gestione errore per eventuali duplicati
    static Map<String, Transaction__c> newTransactions = new Map<String, Transaction__c>();
    static Map<String, Transaction__c> newTransactionsOld = new Map<String, Transaction__c>();
    static Map<String, Transaction__c> updateTransactions = new Map<String, Transaction__c>();
    static Map<String, Transaction__c> updateTransactionsEvent19 = new Map<String, Transaction__c>();
    static Map<String, Transaction__c> newTransactionsEvent17 = new Map<String, Transaction__c>();
    static Map<String, Transaction__c> newTransactionsEvent19 = new Map<String, Transaction__c>();
    static Map<String, List<ProdottiEmporium>> mapListProd = new Map<String, List<ProdottiEmporium>>();
    static List<Loyalty_card__c> loyaltyCards = new List<Loyalty_card__c>();
    static Map<Id, String> loyaltyCardsMap = new Map<Id, String>();
    //reinserito per testApp
    static Map<String, String> rtContactMap = new Map<String, String>{ '0' => Utils.getRecordTypeId('Customer', 'Contact'), '1' => Utils.getRecordTypeId('Business', 'Contact') };
    static String numCartaLoyalty;
    static String capitalizedFC;
    static String capitalizeEmail;
    static String num_carta_loy;
    static Loyalty_card__c loy;
    static List<Log> logs = new List<Log>();
    // 03/09/2019 TRACE ALL INBOUND EVENTS BEFORE ELABORATION
    static List<Log> logInboundEvents = new List<Log>();
    //25/03/2021
    static String requestId = '';
    static List<String> ListFiscalCodeList = new List<String>();
    static List<String> existEmailList = new List<String>();
    static List<String> noEmailList = new List<String>();
    //27/04/2021
    static String eventId = '';
    static Map<String, voucherValues> voucherInitilizeMap = new Map<String, voucherValues>();
    static Map<String, voucherValues> voucherInitilizeMap2 = new Map<String, voucherValues>();
    static List<Contact> ContactOfferList = new List<Contact>();
    static List<Contact> ContactOfferList7 = new List<Contact>();
    static List<Contact> preRegisteredContactsVoucher = new List<Contact>();    //per RET-22030 DEM real pre registrati
    static Map<String, Set<String>> requiredFields = new Map<String, Set<String>>();
    static Map<String, Set<String>> requiredFieldsEvent12 = new Map<String, Set<String>>();
    static Map<String, Set<String>> requiredFieldsEvent18 = new Map<String, Set<String>>();
    global class WS_ENIInteract_Exception extends Exception{
    }

    global class Request{
        webservice Header header;
        webservice List<Request_Voucher__c> voucher;
    }

    global class Header{
        webservice String REQUESTID;
        webservice DateTime timestamp;
    }

    global virtual class Response{
    }

    global class Wrapper_Request_NotifyEvent{
        webservice Header header;
        webservice List<Request_NotifyEvent> request;
    }

    global class Request_NotifyEvent{
        webservice String CODICE_FISCALE;//Codice fiscale nuovo iscritto
        webservice DateTime DATA;//Data
        webservice String IMPIANTO;//Codice impianto
        webservice String PRODOTTO;//Tipo Prodotto
        webservice Boolean FLAG_PAGAMENTO;//Flag Pagamento App
        webservice Integer PUNTI;//Punti Rifornimento
        WebService Decimal LITRI;//Litri Rifornimento
        WebService String MODALITA_OPERATIVA;//Modalità Operativa Rifornimento
        webservice String NOME;//Nome nuovo iscritto
        webservice String COGNOME;//Cognome nuovo iscritto
        webservice String INDIRIZZO_EMAIL;//Indirizzo e-mail nuovo iscritto
        webservice Date DATA_DI_NASCITA;//Data di nascita nuovo iscritto
        webservice boolean FG_NOTIFICA;//Flag Attivazione notifica
        webservice boolean FG_1;//Flag associazione carta pagamento
        webservice String CARTA;//Tipo carta
        webservice String CLUSTER;//Decodifica Cluster di appartenenza 1 Y&E 2 Enipay
        webservice Decimal IMPORTO; //Valore economico dell'importo del rifornimento (in euro)
        webservice Boolean FLG_PRIVACY1;//Flag consenso privacy e ricezione iniziative commerciali
        webservice Boolean FLG_PRIVACY2;//Flag consenso privacy e ricezione iniziative commerciali provenienti da altri soggetti
        webservice String TEL_MOBILE;//Telefono mobile dell’iscritto
        webservice String NUM_CARTA_LOYALTY;//Numero della carta loyalty
        webservice String EVENT_TYPE;//Tipo di evento trasmesso
        webservice String PARAMETER1;//TBD
        webservice String PARAMETER2;//TBD
        webservice String EVENT_ID;
        webservice String MODALITA_PAGAMENTO;
        //EN: aggiunti i nuovi attributi relativi ai clienti Partita IVA
        webservice String TIPOLOGIA_UTENTE; //se customer (0) o business (1)
        webservice String RAGIONE_SOCIALE; // ragione sociale del cliente P.IVA
        webservice String INDIRIZZO_FATTURAZIONE; // Indirizzo fatturazione
        webservice String CIVICO_FATTURAZIONE; // numero civico fatturazione
        webservice String CITTA_FATTURAZIONE; // città fatturazione
        webservice String PROVINCIA_FATTURAZIONE; // provincia fatturazione
        webservice String NAZIONE_FATTURAZIONE; // nazione fatturazione
        webservice String CAP_FATTURAZIONE; // CAP fatturazione
        webservice String NOME_FATTURAZIONE; // Nome cliente fatturazione
        webservice String COGNOME_FATTURAZIONE; // Cognome cliente fatturazione
        webservice String PEC_EMAIL; // Email PEC cliente fatturazione
        webservice String SDI_CODE; // Codice Di Interscambio cliente fatturazione
        webservice String PARTITA_IVA; // Numero Partita IVA cliente fatturazione
        webservice String CODICE_FISCALE_FATTURAZIONE; // Codice fiscale cliente fatturazione
        webservice List<Targhe> TARGHE; // Numero targa //RET20015 change type from String to List<String> sul Contact il campo di riferimento Plate__c è di tipo TextArea
        webservice String SESSO; // Sesso cliente (M/F)
        //ENICCM-137 [RET20012] Cancellazione Cliente
        webservice String ORIGINE_RICHIESTA; //l’origine della richiesta di cancellazione da parte dell’utente | 0 = App; 1 = Contact Center
        webservice String TIPOLOGIA_CANCELLAZIONE; //tipologia di cancellazione | 0 = Cancellazione dalla loyalty; 1 = Cancellazione dall'app; 2 = Diritto all’oblio
        //[RET20015] Nuova loyalty
        webservice String EMAIL_FATTURAZIONE;//Seconda email (opzionale), se valorizzata verrà utilizzata per l’invio delle fatture
        webservice Decimal KWH;//kWh erogati per il rifornimento di energia elettrica
        webservice Integer DURATA;//Durata della ricarica elettrica o della sosta parcheggio (valore espresso in MINUTI)
        webservice String TIPOLOGIA_RICARICA;//Identifica la tipologia di corrente per la ricarica elettrica. 0 = Corrente continua 1 = Corrente alternata
        webservice String TIPOLOGIA_SERVIZO;//Identifica la tipologia di servizio associato alla transazione di pagamento. 0 = Rifornimento 1 = Parcheggio 2 = NON-OIL
        webservice DateTime DATA_INIZIO;//Data di inizio della sosta nel parcheggio/ricarica elettrica
        webservice DateTime DATA_FINE;//Data di fine della sosta nel parcheggio
        webservice Boolean BLACKLIST;//Flag inserimento (TRUE) cancellazione (FALSE) Cliente da Blacklist
        webservice String CAUSALE_BLACKLIST;//Motivo per cui il cliente è in blacklist
        webservice Boolean BLOCCO_ANTIFRODE;//Necessario per ricevere esito sui controlli anti-frode effettuati da P4Cards – valorizzato eventualmente a TRUE solo per transazione che arrivano da APP
        webservice String CODICE_TRANSAZIONE;//Codice relativo alla transazione. Per distinguere più prodotti acquistati con la stessa transazione di pagamento (le transazioni per questi prodotti avranno lo stesso CODICE_TRANSAZIONE)
        webservice Boolean IMPIANTO_NON_ABILITATO;//Valorizzato eventualmente a TRUE solo per transazioni che arrivano da App
        webservice String OPERATION_ID;
        webservice String LOTTERY_CODE;
        webservice DateTime TIMESTAMP_TAP;
        webservice String COMUNE_NASCITA;
        webservice String PROVINCIA_NASCITA;
        webservice List<AllPrivacy> ALL_PRIVACY;//Contiene tutti i flag privacy nel formato KEY/VALUE (FLG_PRIVACY1;FALSE FLG_PRIVACY2;TRUE FG_NOTIFICA;TRUE)
        webservice String CAMPAIGN_TYPE;
        webservice String TRANSACTION_ID;//Chiave univoca Transazione generata da App e propagata agli altri sistemi
        //12-03-2021 Campi aggiuntivi App Unica
        webservice String INDIRIZZO_RESIDENZA;
        //webservice String DESCRIZIONE_VEICOLO;
        webservice List<MulticardWrap> MULTICARD;
        webservice List<String> TARGA;
        webservice String RICONCILIAZIONE;
        webservice String SISTEMA_SORGENTE;
        webservice String INDIRIZZO_FATTURAZIONE_PRIVATI;
        webservice String CITTA_FATTURAZIONE_PRIVATI;
        webservice String NOME_FATTURAZIONE_PRIVATI;
        webservice String COGNOME_FATTURAZIONE_PRIVATI;
        webservice String CAP_FATTURAZIONE_PRIVATI;
        webservice String PROVINCIA_FATTURAZIONE_PRIVATI;
        webservice String CIVICO_FATTURAZIONE_PRIVATI;
        webservice String CIVICO_RESIDENZA;
        webservice String CAP_RESIDENZA;
        webservice String CITTA_RESIDENZA;
        webservice String PROVINCIA_RESIDENZA;
        webservice String CODICE_BUONO;
        webservice String ESITO_BUONO;
        webservice String RICONCILIAZIONE_CUSTOMER_TYPE;
        // GN - 15/07/2021 - Campi aggiunti all'evento 11 per reportistica pre-registrazione
        webservice String ID_GESTIONE;
        webservice String SCONTO_APPLICATO;
        webservice String CODICE_ERRORE_PARCHEGGIO;
        webservice String DESCRIZIONE_ERRORE_PARCHEGGIO;
        webservice String TRANSAZIONE_MOROSA;
        webservice String CITTA_SOSTA;  //per sosta MyCicero
        webservice String ID_ZONA;      //per sosta MyCicero
        webservice String ID_PARCHIMETRO;  //per sosta MyCicero
        webservice Decimal IMPORTO_PENALITA; // per penalita EnelX
        webservice String TIPOLOGIA_SCONTO; // per tariffa convenzionata
        webservice Decimal SCONTO_CONVENZIONE;  //per tariffa convenzionata
        webservice Boolean ISCRIZIONE_ENJOY_COMPLETA; //per voucher enjoy
        webservice String CANALE_REGISTRAZIONE;
        webservice String CODICE_PROMOZIONE; //Promo gestori 1
        webservice Decimal IMPORTO_PRENOTAZIONE; // per recharge integrazione della prenotazione
        webservice Integer DURATA_SOSTA;//Durata della sosta relativa alla penalita EnelX(valore espresso in MINUTI)
        webservice Integer NUMERO_STALLO;   //per parecheggio a stallo singolo
        webservice Integer DURATA_PRENOTAZIONE; //per transazione con durata prenotazione
        webservice List<ProdottiEmporium> PRODOTTI_EMPORIUM; //array contenente la lista dei prodotti emporium
        webservice String NUMERO_ORDINE; //Promo Emporium
        webservice DateTime ORARIO_ACQUISTO; //Promo Emporium
        webservice DateTime DATA_CONFERMA_GESTORE; //Promo Emporium
        webservice String FASCIA_PREVISTA_RITIRO; //Promo Emporium
        webservice String CODICE_RITIRO; //Promo Emporium
        webservice DateTime ORARIO_EFFETTIVO_RITIRO; //Promo Emporium
        webservice String STATO_TRANSAZIONE; //Promo Emporium
        webservice String MOTIVO_STORNO; //Promo Emporium
    }

    global class Response_NotifyEvent extends Response{
        webservice Header header;
        webservice List<Result_NotifyEvent> result_NotifyEvent;
    }

    global class Result_NotifyEvent{
        webservice Boolean SUCCESS;
        webservice String ERRORCODE;
        webservice String MESSAGE;
        webservice String REQUESTID;// SAME VALUE OF EVENT_ID FIELD
        webservice String OPERATION_ID;//voucher request operation id
        webservice String FISCALCODE;//fiscal code for voucher request
        webservice String PROMO_CODE;//promo code for voucher request
        webService Decimal VOUCHER_AMOUNT;//amount for voucher request
        webService String CONTACT_KEY;//SF ID used to register mobile device into Marketing Cloud on the sync Contact from Service Cloud
        // EN: attributo che discrimina la tipologia di utente
        //11-03-2021 rimosso per modifiche App Unica
        webservice String TIPOLOGIA_UTENTE; //se consumer (0) o business (1)
        webService String RESULT_CODE;
        webService String EMAIL;
        webService String FIRST_NAME;
        webService String LAST_NAME;
        webService String PROVINCE;
        webService String CITY;
        webService Date BIRTH_DATE;
        webService String TELEPHONE;
        webService String ADDRESS;
        webService Boolean PRIVACY;
        webService String STREET_NUMBER;
        webService String POSTAL_CODE;
        webService String PROVINCE_RESIDENCE;
        webService String CITY_RESIDENCE;
        webService String FLOW_CODE;
    }

    global class Wrapper_Request_GetOffers{
        webservice Header header;
        webservice List<Request_GetOffers> request;
    }

    global class Request_GetOffers{
        webservice String CODICE_FISCALE;
        webservice Datetime DATA;
        webservice Boolean FG_NOTIFICA;
        webservice Boolean FG_1;
        webservice String CARTA;
        webservice String CLUSTER;
        // EN: attributo che discrimina la tipologia di utente
        webservice String TIPOLOGIA_UTENTE; //se consumer (0) o business (1)
    }

    global class Response_GetOffers extends Response{
        webservice Header header;
        webservice List<Result_GetOffers> result_GetOffers;
    }

    global class Result_GetOffers{
        webservice String OFFER_CODE;//Codice offerta
        webservice String NOME;//Nome offerta
        webservice String BANNER_ID;//Identificativo della creativita associato all'offerta
        WebService Datetime DATA_INIZIO;// Data inizio validità offerta
        webservice Datetime DATA_FINE;//Data fine validità offerta
        webservice String DESCRIZIONE;//Descrizione offerta ed eventualmente dell'obiettivo commerciale
        webservice String TIPO_OFFERTA;//Real Time
        webservice String CANALE;// APP
        webservice String TIPO_MISSIONE;//"Promozione" o "Missione"
        webservice Integer NUM_EXECUTED_STEPS;//Indica il numero operazioni eseguite rispetto al numero operazioni obiettivo per le missioni a step
        webservice Integer NUM_TOT_STEPS;//Indica il numero di operazioni obiettivo
        webservice String URL;//Link della mobile push page
        webservice String PARAMETER1;//TBD
        webservice String PARAMETER2;//TBD
        webservice String PARAMETER3;//TBD
        webservice Decimal PARAMETER4;//TBD
    }

    //GetPromotions
    global class Wrapper_Request_GetPromotions{
        webservice Header header;
        webservice List<Request_GetPromotions> request;
    }

    global class Request_GetPromotions{
        webservice Datetime DATA;
        webservice String PARAMETER1;
        webservice String PARAMETER2;
        webservice String PARAMETER3;
        webservice String PARAMETER4;
    }

    global class Response_GetPromotions extends Response{
        webservice Header header;
        webservice List<Result_GetPromotions> result_GetPromotions;
    }

    global class Result_GetPromotions{
        webservice String OFFER_CODE;//Codice promozione
        webservice String NOME;//Nome promozione
        webservice String BANNER_ID;//Identificativo della creativita associato alla promozione
        WebService Datetime DATA_INIZIO;// Data inizio validità promozione
        webservice Datetime DATA_FINE;//Data fine validità promozione
        webservice String URL;//Link della mobile push page
        webservice String PARAMETER1;//TBD
        webservice String PARAMETER2;//TBD
        webservice String PARAMETER3;//TBD
        webservice Decimal PARAMETER4;//TBD
        // EN: attributo che discrimina la tipologia di utente
        webservice String TIPOLOGIA_UTENTE; //se customer (0) o business (1)
    }

    //end GetPromotions
    global class Wrapper_Request_ProcessEventOutComes{
        webservice Header header;
        webservice List<Request_ProcessEventOutComes> request;
    }

    global class Request_ProcessEventOutComes{
        webservice String STATUS_CODE;//Esito creazione Voucher nel backend dell'app
        webservice String MESSAGE_CODE;//Codice associato all'esito della creazione del Voucher
        webservice String OPERATION_ID;//Codice univoco per individuare il Request_voucher__c da aggiornare
    }

    global class Response_ProcessEventOutComes extends Response{
        webservice Header header;
        webservice List<Result_ProcessEventOutComes> result_ProcessEventOutComes;
    }

    global class Result_ProcessEventOutComes{
        webservice String STATUS_CODE;
        webservice String MESSAGE_CODE;
        webservice String OPERATION_ID;
        WebService String ERROR_MESSAGE;
    }

    global class AllPrivacy{
        webservice String KEY;
        webservice Boolean VALUE;
        webservice String SOURCE; //app chiamante: 1 = Enilive, 2 = Enjoy
        webservice DateTime DATECHANGE;
    }

    global class PrivacyDetails{
        String sourcePrivacy;
        Datetime dateChangePrivacy;
        public PrivacyDetails(String privacy, DateTime timeStamp){
            this.sourcePrivacy = privacy;
            this.dateChangePrivacy = timeStamp;
        }

        public String getSourcePrivacy(){
            return this.sourcePrivacy;
        }

        public Datetime getDateChangePrivacy(){
            return this.dateChangePrivacy;
        }

    }

    global class Targhe{
        webservice String TARGA;
        webservice String DESCRIZIONE_VEICOLO;
    }

    global class MulticardWrap{
        webservice String MULTICARD;
        webservice Datetime DATA_INSERIMENTO_MULTICARD;
    }

    global class ProdottiEmporium{
        webservice String CATEGORIA;
        webservice String CODICE_ARTICOLO;
        webservice String DESCRIZIONE_ARTICOLO;
        webservice Integer QUANTITA_PEZZI;
        webservice Double IMPORTO_UNITARIO;
    }

    webservice static Response_ProcessEventOutComes ProcessEventOutComes(WS_ENIInteract.Wrapper_Request_ProcessEventOutComes res){
        List<Log> logs = new List<Log>();

        WS_ENIInteract.Response_ProcessEventOutComes ws = new WS_ENIInteract.Response_ProcessEventOutComes();
        ws.Result_ProcessEventOutComes = new List<Result_ProcessEventOutComes>();
        ws.header = res.header;

        Set<String> operationIds = new Set<String>();

        List<Request_voucher__c> vouchers = new List<Request_Voucher__c>();

        for (Request_ProcessEventOutComes lis : res.request){

            //GC TEMPORARY TO DELETE
            logs.add(new Log('INFO', 'WS_ENIInteract.ProcessEventOutComes', 'Response generaz puntuale voucher', '', String.valueOf(lis), '', '', null));
            //GC
            vouchers.add(new Request_Voucher__c(Delivery_Id__c = lis.STATUS_CODE, Operation_ID__c = lis.OPERATION_ID));
        }

        Schema.SObjectField o = Request_Voucher__c.Fields.Operation_ID__c;
        Integer i = 0;
        for (Database.UpsertResult upr : Database.upsert (vouchers, o, false)){
            if (upr.isSuccess()){
                Result_ProcessEventOutComes result = new Result_ProcessEventOutComes();

                result.STATUS_CODE = res.request.get(i).STATUS_CODE;
                result.MESSAGE_CODE = res.request.get(i).MESSAGE_CODE;
                result.OPERATION_ID = res.request.get(i).OPERATION_ID;
                result.ERROR_MESSAGE = '';

                ws.result_ProcessEventOutComes.add(result);

                operationIds.add(res.request.get(i).OPERATION_ID);

            } else{
                Result_ProcessEventOutComes result = new Result_ProcessEventOutComes();

                result.STATUS_CODE = res.request.get(i).STATUS_CODE;
                result.MESSAGE_CODE = res.request.get(i).MESSAGE_CODE;
                result.OPERATION_ID = res.request.get(i).OPERATION_ID;
                result.ERROR_MESSAGE = String.valueOf(upr.getErrors());

                ws.result_ProcessEventOutComes.add(result);
                Log l = new Log('ERROR', 'WS_ENIInteract.ProcessEventOutComes', 'Errore upsert voucher', 'Errore: ' + upr.getErrors(), String.valueOf(result), res.request.get(i).OPERATION_ID, '', null);
                logs.add(l);
            }

            i++;
        }

        List<Contact> contactsToUpd = new List<Contact>();
        //GC 03/04/2019
        Map<String, Request_Voucher__c> contactCodesReqVoucher = new Map<String, Request_Voucher__c>();
        //GC

        for (Request_Voucher__c req : [SELECT Contact_code__c, Type__c, Delivery_Id__c
                                       FROM Request_Voucher__c
                                       WHERE Operation_ID__c IN:operationIds]){
            contactCodesReqVoucher.put(req.Contact_code__c, req);//GC
            //contactsToUpd.add(new Contact(Id = req.Contact_code__c, Mastercard_voucher_recieved__c = true));
        }

        //GC 03/04/2019
        for (Contact con : [SELECT Id, Mastercard_voucher_recieved__c, Contact_code__c
                            FROM Contact
                            WHERE Id IN:contactCodesReqVoucher.keySet()]){
            Request_Voucher__c currReqVou = contactCodesReqVoucher.get(con.Id);
            if (!con.Mastercard_voucher_recieved__c && currReqVou.Type__c.toUpperCase() == 'MASTERCARD' && currReqVou.Delivery_Id__c.toUpperCase() == 'SUCCESS')
                //(currReqVou.Type__c.toUpperCase() == 'MASTERCARD' && currReqVou.Delivery_Id__c.toUpperCase() == 'SUCCESS'))
                //se testo il success in caso di errore e prima che venga elaborato retry se l'utente riassocia mastercard si potrebbe rigenerare
                //altro voucher masterc non essendo Mastercard_voucher_recieved__c a true - questo flag a true dovrebbe essere considerato come voucher
                //generato o in attesa di generazione
                contactsToUpd.add(new Contact(Id = con.Id/*, Mastercard_voucher_recieved__c = true*/));
        }
        //GC
        update contactsToUpd;

        Utils.generateLogs(logs, Utils.INFO_CODE);

        return ws;
    }

    webservice static Response_NotifyEvent NotifyEvent(WS_ENIInteract.Wrapper_Request_NotifyEvent res){
        //List<Log> logs = new List<Log>();
        //Savepoint sp = Database.setSavepoint();

        try{
            Schema.SObjectField f = Contact.Fields.Contact_code__c; //field used for contact upsert
            Schema.SObjectField c = Loyalty_Card__c.Fields.Card_code__c;//field used for loyalty card upsert
            WS_ENIInteract.Response_NotifyEvent ws = new WS_ENIInteract.Response_NotifyEvent();
            ws.Result_NotifyEvent = new List<Result_NotifyEvent>();
            ws.header = res.header;
            existingContactsByEmail = ENL_APC_WsInteractHelper.queryExistingContactsByMail(res.request);
            existingLeadsByEmail = ENL_APC_WsInteractHelper.retrieveExistingLeadsByEmail(res.request);
            existingContactsLead = ENL_APC_WsInteractHelper.queryExistingContactsLead(res.request);
            existingLead = ENL_APC_WsInteractHelper.queryOnlyEnlLead(res.request);
            existingContacts = queryExistingContacts(res.request);
            existingContactsOld = queryExistingContactsOld(res.request);
            //commentato per dismissione loyalty_card 24/02/23
            //existingCards = queryExistingCards(res.request);
            //existingCardsOld = queryExistingCardsOld(res.request);
            existingTransactions = queryExistingTransactions(res.request);
            existingTransactionsOld = queryExistingTransactionsOld(res.request);
            existingCustomerOffer = queryExistingCustomerOffer4Lottery(res.request);
            transactionMorosaToBeLinked = queryExistingTransactionMorosa(res.request);
            transactionIntegrataToBeLinked = queryExistingTransactionIntegrata(res.request);
            transactionProdEmpRitirAnnullati = queryExistingTransactionProdotti(res.request);
            //nuovo metodo per controllo cluster gestori
            existingAnagraficaGestori = ENL_APC_WsInteractHelper.queryExistingAnagraficaGestori(res.request);

            ssMap = queryExistingServiceStations(res.request);
            requestId = res.header.REQUESTID;

            for (Request_NotifyEvent lis : res.request){

                numCartaLoyalty = (String.isNotBlank(lis.NUM_CARTA_LOYALTY)) ? lis.NUM_CARTA_LOYALTY.substring(0, 18) : NULL;
                logInboundEvents.add(new Log('INFO', 'WS_ENIInteract.NotifyEvent', '', '', String.valueOf(lis), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE, numCartaLoyalty, lis.PRODOTTO, lis.LITRI, lis.IMPORTO, lis.PUNTI, lis.MODALITA_OPERATIVA, lis.PARTITA_IVA, fromObjectToString(lis.TARGHE), null, lis.CARTA));

            }

            Utils.generateLogs(logInboundEvents, Utils.INFO_CODE);
            //--------------------------------------------------------

            for (Request_NotifyEvent lis : res.request){

                // SET numCartaLoyalty TO POPULATE LOG OBJECTS
                numCartaLoyalty = (String.isNotBlank(lis.NUM_CARTA_LOYALTY)) ? lis.NUM_CARTA_LOYALTY.substring(0, 18) : NULL;

                //  if(!String.isEmpty(lis.CODICE_FISCALE) && lis.EVENT_TYPE != '12') {
                capitalizedFC = String.isNotBlank(lis.CODICE_FISCALE) ? lis.CODICE_FISCALE.toUpperCase() : '';
                capitalizeEmail = String.isNotBlank(lis.INDIRIZZO_EMAIL) ? lis.INDIRIZZO_EMAIL.toUpperCase() : '';

                system.debug('lis.PRODOTTI_EMPORIUM = ' + lis.PRODOTTI_EMPORIUM);
                mapListProd.put(lis.NUMERO_ORDINE, lis.PRODOTTI_EMPORIUM);
                system.debug('mappa ListProd =' + mapListProd);

                if (String.isNotBlank(lis.NUM_CARTA_LOYALTY)){
                    num_carta_loy = lis.NUM_CARTA_LOYALTY.left(18);
                    lis.NUM_CARTA_LOYALTY = num_carta_loy;
                }

                if (eventTypes.contains(lis.EVENT_TYPE)){
                    // 1| Iscrizione nuovo cliente
                    if (lis.EVENT_TYPE == '1'){
                        initializeEvent1(lis);
                    }
                    // 2| Accredito punti loyalty in modalità NFC/TOTP - 3| Pagamento servizio tramite App (Esecuzione rifornimento e pagamento con APP)
                    if (lis.EVENT_TYPE == '2' || lis.EVENT_TYPE == '3'){

                        initializeEvent3(lis, ws);
                    }
                    // 4| Associazione Carta di Pagamento
                    // evento = cliente che associa una carta di pagamento
                    // in un momento successivo all'iscrizione (il cliente già esiste quindi,
                    // va ad updatare le info della carta di pagamento sul Contact)
                    if (lis.EVENT_TYPE == '4'){
                        initializeEvent4(lis, ws);
                    }
                    // 5| Associazione Carta Loyalty
                    //EN: solo per clienti senza Partita IVA
                    //commentato per dismissione loyalty_card 24/02/23
                    /*
                    if (lis.EVENT_TYPE == '5'){
                        initializeEvent5(lis, ws);
                    }
                    */
                    //EN
                    // 6| Iscrizione cliente Partita IVA
                    //11-03-2021 rimosso per modifiche App Unica
                    /*if(lis.EVENT_TYPE=='6' && lis.TIPOLOGIA_UTENTE == '1'){

                     Contact con = new Contact(Fiscal_code__c = lis.CODICE_FISCALE, APP_created_date__c = lis.DATA,
                     FirstName = lis.NOME, LastName = lis.COGNOME, Email = lis.INDIRIZZO_EMAIL,
                     Birthdate = lis.DATA_DI_NASCITA, Push_Notification__c = lis.FG_NOTIFICA,
                     Credit_Card_Type__c = lis.CARTA, Cluster__c = lis.CLUSTER,
                     Flag_Privacy_ENI__c = lis.FLG_PRIVACY1, Flag_Privacy_Analysis__c = lis.FLG_PRIVACY1,
                     Flag_Privacy_Partner__c = lis.FLG_PRIVACY2, MobilePhone = lis.TEL_MOBILE, Phone = lis.TEL_MOBILE,
                     Enabled__c = true,Contact_code__c = lis.CODICE_FISCALE + '_' + lis.PARTITA_IVA,
                     //11-03-2021 rimosso per modifiche App Unica
                     //Customer_type__c = lis.TIPOLOGIA_UTENTE ,
                     //EN : attributi fatturazione
                     Business_Name__c = lis.RAGIONE_SOCIALE,
                     Billing_Address__c = lis.INDIRIZZO_FATTURAZIONE, Billing_Street_Number__c = lis.CIVICO_FATTURAZIONE,
                     Billing_City__c = lis.CITTA_FATTURAZIONE, Billing_Region__c = lis.PROVINCIA_FATTURAZIONE,
                     Billing_Country__c = lis.NAZIONE_FATTURAZIONE, Billing_Postal_Code__c = lis.CAP_FATTURAZIONE,
                     Billing_First_Name__c = lis.NOME_FATTURAZIONE, Billing_Last_Name__c = lis.COGNOME_FATTURAZIONE,
                     PEC_Email__c = lis.PEC_EMAIL, SDI_Code__c = lis.SDI_CODE, VAT_Number__c = lis.PARTITA_IVA,
                     Billing_Fiscal_Code__c = lis.CODICE_FISCALE_FATTURAZIONE,
                     Gender__c = lis.SESSO,
                     //RET20015 Nuova Loyalty ENICCM-146
                     Birth_City__c = lis.COMUNE_NASCITA,
                     Birth_Region__c = lis.PROVINCIA_NASCITA
                     );


                     if(!String.isEmpty(lis.CARTA)) {
                     con.Card_Association_Date__c = Date.valueOf(lis.DATA);
                     con.Credit_card_association__c = lis.FG_1;
                     }

                     if(!eventPIVAContacts.containsKey(capitalizedFC) && !existingContacts.containsKey(capitalizedFC) ){
                     eventPIVAContacts.put(capitalizedFC,con);
                     successPIVAMap.put(capitalizedFC,lis.EVENT_ID);
                     }
                     }
                     */
                    //EN
                    // 7| Modifica dati Cliente (ex Aggiornamento cliente Partita IVA) Consumer e Business
                    if (lis.EVENT_TYPE == '7'){
                        initializeEvent7(lis, ws);
                    }

                    // 8| Cancellazione Cliente
                    if (lis.EVENT_TYPE == '8'){
                        initializeEvent8(lis, ws);
                    }

                    // 9| Blocco Cliente (gestione Blacklist)
                    if (lis.EVENT_TYPE == '9'){
                        initializeEvent9(lis, ws);
                    }

                    // 10| Partecipazione Lotteria Periodica
                    if (lis.EVENT_TYPE == '10'){
                        initializeEvent10(lis, ws);
                    }

                    // 11| Pre-registrazione Lead da gestore
                    if (lis.EVENT_TYPE == '11'){
                        Set<String> checkReqFields = ENL_APC_WsInteractHelper.getMissingFieldEvent11(lis);
                        if (checkReqFields.size() > 0){
                            // requiredFields.addAll(ENL_APC_WsInteractHelper.getMissingFieldEvent11(lis));
                            requiredFields.put(lis.EVENT_ID, checkReqFields);
                        }
                        if (checkReqFields.isEmpty()){
                            initializeEvent11(lis);
                        }
                    }

                    // 12| registrazione Lead
                    if (lis.EVENT_TYPE == '12'){
                        Set<String> checkReqFields12 = ENL_APC_WsInteractHelper.getMissingFieldEvent12(lis);
                        // requiredFieldsEvent12.addAll(ENL_APC_WsInteractHelper.getMissingFieldEvent12(lis));
                        if (checkReqFields12.size() > 0){
                            requiredFieldsEvent12.put(lis.EVENT_ID, checkReqFields12);
                        }

                        if (checkReqFields12.isEmpty()){
                            initializeEvent12(lis);
                        }
                    }

                    if (lis.EVENT_TYPE == '13' && lis.TIPOLOGIA_UTENTE == '0'){
                        initializeEvent13(lis);
                    }
                    if (lis.EVENT_TYPE == '14'){
                        initializeEvent14(lis, ws);
                    }
                    if (lis.EVENT_TYPE == '15' && lis.TIPOLOGIA_UTENTE == '1'){
                        initializeEvent15(lis);
                    }
                    if (lis.EVENT_TYPE == '16'){
                        initializeEvent16(lis, ws);
                    }
                    if (lis.EVENT_TYPE == '17'){
                        initializeEvent17(lis, ws);    //EVENTO 17 ANCORA DA TERMINARE
                    }

                    //gestione lead di wifi fastweb caffè
                    if (lis.EVENT_TYPE == '18'){
                        Set<String> checkReqFields18 = ENL_APC_WsInteractHelper.getMissingFieldEvent18(lis);
                        if (checkReqFields18.size() > 0)
                            requiredFieldsEvent18.put(lis.EVENT_ID, checkReqFields18);
                        if (checkReqFields18.isEmpty()){
                            initializeEvent18(lis);
                        }
                    }

                    if (lis.EVENT_TYPE == '19'){
                        initializeEvent19(lis, ws);
                    }

                } else{
                    Result_NotifyEvent result = new Result_NotifyEvent();

                    result.SUCCESS = false;
                    result.ERRORCODE = '';
                    result.MESSAGE = 'Mandatory field [EVENT_TYPE] missing or incorrect';
                    result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD

                    ws.Result_NotifyEvent.add(result);
                    Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Tipo evento non valido o insesistente', 'Mandatory field [EVENT_TYPE] missing or incorrect', String.valueOf(result), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE,/*commentato per dismissione loyalty_card 24/02/23 numCartaLoyalty*/ '', lis.PRODOTTO, lis.LITRI, lis.IMPORTO, lis.PUNTI, lis.MODALITA_OPERATIVA, lis.PARTITA_IVA, fromObjectToString(lis.TARGHE), null, lis.CARTA);
                    logs.add(l);
                }

                /*   }else{
                 Result_NotifyEvent result = new Result_NotifyEvent();

                 result.SUCCESS = false;
                 result.ERRORCODE = '';
                 result.MESSAGE = 'Mandatory field [CODICE_FISCALE] missing';
                 result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD

                 ws.Result_NotifyEvent.add(result);
                 Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Codice Fiscale assente',
                 'Mandatory field [CODICE_FISCALE] missing', String.valueOf(result) , lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE, numCartaLoyalty, lis.PRODOTTO,
                 lis.LITRI, lis.IMPORTO, lis.PUNTI, lis.MODALITA_OPERATIVA, lis.PARTITA_IVA, fromObjectToString(lis.TARGHE), null, lis.CARTA);
                 logs.add(l);

                 }*/

            }

            //logiche di inserimento di contact ed eventuali offerte + voucher
            // List<Customer_Offer__c> offers = new List<Customer_Offer__c>();
            // List<Request_Voucher__c> vouchers = new List<Request_Voucher__c>();
            // Map<Id, String> offersMap = new Map<Id, String>();
            // Map<Id, String> voucherOffersMap = new Map<Id, String>();
            //List<Loyalty_card__c> loyaltyCards = new List<Loyalty_card__c>();

            //event type 1 contacts upsert contatti e generazione offerta welcome più eventuale voucher mastercard
            //Map<Id, String> fiscalCodesForET1 = new Map<Id, String>();
            executeEvent1(ws, f);
            //other contacts generated in events 2,3,5
            //aggiornamento contatti da evento 3 e inserimento transaction
            //Database.upsert(otherContacts.values(), f, true);
            executeEvent3(ws, f);
            //event type 4 contacts upsert contatti e generazione offerta welcome più eventuale voucher mastercard
            //Vouchers list and Offer list for Event type == 4
            //List<Request_Voucher__c> event4Vouchers = new List<Request_Voucher__c>();
            //List<Customer_Offer__c> event4Offers = new List<Customer_Offer__c>();
            //event4VoucherOffersMap, event4OffersMap  for Event type == 4
            //Map<Id, String> event4VoucherOffersMap = new Map<Id, String>();
            executeEvent4(ws, f);
            /* 15-03-2021 rimosso evento 6 per modifiche App Unica
             // EN:  Event 6
             for(Database.UpsertResult upr :Database.upsert(eventPIVAContacts.values(), f, false)) {
             Result_NotifyEvent result = new Result_NotifyEvent();
             if(upr.isSuccess()){
             result.SUCCESS = true;
             result.ERRORCODE = '';
             result.MESSAGE = '';
             result.CONTACT_KEY = upr.getId();//salesforce id of the created contact
             result.FISCALCODE = eventPIVAContacts.values().get(i).Fiscal_code__c.toUpperCase(); //codice fiscale del contatto creato
             //result.TIPOLOGIA_UTENTE = '1'; // EN: restituzione della tipologia Utente
             result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
             result.REQUESTID = successPIVAMap.get(eventPIVAContacts.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

             ws.Result_NotifyEvent.add(result);

             } else {
             result.SUCCESS = false;
             result.ERRORCODE = 'Upsert failed';
             result.MESSAGE = String.valueOf(upr.getErrors());
             result.REQUESTID = successPIVAMap.get(eventPIVAContacts.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

             ws.Result_NotifyEvent.add(result);
             Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore inserimento contatto P.IVA',
             'Errore: ' + upr.getErrors(), String.valueOf(result) , successPIVAMap.get(eventPIVAContacts.values().get(i).Fiscal_code__c.toUpperCase()),'',null);
             logs.add(l);
             system.debug(upr.getErrors());
             }
             i++;
             }
             */
            // Event 7
            // aggiornamento dati anagrafica Contact
            executeEvent7(ws);
            // Event 8
            //Deletion on CRM SFDC
            executeEvent8(ws, res);
            // Event 9
            //Blacklist on CRM SFDC
            executeEvent9(ws);
            // Event 10
            // Partecipazione Lotteria Periodica
            executeEvent10(ws);

            //event nuova registrazione
            executeEvent11(ws, f);

            //event registrazione nuova lead
            executeEvent12(ws, f);

            //event iscrizione nuovo cliente old testApp
            executeEvent13(ws, f);

            //event transazione old testApp
            executeEvent14(ws, f);

            //event iscrizione cliente business old testApp
            executeEvent15(ws, f);

            //event modifica dati cliente old testApp
            executeEvent16(ws, f);

            //event tariffa integrata
            executeEvent17(ws, f);

            //event creazione/modifica lead per wifi fastweb caffè
            executeEvent18(ws, f);


            // event promo emporium
            executeEvent19(ws, f);

            /**
             * @author: Giuseppe Naro
             * @description : modficiato il metodo e la posizione del metodo per l'invio delle customer Offer di iscrizione
             * @data: 01/07/2021
             */
            //Chiamata alla callout per la creazione e l'invio delle customer offer di iscrizione
            try{
                if (!contactToCreateCustomerOffer.isEmpty()){
                    // G.N. 30/10/2022 rimosso per disattivazione offerta
                    //ENL_APC_WsInteractHelper.startBatchToCreateCustomerOffer(contactToCreateCustomerOffer);
                }
                
               if(Test.isRunningTest()){
                    throw new ECU_APC_CustomException('error'); 
                }  
            } catch (Exception e){

                system.debug('Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber());
                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Execution failed', 'Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber(), '', '', '', null);
                logs.add(l);

            }


            Utils.generateLogs(logs, Utils.INFO_CODE);

            return ws;

            //Event 4 offers and Vouchers
            //offerVoucherForWS_ENIInetract(event4Vouchers, event4Offers, event4VoucherOffersMap, logs, ws, null, null);

            //insertion of offers, vouchers and loyalty cards
            //i = 0;

            //GC TEMPORARY TO DELETE
            // if (vouchers != null && vouchers.size() > 0)
            //     logs.add(new Log('INFO', 'WS_ENIInteract.NotifyEvent-vouchers', 'vouchers',
            //                  '', String.valueOf(vouchers), '', '', null));
            // if (offers != null && offers.size() > 0)
            //     logs.add(new Log('INFO', 'WS_ENIInteract.NotifyEvent-offers', 'offers',
            //                  '', String.valueOf(offers), '', '', null));
            //GC

            //offerVoucherForWS_ENIInetract(vouchers,offers, voucherOffersMap, logs, ws, fiscalCodesForET1, offersMap);
            //List<Database.SaveResult> voucherResults = Database.insert(vouchers, false);

            //Map<Id, Request_Voucher__c> vouchersMap = new Map<Id, Request_Voucher__c>(vouchers);
            //for (Customer_Offer__c coff : offers) {
            //    for (Database.SaveResult vou : voucherResults) {
            //        if(vou.isSuccess()
            //            && String.isNotBlank(vouchersMap.get(vou.getId()).Contact_code__c)
            //            && String.isNotBlank(coff.Contact_code__c)
            //                && vouchersMap.get(vou.getId()).Contact_code__c == coff.Contact_code__c
            //            && String.isNotBlank(vouchersMap.get(vou.getId()).Offer_code__c)
            //            && String.isNotBlank(coff.Offer_code__c)
            //                && vouchersMap.get(vou.getId()).Offer_code__c == coff.Offer_code__c) {
            //        coff.Request_Voucher__c = vou.getId();
            //        }
            //    }
            //}

            //List<Database.SaveResult> offerResults = Database.insert(offers, false);

            //for(Database.SaveResult off :offerResults) {
            //    if(off.isSuccess()) {

            //        //system.debug('offercode: ' + offers.get(i).Offer_code__c + ' utils offercode: ' + Utils__c.getOrgdefaults().MastercardOfferId__c);
            //        if(voucherOffersMap.containsKey(offers.get(i).Contact_code__c) &&
            //            (offers.get(i).Offer_code__c == Utils__c.getOrgdefaults().MastercardOfferId__c ||
            //             offers.get(i).Offer_code__c == Utils__c.getOrgdefaults().MastercardOfferId2__c)) {

            //            Integer j = 0;
            //            for(Database.SaveResult vou :voucherResults) {
            //                if(vou.isSuccess() && offers.get(i).Contact_code__c == vouchers.get(j).Contact_code__c){
            //                    Result_NotifyEvent result = new Result_NotifyEvent();

            //                    result.SUCCESS = true;
            //                    result.ERRORCODE = '';
            //                    result.MESSAGE = '';
            //                    result.OPERATION_ID = vouchers.get(j).Operation_ID__c;
            //                    result.FISCALCODE = vouchers.get(j).Fiscal_code__c;
            //                    result.PROMO_CODE = vouchers.get(j).Voucher_code__c;//'MAS2';//???GC 03/04/2019 deve essere recuperato dalla offer corrispondente o dal voucher
            //                    result.VOUCHER_AMOUNT = vouchers.get(j).Voucher_amount__c;//5.0;//???GC 03/04/2019
            //                    result.REQUESTID = voucherOffersMap.get(offers.get(i).Contact_code__c);// SAME VALUE OF EVENT_ID FIELD
            //                    result.CONTACT_KEY = offers.get(i).Contact_code__c;

            //                    ws.Result_NotifyEvent.add(result);

            //                    //GC TEMP TO DELETE
            //                Log l = new Log('INFO','WS_ENIInteract.NotifyEvent', 'Result per req voucher ProcessEvent',
            //                                    '' , String.valueOf(result), '');
            //                logs.add(l);
            //                    //

            //                    break;
            //                }else{
            //                    Result_NotifyEvent result = new Result_NotifyEvent();

            //                    result.SUCCESS = false;
            //                    result.ERRORCODE = 'Insert error';
            //                    result.MESSAGE = 'The mastercard Request Voucher was non created';
            //                    result.REQUESTID = voucherOffersMap.get(offers.get(i).Contact_code__c);// SAME VALUE OF EVENT_ID FIELD

            //                    ws.Result_NotifyEvent.add(result);
            //                    Log l = new Log('ERROR','WS_ENIInteract.NotifyEvent', 'Errore di creazione del request voucher',
            //                                    'The mastercard Request Voucher was non created' , String.valueOf(result), voucherOffersMap.get(offers.get(i).Contact_code__c));
            //                    logs.add(l);

            //                    break;
            //                }

            //                j++;
            //            }
            //        }
            //        if(offersMap.containsKey(offers.get(i).Contact_code__c) && !voucherOffersMap.containsKey(offers.get(i).Contact_code__c)) {
            //            Result_NotifyEvent result = new Result_NotifyEvent();

            //            result.SUCCESS = true;
            //            result.ERRORCODE = '';
            //            result.MESSAGE = '';
            //            result.REQUESTID = offersMap.get(offers.get(i).Contact_code__c);// SAME VALUE OF EVENT_ID FIELD
            //            result.CONTACT_KEY = offers.get(i).Contact_code__c;//salesforce id of the created contact
            //            result.FISCALCODE = fiscalCodesForET1.get(offers.get(i).Contact_code__c); //codice fiscale del contatto creato
            //                Datetime now = Datetime.now();
            //                Integer offset = UserInfo.getTimezone().getOffset(now);
            //                Datetime local = now.addSeconds(offset/1000);
            //            result.OPERATION_ID = String.valueOf(local.getTime());

            //            ws.Result_NotifyEvent.add(result);
            //        }
            //    }

            //    i++;
            //}

            //event type 5
            //18-03-2021  rimosso mdofiche App Unica
            /*
             List<Database.UpsertResult> loyaltyCardResults = Database.upsert(loyaltyCards, c, false);
             i = 0;
             for(Database.UpsertResult loy :loyaltyCardResults) {
             if(!(loyaltyCardsMap.get(loyaltyCards.get(i).Contact__c) == null)){
             if(loy.isSuccess()) {
             Result_NotifyEvent result = new Result_NotifyEvent();

             result.SUCCESS = true;
             result.ERRORCODE = '';
             result.MESSAGE = '';
             result.REQUESTID = loyaltyCardsMap.get(loyaltyCards.get(i).Contact__c);// SAME VALUE OF EVENT_ID FIELD

             ws.Result_NotifyEvent.add(result);
             }else{
             Result_NotifyEvent result = new Result_NotifyEvent();

             result.SUCCESS = false;
             result.ERRORCODE = 'Upsert failed';
             result.MESSAGE = String.valueOf(loy.getErrors());
             result.REQUESTID = loyaltyCardsMap.get(loyaltyCards.get(i).Contact__c);// SAME VALUE OF EVENT_ID FIELD

             ws.Result_NotifyEvent.add(result);
             Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore di inserimento loyalty card',
             'Errore: ' + loy.getErrors() , String.valueOf(result), loyaltyCardsMap.get(loyaltyCards.get(i).Contact__c),'',null);
             logs.add(l);
             }
             }
             i++;
             }
             */
                

        } catch (Exception e){
            //Database.rollback(sp);

            system.debug('Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber());
            Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Execution failed', 'Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber(), '', '', '', null);
            logs.add(l);

            Utils.generateLogs(logs, Utils.EXCEPTION_CODE);

            WS_ENIInteract.Response_NotifyEvent ws = new WS_ENIInteract.Response_NotifyEvent();
            ws.Result_NotifyEvent = new List<Result_NotifyEvent>();
            ws.header = res.header;

            for (Request_NotifyEvent lis : res.request){

                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = false;
                result.ERRORCODE = 'System Exception';
                result.MESSAGE = '';
                result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
            }

            return ws;
        }
    }

    webservice static Response_GetOffers GetOffers(WS_ENIInteract.Wrapper_Request_GetOffers res){
        /*WS_ENIInteract.Response_GetOffers ws = new WS_ENIInteract.Response_GetOffers();
         ws.Result_GetOffers = new List<Result_GetOffers>();
         //List<Log> logs = new List<Log>();
         for (WS_ENIInteract.Request_GetOffers lis : res.request) {
         //Log l = new Log('INFO','WS_ENIInteract.Response_GetOffers', 'Execution succesfull', '--', String.valueOf(ws));

         Result_GetOffers result = new Result_GetOffers();
         ws.header = res.header;

         result.OFFER_CODE = 'Ds+';
         result.NOME = 'Diesel+';
         result.BANNER_ID = 'Id Banner';
         result.DATA_INIZIO = Datetime.now();
         result.DATA_FINE = Datetime.now().addDays(7);
         result.DESCRIZIONE = 'Descrizione offerta';
         result.TIPO_OFFERTA = 'Tipo Offerta';
         result.CANALE = 'Canale Offerta';
         result.TIPO_MISSIONE = 'Promozione';
         result.NUM_EXECUTED_STEPS = 5;
         result.NUM_TOT_STEPS = 10;
         result.URL = 'www.exampleurl.com';
         result.PARAMETER1 = 'Parameter 1';
         result.PARAMETER2 = 'Parameter 2';
         result.PARAMETER3 = 'Parameter 3';
         result.PARAMETER4 = 0.0;

         system.debug(lis);
         ws.Result_GetOffers.add(result);
         //logs.add(l);
         }

         //Utils.generateLogs(logs);

         return ws;*/
        return null;
    }

    webservice static Response_GetPromotions GetPromotions(WS_ENIInteract.Wrapper_Request_GetPromotions res){
        /*WS_ENIInteract.Response_GetPromotions ws = new WS_ENIInteract.Response_GetPromotions();
         ws.Result_GetPromotions = new List<Result_GetPromotions>();
         //List<Log> logs = new List<Log>();
         for (WS_ENIInteract.Request_GetPromotions lis : res.request) {
         //Log l = new Log('INFO','WS_ENIInteract.Response_GetPromotions', 'Execution succesfull', '--', String.valueOf(ws));

         Result_GetPromotions result = new Result_GetPromotions();
         ws.header = res.header;

         result.OFFER_CODE = 'Ds+';
         result.NOME = 'Diesel+';
         result.BANNER_ID = 'Id Banner';
         result.DATA_INIZIO = Datetime.now();
         result.DATA_FINE = Datetime.now().addDays(7);
         result.URL = 'www.exampleurl.com';
         result.PARAMETER1 = 'Parameter 1';
         result.PARAMETER2 = 'Parameter 2';
         result.PARAMETER3 = 'Parameter 3';
         result.PARAMETER4 = 0.0;
         //EN: discriminazione in base alla tipologia di utente
         result.TIPOLOGIA_UTENTE = 'Tipologia utente';

         system.debug(lis);
         ws.Result_GetPromotions.add(result);
         //logs.add(l);
         }

         //Utils.generateLogs(logs);

         return ws;*/
        return null;
    }

    //EN: funzione che estrae le transazioni esistenti
    @TestVisible
    public static Map<String, Transaction__c> queryExistingTransactions(List<WS_ENIInteract.Request_NotifyEvent> req){
        Map<String, Transaction__c> resMap = new Map<String, Transaction__c>();
        Set<String> eventIds = new Set<String>();

        for (WS_ENIInteract.Request_NotifyEvent lis : req){
            if ((new Set<String>{ '1', '2', '3', '4', '5', '17', '19' }).contains(lis.EVENT_TYPE) && !String.isEmpty(lis.EVENT_ID)){
                eventIds.add(lis.EVENT_ID);
            }
        }

        for (Transaction__c trans : [SELECT Id, Transaction_Id__c
                                     FROM Transaction__c
                                     WHERE Transaction_Id__c IN:eventIds]){
            resMap.put(trans.Transaction_Id__c, trans);
        }

        return resMap;
    }

    @TestVisible
    public static Map<String, Transaction__c> queryExistingTransactionsOld(List<WS_ENIInteract.Request_NotifyEvent> req){
        Map<String, Transaction__c> resMap = new Map<String, Transaction__c>();
        Set<String> eventIds = new Set<String>();

        for (WS_ENIInteract.Request_NotifyEvent lis : req){
            if ((new Set<String>{ '13', '14' }).contains(lis.EVENT_TYPE) && !String.isEmpty(lis.EVENT_ID)){
                eventIds.add(lis.EVENT_ID);
            }
        }
        system.debug(' transactions Old ' + eventIds);
        for (Transaction__c trans : [SELECT Id, Transaction_Id__c
                                     FROM Transaction__c
                                     WHERE Transaction_Id__c IN:eventIds]){
            resMap.put(trans.Transaction_Id__c, trans);
        }

        return resMap;
    }

    //function that extracts existing contacts from the Database
    @TestVisible
    public static Map<String, Contact> queryExistingContacts(List<WS_ENIInteract.Request_NotifyEvent> req){
        Map<String, Contact> resMap = new Map<String, Contact>();
        Set<String> fiscalCodes = new Set<String>();
        Id recordTypeCustomer = Utils.getRecordTypeId('Customer', 'Contact');
        Id recordTypeBusiness = Utils.getRecordTypeId('Business', 'Contact');
        Id recordTypeLead = Utils.getRecordTypeId('ENL_Lead_Gestore', 'Contact');


        for (WS_ENIInteract.Request_NotifyEvent lis : req){
            if ((new Set<String>{ '1', '2', '3', '4', '5', '7', '8', '9', '12', '17', '19' }).contains(lis.EVENT_TYPE) && !String.isEmpty(lis.CODICE_FISCALE)){
                fiscalCodes.add(lis.CODICE_FISCALE.toUpperCase());
            }
        }
        //20190429 AN
        //APP_loyalty_customer__c <> '0' //filtro per estrarre da Database solo i contatti che hanno eseguito l'accesso da app
        for (Contact con : [SELECT Id, RecordTypeId, Fiscal_code__c, Contact_code__c, ENL_Tipo_Multicard_1__c, ENL_Data_Inserimento_Multicard_1__c, ENL_Tipo_Multicard_2__c, ENL_Data_Inserimento_Multicard_2__c, Mastercard_voucher_recieved__c, FirstName, LastName, APP_created_date__c, MobilePhone, Email, Credit_Card_Type__c, Flag_Loyalty__c, Flag_Entry_Offer__c, Customer_type__c, Flag_Privacy_ENI__c, Flag_Privacy_Partner__c, MailingStreet, MailingPostalCode, MailingCity, MailingState, Cluster__c, Push_notification__c, Business_Name__c, isConsumer__c, Flag_Entry_Gift__c, Flag_Multi_Easy__c, Billing_Address__c, Billing_Street_Number__c, Billing_City__c, Billing_Region__c, Billing_Country__c, Billing_Postal_Code__c, Billing_First_Name__c, Billing_Last_Name__c, PEC_Email__c, SDI_Code__c, VAT_Number__c, Billing_Fiscal_Code__c, Cancellation_Date__c, Cancellation_Request_Origin__c, Cancellation_Type__c
                            FROM Contact
                            WHERE Fiscal_code__c IN:fiscalCodes AND isConsumer__c = true AND (RecordTypeId = :recordTypeCustomer OR RecordTypeId = :recordTypeBusiness OR RecordTypeId = :recordTypeLead)]){
            resMap.put(con.Fiscal_code__c.toUpperCase(), con);
        }

        return resMap;
    }

    //metodo TestApp
    @TestVisible
    public static Map<String, Contact> queryExistingContactsOld(List<WS_ENIInteract.Request_NotifyEvent> req){
        Map<String, Contact> resMap = new Map<String, Contact>();
        Set<String> fiscalCodes = new Set<String>();
        Id recordTypeCustomer = Utils.getRecordTypeId('Customer', 'Contact');
        Id recordTypeBusiness = Utils.getRecordTypeId('Business', 'Contact');
        Id recordTypeLead = Utils.getRecordTypeId('ENL_Lead_Gestore', 'Contact');

        for (WS_ENIInteract.Request_NotifyEvent lis : req){
            if ((new Set<String>{ '13', '14', '15', '16' }).contains(lis.EVENT_TYPE) && !String.isEmpty(lis.CODICE_FISCALE)){
                fiscalCodes.add(lis.CODICE_FISCALE.toUpperCase());
            }
        }
        //20190429 AN
        //APP_loyalty_customer__c <> '0' //filtro per estrarre da Database solo i contatti che hanno eseguito l'accesso da app
        for (Contact con : [SELECT Id, RecordTypeId, Fiscal_code__c, Contact_code__c, Mastercard_voucher_recieved__c, FirstName, LastName, APP_created_date__c, MobilePhone, Email, Credit_Card_Type__c, Customer_type__c, Flag_Privacy_ENI__c, Flag_Privacy_Partner__c, Flag_Entry_Gift__c, Cluster__c, Push_notification__c, Business_Name__c, Flag_Entry_Offer__c, Flag_Multi_Easy__c, Billing_Address__c, Billing_Street_Number__c, Billing_City__c, Billing_Region__c, Billing_Country__c, Billing_Postal_Code__c, Billing_First_Name__c, Billing_Last_Name__c, PEC_Email__c, SDI_Code__c, VAT_Number__c, Billing_Fiscal_Code__c, Cancellation_Date__c, Cancellation_Request_Origin__c, Cancellation_Type__c
                            FROM Contact
                            WHERE Fiscal_code__c IN:fiscalCodes AND ( NOT Contact_code__c LIKE '%_OLD') AND (RecordTypeId = :recordTypeCustomer OR RecordTypeId = :recordTypeBusiness OR RecordTypeId = :recordTypeLead)]){
            resMap.put(con.Fiscal_code__c.toUpperCase() + '_' + con.RecordTypeId, con);
        }

        return resMap;
    }

    //commentato per dismissione loyalty_card 24/02/23
    //function that extracts existing loyalty cards
    /*
    @TestVisible
    private static Map<String, Loyalty_card__c> queryExistingCards(List<WS_ENIInteract.Request_NotifyEvent> req){
        Map<String, Loyalty_card__c> resMap = new Map<String, Loyalty_card__c>();
        Set<String> cardNumbers = new Set<String>();
        Map<String, Loyalty_card__c> newLoyCards = new Map<String, Loyalty_card__c>();
        Id recordTypeCustomer = Utils.getRecordTypeId('Customer', 'Contact');
        Id recordTypeBusiness = Utils.getRecordTypeId('Business', 'Contact');
        Id recordTypeLead = Utils.getRecordTypeId('ENL_Lead_Gestore', 'Contact');

        for (WS_ENIInteract.Request_NotifyEvent lis : req){
            if ((new Set<String>{ '2', '3', '5', '19' }).contains(lis.EVENT_TYPE)){
                if (lis.EVENT_TYPE != '5' && (String.isEmpty(lis.NUM_CARTA_LOYALTY) || lis.NUM_CARTA_LOYALTY == null)){
                    //Nuova valorizzazione loyalty card modifiche app unica
                    if (lis.EVENT_TYPE == '3'){
                        if (lis.MODALITA_PAGAMENTO == '2' && (lis.PARTITA_IVA != null && !String.isEmpty(lis.PARTITA_IVA))){
                            cardNumbers.add(lis.CODICE_FISCALE.toUpperCase() + '_BUSINESS');
                            newLoyCards.put(lis.CODICE_FISCALE.toUpperCase(), new Loyalty_Card__c(Name = lis.CODICE_FISCALE.toUpperCase() + '_BUSINESS', Card_code__c = lis.CODICE_FISCALE.toUpperCase() + '_BUSINESS', RecordtypeId = Utils__c.getOrgdefaults().WithoutCardId__c));
                        } else if (lis.MODALITA_PAGAMENTO == '1' || lis.MODALITA_PAGAMENTO == '6' || lis.MODALITA_PAGAMENTO == '7'){
                            cardNumbers.add(lis.CODICE_FISCALE.toUpperCase() + '_MULTICARDBUSINESS');
                            newLoyCards.put(lis.CODICE_FISCALE.toUpperCase(), new Loyalty_Card__c(Name = lis.CODICE_FISCALE.toUpperCase() + '_MULTICARDBUSINESS', Card_code__c = lis.CODICE_FISCALE.toUpperCase() + '_MULTICARDBUSINESS', RecordtypeId = Utils__c.getOrgdefaults().WithoutCardId__c));
                        } else if (lis.MODALITA_PAGAMENTO == '5'){
                            cardNumbers.add(lis.CODICE_FISCALE.toUpperCase() + '_MULTICARDENIPEOPLE');
                            newLoyCards.put(lis.CODICE_FISCALE.toUpperCase(), new Loyalty_Card__c(Name = lis.CODICE_FISCALE.toUpperCase() + '_MULTICARDENIPEOPLE', Card_code__c = lis.CODICE_FISCALE.toUpperCase() + '_MULTICARDENIPEOPLE', RecordtypeId = Utils__c.getOrgdefaults().WithoutCardId__c));
                        } else{
                            cardNumbers.add(lis.CODICE_FISCALE.toUpperCase() + '_CONSUMER');
                            newLoyCards.put(lis.CODICE_FISCALE.toUpperCase(), new Loyalty_Card__c(Name = lis.CODICE_FISCALE.toUpperCase() + '_CONSUMER', Card_code__c = lis.CODICE_FISCALE.toUpperCase() + '_CONSUMER', RecordtypeId = Utils__c.getOrgdefaults().WithoutCardId__c));
                        }
                    }
                    //cardNumbers.add(lis.CODICE_FISCALE.toUpperCase());
                } else{
                    cardNumbers.add(lis.NUM_CARTA_LOYALTY.toUpperCase().left(18));
                }
            }
        }
        system.debug('now cards code ' + cardNumbers);
        Set<String> newCardCodes = cardNumbers;

        for (Loyalty_card__c loy : [SELECT Card_code__c, Contact__r.Fiscal_code__c, Contact__c
                                    FROM Loyalty_card__c
                                    WHERE Card_code__c IN:cardNumbers]){
            if (cardNumbers.contains(loy.Card_code__c.toUpperCase())){
                newCardCodes.remove(loy.Card_code__c.toUpperCase());
                newLoyCards.remove(loy.Contact__r.Fiscal_code__c);
            }
            resMap.put(loy.Card_code__c.toUpperCase(), loy);
        }

        //inserts loyalty cards with without card record type for events 2 and 3 with empty loyalty card
        system.debug('new cards ' + newCardCodes);
        if (!newCardCodes.isEmpty()){
            //EN: mappa per evitare eventuali duplicati
            //Map<String,Loyalty_card__c> newLoyCards = new Map<String,Loyalty_card__c>();
            //20190429 AN
            //APP_loyalty_customer__c <> '0' //filtro per estrarre da Database solo i contatti che hanno eseguito l'accesso da app
            for (Contact con : [SELECT Id, Fiscal_code__c
                                FROM Contact
                                WHERE Fiscal_code__c IN:newLoyCards.keySet() AND isConsumer__c = true AND (RecordTypeId = :recordTypeCustomer OR RecordTypeId = :recordTypeBusiness OR RecordTypeId = :recordTypeLead)]){
                if (newLoyCards.containsKey(con.Fiscal_code__c)){
                    newLoyCards.get(con.Fiscal_code__c).Contact__c = con.Id;
                }
                // newLoyCards.put(con.Fiscal_code__c,new Loyalty_card__c(Name = con.Fiscal_code__c, Card_code__c = con.Fiscal_code__c,
                //                                     RecordtypeId = Utils__c.getOrgdefaults().WithoutCardId__c,
                //                                     Contact__c = con.Id));
            }
            //controllo se esistono carte senza contatto
            List<Loyalty_Card__c> loyCardsToInsert = new List<Loyalty_Card__c>();
            for (Loyalty_Card__c loy : newLoyCards.values()){
                if (loy.Contact__c != null)
                    loyCardsToInsert.add(loy);
            }
            try{
                Integer i = 0;
                for (Database.SaveResult ins : Database.insert (loyCardsToInsert)){
                    resMap.put(loyCardsToInsert.get(i).Card_code__c.toUpperCase(), loyCardsToInsert.get(i));
                    i++;
                    system.debug('Sono nel ciclo che inserisce i nuovi loyaltyCards ' + ins.getErrors());
                }
                if(Test.isRunningTest()){
                    throw new ECU_APC_CustomException('error'); 
                }  
                 if(Test.isRunningTest()){
                    throw new ECU_APC_CustomException('error'); 
                }  
            } catch (Exception e){
                //Database.rollback(sp);

                system.debug('Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber());
                Log l = new Log('ERROR', 'WS_ENIInteract.queryExistingCards', 'Execution failed', 'Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber(), '', '', '', null);
                logs.add(l);

            }
        }

        return resMap;
    }
    */

    //commentato per dismissione loyalty_card 24/02/23
    //metodo TestApp
    /*
    @TestVisible
    private static Map<String, Loyalty_card__c> queryExistingCardsOld(List<WS_ENIInteract.Request_NotifyEvent> req){
        Map<String, Loyalty_card__c> resMap = new Map<String, Loyalty_card__c>();
        Set<String> cardNumbers = new Set<String>();

        for (WS_ENIInteract.Request_NotifyEvent lis : req){
            if ((new Set<String>{ '14' }).contains(lis.EVENT_TYPE)){
                // if(lis.EVENT_TYPE != '5' && String.isEmpty(lis.NUM_CARTA_LOYALTY)) {
                cardNumbers.add(lis.CODICE_FISCALE.toUpperCase());
                // } else {
                //    cardNumbers.add(lis.NUM_CARTA_LOYALTY.toUpperCase().left(18));
                //}
            }
        }

        Set<String> newCardCodes = cardNumbers;

        for (Loyalty_card__c loy : [SELECT Card_code__c, Contact__r.Fiscal_code__c, Contact__c
                                    FROM Loyalty_card__c
                                    WHERE Card_code__c IN:cardNumbers]){
            if (cardNumbers.contains(loy.Card_code__c.toUpperCase())){
                newCardCodes.remove(loy.Card_code__c.toUpperCase());
            }
            resMap.put(loy.Card_code__c.toUpperCase(), loy);
        }

        //inserts loyalty cards with without card record type for events 2 and 3 with empty loyalty card
        system.debug('new cards ' + newCardCodes);
        if (!newCardCodes.isEmpty()){
            //EN: mappa per evitare eventuali duplicati
            Map<String, Loyalty_card__c> newLoyCards = new Map<String, Loyalty_card__c>();
            //20190429 AN
            //APP_loyalty_customer__c <> '0' //filtro per estrarre da Database solo i contatti che hanno eseguito l'accesso da app
            for (Contact con : [SELECT Id, Fiscal_code__c
                                FROM Contact
                                WHERE Fiscal_code__c IN:newCardCodes AND ( NOT Contact_code__c LIKE '%_OLD')]){
                newLoyCards.put(con.Fiscal_code__c, new Loyalty_card__c(Name = con.Fiscal_code__c, Card_code__c = con.Fiscal_code__c, RecordtypeId = Utils__c.getOrgdefaults().WithoutCardId__c, Contact__c = con.Id));
            }
            Integer i = 0;
            for (Database.SaveResult ins : Database.insert (newLoyCards.values())){
                resMap.put(newLoyCards.values().get(i).Card_code__c.toUpperCase(), newLoyCards.values().get(i));
                i++;
                system.debug('Sono nel ciclo che inserisce i nuovi loyaltyCards Old ' + ins.getErrors());
            }
        }

        return resMap;
    }
    */

    //function that extracts existing Accounts from the Database for anonymization
    @TestVisible
    public static List<Account> queryExistingAccountsToAnonymize(List<WS_ENIInteract.Request_NotifyEvent> req, Map<String, Contact> event8ContactsToUpdate){
        Set<String> fiscalCodes = new Set<String>();
        Map<Id, Contact> contactToAnonymize = new Map<Id, Contact>();
        Set<Id> accIdToUpdateSet = new Set<Id>();
        List<Account> resList = new List<Account>();

        //        Map<String, String> rtContactMap = new Map<String, String>{'0' => Utils.getRecordTypeId('Customer', 'Contact'),
        //                                                                     '1' => Utils.getRecordTypeId('Business', 'Contact') };

        // get Accounts to anonymization related to Contacts cancellation
        for (WS_ENIInteract.Request_NotifyEvent lis : req){
            if ((new Set<String>{ '8' }).contains(lis.EVENT_TYPE) && (!String.isEmpty(lis.CODICE_FISCALE) && lis.TIPOLOGIA_CANCELLAZIONE == '2')){
                if (event8ContactsToUpdate != NULL && event8ContactsToUpdate.size() > 0){
                    Contact currContact = event8ContactsToUpdate.get(lis.CODICE_FISCALE);
                    if (currContact != NULL)
                        contactToAnonymize.put(currContact.Id, currContact);
                }
            }
        }
        // get Contact from request (FISCAL_CODE), both TIPOLOGIA_UTENTE (Consumer, Business)
        for (Contact con : [SELECT Id, AccountId
                            FROM Contact
                            WHERE Id IN:contactToAnonymize.keySet()]){
            accIdToUpdateSet.add(con.AccountId);
        }
        // exclude Account with more than one Contact (I don't want to anonymize BSN Account with more than one Contact related)
        for (Account acc : [SELECT Id, (SELECT Id
                                        FROM Contacts), Name, Contact_code__c
                            FROM Account
                            WHERE Id IN:accIdToUpdateSet]){
            if (acc.Contacts.size() == 1)
                resList.add(acc);
        }

        /*if (accIdToUpdateSet.size() > 0) {
         resList = [SELECT Id, Name, Contact_code__c
         FROM Account WHERE Id IN :accIdToUpdateSet];
         }*/

        return resList;
    }

    //function that extracts existing Customer_Offer__c from the Database to set Lottery request of partecipation
    @TestVisible
    public static Map<String, Customer_Offer__c> queryExistingCustomerOffer4Lottery(List<WS_ENIInteract.Request_NotifyEvent> req){
        Set<String> cofferToUpdate = new Set<String>();
        Map<String, Customer_Offer__c> resList = new Map<String, Customer_Offer__c>();

        // get Customer_Offer__c ID to update
        for (WS_ENIInteract.Request_NotifyEvent lis : req){
            if ((new Set<String>{ '10' }).contains(lis.EVENT_TYPE) && !String.isEmpty(lis.OPERATION_ID)){
                cofferToUpdate.add(lis.OPERATION_ID);
            }
        }
        // get Customer_Offer__c to update
        for (Customer_Offer__c coff : [SELECT Id, Fiscal_Code__c, Customer_Type__c, ENL_Lottery_Timestamp_Tap__c, ENL_Lottery_Code__c, ENL_Operation_ID__c
                                       FROM Customer_Offer__c
                                       WHERE ENL_Operation_ID__c IN:cofferToUpdate]){
            resList.put(coff.ENL_Operation_ID__c, coff);
        }

        /*if (accIdToUpdateSet.size() > 0) {
         resList = [SELECT Id, Name, Contact_code__c
         FROM Account WHERE Id IN :accIdToUpdateSet];
         }*/

        return resList;
    }

    //metodo che recupera una transazione morosa gia esistente
    @TestVisible
    private static Map<String, Transaction__c> queryExistingTransactionMorosa(List<WS_ENIInteract.Request_NotifyEvent> req){
        Map<String, Transaction__c> resMap = new Map<String, Transaction__c>();
        Set<String> transactionCodes = new Set<String>();

        for (WS_ENIInteract.Request_NotifyEvent lis : req){
            if ((new Set<String>{ '3' }).contains(lis.EVENT_TYPE) && !String.isEmpty(lis.CODICE_TRANSAZIONE)){
                transactionCodes.add(lis.CODICE_TRANSAZIONE);
            }
        }

        for (Transaction__c trans : [SELECT Id, Name, Transaction_Id__c, Fiscal_code__c, Transaction_Date__c, Service_Station_Code__c, Product_Type__c, EniStation_APP_payment__c, Total_Points__c, Liters__c, Refueling_Mode__c, Amount__c, EVENT_TYPE__c, EniStation_App_Payment_Mode__c, Customer_Type__c, VAT_Number__c, Plate__c, Kwh__c, Time__c, Recarge_Type__c, ENL_Service_Type__c, ENL_Start_Date__c, ENL_End_Date__c, ENL_Transaction_Locked__c, ENL_Transaction_Code__c, ENL_Disabled_Service_Station__c, Transazione_Morosa__c, Related_transaction_id__c
                                     FROM Transaction__c
                                     WHERE ENL_Transaction_Code__c IN:transactionCodes AND Transazione_Morosa__c LIKE 'true']){
            resMap.put(trans.ENL_Transaction_Code__c, trans);
        }

        return resMap;
    }

    //metodo che recupera una transazione di tariffa integrata gia esistente
    @TestVisible
    private static Map<String, Transaction__c> queryExistingTransactionIntegrata(List<WS_ENIInteract.Request_NotifyEvent> req){
        Map<String, Transaction__c> resMap = new Map<String, Transaction__c>();
        Set<String> transactionCodes = new Set<String>();

        for (WS_ENIInteract.Request_NotifyEvent lis : req){
            if ((new Set<String>{ '3' }).contains(lis.EVENT_TYPE) && !String.isEmpty(lis.CODICE_TRANSAZIONE)){
                transactionCodes.add(lis.CODICE_TRANSAZIONE);
            }
        }

        for (Transaction__c trans : [SELECT Id, Name, Transaction_Id__c, Fiscal_code__c, Transaction_Date__c, Service_Station_Code__c, Product_Type__c, EniStation_APP_payment__c, Total_Points__c, Liters__c, Refueling_Mode__c, Amount__c, EVENT_TYPE__c, EniStation_App_Payment_Mode__c, Customer_Type__c, VAT_Number__c, Plate__c, Kwh__c, Time__c, Recarge_Type__c, ENL_Service_Type__c, ENL_Start_Date__c, ENL_End_Date__c, ENL_Transaction_Locked__c, ENL_Transaction_Code__c, ENL_Disabled_Service_Station__c, Transazione_Morosa__c, Related_transaction_id__c
                                     FROM Transaction__c
                                     WHERE ENL_Transaction_Code__c IN:transactionCodes AND EVENT_TYPE__c LIKE '17']){
            resMap.put(trans.ENL_Transaction_Code__c, trans);
        }

        return resMap;
    }

    //EN: funzione che estrae le transazioni relative ai prodotti
    @TestVisible
    public static Map<String, Transaction__c> queryExistingTransactionProdotti(List<WS_ENIInteract.Request_NotifyEvent> req){
        Map<String, Transaction__c> resMap = new Map<String, Transaction__c>();
        Set<String> transactionCodes = new Set<String>();

        for (WS_ENIInteract.Request_NotifyEvent lis : req){
            if ((new Set<String>{ '19' }).contains(lis.EVENT_TYPE) && !String.isEmpty(lis.CODICE_TRANSAZIONE)){
                transactionCodes.add(lis.CODICE_TRANSAZIONE);
            }
        }

        for (Transaction__c trans : [SELECT Id, Transaction_Id__c, ENL_Transaction_Code__c, Enl_Motivo_Storno__c, Enl_Orario_Effettivo__c, Enl_Transazione_Emporium__c
                                     FROM Transaction__c
                                     WHERE ENL_Transaction_Code__c IN:transactionCodes AND Enl_Motivo_Storno__c = '' AND Enl_Orario_Effettivo__c = null AND Enl_Transazione_Emporium__c = TRUE]){
            resMap.put(trans.ENL_Transaction_Code__c, trans);
        }

        return resMap;
    }

    //function that generates request voucher and customer offer for mastercard
    //@TestVisible private static Boolean generateMastercard(Request_Voucher__c voucher, Customer_Offer__c offer, Contact con) {
    //    try{
    //        //test if Contact has already received Mastercard voucher
    //        if (!con.Mastercard_voucher_recieved__c) {
    //            offer.Contact_code__c = con.Id;
    //            offer.Offer_code__c = Utils__c.getOrgdefaults().MastercardOfferId__c;
    //            offer.Name = con.FirstName + ' ' + con.LastName + ' MASTERCARD';
    //            offer.Start_date__c = con.APP_created_date__c;
    //            offer.End_date__c = con.APP_created_date__c.addDays(10);
    //            offer.Partial_step__c =1;
    //            Datetime now = Datetime.now();
    //            Integer offset = UserInfo.getTimezone().getOffset(now);
    //            Datetime local = now.addSeconds(offset/1000);
    //            String operationId = String.valueOf(local.getTime());
    //            voucher.Name = con.FirstName + ' ' + con.LastName + ' MASTERCARD';
    //            voucher.Type__c = 'Mastercard';
    //            voucher.Contact_code__c = con.Id;
    //            voucher.Operation_ID__c = operationId;
    //            voucher.First_name__c = con.FirstName;
    //            voucher.Last_name__c = con.LastName;
    //            voucher.Phone__c = con.MobilePhone;
    //            voucher.Email__c = con.Email;
    //            voucher.Fiscal_code__c = con.Fiscal_code__c;
    //            voucher.Voucher_amount__c = 5.00;
    //            voucher.Voucher_code__c = operationId;//??? GC 03/04/2019
    //            con.Mastercard_voucher_recieved__c = true;//GC VERIFICARE!!!
    //        } else {
    //            return false;
    //        }
    //    }catch(Exception e){
    //        system.debug('Error during the generation of voucher and offer for Mastercard. Error: ' + e.getMessage() +
    //                     ' #' + e.getLineNumber());
    //        return false;
    //    }
    //    return true;
    //}
/*
    private static Contact updateContactData(String eventType, String cluster, Boolean flgNotifica, Boolean flagPrivacy1, Boolean flagPrivacy2, Boolean fg1, Contact con){
        try{

            con.Push_Notification__c = flgNotifica;
            con.Flag_Privacy_ENI__c = flagPrivacy1;
            con.Flag_Privacy_Analysis__c = flagPrivacy1;
            con.Flag_Privacy_Partner__c = flagPrivacy2;
            con.Cluster__c = cluster;
            if (!eventType.equals('5'))
                con.Credit_card_association__c = fg1;
            
             if(Test.isRunningTest()){
                    throw new ECU_APC_CustomException('error'); 
                }  
        } catch (Exception e){
            system.debug('Error during update Contact data. Error: ' + e.getMessage() + 
                               ' #' + e.getLineNumber());
        }

        return con;
    }
*/

    public static String fromObjectToString(List<Targhe> targheStrings){

        String result = '';
        if (targheStrings != NULL && targheStrings.size() > 0){
            for (Targhe tr : targheStrings){
                result += tr.TARGA + ' : ' + tr.DESCRIZIONE_VEICOLO + '\n';
            }
            result = result.removeEnd('\n');
        }

        return result;
    }

    public static String fromObjectMulticardToString(List<MulticardWrap> multicardString){
        String result = '';
        if (multicardString != null && multicardString.size() > 0){
            for (MulticardWrap item : multicardString){
                result += item.MULTICARD + '\n';
            }
            result = result.removeEnd('\n');
        }
        return result;
    }

    public static String fromObjectMulticardToStringWithData(List<MulticardWrap> multicardString){
        String result = '';
        if (multicardString != null && multicardString.size() > 0){
            for (MulticardWrap item : multicardString){
                result += item.MULTICARD + ' | ' + item.DATA_INSERIMENTO_MULTICARD + '\n';
            }
            result = result.removeEnd('\n');
        }
        return result;
    }

    public static Boolean fromObjectToBoolean(List<AllPrivacy> allPrivacyStrings, String flag){

        String result = '';
        system.debug(' All Privacy  ' + allPrivacyStrings);
        if (allPrivacyStrings != NULL && allPrivacyStrings.size() > 0){
            for (AllPrivacy ap : allPrivacyStrings){
                if (ap.KEY == flag)
                    return ap.VALUE;
            }
        }

        return null;
    }

    public static PrivacyDetails fromObjectToPrivacyDetails(List<AllPrivacy> allPrivacyStrings, String flag){
        if (allPrivacyStrings != null){
            for (AllPrivacy item : allPrivacyStrings){
                if (item.KEY.equals(flag)){
                    PrivacyDetails privacyDet = new PrivacyDetails(item.SOURCE, item.DATECHANGE);
                    return privacyDet;
                }
            }
        }
        return null;
    }

    public static String fromObjectToPlate(List<Targhe> targheList){
        String result = '';
        if (targheList != null && targheList.size() > 0)
            result = targheList[0].TARGA;
        return result;
    }

    public static Void offerVoucherForWS_ENIInetract(List<Request_Voucher__c> vouchers, List<Customer_Offer__c> offers, Map<Id, String> voucherOffersMap, List<Log> logs, WS_ENIInteract.Response_NotifyEvent ws, Map<Id, String> fiscalCodesForET1, Map<Id, String> offersMap){
        /* 15-03-2021 rimosso metodo non più utilizzato  per la gestione voucher
         List<Database.SaveResult> voucherResults = Database.insert(vouchers, false);
         system.debug('voucherResults ' + voucherResults);

         Integer i = 0;
         Map<Id, Request_Voucher__c> vouchersMap = new Map<Id, Request_Voucher__c>(vouchers);
         for (Customer_Offer__c coff : offers) {
         for (Database.SaveResult vou : voucherResults) {
         if(vou.isSuccess()
         && String.isNotBlank(vouchersMap.get(vou.getId()).Contact_code__c)
         && String.isNotBlank(coff.Contact_code__c)
         && vouchersMap.get(vou.getId()).Contact_code__c == coff.Contact_code__c
         && String.isNotBlank(vouchersMap.get(vou.getId()).Offer_code__c)
         && String.isNotBlank(coff.Offer_code__c)
         && vouchersMap.get(vou.getId()).Offer_code__c == coff.Offer_code__c) {
         coff.Request_Voucher__c = vou.getId();
         }
         }
         }

         List<Database.SaveResult> offerResults = Database.insert(offers, false);
         system.debug('offerResults ' + offerResults);

         for(Database.SaveResult off :offerResults) {
         if(off.isSuccess()) {

         //system.debug('offercode: ' + offers.get(i).Offer_code__c + ' utils offercode: ' + Utils__c.getOrgdefaults().MastercardOfferId__c);
         if(voucherOffersMap.containsKey(offers.get(i).Contact_code__c) &&
         (offers.get(i).Offer_code__c == Utils__c.getOrgdefaults().MastercardOfferId__c ||
         offers.get(i).Offer_code__c == Utils__c.getOrgdefaults().MastercardOfferId2__c)) {

         Integer j = 0;
         Boolean found = false;
         for(Database.SaveResult vou :voucherResults) {
         system.debug('offers.get(i) ' + offers.get(i));
         system.debug('vouchers.get(j) ' + vouchers.get(j));
         if(vou.isSuccess() && offers.get(i).Contact_code__c == vouchers.get(j).Contact_code__c){
         WS_ENIInteract.Result_NotifyEvent result = new WS_ENIInteract.Result_NotifyEvent();

         result.SUCCESS = true;
         result.ERRORCODE = '';
         result.MESSAGE = '';
         result.OPERATION_ID = vouchers.get(j).Operation_ID__c;
         result.FISCALCODE = vouchers.get(j).Fiscal_code__c;
         result.PROMO_CODE = vouchers.get(j).Voucher_code__c;//'MAS2';//???GC 03/04/2019 deve essere recuperato dalla offer corrispondente o dal voucher
         result.VOUCHER_AMOUNT = vouchers.get(j).Voucher_amount__c;//5.0;
         result.REQUESTID = voucherOffersMap.get(offers.get(i).Contact_code__c);// SAME VALUE OF EVENT_ID FIELD

         if(fiscalCodesForET1 != null) {
         result.CONTACT_KEY = offers.get(i).Contact_code__c;
         //result.TIPOLOGIA_UTENTE = '0'; // EN: restituzione della tipologia Utente
         }//The id is returned only when EventType == 1

         ws.Result_NotifyEvent.add(result);

         //GC TEMP TO DELETE
         Log l = new Log('INFO','Utils.offerVoucherForWS_ENIInetract', 'Result per req voucher ProcessEvent',
         '' , String.valueOf(result), '','',null);
         logs.add(l);
         //
         found = true;
         break;

         }

         j++;
         }

         if (found == false) {
         WS_ENIInteract.Result_NotifyEvent result = new WS_ENIInteract.Result_NotifyEvent();

         result.SUCCESS = false;
         result.ERRORCODE = 'Insert error';
         result.MESSAGE = 'The mastercard Request Voucher was non created';
         result.REQUESTID = voucherOffersMap.get(offers.get(i).Contact_code__c);// SAME VALUE OF EVENT_ID FIELD

         ws.Result_NotifyEvent.add(result);
         Log l = new Log('ERROR', 'Utils.offerVoucherForWS_ENIInetract', 'Errore di creazione del request voucher',
         'The mastercard Request Voucher was non created', String.valueOf(result), voucherOffersMap.get(offers.get(i).Contact_code__c),'',null);
         logs.add(l);

         break;
         }

         }

         if(fiscalCodesForET1 != null) {
         system.debug('offersMap ' + offersMap + ' offers.get(i).Contact_code__c ' + offers.get(i).Contact_code__c);
         if(offersMap.containsKey(offers.get(i).Contact_code__c) && !voucherOffersMap.containsKey(offers.get(i).Contact_code__c)) {
         WS_ENIInteract.Result_NotifyEvent result = new WS_ENIInteract.Result_NotifyEvent();

         result.SUCCESS = true;
         result.ERRORCODE = '';
         result.MESSAGE = '';
         result.REQUESTID = offersMap.get(offers.get(i).Contact_code__c);// SAME VALUE OF EVENT_ID FIELD
         result.CONTACT_KEY = offers.get(i).Contact_code__c;//salesforce id of the created contact
         result.FISCALCODE = fiscalCodesForET1.get(offers.get(i).Contact_code__c); //codice fiscale del contatto creato
         //result.TIPOLOGIA_UTENTE = '0'; // EN: restituzione della tipologia Utente
         result.OPERATION_ID = Utils.generateOperationIdFromDateTime();

         ws.Result_NotifyEvent.add(result);
         }
         }
         }

         i++;
         }
         */
    }

    /*
     public static WS_ENIInteract.Result_NotifyEvent getResultNotifyEvent (Boolean newSuccess, String newErrorCode, String newMessage, String newRequestID) {

     WS_ENIInteract.Result_NotifyEvent result = new WS_ENIInteract.Result_NotifyEvent();

     result.SUCCESS = newSuccess;
     result.ERRORCODE = newErrorCode;
     result.MESSAGE = newMessage;
     result.REQUESTID = newRequestID;

     return result;
     }
     */
    //@TestVisible private static Contact generateContact(WS_ENIInteract.Request_NotifyEvent lis, Boolean hasContactCode, String eventType) {
    //    Contact con;
    //    switch on eventType {
    //        when '1' {
    //            con = new Contact(Fiscal_code__c = lis.CODICE_FISCALE, APP_created_date__c = lis.DATA,
    //                              FirstName = lis.NOME, LastName = lis.COGNOME, Email = lis.INDIRIZZO_EMAIL,
    //                              Birthdate = lis.DATA_DI_NASCITA, Push_Notification__c = lis.FG_NOTIFICA,
    //                              Credit_card_association__c = lis.FG_1, Credit_Card_Type__c =lis.CARTA,
    //                              Flag_Privacy_Analysis__c = lis.FLG_PRIVACY1,
    //                              Flag_Privacy_Partner__c = lis.FLG_PRIVACY2, MobilePhone = lis.TEL_MOBILE);
    //            if(!String.isEmpty(lis.CARTA)) {
    //                con.Card_Association_Date__c = Date.valueOf(lis.DATA);
    //            }
    //        }
    //        when '2' {
    //            //mappamento campi sull'oggetto Contact
    //        }
    //        when '3' {
    //            //mappamento campi sull'oggetto Contact
    //        }
    //        when '4' {
    //            //mappamento campi sull'oggetto Contact
    //            if(lis.CARTA.toUpperCase() == 'MASTERCARD') {
    //            }else {
    //            }
    //        }
    //        when '5' {
    //            con = new Contact(Fiscal_code__c = lis.CODICE_FISCALE, APP_created_date__c = lis.DATA,
    //                              Push_Notification__c = lis.FG_NOTIFICA,
    //                              Flag_Privacy_Analysis__c = lis.FLG_PRIVACY1, Flag_Privacy_Partner__c = lis.FLG_PRIVACY2,
    //                              MobilePhone = lis.TEL_MOBILE);
    //        }
    //    }
    //    if(!hasContactCode) {
    //        con.Contact_code__c = lis.CODICE_FISCALE;
    //    }
    //    return con;
    //}
    //@TestVisible private static Boolean mandatoryPresent(WS_ENIInteract.Request_NotifyEvent lis, String eventType) {
    //    switch on eventType {
    //        when '1' {
    //            if(String.isEmpty(lis.CODICE_FISCALE) || String.isEmpty(String.valueOf(lis.DATA)) || String.isEmpty(lis.NOME) || String.isEmpty(lis.COGNOME) ||
    //               String.isEmpty(lis.INDIRIZZO_EMAIL) || String.isEmpty(String.valueOf(lis.DATA_DI_NASCITA)) || String.isEmpty(String.valueOf(lis.FG_NOTIFICA)) ||
    //               String.isEmpty(String.valueOf(lis.FG_1)) || String.isEmpty(lis.CARTA) || String.isEmpty(lis.CLUSTER) || String.isEmpty(lis.NUM_CARTA_LOYALTY) ||
    //               String.isEmpty(String.valueOf(lis.FLG_PRIVACY1)) || String.isEmpty(String.valueOf(lis.FLG_PRIVACY2)) || String.isEmpty(lis.TEL_MOBILE) ||
    //               String.isEmpty(lis.EVENT_TYPE) || String.isEmpty(lis.EVENT_ID)) {
    //                return false;
    //            }
    //        }
    //        when '2' {
    //            if(String.isEmpty(lis.CODICE_FISCALE) || String.isEmpty(String.valueOf(lis.DATA)) || String.isEmpty(lis.IMPIANTO) || String.isEmpty(lis.PRODOTTO) ||
    //               String.isEmpty(String.valueOf(lis.FLAG_PAGAMENTO)) || String.isEmpty(String.valueOf(lis.PUNTI)) || String.isEmpty(String.valueOf(lis.LITRI)) ||
    //               String.isEmpty(lis.MODALITA_OPERATIVA) || String.isEmpty(lis.COGNOME) || String.isEmpty(String.valueOf(lis.FG_NOTIFICA)) || String.isEmpty(String.valueOf(lis.FG_1)) ||
    //               String.isEmpty(lis.CARTA) || String.isEmpty(lis.CLUSTER) || String.isEmpty(String.valueOf(lis.IMPORTO)) || String.isEmpty(String.valueOf(lis.FLG_PRIVACY1)) ||
    //               String.isEmpty(String.valueOf(lis.FLG_PRIVACY2)) || String.isEmpty(lis.EVENT_TYPE) || String.isEmpty(lis.MODALITA_PAGAMENTO) || String.isEmpty(lis.EVENT_ID)) {
    //                return false;
    //            }
    //        }
    //        when '3' {
    //            if(String.isEmpty(lis.CODICE_FISCALE) || String.isEmpty(String.valueOf(lis.DATA)) || String.isEmpty(lis.IMPIANTO) || String.isEmpty(lis.PRODOTTO) ||
    //               String.isEmpty(String.valueOf(lis.FLAG_PAGAMENTO)) || String.isEmpty(String.valueOf(lis.PUNTI)) || String.isEmpty(String.valueOf(lis.LITRI)) ||
    //               String.isEmpty(lis.MODALITA_OPERATIVA) || String.isEmpty(lis.COGNOME) || String.isEmpty(String.valueOf(lis.FG_NOTIFICA)) || String.isEmpty(String.valueOf(lis.FG_1)) ||
    //               String.isEmpty(lis.CARTA) || String.isEmpty(lis.CLUSTER) || String.isEmpty(String.valueOf(lis.IMPORTO)) || String.isEmpty(String.valueOf(lis.FLG_PRIVACY1)) ||
    //               String.isEmpty(String.valueOf(lis.FLG_PRIVACY2)) || String.isEmpty(lis.EVENT_TYPE) || String.isEmpty(lis.MODALITA_PAGAMENTO) || String.isEmpty(lis.EVENT_ID)) {
    //                return false;
    //            }
    //        }
    //        when '4' {
    //            if(String.isEmpty(lis.CODICE_FISCALE) || String.isEmpty(String.valueOf(lis.DATA)) || String.isEmpty(String.valueOf(lis.FG_NOTIFICA)) || String.isEmpty(String.valueOf(lis.FG_1)) ||
    //               String.isEmpty(lis.CARTA) || String.isEmpty(lis.CLUSTER) || String.isEmpty(String.valueOf(lis.FLG_PRIVACY1)) || String.isEmpty(String.valueOf(lis.FLG_PRIVACY2)) ||
    //               String.isEmpty(lis.EVENT_TYPE) || String.isEmpty(lis.EVENT_ID)) {
    //                return false;
    //            }
    //        }
    //        when '5' {
    //            if(String.isEmpty(lis.CODICE_FISCALE) || String.isEmpty(String.valueOf(lis.DATA)) || String.isEmpty(String.valueOf(lis.FG_NOTIFICA)) || String.isEmpty(lis.CLUSTER) ||
    //               String.isEmpty(String.valueOf(lis.FLG_PRIVACY1)) || String.isEmpty(String.valueOf(lis.FLG_PRIVACY2)) || String.isEmpty(lis.NUM_CARTA_LOYALTY) ||
    //               String.isEmpty(lis.EVENT_TYPE) || String.isEmpty(lis.EVENT_ID)) {
    //                return false;
    //            }
    //        }
    //    }
    //    return true;
    //}
    private static void initializeEvent1(WS_ENIInteract.Request_NotifyEvent lis){
        Boolean isExistFc = false;
        Boolean isExistEmail = false;
        PrivacyDetails privacyDet;

        Contact con;
        //if(mandatoryPresent(lis, '1')) {
        con = new Contact(Fiscal_code__c = lis.CODICE_FISCALE, APP_created_date__c = lis.DATA, FirstName = lis.NOME, LastName = lis.COGNOME, Birthdate = lis.DATA_DI_NASCITA, Push_Notification__c = lis.FG_NOTIFICA, Credit_Card_Type__c = lis.CARTA, Cluster__c = lis.CLUSTER, Flag_Privacy_ENI__c = lis.FLG_PRIVACY1, Flag_Privacy_Analysis__c = lis.FLG_PRIVACY1, Flag_Privacy_Partner__c = lis.FLG_PRIVACY2, MobilePhone = lis.TEL_MOBILE, Phone = lis.TEL_MOBILE, Enabled__c = true, Gender__c = lis.SESSO, 
        // 11-03-2021 nuovi campi dall'unificazione dell' evento 6 App Unica
        Business_Name__c = lis.RAGIONE_SOCIALE, SDI_Code__c = lis.SDI_CODE, VAT_Number__c = lis.PARTITA_IVA, 
        // 12-03-2021 aggiunta nuovi campi App Unica
        Multicard__c = fromObjectMulticardToString(lis.MULTICARD),                           //Utils.fromStringArrayToString(lis.MULTICARD)
        Multicard_Wa__c = fromObjectMulticardToStringWithData(lis.MULTICARD), 
        //MailingStreet = lis.INDIRIZZO_RESIDENZA + ' ' + lis.CIVICO_RESIDENZA,
        MailingPostalCode = lis.CAP_RESIDENZA, MailingCity = lis.CITTA_RESIDENZA, MailingState = lis.PROVINCIA_RESIDENZA, 
        //Residence_Address__c = lis.INDIRIZZO_RESIDENZA,
        //Vehicle_Description__c = lis.DESCRIZIONE_VEICOLO,
        Consumer_Billing_Address__c = lis.INDIRIZZO_FATTURAZIONE_PRIVATI, Consumer_Billing_City__c = lis.CITTA_FATTURAZIONE_PRIVATI, Consumer_Billing_First_Name__c = lis.NOME_FATTURAZIONE_PRIVATI, Consumer_Billing_Last_Name__c = lis.COGNOME_FATTURAZIONE_PRIVATI, Consumer_Billing_Postal_Code__c = lis.CAP_FATTURAZIONE_PRIVATI, Consumer_Billing_Region__c = lis.PROVINCIA_FATTURAZIONE_PRIVATI, Consumer_Billing_Street_Number__c = lis.CIVICO_FATTURAZIONE_PRIVATI, 
        //Residence_Street_Number__c = lis.CIVICO_RESIDENZA,
        //Residence_Postal_Code__c = lis.CAP_RESIDENZA,
        //Residence_City__c = lis.CITTA_RESIDENZA,
        //Residence_Region__c = lis.PROVINCIA_RESIDENZA,
        Plate__c = fromObjectToString(lis.TARGHE), 
        //EN: nuovo attributo TIPOLOGIA UTENTE
        Customer_Type__c = lis.TIPOLOGIA_UTENTE, ENL_Codice_Promozione__c = lis.CODICE_PROMOZIONE, 
        //RET20015 Nuova Loyalty ENICCM-146
        Billing_Address__c = lis.INDIRIZZO_FATTURAZIONE, Billing_Street_Number__c = lis.CIVICO_FATTURAZIONE, Billing_City__c = lis.CITTA_FATTURAZIONE, Billing_Region__c = lis.PROVINCIA_FATTURAZIONE, Billing_Country__c = lis.NAZIONE_FATTURAZIONE, Billing_Postal_Code__c = lis.CAP_FATTURAZIONE, Billing_First_Name__c = lis.NOME_FATTURAZIONE, Billing_Last_Name__c = lis.COGNOME_FATTURAZIONE, PEC_Email__c = lis.PEC_EMAIL, Billing_Fiscal_Code__c = lis.CODICE_FISCALE_FATTURAZIONE, Billing_Email__c = lis.EMAIL_FATTURAZIONE, Birth_City__c = lis.COMUNE_NASCITA, Birth_Region__c = lis.PROVINCIA_NASCITA, Cancellation_Date__c = NULL, Cancellation_Type__c = NULL, Cancellation_Request_Origin__c = NULL, APP_loyalty_customer__c = NULL, Sync_with_marketing_cloud__c = true);
        
                
        //check se il contact è un gestore
        if(existingAnagraficaGestori.get(lis.CODICE_FISCALE.toUpperCase()) != null){
            con.Cluster__c = '0';
        }

        //per modifica dati multicard
        if (lis.MULTICARD != null && lis.MULTICARD.size() == 1){
            con.ENL_Tipo_Multicard_1__c = lis.MULTICARD[0].MULTICARD;
            con.ENL_Data_Inserimento_Multicard_1__c = lis.MULTICARD[0].DATA_INSERIMENTO_MULTICARD;
        }
        if (lis.MULTICARD != null && lis.MULTICARD.size() == 2){
            con.ENL_Tipo_Multicard_1__c = lis.MULTICARD[0].MULTICARD;
            con.ENL_Data_Inserimento_Multicard_1__c = lis.MULTICARD[0].DATA_INSERIMENTO_MULTICARD;
            con.ENL_Tipo_Multicard_2__c = lis.MULTICARD[1].MULTICARD;
            con.ENL_Data_Inserimento_Multicard_2__c = lis.MULTICARD[1].DATA_INSERIMENTO_MULTICARD;
        }
        if (lis.MULTICARD == null){
            con.ENL_Tipo_Multicard_1__c = null;
            con.ENL_Data_Inserimento_Multicard_1__c = null;
            con.ENL_Tipo_Multicard_2__c = null;
            con.ENL_Data_Inserimento_Multicard_2__c = null;
        }
        if (lis.MULTICARD != null && lis.MULTICARD.size() == 1 && con.ENL_Tipo_Multicard_1__c != null && con.ENL_Tipo_Multicard_2__c != null){
            if (lis.MULTICARD[0].MULTICARD == con.ENL_Tipo_Multicard_1__c){
                con.ENL_Tipo_Multicard_2__c = null;
                con.ENL_Data_Inserimento_Multicard_2__c = null;
            } else{
                con.ENL_Tipo_Multicard_1__c = null;
                con.ENL_Data_Inserimento_Multicard_1__c = null;
            }
        }

        //Process to manage update from event type 11 and 12 (by Nick 20-05-2021)
        isExistFc = existingContactsLead.containsKey(capitalizedFC) ? true : false;
        isExistEmail = existingContactsByEmail.containsKey(lis.INDIRIZZO_EMAIL.toUpperCase()) ? true : false;
        //AC Valorizzazione email fuori dall'if per bug
        con.Email = lis?.INDIRIZZO_EMAIL;

        if (lis.ISCRIZIONE_ENJOY_COMPLETA != null)
            con.ECU_Iscrizione_Enjoy_Completa__c = lis.ISCRIZIONE_ENJOY_COMPLETA;
        // valorizzare campo stato iscrizione cliente su contact
        if (lis.CANALE_REGISTRAZIONE != null)
            con.ENL_Canale_Registrazione__c = lis.CANALE_REGISTRAZIONE;
        if (!isExistFc && !isExistEmail){
            con.Contact_code__c = capitalizedFC;
            //AC Valorizzazione email fuori dall'if per bug
            // con.Email = lis?.INDIRIZZO_EMAIL;
        } else{
            con.Contact_code__c = isExistFc ? capitalizedFC : lis.INDIRIZZO_EMAIL.toUpperCase();
            if (isExistEmail){
                existingContactsByEmail.get(lis.INDIRIZZO_EMAIL.toUpperCase()).Contact_code__c = capitalizedFC;
                existingContactsByEmail.get(lis.INDIRIZZO_EMAIL.toUpperCase()).RecordTypeId = Utils.getRecordTypeId('Customer', 'Contact');
            }

            con.RecordTypeId = Utils.getRecordTypeId('Customer', 'Contact');
        }
        // End

        if (!String.isEmpty(lis.CARTA)){
            con.Card_Association_Date__c = Date.valueOf(lis.DATA);
            con.Credit_card_association__c = lis.FG_1;
        }
        if (!String.isBlank(lis.INDIRIZZO_RESIDENZA)){
            if (!String.isBlank(lis.CIVICO_RESIDENZA)){
                con.MailingStreet = lis.INDIRIZZO_RESIDENZA + ',' + lis.CIVICO_RESIDENZA;
            } else{
                con.MailingStreet = lis.INDIRIZZO_RESIDENZA;
            }
        }
        if (fromObjectToBoolean(lis.ALL_PRIVACY, 'flg_privacy_geo') != null)
            con.Privacy_GEO__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'flg_privacy_geo');
        if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_TERMCOND') != null)
            con.Flag_Term_Cond__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_TERMCOND');
        if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_CLAUSPEC') != null)
            con.Flag_Clause_Spec__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_CLAUSPEC');
        if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_LOYALTY') != null)
            con.Flag_Loyalty__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_LOYALTY');
        if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_PRIVACYPOLICY') != null)
            con.Flag_Privacy_Policy__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_PRIVACYPOLICY');
        if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_PROFILAZIONE') != null)
            con.Flag_Profilazione__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_PROFILAZIONE');
        //F.Fiorentini ECU Wave 2 aggiunto flag per aggiornamento LEAD ECU
        con.ECU_ES_Customer__c = true;

        privacyDet = null;
        privacyDet = fromObjectToPrivacyDetails(lis.ALL_PRIVACY, 'FLG_PRIVACY1');
        if (privacyDet != null){
            con.Flag_Privacy_ENI_Source__c = privacyDet.getSourcePrivacy();
            con.Flag_Privacy_ENI_DateChange__c = privacyDet.getDateChangePrivacy();
        }
        privacyDet = null;
        privacyDet = fromObjectToPrivacyDetails(lis.ALL_PRIVACY, 'FLG_PRIVACY2');
        if (privacyDet != null){
            con.Flag_Privacy_Partner_Source__c = privacyDet.getSourcePrivacy();
            con.Flag_Privacy_Partner_DateChange__c = privacyDet.getDateChangePrivacy();
        }
        privacyDet = null;
        privacyDet = fromObjectToPrivacyDetails(lis.ALL_PRIVACY, 'FG_PRIVACYPOLICY');
        if (privacyDet != null){
            con.Flag_Privacy_Policy_Source__c = privacyDet.getSourcePrivacy();
            con.Flag_Privacy_Policy_DateChange__c = privacyDet.getDateChangePrivacy();
        }
        privacyDet = null;

        //commentato per dismissione loyalty_card 24/02/23
        /*
        if (!String.isEmpty(lis.NUM_CARTA_LOYALTY)){
            loyaltyCardNumbers.put(capitalizedFC, lis.NUM_CARTA_LOYALTY);
        }
        */
        if (!event1Contacts.containsKey(capitalizedFC)){
            event1Contacts.put(capitalizedFC, con);
        }
        if (!successMap1.containsKey(capitalizedFC)){
            successMap1.put(capitalizedFC, lis.EVENT_ID);
        }

        if (con.Flag_Loyalty__c){
            if (!con.Flag_Entry_Offer__c)
                conFicalCodeToStartBatch.add(capitalizedFC);
            if (isExistFc){
                contactIdsMapWithTrans.add(capitalizedFC);
            }
            if (!con.Flag_Entry_Gift__c)
                contactEntryGift.add(capitalizedFC);
        }
        //Aggiunto controllo su tipologia Multicard per Bonus Multicard Easy (G.C. 08/09/21)
        if ((con.Flag_Privacy_ENI__c || lis.FLG_PRIVACY1) && !con.Flag_Multi_Easy__c &&                           /*Utils.fromStringArrayToString(lis.MULTICARD)*/fromObjectMulticardToString(lis.MULTICARD).containsIgnoreCase('EASY')){
            contactMulticardEasy.add(capitalizedFC);
        }

        //aggiungo lista contact senza effettuare controllo sullo stato cliente
        //controllo stato cliente da effettuare nell'helper

        contactVoucherEnjoy.add(con);


        //Controllo privacy per invio voucher di natale
        if (isExistFc){
            ContactOfferList.add(con);
            }
        //controllo per invio voucher RET-22030 DEM real pre registrati
        Contact checkLeadForVoucherValidity = existingLead.get(lis.CODICE_FISCALE.toUpperCase());
        if (checkLeadForVoucherValidity != null && Date.valueOf(checkLeadForVoucherValidity.Data_Preregistrazione__c) >= System.today().addDays(-25) && Date.valueOf(checkLeadForVoucherValidity.Data_Preregistrazione__c) < System.today().addDays(-15)){
            preRegisteredContactsVoucher.add(con);
            system.debug(' sei qui dentro');
        }
    }

    private static void initializeEvent3(WS_ENIInteract.Request_NotifyEvent lis, WS_ENIInteract.Response_NotifyEvent ws){

        //commentato per dismissione loyalty_card 24/02/23
        /*
        if (lis.TRANSAZIONE_MOROSA == 'false' || lis.TRANSAZIONE_MOROSA == null){
            if (!String.isEmpty(lis.NUM_CARTA_LOYALTY) && lis.NUM_CARTA_LOYALTY != null){
                loy = existingCards.get(lis.NUM_CARTA_LOYALTY.toUpperCase());
            } else{
                if (lis.MODALITA_PAGAMENTO == '2' && (lis.PARTITA_IVA != null && !String.isEmpty(lis.PARTITA_IVA))){
                    loy = existingCards.get(lis.CODICE_FISCALE.toUpperCase() + '_BUSINESS');
                } else if (lis.MODALITA_PAGAMENTO == '1' || lis.MODALITA_PAGAMENTO == '6' || lis.MODALITA_PAGAMENTO == '7'){
                    loy = existingCards.get(lis.CODICE_FISCALE.toUpperCase() + '_MULTICARDBUSINESS');
                } else if (lis.MODALITA_PAGAMENTO == '5'){
                    loy = existingCards.get(lis.CODICE_FISCALE.toUpperCase() + '_MULTICARDENIPEOPLE');
                } else{
                    loy = existingCards.get(lis.CODICE_FISCALE.toUpperCase() + '_CONSUMER');
                }
            }
        }
        system.debug('loy #304 : ' + loy);

        // RET20015 Nuova Loyalty ENICCM-146 : loyalty card no more mandatory

        //if(loy != null){
        */
        Contact con = existingContacts.get(capitalizedFC);
        //GC 01/04/2019
        //WS_ENIInteract.updateContactData(lis.EVENT_TYPE, lis.CLUSTER, lis.FG_NOTIFICA, lis.FLG_PRIVACY1, lis.FLG_PRIVACY2, lis.FG_1, con);

        //AN 06/06/2019
        if (con != null){
            if (lis.EVENT_TYPE == '3'){
                con.EniStation_APP_payment__c = true;
                /*if(lis.TARGA != NULL && lis.TARGA.size() > 0) {
                 con.Plate__c = Utils.fromStringArrayToString(lis.TARGA);
                 }*/
            }
            otherContacts.put(capitalizedFC, con);

            //END GC 01/04/2019
            Transaction__c tr = new Transaction__c(Name = lis.TRANSACTION_ID, Transaction_Id__c = lis.TRANSACTION_ID, Transaction_Date__c = lis.DATA, Service_Station_Code__c = lis.IMPIANTO, Product_Type__c = lis.PRODOTTO, EniStation_APP_payment__c = lis.FLAG_PAGAMENTO, Contact__c = (con != null) ? con.ID : NULL,/*commentato per dismissione loyalty_card 24/02/23 Loyalty_Card__c = (loy != null) ? loy.Id : NULL*/ EniStation_App_Payment_Mode__c = lis.MODALITA_PAGAMENTO, Flag_Privacy_1__c = (con != null) ? con.Flag_Privacy_ENI__c : FALSE, Flag_Privacy_2__c = (con != null) ? con.Flag_Privacy_Partner__c : FALSE, Cluster__c = (con != null) ? con.Cluster__c : NULL, Push_Notification__c = (con != null) ? con.Push_notification__c : FALSE, Card_Type__c = (con != null) ? con.Credit_Card_Type__c : NULL, Amount__c = lis.IMPORTO, Refueling_Mode__c = lis.MODALITA_OPERATIVA, Total_Points__c = lis.PUNTI, Liters__c = lis.LITRI, EVENT_TYPE__c = lis.EVENT_TYPE, EVENT_ID__c = lis.EVENT_ID, 
            //12-03-2021 Aggiunta nuovi campi App Unica
            //Vehicle_Description__c = lis.DESCRIZIONE_VEICOLO,
            VAT_Number__c = lis.PARTITA_IVA, Fiscal_code__c = lis.CODICE_FISCALE, 
            //11-03-2021 rimosso per modifiche App Unica
            //Customer_Type__c = lis.TIPOLOGIA_UTENTE,
            //RET20015 Nuova Loyalty ENICCM-146
            ENL_System_Source__c = lis.SISTEMA_SORGENTE, Kwh__c = lis.KWH, Time__c = lis.DURATA, Recarge_Type__c = lis.TIPOLOGIA_RICARICA, ENL_Service_Type__c = lis.TIPOLOGIA_SERVIZO, ENL_Start_Date__c = lis.DATA_INIZIO, ENL_End_Date__c = lis.DATA_FINE, ENL_Transaction_Locked__c = lis.BLOCCO_ANTIFRODE, ENL_Transaction_Code__c = lis.CODICE_TRANSAZIONE, ENL_Disabled_Service_Station__c = lis.IMPIANTO_NON_ABILITATO, ECU_Sconto_Applicato__c = lis.SCONTO_APPLICATO, ECU_offerCondition__c = lis.PARAMETER1,                                //campi aggiunti per tariffa integrata il 10/11/2021
            ECU_Codice_Errore_Parcheggio__c = lis.CODICE_ERRORE_PARCHEGGIO,                               //campi aggiunti per tariffa integrata il 10/11/2021
            ECU_Descrizione_Errore_Parcheggio__c = lis.DESCRIZIONE_ERRORE_PARCHEGGIO,                                 //campi aggiunti per tariffa integrata il 10/11/2021
            ENL_Sconto_Applicato__c = String.valueOf(lis.SCONTO_CONVENZIONE),                                //per tariffa convezionata
            ENL_Tipologia_Sconto__c = lis.TIPOLOGIA_SCONTO,                           //per tariffa convenzionata
            ENL_Importo_Prenotazione__c = lis.IMPORTO_PRENOTAZIONE,                           //per integrazione prenotazione recharge
            ENL_Importo_Penalita__c = lis.IMPORTO_PENALITA,                           // per penalità ricarica elettrica
            ENL_Durata_Sosta__c = lis.DURATA_SOSTA,                           // per penalità ricarica elettrica
            ENL_Numero_Stallo__c = lis.NUMERO_STALLO,                              //per parcheggio a stallo singolo
            ENL_Durata_Prenotazione__c = lis.DURATA_PRENOTAZIONE    //per transazione con durata prenotazione
            );

            if (lis.TARGHE != NULL && lis.TARGHE.size() > 0){
                tr.Plate__c = fromObjectToString(lis.TARGHE);
            }

            if (lis.TRANSAZIONE_MOROSA != null)
                tr.Transazione_Morosa__c = lis.TRANSAZIONE_MOROSA;
            //campi per sosta MyCicero
            if (lis.CITTA_SOSTA != null)
                tr.ENL_Citta_Sosta__c = lis.CITTA_SOSTA;
            if (lis.ID_ZONA != null)
                tr.ENL_Id_Zona__c = lis.ID_ZONA;
            if (lis.ID_PARCHIMETRO != null)
                tr.ENL_Id_Parchimetro__c = lis.ID_PARCHIMETRO;
            //verifica del caso in cui una transazione che sta per essere sanata deve essere conseguentemente collegata alla sua transazione morosa originaria
            if (lis.TRANSAZIONE_MOROSA != null && lis.TRANSAZIONE_MOROSA == 'false' && transactionMorosaToBeLinked.get(lis.CODICE_TRANSAZIONE) != null){
                tr.Related_transaction_id__c = transactionMorosaToBeLinked.get(lis.CODICE_TRANSAZIONE).Id;
                if (!updateTransactions.containsKey(transactionMorosaToBeLinked.get(lis.CODICE_TRANSAZIONE).Transaction_Id__c)){
                    updateTransactions.put((transactionMorosaToBeLinked.get(lis.CODICE_TRANSAZIONE).Transaction_Id__c), transactionMorosaToBeLinked.get(lis.CODICE_TRANSAZIONE));
                    transactionsSucessMap.put(transactionMorosaToBeLinked.get(lis.CODICE_TRANSAZIONE).Transaction_Id__c, lis.EVENT_ID);
                }
            }
            //verifica del caso in cui una transazione che sta per essere inserita sia di tipo tariffa integrata e conseguentemente debba essere collegata alla sua gemella
            if (lis.TIPOLOGIA_SERVIZO == '1' && transactionIntegrataToBeLinked.get(lis.CODICE_TRANSAZIONE) != null){
                tr.Related_transaction_id__c = transactionIntegrataToBeLinked.get(lis.CODICE_TRANSAZIONE).Id;
                if (!updateTransactions.containsKey(transactionIntegrataToBeLinked.get(lis.CODICE_TRANSAZIONE).Transaction_Id__c)){
                    updateTransactions.put((transactionIntegrataToBeLinked.get(lis.CODICE_TRANSAZIONE).Transaction_Id__c), transactionIntegrataToBeLinked.get(lis.CODICE_TRANSAZIONE));
                    transactionsSucessMap.put(transactionIntegrataToBeLinked.get(lis.CODICE_TRANSAZIONE).Transaction_Id__c, lis.EVENT_ID);
                }
            }

            // RET20015 Nuova Loyalty ENICCM-146
            // il Transaction_ID ora è quello generato e propagato dal BE dell'App
            // tr.Transaction_Id__c = lis.EVENT_ID; //come comunicato da techedge:
            //il requestId sarà una stringa alfanumerica generata
            //casualmente che resterà univoca nel tempo
            if ((lis.TRANSAZIONE_MOROSA != null && lis.TRANSAZIONE_MOROSA == 'false' && transactionMorosaToBeLinked.get(lis.CODICE_TRANSAZIONE) == null) || (lis.SCONTO_APPLICATO != null && transactionIntegrataToBeLinked.get(lis.CODICE_TRANSAZIONE) == null)){
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = false;
                result.ERRORCODE = '';
                result.MESSAGE = 'Error when creating Transaction';
                result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD


                ws.Result_NotifyEvent.add(result);
                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore nella creazione della transazione per mancanza di una Transaction morosa o tariffa integrata da associare', 'Error when creating Transaction', String.valueOf(result), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE,/*commentato per dismissione loyalty_card 24/02/23 numCartaLoyalty*/ '', lis.PRODOTTO, lis.LITRI, lis.IMPORTO, lis.PUNTI, lis.MODALITA_OPERATIVA, lis.PARTITA_IVA, fromObjectToString(lis.TARGHE), null, lis.CARTA);
                logs.add(l);
                system.debug('Log event 3 ' + logs);

            } else{
                if (!newTransactions.containsKey(tr.Transaction_Id__c) && !existingTransactions.containsKey(tr.Transaction_Id__c)){
                    newTransactions.put(tr.Transaction_Id__c, tr);
                    transactionsSucessMap.put(tr.Transaction_Id__c, lis.EVENT_ID);
                }
            }

            system.debug('TRANSACTION: ' + tr);

        } else{
            Result_NotifyEvent result = new Result_NotifyEvent();

            result.SUCCESS = false;
            result.ERRORCODE = '';
            result.MESSAGE = 'Error when creating Transaction';
            result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD


            ws.Result_NotifyEvent.add(result);
            Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore nella creazione della transazione' + 
                            ' per mancanza di un Contact da associare', 'Error when creating Transaction', String.valueOf(result), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE,/*commentato per dismissione loyalty_card 24/02/23 numCartaLoyalty*/ '', lis.PRODOTTO, lis.LITRI, lis.IMPORTO, lis.PUNTI, lis.MODALITA_OPERATIVA, lis.PARTITA_IVA, fromObjectToString(lis.TARGHE), null, lis.CARTA);
            logs.add(l);
            system.debug('Log event 3 ' + logs);
        }
        /*}else{
         Result_NotifyEvent result = new Result_NotifyEvent();

         result.SUCCESS = false;
         result.ERRORCODE = '';
         result.MESSAGE = 'Error when creating Transaction';
         result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD

         ws.Result_NotifyEvent.add(result);
         Log l = new Log('ERROR','WS_ENIInteract.NotifyEvent', 'Errore nella creazione della transazione' +
         ' per mancanza di una loyalty card da associare',
         'Error when creating Transaction', String.valueOf(result) , lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE, numCartaLoyalty, lis.PRODOTTO,
         lis.LITRI, lis.IMPORTO, lis.PUNTI, lis.MODALITA_OPERATIVA, lis.PARTITA_IVA, Utils.fromStringArrayToString(lis.TARGA), lis.TIPOLOGIA_UTENTE, lis.CARTA);
         logs.add(l);
         system.debug('Log event 3 ' + logs);
         }*/
    }

    private static void initializeEvent4(WS_ENIInteract.Request_NotifyEvent lis, WS_ENIInteract.Response_NotifyEvent ws){
        if (!String.isEmpty(lis.CARTA) && existingContacts.containsKey(capitalizedFC)){
            //GC 01/04/2019
            /*Contact con = new Contact(Fiscal_code__c = lis.CODICE_FISCALE, Card_Association_Date__c = Date.valueOf(lis.DATA),
             Credit_Card_Type__c = lis.CARTA, FirstName = lis.NOME, LastName = lis.COGNOME,
             Email = lis.INDIRIZZO_EMAIL);
             */
            Contact con = existingContacts.get(capitalizedFC);
            con.Card_Association_Date__c = Date.valueOf(lis.DATA);
            con.Credit_Card_Type__c = lis.CARTA;
            con.Credit_card_association__c = lis.FG_1;
            //[RET20015: Nuova Loyalty - i campi anagrafici si aggiornano soltanto con l'evento di Modifica dati Cliente] >> WS_ENIInteract.updateContactData(lis.EVENT_TYPE, lis.CLUSTER, lis.FG_NOTIFICA, lis.FLG_PRIVACY1, lis.FLG_PRIVACY2, lis.FG_1, con);
            //END GC 01/04/2019
            if (!event4Contacts.containsKey(capitalizedFC)){
                event4Contacts.put(capitalizedFC, con);
            }
            if (!successMap4.containsKey(capitalizedFC)){
                successMap4.put(capitalizedFC, lis.EVENT_ID);
            }

        } else{
            Result_NotifyEvent result = new Result_NotifyEvent();

            result.SUCCESS = false;
            result.ERRORCODE = '';
            result.MESSAGE = 'Absent card or non existing customer';
            result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD

            ws.Result_NotifyEvent.add(result);
            Log l = new Log(capitalizedFC == '9999999999999999' ? 'WARNING' : 'ERROR', 'WS_ENIInteract.NotifyEvent', 'Carta di credito assente o contatto non esistente', 'Absent card or non existing customer', String.valueOf(result), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE,/*commentato per dismissione loyalty_card 24/02/23 numCartaLoyalty*/ '', lis.PRODOTTO, lis.LITRI, lis.IMPORTO, lis.PUNTI, lis.MODALITA_OPERATIVA, lis.PARTITA_IVA, fromObjectToString(lis.TARGHE), null, lis.CARTA);
            logs.add(l);

        }
    }

    //commentato per dismissione loyalty_card 24/02/23
    /*
    private static void initializeEvent5(WS_ENIInteract.Request_NotifyEvent lis, WS_ENIInteract.Response_NotifyEvent ws){
        String cardCode = lis.NUM_CARTA_LOYALTY;
        if (!String.isEmpty(cardCode)){
            //GC 01/04/2019
            Contact con = existingContacts.get(capitalizedFC);
            WS_ENIInteract.updateContactData(lis.EVENT_TYPE, lis.CLUSTER, lis.FG_NOTIFICA, lis.FLG_PRIVACY1, lis.FLG_PRIVACY2, lis.FG_1, con);
            //NA 06/06/2019
            if (con != null){
                otherContacts.put(capitalizedFC, con);
                Boolean virtualCard = !cardCode.startsWith(Utils__c.getOrgDefaults().VirtualCardCode__c);

                loyaltyCards.add(new Loyalty_card__c(Name = cardCode, Virtual_card__c = virtualCard, Card_code__c = cardCode, Contact__c = existingContacts.get(capitalizedFC).Id));
                loyaltyCardsMap.put(existingContacts.get(capitalizedFC).Id, lis.EVENT_ID);

            }

        } else{
            Result_NotifyEvent result = new Result_NotifyEvent();

            result.SUCCESS = false;
            result.ERRORCODE = '';
            result.MESSAGE = 'Mandatory field [NUM_CARTA_LOYALTY] missing or incorrect';
            result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD

            ws.Result_NotifyEvent.add(result);
            Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Carta loyalty assente o contatto non esistente', 'Mandatory field [NUM_CARTA_LOYALTY] missing or incorrect', String.valueOf(result), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE, numCartaLoyalty, lis.PRODOTTO, lis.LITRI, lis.IMPORTO, lis.PUNTI, lis.MODALITA_OPERATIVA, lis.PARTITA_IVA, fromObjectToString(lis.TARGHE), null, lis.CARTA);
            logs.add(l);

        }
    }
    */

    private static void initializeEvent7(WS_ENIInteract.Request_NotifyEvent lis, WS_ENIInteract.Response_NotifyEvent ws){
        Contact exCont = null;
        Contact exContRic = null;
        PrivacyDetails privacyDet;
        // GN - 26-03-2021 inizio blocco riconciliazione modifiche App Unica
        if (lis.RICONCILIAZIONE != null && !String.isBlank(lis.RICONCILIAZIONE)){
            exContRic = Utils.initializeReconciliation(lis.RICONCILIAZIONE, lis.RICONCILIAZIONE_CUSTOMER_TYPE, lis.CODICE_FISCALE);
            system.debug('Contatto riconciliazione  ' + exContRic);
            if (exContRic != null){

                if ((exContRic.Cluster__c != '5' || !exContRic.Flag_Loyalty__c) && (lis.CLUSTER == '5' && fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_LOYALTY'))){
                    if (!exContRic.Flag_Entry_Offer__c)
                        conFicalCodeToStartBatch.add(capitalizedFC);
                    if ((exContRic.Flag_Privacy_ENI__c || lis.FLG_PRIVACY1) && !exContRic.Flag_Entry_Gift__c)
                        contactEntryGift.add(capitalizedFC);
                }
                //Aggiunto check su Bonus Multicard Easy (G.C. 08/09/21)
                if ((exContRic.Flag_Privacy_ENI__c || lis.FLG_PRIVACY1) && !exContRic.Flag_Multi_Easy__c &&                           /*Utils.fromStringArrayToString(lis.MULTICARD)*/fromObjectMulticardToString(lis.MULTICARD).containsIgnoreCase('EASY')){
                    contactMulticardEasy.add(capitalizedFC);
                }

                //Controllo privacy per invio voucher di natale
                //Controllare se il Customer Type è corretto
                if (exContRic.Customer_Type__c == '2'){
                    contactVoucherChristmas.add(exContRic.id);
                }
                   
                exContRic.APP_created_date__c = lis.DATA;//???
                exContRic.Email = lis.INDIRIZZO_EMAIL;
                exContRic.Credit_card_association__c = lis.FG_1;
                if (lis.FG_1 && !String.isEmpty(lis.CARTA))
                    exContRic.Credit_Card_Type__c = lis.CARTA;
                exContRic.Cluster__c = lis.CLUSTER;
                exContRic.Flag_Privacy_ENI__c = lis.FLG_PRIVACY1;
                exContRic.Flag_Privacy_Analysis__c = lis.FLG_PRIVACY1;
                exContRic.Flag_Privacy_Partner__c = lis.FLG_PRIVACY2;
                exContRic.Push_notification__c = lis.FG_NOTIFICA;
                exContRic.MobilePhone = lis.TEL_MOBILE;
                exContRic.Phone = lis.TEL_MOBILE; //????
                exContRic.Business_Name__c = lis.RAGIONE_SOCIALE;
                // 12-03-2021 aggiunta nuovi campi App Unica
                exContRic.Multicard__c = fromObjectMulticardToString(lis.MULTICARD);   //Utils.fromStringArrayToString(lis.MULTICARD)
                exContRic.Multicard_Wa__c = fromObjectMulticardToStringWithData(lis.MULTICARD);
                //exContRic.Residence_Address__c = lis.INDIRIZZO_RESIDENZA;
                //exContRic.Vehicle_Description__c = lis.DESCRIZIONE_VEICOLO;
    
                //check se il contact è un gestore
                if(existingAnagraficaGestori.get(lis.CODICE_FISCALE.toUpperCase()) != null){
                    exContRic.Cluster__c = '0';
                }

                if (lis.MULTICARD != null && lis.MULTICARD.size() == 1){
                    exContRic.ENL_Tipo_Multicard_1__c = lis.MULTICARD[0].MULTICARD;
                    exContRic.ENL_Data_Inserimento_Multicard_1__c = lis.MULTICARD[0].DATA_INSERIMENTO_MULTICARD;
                }
                if (lis.MULTICARD != null && lis.MULTICARD.size() == 2){
                    exContRic.ENL_Tipo_Multicard_1__c = lis.MULTICARD[0].MULTICARD;
                    exContRic.ENL_Data_Inserimento_Multicard_1__c = lis.MULTICARD[0].DATA_INSERIMENTO_MULTICARD;
                    exContRic.ENL_Tipo_Multicard_2__c = lis.MULTICARD[1].MULTICARD;
                    exContRic.ENL_Data_Inserimento_Multicard_2__c = lis.MULTICARD[1].DATA_INSERIMENTO_MULTICARD;
                }
                if (lis.MULTICARD == null){
                    exContRic.ENL_Tipo_Multicard_1__c = null;
                    exContRic.ENL_Data_Inserimento_Multicard_1__c = null;
                    exContRic.ENL_Tipo_Multicard_2__c = null;
                    exContRic.ENL_Data_Inserimento_Multicard_2__c = null;
                }
                if (lis.MULTICARD != null && lis.MULTICARD.size() == 1 && exContRic.ENL_Tipo_Multicard_1__c != null && exContRic.ENL_Tipo_Multicard_2__c != null){
                    if (lis.MULTICARD[0].MULTICARD == exContRic.ENL_Tipo_Multicard_1__c){
                        exContRic.ENL_Tipo_Multicard_2__c = null;
                        exContRic.ENL_Data_Inserimento_Multicard_2__c = null;
                    } else{
                        exContRic.ENL_Tipo_Multicard_1__c = null;
                        exContRic.ENL_Data_Inserimento_Multicard_1__c = null;
                    }
                }
                exContRic.Consumer_Billing_Address__c = lis.INDIRIZZO_FATTURAZIONE_PRIVATI;
                exContRic.Consumer_Billing_City__c = lis.CITTA_FATTURAZIONE_PRIVATI;
                exContRic.Consumer_Billing_First_Name__c = lis.NOME_FATTURAZIONE_PRIVATI;
                exContRic.Consumer_Billing_Last_Name__c = lis.COGNOME_FATTURAZIONE_PRIVATI;
                exContRic.Consumer_Billing_Postal_Code__c = lis.CAP_FATTURAZIONE_PRIVATI;
                exContRic.Consumer_Billing_Region__c = lis.PROVINCIA_FATTURAZIONE_PRIVATI;
                exContRic.Consumer_Billing_Street_Number__c = lis.CIVICO_FATTURAZIONE_PRIVATI;
                //exContRic.MailingStreet = lis.INDIRIZZO_RESIDENZA + ' ' + lis.CIVICO_RESIDENZA;
                exContRic.MailingPostalCode = lis.CAP_RESIDENZA;
                exContRic.MailingCity = lis.CITTA_RESIDENZA;
                exContRic.MailingState = lis.PROVINCIA_RESIDENZA;
                // exContRic.Residence_Street_Number__c = lis.CIVICO_RESIDENZA;
                // exContRic.Residence_Postal_Code__c = lis.CAP_RESIDENZA;
                // exContRic.Residence_City__c = lis.CITTA_RESIDENZA;
                // exContRic.Residence_Region__c = lis.PROVINCIA_RESIDENZA;
                // fine nuovi campi App Unica
                exContRic.Billing_Address__c = lis.INDIRIZZO_FATTURAZIONE;
                exContRic.Billing_Street_Number__c = lis.CIVICO_FATTURAZIONE;
                exContRic.Billing_City__c = lis.CITTA_FATTURAZIONE;
                exContRic.Billing_Region__c = lis.PROVINCIA_FATTURAZIONE;
                exContRic.Billing_Country__c = lis.NAZIONE_FATTURAZIONE;
                exContRic.Billing_Postal_Code__c = lis.CAP_FATTURAZIONE;
                exContRic.Billing_First_Name__c = lis.NOME_FATTURAZIONE;
                exContRic.Billing_Last_Name__c = lis.COGNOME_FATTURAZIONE;
                exContRic.PEC_Email__c = lis.PEC_EMAIL;
                exContRic.SDI_Code__c = lis.SDI_CODE;

                if (lis.CANALE_REGISTRAZIONE != null)
                    exContRic.ENL_Canale_Registrazione__c = lis.CANALE_REGISTRAZIONE;
                if (exContRic.VAT_Number__c != lis.PARTITA_IVA && !String.isBlank(lis.PARTITA_IVA)){
                    exContRic.VAT_Number__c = lis.PARTITA_IVA;
                }
                if (!String.isBlank(lis.INDIRIZZO_RESIDENZA)){
                    if (!String.isBlank(lis.CIVICO_RESIDENZA)){
                        exContRic.MailingStreet = lis.INDIRIZZO_RESIDENZA + ',' + lis.CIVICO_RESIDENZA;
                    } else{
                        exContRic.MailingStreet = lis.INDIRIZZO_RESIDENZA;
                    }
                }
                if (fromObjectToBoolean(lis.ALL_PRIVACY, 'flg_privacy_geo') != null)
                    exContRic.Privacy_GEO__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'flg_privacy_geo');
                if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_TERMCOND') != null)
                    exContRic.Flag_Term_Cond__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_TERMCOND');
                if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_CLAUSPEC') != null)
                    exContRic.Flag_Clause_Spec__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_CLAUSPEC');
                if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_LOYALTY') != null)
                    exContRic.Flag_Loyalty__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_LOYALTY');
                if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_PRIVACYPOLICY') != null)
                    exContRic.Flag_Privacy_Policy__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_PRIVACYPOLICY');
                if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_PROFILAZIONE') != null)
                    exContRic.Flag_Profilazione__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_PROFILAZIONE');
                privacyDet = null;
                privacyDet = fromObjectToPrivacyDetails(lis.ALL_PRIVACY, 'FLG_PRIVACY1');
                if (privacyDet != null){
                    exContRic.Flag_Privacy_ENI_Source__c = privacyDet.getSourcePrivacy();
                    exContRic.Flag_Privacy_ENI_DateChange__c = privacyDet.getDateChangePrivacy();
                }
                privacyDet = null;
                privacyDet = fromObjectToPrivacyDetails(lis.ALL_PRIVACY, 'FLG_PRIVACY2');
                if (privacyDet != null){
                    exContRic.Flag_Privacy_Partner_Source__c = privacyDet.getSourcePrivacy();
                    exContRic.Flag_Privacy_Partner_DateChange__c = privacyDet.getDateChangePrivacy();
                }
                privacyDet = null;
                privacyDet = fromObjectToPrivacyDetails(lis.ALL_PRIVACY, 'FG_PRIVACYPOLICY');
                if (privacyDet != null){
                    exContRic.Flag_Privacy_Policy_Source__c = privacyDet.getSourcePrivacy();
                    exContRic.Flag_Privacy_Policy_DateChange__c = privacyDet.getDateChangePrivacy();
                }
                privacyDet = null;


                exContRic.Billing_Fiscal_Code__c = lis.CODICE_FISCALE_FATTURAZIONE;
                exContRic.Plate__c = fromObjectToString(lis.TARGHE); //può essere NULL e cancellare val presistente?????
                exContRic.Gender__c = lis.SESSO;
                exContRic.Billing_Email__c = lis.EMAIL_FATTURAZIONE;

                //controllo ed aggiornamento valori per RET-22025 soft Spam
                // if(exContRic.Flag_Privacy_ENI__c == false && lis.FLG_PRIVACY1 == true && exContRic.ENL_NoSoftSpam__c == true){
                //     exContRic.ENL_NoSoftSpam__c = false;
                //     exContRic.ENL_Data_SoftSpam__c = null;
                // }

                if (!event7ContactsToReconcile.containsKey(exContRic.Fiscal_code__c)){
                    event7ContactsToReconcile.put(exContRic.Fiscal_code__c, exContRic);
                }

                if (!successMap7Reconciliation.containsKey(exContRic.Fiscal_code__c)){
                    successMap7Reconciliation.put(exContRic.Fiscal_code__c, lis.EVENT_ID);
                }

            } else{
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = false;
                result.ERRORCODE = '';
                result.MESSAGE = 'Customer to reconcile does not exist';
                result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Contatto da riconciliare non esistente - errore aggiornamento anagrafica', 'Customer does not exist', String.valueOf(result), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE, null, null, 0, 0, 0, null, lis.PARTITA_IVA, null, null, null, null, null, null);
                logs.add(l);
            }
            // GN - 26-03-2021 fine blocco riconciliazione modifiche App Unica
        } else{
            
                if (existingContacts.containsKey(capitalizedFC) || event1Contacts.containsKey(capitalizedFC) || event7ContactsToReconcile.containsKey(capitalizedFC)){
                    if(event1Contacts.containsKey(capitalizedFC)){
                        exCont = event1Contacts.get(capitalizedFC);
                    }
                    else if(event7ContactsToReconcile.containsKey(capitalizedFC)){
                        exCont = event7ContactsToReconcile.get(capitalizedFC);
                    }
                    else{
                        exCont = existingContacts.get(capitalizedFC);
                    }
                    // if(exCont.isConsumer__c == false && event7ContactsToReconcile.containsKey(capitalizedFC))
                    //     exCont = event7ContactsToReconcile.get(capitalizedFC);
                    /*if(exCont.Fiscal_code__c != lis.CODICE_FISCALE && !String.Isblank(lis.CODICE_FISCALE)){
                     exCont.Fiscal_code__c = lis.CODICE_FISCALE;
                     }*/
                    //exCont.APP_created_date__c = lis.DATA;//???

                    //11-03-2021 rimosso per modifiche App Unica
                    //Check only for BSN
                    /*
                     if (lis.TIPOLOGIA_UTENTE =='1') {
                     if(exCont.Contact_code__c!=lis.CODICE_FISCALE + '_' + lis.PARTITA_IVA
                     && !String.IsBlank(lis.CODICE_FISCALE)
                     && !String.IsBlank(lis.PARTITA_IVA) ){
                     exCont.Contact_code__c = lis.CODICE_FISCALE + '_' + lis.PARTITA_IVA;
                     }
                     }
                     */
                    //Process to manage update from event type 11 -- create customer offer (by Nick 20-05-2021)
                    if ((exCont.Cluster__c != '5' || !exCont.Flag_Loyalty__c) && (lis.CLUSTER == '5' && fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_LOYALTY'))){
                        if (!exCont.Flag_Entry_Offer__c)
                            conFicalCodeToStartBatch.add(capitalizedFC);
                        if ((exCont.Flag_Privacy_ENI__c || lis.FLG_PRIVACY1) && !exCont.Flag_Entry_Gift__c)
                            contactEntryGift.add(capitalizedFC);
                    }
                    //Aggiunto check su Bonus Multicard Easy (G.C. 08/09/21)
                    if ((exCont.Flag_Privacy_ENI__c || lis.FLG_PRIVACY1) && !exCont.Flag_Multi_Easy__c &&                           /*Utils.fromStringArrayToString(lis.MULTICARD)*/fromObjectMulticardToString(lis.MULTICARD).containsIgnoreCase('EASY')){
                        contactMulticardEasy.add(capitalizedFC);
                    }


                    exCont.Customer_type__c = lis.TIPOLOGIA_UTENTE;
                    exCont.Email = lis.INDIRIZZO_EMAIL;
                    exCont.Credit_card_association__c = lis.FG_1;
                    if (lis.FG_1 && !String.isEmpty(lis.CARTA))
                        exCont.Credit_Card_Type__c = lis.CARTA;
                    exCont.Cluster__c = lis.CLUSTER;
                    exCont.Flag_Privacy_ENI__c = lis.FLG_PRIVACY1;
                    exCont.Flag_Privacy_Analysis__c = lis.FLG_PRIVACY1;
                    exCont.Flag_Privacy_Partner__c = lis.FLG_PRIVACY2;
                    exCont.Push_notification__c = lis.FG_NOTIFICA;
                    exCont.MobilePhone = lis.TEL_MOBILE;
                    exCont.Phone = lis.TEL_MOBILE; //????
                    exCont.Business_Name__c = lis.RAGIONE_SOCIALE;
    
                    //check se il contact è un gestore
                    if(existingAnagraficaGestori.get(lis.CODICE_FISCALE.toUpperCase()) != null){
                        exCont.Cluster__c = '0';
                    }

                    // 12-03-2021 aggiunta nuovi campi App Unica
                    exCont.Multicard__c = fromObjectMulticardToString(lis.MULTICARD);  //Utils.fromStringArrayToString(lis.MULTICARD)
                    exCont.Multicard_Wa__c = fromObjectMulticardToStringWithData(lis.MULTICARD);
                    if (lis.MULTICARD != null && lis.MULTICARD.size() == 1){
                        exCont.ENL_Tipo_Multicard_1__c = lis.MULTICARD[0].MULTICARD;
                        exCont.ENL_Data_Inserimento_Multicard_1__c = lis.MULTICARD[0].DATA_INSERIMENTO_MULTICARD;
                    }
                    if (lis.MULTICARD != null && lis.MULTICARD.size() == 2){
                        exCont.ENL_Tipo_Multicard_1__c = lis.MULTICARD[0].MULTICARD;
                        exCont.ENL_Data_Inserimento_Multicard_1__c = lis.MULTICARD[0].DATA_INSERIMENTO_MULTICARD;
                        exCont.ENL_Tipo_Multicard_2__c = lis.MULTICARD[1].MULTICARD;
                        exCont.ENL_Data_Inserimento_Multicard_2__c = lis.MULTICARD[1].DATA_INSERIMENTO_MULTICARD;
                    }
                    if (lis.MULTICARD == null){
                        exCont.ENL_Tipo_Multicard_1__c = null;
                        exCont.ENL_Data_Inserimento_Multicard_1__c = null;
                        exCont.ENL_Tipo_Multicard_2__c = null;
                        exCont.ENL_Data_Inserimento_Multicard_2__c = null;
                    }
                    if (lis.MULTICARD != null && lis.MULTICARD.size() == 1 && exCont.ENL_Tipo_Multicard_1__c != null && exCont.ENL_Tipo_Multicard_2__c != null){
                        if (lis.MULTICARD[0].MULTICARD == exCont.ENL_Tipo_Multicard_1__c){
                            exCont.ENL_Tipo_Multicard_2__c = null;
                            exCont.ENL_Data_Inserimento_Multicard_2__c = null;
                        } else{
                            exCont.ENL_Tipo_Multicard_1__c = null;
                            exCont.ENL_Data_Inserimento_Multicard_1__c = null;
                        }
                    }
                    //exCont.Residence_Address__c = lis.INDIRIZZO_RESIDENZA;
                    //exCont.Vehicle_Description__c = lis.DESCRIZIONE_VEICOLO;
                    exCont.Consumer_Billing_Address__c = lis.INDIRIZZO_FATTURAZIONE_PRIVATI;
                    exCont.Consumer_Billing_City__c = lis.CITTA_FATTURAZIONE_PRIVATI;
                    exCont.Consumer_Billing_First_Name__c = lis.NOME_FATTURAZIONE_PRIVATI;
                    exCont.Consumer_Billing_Last_Name__c = lis.COGNOME_FATTURAZIONE_PRIVATI;
                    exCont.Consumer_Billing_Postal_Code__c = lis.CAP_FATTURAZIONE_PRIVATI;
                    exCont.Consumer_Billing_Region__c = lis.PROVINCIA_FATTURAZIONE_PRIVATI;
                    exCont.Consumer_Billing_Street_Number__c = lis.CIVICO_FATTURAZIONE_PRIVATI;
                    //exCont.MailingStreet = lis.INDIRIZZO_RESIDENZA + ' ' + lis.CIVICO_RESIDENZA;
                    exCont.MailingPostalCode = lis.CAP_RESIDENZA;
                    exCont.MailingCity = lis.CITTA_RESIDENZA;
                    exCont.MailingState = lis.PROVINCIA_RESIDENZA;
                    // exCont.Residence_Street_Number__c = lis.CIVICO_RESIDENZA;
                    // exCont.Residence_Postal_Code__c = lis.CAP_RESIDENZA;
                    // exCont.Residence_City__c = lis.CITTA_RESIDENZA;
                    // exCont.Residence_Region__c = lis.PROVINCIA_RESIDENZA;
                    // fine nuovi campi App Unica
                    exCont.Billing_Address__c = lis.INDIRIZZO_FATTURAZIONE;
                    exCont.Billing_Street_Number__c = lis.CIVICO_FATTURAZIONE;
                    exCont.Billing_City__c = lis.CITTA_FATTURAZIONE;
                    exCont.Billing_Region__c = lis.PROVINCIA_FATTURAZIONE;
                    exCont.Billing_Country__c = lis.NAZIONE_FATTURAZIONE;
                    exCont.Billing_Postal_Code__c = lis.CAP_FATTURAZIONE;
                    exCont.Billing_First_Name__c = lis.NOME_FATTURAZIONE;
                    exCont.Billing_Last_Name__c = lis.COGNOME_FATTURAZIONE;
                    exCont.PEC_Email__c = lis.PEC_EMAIL;
                    exCont.SDI_Code__c = lis.SDI_CODE;

                    if (lis.CANALE_REGISTRAZIONE != null)
                        exCont.ENL_Canale_Registrazione__c = lis.CANALE_REGISTRAZIONE;
                    if (!String.isBlank(lis.INDIRIZZO_RESIDENZA)){
                        if (!String.isBlank(lis.CIVICO_RESIDENZA)){
                            exCont.MailingStreet = lis.INDIRIZZO_RESIDENZA + ',' + lis.CIVICO_RESIDENZA;
                        } else{
                            exCont.MailingStreet = lis.INDIRIZZO_RESIDENZA;
                        }
                    }
                    if (fromObjectToBoolean(lis.ALL_PRIVACY, 'flg_privacy_geo') != null)
                        exCont.Privacy_GEO__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'flg_privacy_geo');
                    if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_TERMCOND') != null)
                        exCont.Flag_Term_Cond__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_TERMCOND');
                    if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_CLAUSPEC') != null)
                        exCont.Flag_Clause_Spec__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_CLAUSPEC');
                    if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_LOYALTY') != null)
                        exCont.Flag_Loyalty__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_LOYALTY');
                    if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_PRIVACYPOLICY') != null)
                        exCont.Flag_Privacy_Policy__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_PRIVACYPOLICY');
                    if (fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_PROFILAZIONE') != null)
                        exCont.Flag_Profilazione__c = fromObjectToBoolean(lis.ALL_PRIVACY, 'FG_PROFILAZIONE');
                    privacyDet = null;
                    privacyDet = fromObjectToPrivacyDetails(lis.ALL_PRIVACY, 'FLG_PRIVACY1');
                    if (privacyDet != null){
                        exCont.Flag_Privacy_ENI_Source__c = privacyDet.getSourcePrivacy();
                        exCont.Flag_Privacy_ENI_DateChange__c = privacyDet.getDateChangePrivacy();
                    }
                    privacyDet = null;
                    privacyDet = fromObjectToPrivacyDetails(lis.ALL_PRIVACY, 'FLG_PRIVACY2');
                    if (privacyDet != null){
                        exCont.Flag_Privacy_Partner_Source__c = privacyDet.getSourcePrivacy();
                        exCont.Flag_Privacy_Partner_DateChange__c = privacyDet.getDateChangePrivacy();
                    }
                    privacyDet = null;
                    privacyDet = fromObjectToPrivacyDetails(lis.ALL_PRIVACY, 'FG_PRIVACYPOLICY');
                    if (privacyDet != null){
                        exCont.Flag_Privacy_Policy_Source__c = privacyDet.getSourcePrivacy();
                        exCont.Flag_Privacy_Policy_DateChange__c = privacyDet.getDateChangePrivacy();
                    }
                    privacyDet = null;


                    if (exCont.VAT_Number__c != lis.PARTITA_IVA && !String.isBlank(lis.PARTITA_IVA)){
                        exCont.VAT_Number__c = lis.PARTITA_IVA;
                    }

                    exCont.Billing_Fiscal_Code__c = lis.CODICE_FISCALE_FATTURAZIONE;
                    exCont.Plate__c = fromObjectToString(lis.TARGHE); //può essere NULL e cancellare val presistente?????
                    exCont.Gender__c = lis.SESSO;
                    exCont.Billing_Email__c = lis.EMAIL_FATTURAZIONE;

                    //controllo ed aggiornamento valori per RET-22025 soft Spam
                    // if(exCont.Flag_Privacy_ENI__c == false && lis.FLG_PRIVACY1 == true && exCont.ENL_NoSoftSpam__c == true){
                    //     exCont.ENL_NoSoftSpam__c = false;
                    //     exCont.ENL_Data_SoftSpam__c = null;
                    // }
                }

                if (exCont != null){
                    if (!event7ContactsToUpdate.containsKey(capitalizedFC)){
                        event7ContactsToUpdate.put(capitalizedFC, exCont);
                    }
                    if (!successMap7.containsKey(capitalizedFC)){
                        successMap7.put(capitalizedFC, lis.EVENT_ID);
                    }


                    // End

                } else{
                    Result_NotifyEvent result = new Result_NotifyEvent();

                    result.SUCCESS = false;
                    result.ERRORCODE = '';
                    result.MESSAGE = 'Customer does not exist';
                    result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD

                    ws.Result_NotifyEvent.add(result);
                    Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Contatto non esistente - errore aggiornamento anagrafica', 'Customer does not exist', String.valueOf(result), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE, null, null, 0, 0, 0, null, lis.PARTITA_IVA, null, null, null, null, null, null);
                    logs.add(l);

                }
            
        }
    }

    private static void initializeEvent8(WS_ENIInteract.Request_NotifyEvent lis, WS_ENIInteract.Response_NotifyEvent ws){
        Contact exCont;
        if (existingContacts.containsKey(capitalizedFC)){
            exCont = existingContacts.get(capitalizedFC);

            exCont.Cancellation_Date__c = lis.DATA;
            exCont.CancellaTion_Request_Origin__C = lis.ORIGINE_RICHIESTA;
            exCont.CancellaTion_Type__c = lis.TIPOLOGIA_CANCELLAZIONE;
            exCont.CLuster__c = lis.CLUSTER;
            exCont.Credit_card_association__c = lis.FG_1;

            // Manage Contact cancellation by TIPOLOGIA_CANCELLAZIONE
            Utils.contactCancellation(exCont, lis.TIPOLOGIA_CANCELLAZIONE, lis.ORIGINE_RICHIESTA);
        }

        if (exCont != null){
            if (!event8ContactsToUpdate.containsKey(capitalizedFC)){
                event8ContactsToUpdate.put(capitalizedFC, exCont);
            }
            if (!successMap8.containsKey(capitalizedFC)){
                successMap8.put(capitalizedFC, lis.EVENT_ID);
            }

        } else{
            Result_NotifyEvent result = new Result_NotifyEvent();

            result.SUCCESS = false;
            result.ERRORCODE = '';
            result.MESSAGE = 'Customer does not exist';
            result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD

            ws.Result_NotifyEvent.add(result);
            Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Contatto non esistente', 'Customer does not exist', String.valueOf(result), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE, null, null, 0, 0, 0, null, lis.PARTITA_IVA, null, null, null, lis.DATA, lis.ORIGINE_RICHIESTA, lis.TIPOLOGIA_CANCELLAZIONE);
            logs.add(l);

        }
    }

    private static void initializeEvent9(WS_ENIInteract.Request_NotifyEvent lis, WS_ENIInteract.Response_NotifyEvent ws){
        Contact exCont;
        if (existingContacts.containsKey(capitalizedFC)){
            exCont = existingContacts.get(capitalizedFC);

            exCont.Blacklist__c = lis.BLACKLIST;
            exCont.Blacklist_Reason__c = (lis.BLACKLIST) ? lis.CAUSALE_BLACKLIST : NULL;
            exCont.Blacklist_Date__c = (lis.BLACKLIST) ? lis.DATA : NULL;
        }

        if (exCont != null){
            if (!event9ContactsToUpdate.containsKey(capitalizedFC)){
                event9ContactsToUpdate.put(capitalizedFC, exCont);
            }
            if (!successMap9.containsKey(capitalizedFC)){
                successMap9.put(capitalizedFC, lis.EVENT_ID);
            }

        } else{
            Result_NotifyEvent result = new Result_NotifyEvent();

            result.SUCCESS = false;
            result.ERRORCODE = '';
            result.MESSAGE = 'Customer does not exist';
            result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD

            ws.Result_NotifyEvent.add(result);
            Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Contatto non esistente', 'Customer does not exist', String.valueOf(result), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE, null, null, 0, 0, 0, null, lis.PARTITA_IVA, null, null, null, null, null, null);
            logs.add(l);

        }
    }

    private static void initializeEvent10(WS_ENIInteract.Request_NotifyEvent lis, WS_ENIInteract.Response_NotifyEvent ws){
        Customer_Offer__c exCoff;

        if (existingCustomerOffer.containsKey(lis.OPERATION_ID) && existingCustomerOffer.get(lis.OPERATION_ID).Fiscal_code__c.equals(lis.CODICE_FISCALE)){
            exCoff = existingCustomerOffer.get(lis.OPERATION_ID);

            exCoff.ENL_Lottery_Timestamp_Tap__c = lis.TIMESTAMP_TAP;
        }

        if (exCoff != null){
            if (!event10CustomerOfferToUpdate.containsKey(lis.OPERATION_ID)){
                event10CustomerOfferToUpdate.put(lis.OPERATION_ID, exCoff);
            }
            if (!successMap10.containsKey(lis.OPERATION_ID)){
                successMap10.put(lis.OPERATION_ID, lis.EVENT_ID);
            }

        } else{
            Result_NotifyEvent result = new Result_NotifyEvent();

            result.SUCCESS = false;
            result.ERRORCODE = '';
            result.MESSAGE = 'Customer Offer does not exist';
            result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD

            ws.Result_NotifyEvent.add(result);
            Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Customer Offer non esistente', 'Customer Offer', String.valueOf(result), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE, null, null, 0, 0, 0, null, lis.PARTITA_IVA, null, null, null, null, null, null);
            logs.add(l);

        }
    }

    private static void initializeEvent11(WS_ENIInteract.Request_NotifyEvent lis){
        Contact con = null;
        Id recordTypeLead = Utils.getRecordTypeId('ENL_Lead_Gestore', 'Contact');
        String codiceFisc = lis.CODICE_FISCALE.toUpperCase();
        system.debug('codiceFisc:::: '+codiceFisc);
        String contactMail = lis.INDIRIZZO_EMAIL.toLowerCase();
        //eventId=lis.EVENT_ID; 
        if (existingLeadsByEmail != null){
            System.debug('existingLeadsByEmail: ' + existingLeadsByEmail);
            con = existingLeadsByEmail.get(lis.INDIRIZZO_EMAIL.toLowerCase());//inserire ev 11-12 nella query
            System.debug('Sono nell if existingLeadsByEmail diverso da null');
            System.debug('con: ' + con);
        }
        if (con != null && con.RecordTypeId == Utils.getRecordTypeId('ENL_Lead_Gestore', 'Contact')){
            if (String.isBlank(con.List_Type_Lead__c)){
                con.List_Type_Lead__c = 'Preregistrato';
                System.debug('sono nell if con diverso da null e contenente Preregistrato');
            } else{
                System.debug('sono nell if con diverso da null senza Preregistrato');
                List<String> picklistValues = new List<String>();
                picklistValues.addAll(con.List_Type_Lead__c.split(';'));
                System.debug('picklistValues: ' + picklistValues);
                if (!picklistValues.contains('Preregistrato')){
                    picklistValues.add('Preregistrato');
                    con.List_Type_Lead__c = String.join(picklistValues, ';');
                }

            }
            if (!event11ContactsToUpdate.containsKey(contactMail)){
                event11ContactsToUpdate.put(contactMail, con);
                System.debug('event11ContactsToUpdate: ' + event11ContactsToUpdate);
            }
            if (!successMap11ToUpdate.containsKey(contactMail)){
                successMap11ToUpdate.put(contactMail, lis.EVENT_ID);
            }
        } else{
            con = new Contact(Fiscal_code__c = codiceFisc, RecordTypeId = recordTypeLead, Data_Preregistrazione__c = lis.DATA, FirstName = lis.NOME, LastName = lis.COGNOME, Email = lis.INDIRIZZO_EMAIL, Birthdate = lis.DATA_DI_NASCITA,                               //
            MobilePhone = lis.TEL_MOBILE,                               //
            Phone = lis.TEL_MOBILE,                               //
            Contact_Code__c = codiceFisc, 
            //Residence_Address__c = lis.INDIRIZZO_RESIDENZA,//
            Birth_City__c = lis.COMUNE_NASCITA,                               //
            Birth_Region__c = lis.PROVINCIA_NASCITA,                               //
            //MailingStreet = lis.INDIRIZZO_RESIDENZA + ' ' + lis.CIVICO_RESIDENZA,
            MailingPostalCode = lis.CAP_RESIDENZA, MailingCity = lis.CITTA_RESIDENZA, MailingState = lis.PROVINCIA_RESIDENZA, 
            //   Residence_Street_Number__c = lis.CIVICO_RESIDENZA,
            //   Residence_Postal_Code__c = lis.CAP_RESIDENZA,
            //   Residence_City__c = lis.CITTA_RESIDENZA,
            //   Residence_Region__c = lis.PROVINCIA_RESIDENZA,
            Flag_Privacy_ENI__c = lis.FLG_PRIVACY1, ENL_Is_Lead__c = true, APP_loyalty_customer__c = NULL, 
            // GN - 15/07/2021 - Campi aggiunti all'evento 11 per reportistica pre-registrazione
            //ENL_Service_Station_Code__c = lis.IMPIANTO
            Id_Gestione__c = lis.ID_GESTIONE, List_Type_Lead__c = 'Preregistrato');

            if (ssMap.containsKey(lis.IMPIANTO)){
                con.ENL_Service_Station_Code__c = ssMap.get(lis.IMPIANTO).Id;
            }


            if (!String.isBlank(lis.INDIRIZZO_RESIDENZA)){
                if (!String.isBlank(lis.CIVICO_RESIDENZA)){
                    con.MailingStreet = lis.INDIRIZZO_RESIDENZA + ',' + lis.CIVICO_RESIDENZA;
                } else{
                    con.MailingStreet = lis.INDIRIZZO_RESIDENZA;
                }
            }

            if (!event11ContactsToInsert.containsKey(codiceFisc)){
                event11ContactsToInsert.put(codiceFisc, con);
                 system.debug('---------------------------------------------');
            system.debug('event11ContactsToInsert:::::: '+ event11ContactsToInsert.values());
             system.debug('---------------------------------------------');
            }

            
            if (!successMap11.containsKey(capitalizedFC)){
                successMap11.put(codiceFisc, lis.EVENT_ID);
            }
        }
    }

    private static void initializeEvent12(WS_ENIInteract.Request_NotifyEvent lis){
        Id recordTypeLead = Utils.getRecordTypeId('ENL_Lead_Gestore', 'Contact');
        String codiceFisc = '';
        String contactMail = lis.INDIRIZZO_EMAIL;
        Contact con = null;
        if (existingLeadsByEmail != null){
            con = existingLeadsByEmail.get(lis.INDIRIZZO_EMAIL);
        }
        if (con != null && con.RecordTypeId != Utils.getRecordTypeId('Customer', 'Contact')){
            if (String.isBlank(con.List_Type_Lead__c)){
                con.List_Type_Lead__c = 'Epipoli';
                System.debug('sono nell if con diverso da null e contenente Preregistrato');
            } else{
                System.debug('sono nell if con diverso da null senza Preregistrato');
                List<String> picklistValues = new List<String>();
                picklistValues.addAll(con.List_Type_Lead__c.split(';'));
                System.debug('picklistValues: ' + picklistValues);
                if (!picklistValues.contains('Epipoli')){
                    picklistValues.add('Epipoli');
                    con.List_Type_Lead__c = String.join(picklistValues, ';');
                }
            }
            if (!event12ContactsToUpdate.containsKey(contactMail)){
                event12ContactsToUpdate.put(contactMail, con);
            }
            if (!successMap12ToUpdate.containsKey(contactMail)){
                successMap12ToUpdate.put(contactMail, lis.EVENT_ID);
            }
        } else{
            if (String.isBlank(lis.CODICE_FISCALE)){
                //codiceFisc = lis.CODICE_FISCALE.toUpperCase();
                String email = lis.INDIRIZZO_EMAIL.toUpperCase();
                eventId = lis.EVENT_ID;
                voucherInitilizeMap.put(email.toUpperCase(), new voucherValues(lis.CODICE_BUONO.toUpperCase(), lis.ESITO_BUONO.toUpperCase()));
                con = new Contact(Fiscal_code__c = codiceFisc, RecordTypeId = recordTypeLead, 
                //APP_created_date__c = lis.DATA,
                Data_Preregistrazione__c = lis.DATA, FirstName = lis.NOME, LastName = lis.COGNOME, Email = lis.INDIRIZZO_EMAIL, 
                // Birthdate = lis.DATA_DI_NASCITA,//
                MobilePhone = lis.TEL_MOBILE,                               //
                Phone = lis.TEL_MOBILE,                               //
                Contact_Code__c = email, 
                // Residence_Address__c = lis.INDIRIZZO_RESIDENZA,
                // Birth_City__c = lis.COMUNE_NASCITA,//
                // Birth_Region__c = lis.PROVINCIA_NASCITA,//
                Flag_Privacy_ENI__c = lis.FLG_PRIVACY1 != null ? lis.FLG_PRIVACY1 : false, ENL_Is_Lead__c = true, Sync_with_marketing_cloud__c = true, List_Type_Lead__c = 'Epipoli');

                if (!event12ContactsToInsert.containsKey(email)){
                    event12ContactsToInsert.put(email, con);
                }
                if (!successMap12.containsKey(email)){
                    successMap12.put(email, lis.EVENT_ID);
                }
            } else{
                voucherInitilizeMap2.put(lis.CODICE_FISCALE.toUpperCase(), new voucherValues(lis.CODICE_BUONO.toUpperCase(), lis.ESITO_BUONO.toUpperCase()));
                ListFiscalCodeList.add(lis.CODICE_FISCALE.toUpperCase());
                eventIdMap.put(lis.CODICE_FISCALE.toUpperCase(), lis.EVENT_ID);
            }
        }
    }

    private static void initializeEvent13(WS_ENIInteract.Request_NotifyEvent lis){
        Contact con;
        //if(mandatoryPresent(lis, '1')) {
        con = new Contact(Fiscal_code__c = lis.CODICE_FISCALE, APP_created_date__c = lis.DATA, FirstName = lis.NOME, LastName = lis.COGNOME, Email = lis.INDIRIZZO_EMAIL, Birthdate = lis.DATA_DI_NASCITA, Push_Notification__c = lis.FG_NOTIFICA, Credit_Card_Type__c = lis.CARTA, Cluster__c = lis.CLUSTER, Flag_Privacy_ENI__c = lis.FLG_PRIVACY1, Flag_Privacy_Analysis__c = lis.FLG_PRIVACY1, Flag_Privacy_Partner__c = lis.FLG_PRIVACY2, MobilePhone = lis.TEL_MOBILE, Phone = lis.TEL_MOBILE, Enabled__c = true, RecordTypeId = rtContactMap.get('0'), Gender__c = lis.SESSO, 
        //EN: nuovo attributo TIPOLOGIA UTENTE
        Customer_Type__c = lis.TIPOLOGIA_UTENTE, 
        //RET20015 Nuova Loyalty ENICCM-146
        Billing_Address__c = lis.INDIRIZZO_FATTURAZIONE, Billing_Street_Number__c = lis.CIVICO_FATTURAZIONE, Billing_City__c = lis.CITTA_FATTURAZIONE, Billing_Region__c = lis.PROVINCIA_FATTURAZIONE, Billing_Country__c = lis.NAZIONE_FATTURAZIONE, Billing_Postal_Code__c = lis.CAP_FATTURAZIONE, Billing_First_Name__c = lis.NOME_FATTURAZIONE, Billing_Last_Name__c = lis.COGNOME_FATTURAZIONE, PEC_Email__c = lis.PEC_EMAIL, Billing_Fiscal_Code__c = lis.CODICE_FISCALE_FATTURAZIONE, Billing_Email__c = lis.EMAIL_FATTURAZIONE, Birth_City__c = lis.COMUNE_NASCITA, Birth_Region__c = lis.PROVINCIA_NASCITA, Cancellation_Date__c = NULL, Cancellation_Type__c = NULL, Cancellation_Request_Origin__c = NULL);
        if (!existingContactsOld.containsKey(capitalizedFC + '_' + rtContactMap.get(lis.TIPOLOGIA_UTENTE))){
            con.Contact_code__c = lis.CODICE_FISCALE;
        } else{
            con.Contact_code__c = existingContactsOld.get(capitalizedFC + '_' + rtContactMap.get(lis.TIPOLOGIA_UTENTE)).Contact_code__c;
        }

        if (!String.isEmpty(lis.CARTA)){
            con.Card_Association_Date__c = Date.valueOf(lis.DATA);
            con.Credit_card_association__c = lis.FG_1;
        }

        //commentato per dismissione loyalty_card 24/02/23
        /*
        if (!String.isEmpty(lis.NUM_CARTA_LOYALTY)){
            loyaltyCardNumbers.put(capitalizedFC, lis.NUM_CARTA_LOYALTY);
        }
        */
        if (!event13Contacts.containsKey(capitalizedFC)){
            event13Contacts.put(capitalizedFC, con);
        }
        if (!successMap13.containsKey(capitalizedFC)){
            successMap13.put(capitalizedFC, lis.EVENT_ID);
        }
    }

    // private static void initializeEvent12(WS_ENIInteract.Request_NotifyEvent lis){
    //     Id recordTypeLead = Utils.getRecordTypeId('ENL_Lead_Gestore', 'Contact');
    //     if(lis.CODICE_FISCALE != null && String.isNotBlank(lis.CODICE_FISCALE))
    //     String codiceFisc = lis.CODICE_FISCALE.toUpperCase();
    //         Contact con = new Contact(RecordTypeId = recordTypeLead,
    //                           FirstName = lis.NOME,
    //                           LastName = lis.COGNOME,
    //                           Email = lis.INDIRIZZO_EMAIL,
    //                           MobilePhone = lis.TEL_MOBILE,//
    //                           Phone = lis.TEL_MOBILE,//
    //                           Flag_Privacy_ENI__c = lis.FLG_PRIVACY1,
    //                           ENL_Is_Lead__c = true
    //         );
    //         if(!event11ContactsToInsert.containsKey(codiceFisc)){
    //             event11ContactsToInsert.put(codiceFisc, con);
    //         }
    // }
    private static void initializeEvent14(WS_ENIInteract.Request_NotifyEvent lis, WS_ENIInteract.Response_NotifyEvent ws){
        //EN: sia per il cliente P.IVA che non, dovra essere creata una carta
        //successivamente associata alla transazione
        //commentato per dismissione loyalty_card 24/02/23
        /*
        Loyalty_card__c loy;
        if (!String.isEmpty(lis.NUM_CARTA_LOYALTY)){
            loy = existingCardsOld.get(lis.NUM_CARTA_LOYALTY.toUpperCase());
        } else{
            loy = existingCardsOld.get(lis.CODICE_FISCALE.toUpperCase());
        }
        system.debug('loy #304 : ' + loy);
        */
        // RET20015 Nuova Loyalty ENICCM-146 : loyalty card no more mandatory

        //if(loy != null){
        Contact con = existingContactsOld.get(capitalizedFC + '_' + rtContactMap.get(lis.TIPOLOGIA_UTENTE));
        //GC 01/04/2019
        //WS_ENIInteract.updateContactData(lis.EVENT_TYPE, lis.CLUSTER, lis.FG_NOTIFICA, lis.FLG_PRIVACY1, lis.FLG_PRIVACY2, lis.FG_1, con);

        //AN 06/06/2019
        if (con != null){
            if (lis.EVENT_TYPE == '14'){
                con.EniStation_APP_payment__c = true;
                /*if(lis.TARGA != NULL && lis.TARGA.size() > 0) {
                 con.Plate__c = Utils.fromStringArrayToString(lis.TARGA);
                 }*/
            }
            otherContactsOld.put(capitalizedFC + '_' + rtContactMap.get(lis.TIPOLOGIA_UTENTE), con);

            //END GC 01/04/2019
            Transaction__c tr = new Transaction__c(Name = lis.TRANSACTION_ID, Transaction_Id__c = lis.TRANSACTION_ID, Transaction_Date__c = lis.DATA, Service_Station_Code__c = lis.IMPIANTO, Product_Type__c = lis.PRODOTTO, EniStation_APP_payment__c = lis.FLAG_PAGAMENTO, Contact__c = (con != null) ? con.ID : NULL,/*commentato per dismissione loyalty_card 24/02/23 Loyalty_Card__c = (loy != null) ? loy.Id : NULL*/ EniStation_App_Payment_Mode__c = lis.MODALITA_PAGAMENTO, Flag_Privacy_1__c = (con != null) ? con.Flag_Privacy_ENI__c : FALSE, Flag_Privacy_2__c = (con != null) ? con.Flag_Privacy_Partner__c : FALSE, Cluster__c = (con != null) ? con.Cluster__c : NULL, Push_Notification__c = (con != null) ? con.Push_notification__c : FALSE, Card_Type__c = (con != null) ? con.Credit_Card_Type__c : NULL, Amount__c = lis.IMPORTO, Refueling_Mode__c = lis.MODALITA_OPERATIVA, Total_Points__c = lis.PUNTI, Liters__c = lis.LITRI, EVENT_TYPE__c = lis.EVENT_TYPE, EVENT_ID__c = lis.EVENT_ID, Customer_Type__c = lis.TIPOLOGIA_UTENTE, 
            //RET20015 Nuova Loyalty ENICCM-146
            Kwh__c = lis.KWH, Time__c = lis.DURATA, Recarge_Type__c = lis.TIPOLOGIA_RICARICA, ENL_Service_Type__c = lis.TIPOLOGIA_SERVIZO, ENL_Start_Date__c = lis.DATA_INIZIO, ENL_End_Date__c = lis.DATA_FINE, ENL_Transaction_Locked__c = lis.BLOCCO_ANTIFRODE, ENL_Transaction_Code__c = lis.CODICE_TRANSAZIONE, ENL_Disabled_Service_Station__c = lis.IMPIANTO_NON_ABILITATO, ECU_offerCondition__c = lis.PARAMETER1);

            if (lis.TARGA != NULL && lis.TARGA.size() > 0){
                tr.Plate__c = Utils.fromStringArrayToString(lis.TARGA);
            }

            // RET20015 Nuova Loyalty ENICCM-146
            // il Transaction_ID ora è quello generato e propagato dal BE dell'App
            //    tr.Transaction_Id__c = lis.EVENT_ID; //come comunicato da techedge:
            //il requestId sarà una stringa alfanumerica generata
            //casualmente che resterà univoca nel tempo
            if (!newTransactionsOld.containsKey(tr.Transaction_Id__c) && !existingTransactionsOld.containsKey(tr.Transaction_Id__c)){
                newTransactionsOld.put(tr.Transaction_Id__c, tr);
                transactionsSucessMapOld.put(tr.Transaction_Id__c, lis.EVENT_ID);
            }

            system.debug(tr);
        } else{
            Result_NotifyEvent result = new Result_NotifyEvent();

            result.SUCCESS = false;
            result.ERRORCODE = '';
            result.MESSAGE = 'Error when creating Transaction';
            result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD

            ws.Result_NotifyEvent.add(result);
            Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore nella creazione della transazione' + 
                            ' per mancanza di un Contact da associare', 'Error when creating Transaction', String.valueOf(result), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE,/*commentato per dismissione loyalty_card 24/02/23 numCartaLoyalty*/ '', lis.PRODOTTO, lis.LITRI, lis.IMPORTO, lis.PUNTI, lis.MODALITA_OPERATIVA, lis.PARTITA_IVA, Utils.fromStringArrayToString(lis.TARGA), lis.TIPOLOGIA_UTENTE, lis.CARTA);
            logs.add(l);
            system.debug('Log event 3 ' + logs);
        }
    }

    private static void initializeEvent15(WS_ENIInteract.Request_NotifyEvent lis){

        Contact con = new Contact(Fiscal_code__c = lis.CODICE_FISCALE, APP_created_date__c = lis.DATA, FirstName = lis.NOME, LastName = lis.COGNOME, Email = lis.INDIRIZZO_EMAIL, Birthdate = lis.DATA_DI_NASCITA, Push_Notification__c = lis.FG_NOTIFICA, Credit_Card_Type__c = lis.CARTA, Cluster__c = lis.CLUSTER, Flag_Privacy_ENI__c = lis.FLG_PRIVACY1, Flag_Privacy_Analysis__c = lis.FLG_PRIVACY1, Flag_Privacy_Partner__c = lis.FLG_PRIVACY2, MobilePhone = lis.TEL_MOBILE, Phone = lis.TEL_MOBILE, Enabled__c = true, Contact_code__c = lis.CODICE_FISCALE + '_' + lis.PARTITA_IVA, RecordTypeId = rtContactMap.get('1'), 
        //EN : attributi fatturazione
        Customer_type__c = lis.TIPOLOGIA_UTENTE, Business_Name__c = lis.RAGIONE_SOCIALE, Billing_Address__c = lis.INDIRIZZO_FATTURAZIONE, Billing_Street_Number__c = lis.CIVICO_FATTURAZIONE, Billing_City__c = lis.CITTA_FATTURAZIONE, Billing_Region__c = lis.PROVINCIA_FATTURAZIONE, Billing_Country__c = lis.NAZIONE_FATTURAZIONE, Billing_Postal_Code__c = lis.CAP_FATTURAZIONE, Billing_First_Name__c = lis.NOME_FATTURAZIONE, Billing_Last_Name__c = lis.COGNOME_FATTURAZIONE, PEC_Email__c = lis.PEC_EMAIL, SDI_Code__c = lis.SDI_CODE, VAT_Number__c = lis.PARTITA_IVA, Billing_Fiscal_Code__c = lis.CODICE_FISCALE_FATTURAZIONE, Gender__c = lis.SESSO, 
        //RET20015 Nuova Loyalty ENICCM-146
        Birth_City__c = lis.COMUNE_NASCITA, Birth_Region__c = lis.PROVINCIA_NASCITA);


        if (!String.isEmpty(lis.CARTA)){
            con.Card_Association_Date__c = Date.valueOf(lis.DATA);
            con.Credit_card_association__c = lis.FG_1;
        }

        if (!eventPIVAContacts.containsKey(capitalizedFC) && !existingContacts.containsKey(capitalizedFC + '_' + rtContactMap.get(lis.TIPOLOGIA_UTENTE))){
            eventPIVAContacts.put(capitalizedFC, con);
            successPIVAMap.put(capitalizedFC, lis.EVENT_ID);
        }
    }

    private static void initializeEvent16(WS_ENIInteract.Request_NotifyEvent lis, WS_ENIInteract.Response_NotifyEvent ws){
        Contact exCont = null;
        if (existingContactsOld.containsKey(capitalizedFC + '_' + rtContactMap.get(lis.TIPOLOGIA_UTENTE))){
            exCont = existingContactsOld.get(capitalizedFC + '_' + rtContactMap.get(lis.TIPOLOGIA_UTENTE));
            /*if(exCont.Fiscal_code__c != lis.CODICE_FISCALE && !String.Isblank(lis.CODICE_FISCALE)){
             exCont.Fiscal_code__c = lis.CODICE_FISCALE;
             }*/
            exCont.APP_created_date__c = lis.DATA;//???

            //Check only for BSN
            if (lis.TIPOLOGIA_UTENTE == '1'){
                if (exCont.Contact_code__c != lis.CODICE_FISCALE + '_' + lis.PARTITA_IVA && !String.IsBlank(lis.CODICE_FISCALE) && !String.IsBlank(lis.PARTITA_IVA)){
                    exCont.Contact_code__c = lis.CODICE_FISCALE + '_' + lis.PARTITA_IVA;
                }
            }
            //exCont.Customer_type__c = lis.TIPOLOGIA_UTENTE;
            exCont.Email = lis.INDIRIZZO_EMAIL;
            exCont.Credit_card_association__c = lis.FG_1;
            if (lis.FG_1 && !String.isEmpty(lis.CARTA))
                exCont.Credit_Card_Type__c = lis.CARTA;
            exCont.Cluster__c = lis.CLUSTER;
            exCont.Flag_Privacy_ENI__c = lis.FLG_PRIVACY1;
            exCont.Flag_Privacy_Analysis__c = lis.FLG_PRIVACY1;
            exCont.Flag_Privacy_Partner__c = lis.FLG_PRIVACY2;
            exCont.Push_notification__c = lis.FG_NOTIFICA;
            exCont.MobilePhone = lis.TEL_MOBILE;
            exCont.Phone = lis.TEL_MOBILE; //????
            exCont.Business_Name__c = lis.RAGIONE_SOCIALE;
            exCont.Billing_Address__c = lis.INDIRIZZO_FATTURAZIONE;
            exCont.Billing_Street_Number__c = lis.CIVICO_FATTURAZIONE;
            exCont.Billing_City__c = lis.CITTA_FATTURAZIONE;
            exCont.Billing_Region__c = lis.PROVINCIA_FATTURAZIONE;
            exCont.Billing_Country__c = lis.NAZIONE_FATTURAZIONE;
            exCont.Billing_Postal_Code__c = lis.CAP_FATTURAZIONE;
            exCont.Billing_First_Name__c = lis.NOME_FATTURAZIONE;
            exCont.Billing_Last_Name__c = lis.COGNOME_FATTURAZIONE;
            exCont.PEC_Email__c = lis.PEC_EMAIL;
            exCont.SDI_Code__c = lis.SDI_CODE;
            if (exCont.VAT_Number__c != lis.PARTITA_IVA && !String.isBlank(lis.PARTITA_IVA)){
                exCont.VAT_Number__c = lis.PARTITA_IVA;
            }

            exCont.Billing_Fiscal_Code__c = lis.CODICE_FISCALE_FATTURAZIONE;
            exCont.Plate__c = Utils.fromStringArrayToString(lis.TARGA); //può essere NULL e cancellare val presistente?????
            exCont.Gender__c = lis.SESSO;
            exCont.Billing_Email__c = lis.EMAIL_FATTURAZIONE;
        }
        if (exCont != null){
            if (!event16ContactsToUpdate.containsKey(capitalizedFC)){
                event16ContactsToUpdate.put(capitalizedFC, exCont);
            }
            if (!successMap16.containsKey(capitalizedFC)){
                successMap16.put(capitalizedFC, lis.EVENT_ID);
            }
        } else{
            Result_NotifyEvent result = new Result_NotifyEvent();

            result.SUCCESS = false;
            result.ERRORCODE = '';
            result.MESSAGE = 'Customer does not exist';
            result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD

            ws.Result_NotifyEvent.add(result);
            Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Contatto non esistente - errore aggiornamento anagrafica', 'Customer does not exist', String.valueOf(result), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE, null, null, 0, 0, 0, null, lis.PARTITA_IVA, null, lis.TIPOLOGIA_UTENTE, null, null, null, null);
            logs.add(l);
        }
    }

    private static void initializeEvent17(WS_ENIInteract.Request_NotifyEvent req, WS_ENIInteract.Response_NotifyEvent res){
        Contact cont = existingContacts.get(capitalizedFC);
        if (cont != null){
            // if(lis.EVENT_TYPE == '3')
            //     con.EniStation_APP_payment__c = true;
            //otherContactsEvent17.put(capitalizedFC, cont);
            Transaction__c trans = new Transaction__c(Transaction_Date__c = req.DATA, ENL_Service_Type__c = req.TIPOLOGIA_SERVIZO, Product_Type__c = req.PRODOTTO, Amount__c = req.IMPORTO, Plate__c = fromObjectToPlate(req.TARGHE), ENL_Start_Date__c = req.DATA_INIZIO, Transaction_Id__c = req.TRANSACTION_ID, ENL_System_Source__c = req.SISTEMA_SORGENTE, Fiscal_code__c = req.CODICE_FISCALE, EVENT_TYPE__c = req.EVENT_TYPE, Contact__c = cont.Id, ENL_Transaction_Code__c = req.CODICE_TRANSAZIONE//EniStation_App_Payment_Mode__c = lis.MODALITA_PAGAMENTO
            );
            if (!newTransactionsEvent17.containsKey(trans.Transaction_Id__c) && !existingTransactions.containsKey(trans.Transaction_Id__c)){
                newTransactionsEvent17.put(trans.Transaction_Id__c, trans);
                transactionsSucessMapEvent17.put(trans.Transaction_Id__c, req.EVENT_ID);
            }
        } else{
            Result_NotifyEvent result = new Result_NotifyEvent();
            result.SUCCESS = false;
            result.ERRORCODE = '';
            result.MESSAGE = 'Error when creating Transaction';
            result.REQUESTID = req.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD
            res.Result_NotifyEvent.add(result);
            Log lg = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore nella creazione della transazione' + 
                         ' per mancanza di un Contact da associare', 'Error when creating Transaction', String.valueOf(result), req.EVENT_ID, req.EVENT_TYPE, null, req.CODICE_FISCALE,/*commentato per dismissione loyalty_card 24/02/23 numCartaLoyalty*/'', req.PRODOTTO, null, req.IMPORTO, null, null, null, fromObjectToString(req.TARGHE), null, null);
            logs.add(lg);
        }
    }

    private static void initializeEvent18(WS_ENIInteract.Request_NotifyEvent req){
        Contact cont = null;
        String indirizzoEmail = req.INDIRIZZO_EMAIL;
        if (existingLeadsByEmail != null)
            cont = existingLeadsByEmail.get(indirizzoEmail);
        if (cont != null && cont.RecordTypeId != Utils.getRecordTypeId('Customer', 'Contact')){
            //aggiorna il lead
            cont.Data_Preregistrazione__c = req.DATA;
            if (ssMap.containsKey(req.IMPIANTO))
                cont.ENL_Service_Station_Code__c = ssMap.get(req.IMPIANTO).Id;
            cont.Email = req.INDIRIZZO_EMAIL;
            //cont.Contact_Code__c = indirizzoEmail;
            //cont.Flag_Privacy_ENI__c = req.FLG_PRIVACY1;
            if (fromObjectToBoolean(req.ALL_PRIVACY, 'FLG_PRIVACY1') != null)
                cont.Flag_Privacy_ENI__c = fromObjectToBoolean(req.ALL_PRIVACY, 'FLG_PRIVACY1');
            if (fromObjectToBoolean(req.ALL_PRIVACY, 'FG_TERMCOND') != null)
                cont.Flag_Term_Cond__c = fromObjectToBoolean(req.ALL_PRIVACY, 'FG_TERMCOND');
            if (String.isBlank(cont.List_Type_Lead__c))
                cont.List_Type_Lead__c = 'WiFi Fastweb';
            else{
                List<String> picklistValues = new List<String>();
                picklistValues.addAll(cont.List_Type_Lead__c.split(';'));
                if (!picklistValues.contains('WiFi Fastweb')){
                    picklistValues.add('WiFi Fastweb');
                    cont.List_Type_Lead__c = String.join(picklistValues, ';');
                }
            }

        } else if (cont == null){
            Id recordTypeLead = Utils.getRecordTypeId('ENL_Lead_Gestore', 'Contact');
            cont = new Contact(RecordTypeId = recordTypeLead, Data_Preregistrazione__c = req.DATA, FirstName = req.NOME, LastName = req.COGNOME, Email = req.INDIRIZZO_EMAIL, 
            //Flag_Privacy_ENI__c = req.FLG_PRIVACY1,
            Contact_Code__c = indirizzoEmail, List_Type_Lead__c = 'WiFi Fastweb');
            if (ssMap.containsKey(req.IMPIANTO))
                cont.ENL_Service_Station_Code__c = ssMap.get(req.IMPIANTO).Id;
            if (fromObjectToBoolean(req.ALL_PRIVACY, 'FG_TERMCOND') != null)
                cont.Flag_Term_Cond__c = fromObjectToBoolean(req.ALL_PRIVACY, 'FG_TERMCOND');
            if (fromObjectToBoolean(req.ALL_PRIVACY, 'FLG_PRIVACY1') != null)
                cont.Flag_Privacy_ENI__c = fromObjectToBoolean(req.ALL_PRIVACY, 'FLG_PRIVACY1');
        }

        if (!event18ContactsToInsert.containsKey(indirizzoEmail))
            event18ContactsToInsert.put(indirizzoEmail, cont);
        if (!successMap18.containsKey(indirizzoEmail))
            successMap18.put(indirizzoEmail, req.EVENT_ID);
    }

    /**
     * @author Christian Niro
     * @description initialize Event 19
     */

    private static void initializeEvent19(WS_ENIInteract.Request_NotifyEvent lis, WS_ENIInteract.Response_NotifyEvent ws){

        //commentato per dismissione loyalty_card 24/02/23
        /*
        if (!String.isEmpty(lis.NUM_CARTA_LOYALTY) && lis.NUM_CARTA_LOYALTY != null){
            loy = existingCards.get(lis.NUM_CARTA_LOYALTY.toUpperCase());
        } else{
            if (lis.MODALITA_PAGAMENTO == '2' && (lis.PARTITA_IVA != null && !String.isEmpty(lis.PARTITA_IVA))){
                loy = existingCards.get(lis.CODICE_FISCALE.toUpperCase() + '_BUSINESS');
            } else if (lis.MODALITA_PAGAMENTO == '1' || lis.MODALITA_PAGAMENTO == '6' || lis.MODALITA_PAGAMENTO == '7'){
                loy = existingCards.get(lis.CODICE_FISCALE.toUpperCase() + '_MULTICARDBUSINESS');
            } else if (lis.MODALITA_PAGAMENTO == '5'){
                loy = existingCards.get(lis.CODICE_FISCALE.toUpperCase() + '_MULTICARDENIPEOPLE');
            } else{
                loy = existingCards.get(lis.CODICE_FISCALE.toUpperCase() + '_CONSUMER');
            }
        }
        */


        Contact con = existingContacts.get(capitalizedFC);


        if (con != null){


            otherContacts.put(capitalizedFC, con);


            Transaction__c tr = new Transaction__c(Name = lis.TRANSACTION_ID, 
                                                   Transaction_Id__c = lis.TRANSACTION_ID, 
                                                   Transaction_Date__c = lis.DATA, Service_Station_Code__c = lis.IMPIANTO, Product_Type__c = lis.PRODOTTO, 
                                                   EniStation_APP_payment__c = lis.FLAG_PAGAMENTO, Contact__c = (con != null) ? con.ID : NULL, 
                                                   /*commentato per dismissione loyalty_card 24/02/23 Loyalty_Card__c = (loy != null) ? loy.Id : NULL,*/ EniStation_App_Payment_Mode__c = lis.MODALITA_PAGAMENTO, 
                                                   Flag_Privacy_1__c = (con != null) ? con.Flag_Privacy_ENI__c : FALSE, Flag_Privacy_2__c = (con != null) ? con.Flag_Privacy_Partner__c : FALSE, Cluster__c = (con != null) ? con.Cluster__c : NULL, 
                                                   Push_Notification__c = (con != null) ? con.Push_notification__c : FALSE, Card_Type__c = (con != null) ? con.Credit_Card_Type__c : NULL, Amount__c = lis.IMPORTO, Refueling_Mode__c = lis.MODALITA_OPERATIVA, 
                                                   Total_Points__c = lis.PUNTI, Liters__c = lis.LITRI, EVENT_TYPE__c = lis.EVENT_TYPE, 
                                                   EVENT_ID__c = lis.EVENT_ID, VAT_Number__c = lis.PARTITA_IVA, Fiscal_code__c = lis.CODICE_FISCALE, 
                                                   ENL_System_Source__c = lis.SISTEMA_SORGENTE, Kwh__c = lis.KWH, Time__c = lis.DURATA, Recarge_Type__c = lis.TIPOLOGIA_RICARICA, 
                                                   ENL_Service_Type__c = lis.TIPOLOGIA_SERVIZO, ENL_Start_Date__c = lis.DATA_INIZIO, ENL_End_Date__c = lis.DATA_FINE, ENL_Transaction_Locked__c = lis.BLOCCO_ANTIFRODE, 
                                                   ENL_Transaction_Code__c = lis.CODICE_TRANSAZIONE, ENL_Disabled_Service_Station__c = lis.IMPIANTO_NON_ABILITATO, ECU_Sconto_Applicato__c = lis.SCONTO_APPLICATO,
                                                   ECU_offerCondition__c = lis.PARAMETER1, ENL_Sconto_Applicato__c = String.valueOf(lis.SCONTO_CONVENZIONE), 
                                                   ENL_Tipologia_Sconto__c = lis.TIPOLOGIA_SCONTO, ENL_Importo_Prenotazione__c = lis.IMPORTO_PRENOTAZIONE, 
                                                   ENL_Importo_Penalita__c = lis.IMPORTO_PENALITA, ENL_Numero_Stallo__c = lis.NUMERO_STALLO, ENL_Durata_Prenotazione__c = lis.DURATA_PRENOTAZIONE, 

            //Nuovi campi Promo Emporium
            ENL_NumeroOrdineProdEmp__c = lis.NUMERO_ORDINE,
            Enl_Orario_Acquisto__c = lis.ORARIO_ACQUISTO, 
            Enl_Data_Conferma_Gestore__c = lis.DATA_CONFERMA_GESTORE, 
            Enl_Fascia_Previsto_ritiro__c = lis.FASCIA_PREVISTA_RITIRO, 
            Enl_Codice_Ritiro__c = lis.CODICE_RITIRO,
            Enl_Orario_Effettivo__c = lis.ORARIO_EFFETTIVO_RITIRO, 
            Enl_Stato_Transazione__c = lis.STATO_TRANSAZIONE,
            Enl_Motivo_Storno__c = lis.MOTIVO_STORNO, 
            Enl_Transazione_Emporium__c = true);


            if (lis.ORARIO_EFFETTIVO_RITIRO != null || (String.isNotBlank(lis.MOTIVO_STORNO) && lis.MOTIVO_STORNO != null)){
                if(transactionProdEmpRitirAnnullati.containsKey(lis.CODICE_TRANSAZIONE)){
                tr.Related_transaction_id__c = transactionProdEmpRitirAnnullati.get(lis.CODICE_TRANSAZIONE).Id;

                if (!updateTransactionsEvent19.containsKey(transactionProdEmpRitirAnnullati.get(lis.CODICE_TRANSAZIONE).Transaction_Id__c)){
                    updateTransactionsEvent19.put((transactionProdEmpRitirAnnullati.get(lis.CODICE_TRANSAZIONE).Transaction_Id__c), transactionProdEmpRitirAnnullati.get(lis.CODICE_TRANSAZIONE));
                    transactionsSucessMapEvent19.put(transactionProdEmpRitirAnnullati.get(lis.CODICE_TRANSAZIONE).Transaction_Id__c, lis.EVENT_ID);
                }
                }else{

                    tr.Related_transaction_id__c = null;

                }
                
                


            }


            // Inserisco nuova transazione se non è presente utilizziamo stesso schema per prodotti emporium

            if ((lis.ORARIO_EFFETTIVO_RITIRO != null || (String.isNotBlank(lis.MOTIVO_STORNO) && lis.MOTIVO_STORNO != null)) && transactionProdEmpRitirAnnullati.get(lis.CODICE_TRANSAZIONE) == null){
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = false;
                result.ERRORCODE = '';
                result.MESSAGE = 'Error when creating Transaction';
                result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD


                ws.Result_NotifyEvent.add(result);
                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore nella creazione della transazione per mancanza di una Transaction prodotti ritirati o annullati', 'Error when creating Transaction', String.valueOf(result), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE,/*commentato per dismissione loyalty_card 24/02/23 numCartaLoyalty*/'', lis.PRODOTTO, lis.LITRI, lis.IMPORTO, lis.PUNTI, lis.MODALITA_OPERATIVA, lis.PARTITA_IVA, fromObjectToString(lis.TARGHE), null, lis.CARTA);
                logs.add(l);
                system.debug('Log event 19 ' + logs);

            } else{
                if (!newTransactionsEvent19.containsKey(tr.Transaction_Id__c) && !transactionProdEmpRitirAnnullati.containsKey(tr.Transaction_Id__c)){
                    newTransactionsEvent19.put(tr.Transaction_Id__c, tr);
                    transactionsSucessMapEvent19.put(tr.Transaction_Id__c, lis.EVENT_ID);
                }
            }

            system.debug('TRANSACTION: ' + tr);


        } else{
            Result_NotifyEvent result = new Result_NotifyEvent();

            result.SUCCESS = false;
            result.ERRORCODE = '';
            result.MESSAGE = 'Error when creating Transaction';
            result.REQUESTID = lis.EVENT_ID;// SAME VALUE OF EVENT_ID FIELD


            ws.Result_NotifyEvent.add(result);
            Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore nella creazione della transazione evento 19' + 
                            ' per mancanza di un Contact da associare', 'Error when creating Transaction event 19', String.valueOf(result), lis.EVENT_ID, lis.EVENT_TYPE, null, lis.CODICE_FISCALE,/*commentato per dismissione loyalty_card 24/02/23 numCartaLoyalty*/ '', lis.PRODOTTO, lis.LITRI, lis.IMPORTO, lis.PUNTI, lis.MODALITA_OPERATIVA, lis.PARTITA_IVA, fromObjectToString(lis.TARGHE), null, lis.CARTA);
            logs.add(l);
            system.debug('Log event 19 ' + logs);
        }
    }

    private static void executeEvent1(WS_ENIInteract.Response_NotifyEvent ws, Schema.SObjectField f){
        Integer i = 0;
        //Set<Id> contactToCreateCustomerOffer = new Set<Id>();
        for (Database.UpsertResult upr : Database.upsert (event1Contacts.values(), f, false)){
            

            if (upr.isSuccess()){

                Contact con = event1Contacts.values().get(i);

                Id conId = upr.getId();

                //Controllare se il Customer Type è corretto
                if (con.Customer_Type__c == '2')
                contactVoucherChristmas.add(conId);


                WS_ENIInteract.Result_NotifyEvent result = new WS_ENIInteract.Result_NotifyEvent();

                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = '';
                result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                result.FISCALCODE = con.Fiscal_code__c;
                result.PROMO_CODE = '';
                result.VOUCHER_AMOUNT = 0.0;
                result.REQUESTID = successMap1.get(con.Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD
                result.CONTACT_KEY = con.Id;
                result.TIPOLOGIA_UTENTE = '2'; // EN: restituzione della tipologia Utente

                ws.Result_NotifyEvent.add(result);

                Log l = new Log('DEBUG', 'WS_ENIInteract.NotifyEvent', 'Result per Iscrizione nuovo cliente', '', String.valueOf(result), '', '', null, con.Fiscal_code__c, '', '', 0.0, 0.0, 0, '', '', '', '', '');
                logs.add(l);

                //Contact to use to start batch by Nick 20-05-2021
                if (conFicalCodeToStartBatch.contains(con.Fiscal_code__c.toUpperCase())){
                    contactToCreateCustomerOffer.add(con.Id);
                    if (contactIdsMapWithTrans.contains(con.Fiscal_code__c.toUpperCase()))
                        contactIdsMapWithTransBatch.add(con.Id);
                }
                //}

                // }// END Check Customer Type Enistation+ (Customer)
            } else{
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = false;
                result.ERRORCODE = 'Upsert failed';
                result.MESSAGE = String.valueOf(upr.getErrors());
                result.REQUESTID = successMap1.get(event1Contacts.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore aggiornamento contatto', 'Errore: ' + upr.getErrors(), String.valueOf(result), successMap1.get(event1Contacts.values().get(i).Fiscal_code__c.toUpperCase()), '', null);
                logs.add(l);
            }
            i++;
            // EN: Solo se il cliente non è Partita IVA
            //if(con.Customer_Type__c == '0'){
            //fiscalCodesForET1.put(con.Id, con.Fiscal_code__c);
            //12-03-2021 rimosso blocco creazione welcome offer e mastercard offer non più attive
            /*
             Customer_Offer__c offerWelcome = new Customer_Offer__c();
             //Boolean wlcomeOffCreated = Utils.generateWelcomeOffer(offerWelcome, con); //MC variabile non utilizzata, neutralizzata vulnerabilità ws
             System.debug('offerWelcome : ' + offerWelcome);
             if (Utils.generateWelcomeOffer(offerWelcome, con)) {
             System.debug('offerWelcome : ' + offerWelcome);
             offers.add(offerWelcome);
             System.debug('offers : ' + offers);
             }
             //TODO: togliere filtro sulla MasterCard
             System.debug('Utils.checkMastercardActive() : ' + Utils.checkMastercardActive());
             if((!String.isEmpty(con.Credit_Card_Type__c) && con.Credit_Card_Type__c.toUpperCase() == 'MASTERCARD') && Utils.checkMastercardActive()) {
             Customer_Offer__c offer = new Customer_Offer__c();
             Request_Voucher__c voucher = new Request_Voucher__c();

             //if(generateMastercard(voucher, offer, con)) {
             if (Utils.generateMastercardOffer(voucher, offer, con)) {
             System.debug('offer : ' + offer);
             if (String.isBlank(offer.Note_Interne__c)) {
             offers.add(offer);
             *//*GC
             * Request_Voucher__c masVoucher = Utils.generateVoucher(con, 'Mastercard');
             * vouchers.add(masVoucher);
             *//*
             vouchers.add(voucher);
             voucherOffersMap.put(con.Id, successMap1.get(event1Contacts.values().get(i).Fiscal_code__c.toUpperCase()));
             }
             }else{
             System.debug('offer : ' + offer);
             if (String.isBlank(offer.Note_Interne__c)) {
             Result_NotifyEvent result = new Result_NotifyEvent();

             result.SUCCESS = false;
             result.ERRORCODE = '';
             result.MESSAGE = 'Offer and voucher creation failed';
             result.REQUESTID = successMap1.get(event1Contacts.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

             ws.Result_NotifyEvent.add(result);
             Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore creazione voucher o offerta',
             'Offer and voucher creation faile', String.valueOf(result) , successMap1.get(event1Contacts.values().get(i).Fiscal_code__c.toUpperCase()),'',null);
             logs.add(l);
             }
             }

             }

             offersMap.put(con.Id, successMap1.get(event1Contacts.values().get(i).Fiscal_code__c.toUpperCase()));

             String cardCode = loyaltyCardNumbers.get(event1Contacts.values().get(i).Fiscal_code__c.toUpperCase());
             if(!String.isEmpty(cardCode)) {
             Boolean virtualCard = !cardCode.startsWith(Utils__c.getOrgDefaults().VirtualCardCode__c);

             loyaltyCards.add(new Loyalty_card__c(Name = cardCode, Virtual_card__c = virtualCard, Card_code__c = cardCode, Contact__c = event1Contacts.values().get(i).Id));
             //loyaltyCardsMap.put(event1Contacts.get(i).Id, successMap1.get(event1Contacts.get(i).Fiscal_code__c.toUpperCase()));
             }

             // 16/07/2020 GC : BUG FIX - send Contact key + Fiscal code for MC registration via SDK from App if no offer data to return
             if (offers.size() == 0) {
             */

        }

        Datetime dayTime = system.now();  // stefano.bassotti@webresults.it HOTFIX-198

        //Start batch ENL_APB_CustomerOfferBatch (by Nick 20-05-2021)
        try{
            //FLusso per l'assegnazione del voucher di natale
            if(!contactVoucherChristmas.isEmpty()){
                //ENL_APC_WsInteractHelper.christmasVoucherGift(contactVoucherChristmas);
            }

            // if(!contactToCreateCustomerOffer.isEmpty()){
            //     ENL_APC_WsInteractHelper.startBatchToCreateCustomerOffer(contactToCreateCustomerOffer);
            if (!contactIdsMapWithTransBatch.isEmpty()){
                ENL_APC_WsInteractHelper.getCustomerTransaction(contactIdsMapWithTransBatch);
            }

            //Flusso check ed invio voucher
            if (ContactOfferList != null && !ContactOfferList.isEmpty()){

                List<Offer_Catalog__c> offerCatalogVoucherList = new List<Offer_Catalog__c>([SELECT Id, Name, Offer_code__c
                                                                                             FROM Offer_Catalog__c
                                                                                             WHERE offer_code__c = 'AV2' and Validity_start_date__c <= :dayTime and Validity_end_date__c > :dayTime]); // stefano.bassotti@webresults.it HOTFIX-198

                if (offerCatalogVoucherList.size() > 0){
                    ENL_APC_WsInteractHelper.checkSendVoucher(ContactOfferList, offerCatalogVoucherList);

                }


            }
            // invio voucher Enjoy

            if (contactVoucherEnjoy != null && !contactVoucherEnjoy.isEmpty()){
                Boolean active = false;

                List<Offer_Catalog__c> offerCatalogVoucherList = new List<Offer_Catalog__c>([SELECT Id, Name, Offer_code__c, Active__c
                                                                                             FROM Offer_Catalog__c
                                                                                             WHERE Name = 'Voucher Enjoy' and Validity_start_date__c <= :dayTime and Validity_end_date__c > :dayTime]); // stefano.bassotti@webresults.it HOTFIX-198


                for (Offer_Catalog__c off : offerCatalogVoucherList){
                    active = off.Active__c;
                }

                if (active != false){
                    ENL_APC_WsInteractHelper.checkSendVoucherEnjoy(contactVoucherEnjoy, offerCatalogVoucherList);
                }


            }

            //controllo ed invio voucher RET-22030 DEM real pre registrati
            if (preRegisteredContactsVoucher != null && !preRegisteredContactsVoucher.isEmpty()){
                List<Offer_Catalog__c> offerCatalogPP1 = [SELECT Id, Name, Offer_code__c, Active__c, Type_of_reward__c
                                                          FROM Offer_Catalog__c
                                                          WHERE Offer_code__c = 'PP1' AND Active__c = true AND Validity_start_date__c <= :dayTime AND Validity_end_date__c > :dayTime]; // stefano.bassotti@webresults.it HOTFIX-198

                if (offerCatalogPP1 != null && offerCatalogPP1.size() > 0){
                    ENL_APC_WsInteractHelper.checkSendVoucherPreRegistered(preRegisteredContactsVoucher, offerCatalogPP1[0]);
                }
            }


            //update contact code for existing contact
            if (!existingContactsByEmail.isEmpty()){
                update existingContactsByEmail.values();
            }

            //sincronizzazione con Marketing Cloud degli ECU Lead associati ai contatti
            ENL_APC_WsInteractHelper.ecuLeadSynchronization(event1Contacts.values());
          if(Test.isRunningTest()){
                    throw new ECU_APC_CustomException('error'); 
                }  
        } catch (Exception e){
            //Database.rollback(sp);

            system.debug('Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber());
            Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Execution failed', 'Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber(), '', '', '', null);
            logs.add(l);


        }
    }

    private static void executeEvent3(WS_ENIInteract.Response_NotifyEvent ws, Schema.SObjectField f){
        Integer i = 0;

        Map<Id, Contact> retryUpdates = new Map<Id, Contact>();
        List<Transaction__c> transazioniMorose = new List<Transaction__c>();
        List<Transaction__c> transazioniNonMorose = new List<Transaction__c>();
        for (Database.UpsertResult upr : Database.upsert (otherContacts.values(), f, false)){
            if (!upr.isSuccess()){
                retryUpdates.put(upr.getId(), otherContacts.values().get(i));
            }

            i++;
        }
        //gestione record locking per errore UNABLE_TO_LOCK_ROW
        if (retryUpdates.size() > 0){
            Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT ID, Push_Notification__c, Flag_Privacy_ENI__c, Flag_Privacy_Analysis__c, Flag_Privacy_Partner__c, Cluster__c, Credit_card_association__c
                                                                FROM Contact
                                                                WHERE Id IN:retryUpdates.keySet()
                                                                FOR  UPDATE ]);

            for (Id contactID : contactMap.keySet()){
                if (retryUpdates.containsKey(contactID)){
                    Contact con = contactMap.get(contactID);
                    Contact retryContact = retryUpdates.get(contactID);
                    con.Push_Notification__c = retryContact.Push_Notification__c;
                    con.Flag_Privacy_ENI__c = retryContact.Flag_Privacy_ENI__c;
                    con.Flag_Privacy_Analysis__c = retryContact.Flag_Privacy_Analysis__c;
                    con.Flag_Privacy_Partner__c = retryContact.Flag_Privacy_Partner__c;
                    con.Cluster__c = retryContact.Cluster__c;
                    con.Credit_card_association__c = con.Credit_card_association__c;
                    contactMap.put(contactID, con);
                }
            }

            update contactMap.values();

        }

        i = 0;
        //suddivisione delle transazioni in morose, non morose e morosa = null
        for (Transaction__c trans : newTransactions.values()){
            if (trans.Transazione_Morosa__c != null && trans.Transazione_Morosa__c == 'true')
                transazioniMorose.add(trans);
            else
                transazioniNonMorose.add(trans);
        }
        //inserimento transaction non morosa e morosa = null
        for (Database.SaveResult ins : Database.insert (transazioniNonMorose, false)){
            //...
            if (ins.isSuccess()){
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = '';
                result.REQUESTID = transactionsSucessMap.get(transazioniNonMorose.get(i).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
            } else{
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = false;
                result.ERRORCODE = 'Insert failed';
                result.MESSAGE = String.valueOf(ins.getErrors());
                result.REQUESTID = transactionsSucessMap.get(transazioniNonMorose.get(i).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);

                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore inserimento transazione', 'Error Message: ' + ins.getErrors(), String.valueOf(result), transactionsSucessMap.get(transazioniNonMorose.get(i).Transaction_Id__c), '', null);
                logs.add(l);
            }

            i++;
        }

        i = 0;
        //inserimento transaction morosa
        if (transazioniMorose.size() > 0){
            TriggerManager.skipTrigger('TransactionTrigger');
            for (Database.SaveResult ins : Database.insert (transazioniMorose, false)){
                //...
                if (ins.isSuccess()){
                    Result_NotifyEvent result = new Result_NotifyEvent();

                    result.SUCCESS = true;
                    result.ERRORCODE = '';
                    result.MESSAGE = '';
                    result.REQUESTID = transactionsSucessMap.get(transazioniMorose.get(i).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD

                    ws.Result_NotifyEvent.add(result);
                } else{
                    Result_NotifyEvent result = new Result_NotifyEvent();

                    result.SUCCESS = false;
                    result.ERRORCODE = 'Insert failed';
                    result.MESSAGE = String.valueOf(ins.getErrors());
                    result.REQUESTID = transactionsSucessMap.get(transazioniMorose.get(i).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD

                    ws.Result_NotifyEvent.add(result);

                    Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore inserimento transazione', 'Error Message: ' + ins.getErrors(), String.valueOf(result), transactionsSucessMap.get(transazioniMorose.get(i).Transaction_Id__c), '', null);
                    logs.add(l);
                }

                i++;
            }
            TriggerManager.unskipTrigger('TransactionTrigger');
        }

        Set<Id> transactionIds = new Set<Id>();         //lista contentente gli Id delle transazioni morose (transazione_morosa = true) e transazioni tariffa integrata
        Map<Id, Id> linkedIdMap = new Map<Id, Id>();    // mappa con chiave: Id transazione morosa(transazione_morosa = true), valore: Id transazione che viene sanata oppure
        for (Transaction__c item : updateTransactions.values())
            //chiave: Id transazione tariffa integrata, valore: Id transazione tariffa integrata corrispondente
            transactionIds.add(item.Id);
        List<Transaction__c> existingTransactionsToBeLinked = new List<Transaction__c>();
        existingTransactionsToBeLinked = [SELECT Id, Related_transaction_id__c
                                          FROM Transaction__c
                                          WHERE Related_transaction_id__c IN:transactionIds];
        for (Transaction__c item2 : existingTransactionsToBeLinked)
            linkedIdMap.put(item2.Related_transaction_id__c, item2.Id);
        for (Transaction__c item3 : updateTransactions.values())
            item3.Related_transaction_id__c = linkedIdMap.get(item3.Id);
        i = 0;
        //update della transazione da morosa che viene collegata con la rispettiva non morosa oppure la transazione tariffa integrata viene collegata con la rispettiva gemella
        for (Database.SaveResult upd : Database.update (updateTransactions.values(), false)){
            //...
            if (upd.isSuccess()){
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = '';
                result.REQUESTID = transactionsSucessMap.get(updateTransactions.values().get(i).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
            } else{
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = false;
                result.ERRORCODE = 'Update failed';
                result.MESSAGE = String.valueOf(upd.getErrors());
                System.debug('ERRORE: ' + upd.getErrors());
                result.REQUESTID = transactionsSucessMap.get(updateTransactions.values().get(i).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);

                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore aggiornamento transazione', 'Error Message: ' + upd.getErrors(), String.valueOf(result), transactionsSucessMap.get(updateTransactions.values().get(i).Transaction_Id__c), '', null);
                logs.add(l);
            }

            i++;
        }
    }

    private static void executeEvent4(WS_ENIInteract.Response_NotifyEvent ws, Schema.SObjectField f){
        Integer i = 0;
        for (Database.UpsertResult upr : Database.upsert (event4Contacts.values(), f, false)){
            if (upr.isSuccess()){
                //EN: prendo il contatto di tipo Customer
                //Contact con = existingContacts.get(event4Contacts.values().get(i).Fiscal_code__c.toUpperCase());
                //String debug = String.valueOf(con.Requests_Voucher__r) + '\n isEmpty() + ' + String.valueOf(con.Requests_Voucher__r.isEmpty());
                //Utils.sendMail('test requests couvher empty', debug, 'debug', 'andrei.necsulescu@webresults.it');
                //EN: Solo se il cliente non è Partita IVA
                // if(con!=null){
                //     if(con.Requests_Voucher__r.isEmpty()) {
                //         if(!con.Mastercard_voucher_recieved__c && event4Contacts.values().get(i).Credit_Card_Type__c.toUpperCase() == 'MASTERCARD' && Utils.checkMastercardActive()) {

                //             //Utils.sendMail('test requests couvher empty', debug, 'debug', 'andrei.necsulescu@webresults.it');

                //             Customer_Offer__c offer = new Customer_Offer__c();
                //             Request_Voucher__c voucher = new Request_Voucher__c();

                //if(generateMastercard(voucher, offer, con)) {
                /* 15-03-2021 rimossa creazione mastercard offer non
                 if (Utils.generateMastercardOffer(voucher, offer, con)) {
                 if (offer.Note_Interne__c == '') {
                 event4Offers.add(offer);
                 event4Vouchers.add(voucher);

                 event4VoucherOffersMap.put(con.Id, successMap4.get(event4Contacts.values().get(i).Fiscal_code__c.toUpperCase()));
                 }
                 }else{
                 if (offer.Note_Interne__c == '') {
                 Result_NotifyEvent result = new Result_NotifyEvent();

                 result.SUCCESS = false;
                 result.ERRORCODE = '';
                 result.MESSAGE = 'Offer and voucher creation failed';
                 result.REQUESTID = successMap4.get(event4Contacts.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                 ws.Result_NotifyEvent.add(result);
                 Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore aggiornamento contatto',
                 'Offer and voucher creation failed', String.valueOf(result) , successMap4.get(event4Contacts.values().get(i).Fiscal_code__c.toUpperCase()),'',null);
                 logs.add(l);
                 }
                 }*/
                //     }else{
                //         Result_NotifyEvent result = new Result_NotifyEvent();

                //         result.SUCCESS = true;
                //         result.ERRORCODE = '';
                //         result.MESSAGE = '';
                //         result.REQUESTID = successMap4.get(event4Contacts.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                //         ws.Result_NotifyEvent.add(result);
                //     }

                // }else{
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = '';
                result.REQUESTID = successMap4.get(event4Contacts.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
                //     }
                // }
            } else{
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = false;
                result.ERRORCODE = 'Upsert failed';
                result.MESSAGE = String.valueOf(upr.getErrors());
                result.REQUESTID = successMap4.get(event4Contacts.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore aggiornamento contatto', 'Errore: ' + upr.getErrors(), String.valueOf(result), successMap4.get(event4Contacts.values().get(i).Fiscal_code__c.toUpperCase()), '', null);
                logs.add(l);
                system.debug(upr.getErrors());
            }
            i++;
        }
    }

    private static void executeEvent7(WS_ENIInteract.Response_NotifyEvent ws){

                Datetime dayTime = system.now();  // stefano.bassotti@webresults.it HOTFIX-198

                List<Offer_Catalog__c> offerCatalogVoucherList = new List<Offer_Catalog__c>([SELECT Id, Name, Offer_code__c
                                                                                     FROM Offer_Catalog__c
                                                                                     WHERE offer_code__c = 'AV2' and Validity_start_date__c <= :dayTime and Validity_end_date__c > :dayTime]); // stefano.bassotti@webresults.it HOTFIX-198

                // GN - 26-03-2021 inizio blocco riconciliazione modifiche App Unica
                Integer i = 0;
                for (Database.SaveResult upd : Database.update (event7ContactsToReconcile.values(), false)){
        
                    system.debug('>>> event7ContactsToReconcile.values: ' + event7ContactsToReconcile.values());
                    Result_NotifyEvent result = new Result_NotifyEvent();
                    Contact conRic = event7ContactsToReconcile.values().get(i);
                    if (upd.isSuccess()){
                        result.SUCCESS = true;
                        result.ERRORCODE = '';
                        result.MESSAGE = '';
                        result.CONTACT_KEY = upd.getId();//salesforce id of the created contact
                        result.FISCALCODE = event7ContactsToReconcile.values().get(i).Fiscal_code__c.toUpperCase(); //codice fiscale del contatto creato
                        //11-03-2021 rimosso per modifiche App Unica
                        result.TIPOLOGIA_UTENTE = event7ContactsToReconcile.values().get(i).Customer_Type__c; // EN: restituzione della tipologia Utente
                        result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                        result.REQUESTID = successMap7Reconciliation.get(event7ContactsToReconcile.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD
                        system.debug('contatto riconciliato ' + event7ContactsToReconcile.values().get(i));
                        ws.Result_NotifyEvent.add(result);
                        Utils.executeReconciliation(event7ContactsToReconcile.values().get(i).Reconciliation__c, event7ContactsToReconcile.values().get(i).Riconciliazione_Customer_Type__c, event7ContactsToReconcile.values().get(i).Fiscal_code__c.toUpperCase(), event7ContactsToReconcile.values().get(i).Id, event7ContactsToReconcile.values().get(i).AccountId);
                        //Contact to use to start batch by Nick 20-05-2021
                        if (conFicalCodeToStartBatch.contains(conRic.Fiscal_code__c.toUpperCase())){
                            contactToCreateCustomerOffer.add(conRic.Id);
                        }
        
                        //Se esiste l'offerta prendo contatto per invio voucher
                        if (offerCatalogVoucherList.size() > 0){
                            ContactOfferList7.add(conRic);
        
                        }
        
                    } else{
                        result.SUCCESS = false;
                        result.ERRORCODE = 'Upsert failed';
                        result.MESSAGE = String.valueOf(upd.getErrors());
                        result.REQUESTID = successMap7Reconciliation.get(event7ContactsToReconcile.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD
        
                        ws.Result_NotifyEvent.add(result);
                        Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore riconciliazione contatto', 'Errore: ' + upd.getErrors(), String.valueOf(result), successMap7Reconciliation.get(event7ContactsToReconcile.values().get(i).Fiscal_code__c.toUpperCase()), '', null);
                        logs.add(l);
                        system.debug(upd.getErrors());
                    }
                    i++;
                }
        i = 0;
        //Set<Id> contactToCreateCustomerOffer = new Set<Id>();
        // EN:  Event 7

        system.debug('>>> event7ContactsToUpdate.values: ' + event7ContactsToUpdate.values());
        for (Database.SaveResult upd : Database.update (event7ContactsToUpdate.values(), false)){
            Result_NotifyEvent result = new Result_NotifyEvent();
            Contact con = event7ContactsToUpdate.values().get(i);
            if (upd.isSuccess()){

               
                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = '';
                result.CONTACT_KEY = upd.getId();//salesforce id of the created contact
                result.FISCALCODE = event7ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase(); //codice fiscale del contatto creato
                //11-03-2021 rimosso per modifiche App Unica
                result.TIPOLOGIA_UTENTE = event7ContactsToUpdate.values().get(i).Customer_Type__c; // EN: restituzione della tipologia Utente
                result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                result.REQUESTID = successMap7.get(event7ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);

                //Contact to use to start batch by Nick 20-05-2021
                if (conFicalCodeToStartBatch.contains(con.Fiscal_code__c.toUpperCase())){
                    contactToCreateCustomerOffer.add(con.Id);
                }


            } else{
                result.SUCCESS = false;
                result.ERRORCODE = 'Upsert failed';
                result.MESSAGE = String.valueOf(upd.getErrors());
                result.REQUESTID = successMap7.get(event7ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore aggiornamento contatto', 'Errore: ' + upd.getErrors(), String.valueOf(result), successMap7.get(event7ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase()), '', null);
                logs.add(l);
                system.debug(upd.getErrors());
            }
            i++;
        }



        // GN - 26-03-2021 fine blocco riconciliazione modifiche App Unica

        //Start batch ENL_APB_CustomerOfferBatch (by Nick 20-05-2021)
        // try{
        //     if(!contactToCreateCustomerOffer.isEmpty()){
        //         ENL_APC_WsInteractHelper.startBatchToCreateCustomerOffer(contactToCreateCustomerOffer);
        //     }
        // }catch(Exception e) {
        //     //Database.rollback(sp);

        //     system.debug('Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber());
        //     Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent',
        //                     'Execution failed', 'Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber(), '' , '','','');
        //     logs.add(l);


        //     }
        //GN 10-06-2021 Flusso per l'associazione degli Entry Gift
        try{
            if (!contactEntryGift.isEmpty()){
                //(G.N. 18/07/2022 Rimosso per termine offerta)
                //ENL_APC_WsInteractHelper.checkEntryGift(contactEntryGift);
            }
            //FLusso per l'assegnazione del Bonus Multicard Easy (G.C. 08/09/21)
            // if (!contactMulticardEasy.isEmpty()){
            //     ENL_APC_WsInteractHelper.checkMulticardEasy(contactMulticardEasy);
            // }
            //FLusso per l'assegnazione del voucher di natale
            if (!contactVoucherChristmas.isEmpty())
                ENL_APC_WsInteractHelper.christmasVoucherGift(contactVoucherChristmas);
            //Flusso check ed invio voucher
            if (ContactOfferList7 != null && !ContactOfferList7.isEmpty()){
                ENL_APC_WsInteractHelper.checkSendVoucher(ContactOfferList7, offerCatalogVoucherList);
            }

        } catch (Exception e){
            //Database.rollback(sp);

            system.debug('Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber());
            Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Execution failed', 'Error Message: ' + e.getMessage() + '. At line number: ' + e.getLineNumber(), '', '', '', null);
            logs.add(l);


        }
    }

    private static void executeEvent8(WS_ENIInteract.Response_NotifyEvent ws, WS_ENIInteract.Wrapper_Request_NotifyEvent res){
        Integer i = 0;

        // Event 8

        system.debug('>>> event8ContactsToUpdate.values: ' + event8ContactsToUpdate.values());
        if (event8ContactsToUpdate != NULL && event8ContactsToUpdate.size() > 0){
            event8AccountsToUpdate = WS_ENIInteract.queryExistingAccountsToAnonymize(res.request, event8ContactsToUpdate);
            Utils.accountAnonymization(event8AccountsToUpdate);
            for (Database.SaveResult upd : Database.update (event8AccountsToUpdate, false)){
                Result_NotifyEvent result = new Result_NotifyEvent();
                if (!upd.isSuccess()){
                    Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore aggiornamento Account per dati anonimizzazione', 'Errore: ' + upd.getErrors(), String.valueOf(result), '', '', null);
                    logs.add(l);
                    system.debug(upd.getErrors());
                }
            }
        }

        for (Database.SaveResult upd : Database.update (event8ContactsToUpdate.values(), false)){
            Result_NotifyEvent result = new Result_NotifyEvent();
            if (upd.isSuccess()){
                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = 'Deletion on CRM SFDC performed';
                //result.CONTACT_KEY = upd.getId();//salesforce id of the created contact
                result.FISCALCODE = event8ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase(); //codice fiscale del contatto creato
                //11-03-2021 rimosso per modifiche App Unica
                //result.TIPOLOGIA_UTENTE = event8ContactsToUpdate.values().get(i).Customer_Type__c; // EN: restituzione della tipologia Utente
                result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                result.REQUESTID = successMap8.get(event8ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);

            } else{
                result.SUCCESS = false;
                result.ERRORCODE = 'Upsert failed';
                result.MESSAGE = String.valueOf(upd.getErrors());
                result.REQUESTID = successMap8.get(event8ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore aggiornamento Contatto per dati cancellazione', 'Errore: ' + upd.getErrors(), String.valueOf(result), successMap8.get(event8ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase()), '', null);
                logs.add(l);
                system.debug(upd.getErrors());
            }
            i++;
        }
    }

    private static void executeEvent9(WS_ENIInteract.Response_NotifyEvent ws){
        Integer i = 0;
        system.debug('>>> event9ContactsToUpdate.values: ' + event9ContactsToUpdate.values());
        for (Database.SaveResult upd : Database.update (event9ContactsToUpdate.values(), false)){
            Result_NotifyEvent result = new Result_NotifyEvent();
            if (upd.isSuccess()){
                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = 'Blacklist on CRM SFDC performed';
                //result.CONTACT_KEY = upd.getId();//salesforce id of the created contact
                result.FISCALCODE = event9ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase(); //codice fiscale del contatto creato
                //11-03-2021 rimosso per modifiche App Unica
                //result.TIPOLOGIA_UTENTE = event9ContactsToUpdate.values().get(i).Customer_Type__c; // EN: restituzione della tipologia Utente
                result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                result.REQUESTID = successMap9.get(event9ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);

            } else{
                result.SUCCESS = false;
                result.ERRORCODE = 'Upsert failed';
                result.MESSAGE = String.valueOf(upd.getErrors());
                result.REQUESTID = successMap9.get(event9ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore aggiornamento Contatto per blacklist', 'Errore: ' + upd.getErrors(), String.valueOf(result), successMap9.get(event9ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase()), '', null);
                logs.add(l);
                system.debug(upd.getErrors());
            }
            i++;
        }
    }

    private static void executeEvent10(WS_ENIInteract.Response_NotifyEvent ws){
        Integer i = 0;
        system.debug('>>> event10CustomerOfferToUpdate.values: ' + event10CustomerOfferToUpdate.values());
        for (Database.SaveResult upd : Database.update (event10CustomerOfferToUpdate.values(), false)){
            Result_NotifyEvent result = new Result_NotifyEvent();
            if (upd.isSuccess()){
                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = 'Successfully registered participation in the lottery';
                //result.CONTACT_KEY = upd.getId();//salesforce id of the created contact
                result.FISCALCODE = event10CustomerOfferToUpdate.values().get(i).Fiscal_code__c.toUpperCase(); //codice fiscale del contatto creato
                //11-03-2021 rimosso per modifiche App Unica
                //result.TIPOLOGIA_UTENTE = event10CustomerOfferToUpdate.values().get(i).Customer_Type__c; // EN: restituzione della tipologia Utente
                result.OPERATION_ID = event10CustomerOfferToUpdate.values().get(i).Id;
                result.REQUESTID = successMap10.get(event10CustomerOfferToUpdate.values().get(i).Id);// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);

            } else{
                result.SUCCESS = false;
                result.ERRORCODE = 'Upsert failed';
                result.MESSAGE = String.valueOf(upd.getErrors());
                result.REQUESTID = successMap10.get(event10CustomerOfferToUpdate.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore aggiornamento Customer Offer per partecipazione alla lotteria', 'Errore: ' + upd.getErrors(), String.valueOf(result), successMap10.get(event10CustomerOfferToUpdate.values().get(i).Fiscal_code__c.toUpperCase()), '', null);
                logs.add(l);
                system.debug(upd.getErrors());
            }
            i++;
        }
    }

    private static void executeEvent11(WS_ENIInteract.Response_NotifyEvent ws, Schema.SObjectField f){
        WS_ENIInteract.Result_NotifyEvent result;
        Integer i = 0;
        if (!requiredFields.isEmpty()){
            for (String key : requiredFields.keySet()){
                result = new WS_ENIInteract.Result_NotifyEvent();
                result.SUCCESS = false;
                result.ERRORCODE = 'KO';
                result.MESSAGE = 'Mandatory fields ' + requiredFields.get(key).toString() + ' missing or incorrect';
                result.REQUESTID = key;

                ws.Result_NotifyEvent.add(result);
            }
        }
        
        
        List<Contact> contactNotCheck = event11ContactsToInsert.values();
        system.debug('contactNotCheck ::::: '+contactNotCheck);
        
        Map<String, Contact> contactToInsert = ENL_APC_WsInteractHelper.checkContactFiscalCode(contactNotCheck);
        system.debug('contactToInsert ::::: '+ contactToInsert );
        
        for (Contact c : contactNotCheck){
            if (!contactToInsert.containsKey(c.Fiscal_code__c)){
                result = new WS_ENIInteract.Result_NotifyEvent();
                result.SUCCESS = false;
                result.ERRORCODE = 'KO';
                result.MESSAGE = 'Lead già presente o utente già registrato tramite App';
                result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                result.FISCALCODE = c.Fiscal_code__c;
                result.REQUESTID = successMap11.get(c.Fiscal_code__c);
                result.FLOW_CODE = 'ENL-011';

                ws.Result_NotifyEvent.add(result);
            }
        }

        if (!contactToInsert.isEmpty()){
            //relate contact to account
            ENL_APC_WsInteractHelper.newAccount(contactToInsert);
            for (Database.UpsertResult upr : Database.upsert (contactToInsert.values(), f, false)){
                if (upr.isSuccess()){
                    Contact con = contactToInsert.values().get(i);
                    result = new WS_ENIInteract.Result_NotifyEvent();
                    List<String> adressResidence = new List<String>();
                    if (con.MailingStreet != null)
                        adressResidence = con.MailingStreet.split(',');
                    result.SUCCESS = true;
                    result.ERRORCODE = 'OK';
                    result.MESSAGE = '';
                    result.EMAIL = con.Email;
                    result.FIRST_NAME = con.FirstName;
                    result.LAST_NAME = con.LastName;
                    result.PROVINCE = con.Birth_Region__c;
                    result.CITY = con.Birth_City__c;
                    result.BIRTH_DATE = con.Birthdate;
                    result.TELEPHONE = con.Phone;
                    result.ADDRESS = adressResidence.size() > 0 ? adressResidence.get(0) : null;
                    result.STREET_NUMBER = adressResidence.size() > 1 ? adressResidence.get(1) : null;
                    //result.STREET_NUMBER = con.Residence_Street_Number__c;
                    result.POSTAL_CODE = con.MailingPostalCode;
                    result.CITY_RESIDENCE = con.MailingCity;
                    result.PROVINCE_RESIDENCE = con.MailingState;
                    result.PRIVACY = con.Flag_Privacy_ENI__c;
                    result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                    result.FISCALCODE = con.Fiscal_code__c;
                    result.REQUESTID = successMap11.get(contactToInsert.values().get(i).Fiscal_code__c.toUpperCase());
                    result.FLOW_CODE = 'ENL-011';
                    result.CONTACT_KEY = '';

                    ws.Result_NotifyEvent.add(result);

                } else{
                    result = new Result_NotifyEvent();

                    result.SUCCESS = false;
                    result.ERRORCODE = 'KO';
                    result.MESSAGE = 'Insert failed / System error';
                    result.REQUESTID = successMap11.get(contactToInsert.values().get(i).Fiscal_code__c.toUpperCase());
                    result.FLOW_CODE = 'ENL-011';

                    ws.Result_NotifyEvent.add(result);
                    Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore inserimento contatto', 'Errore: ' + upr.getErrors(), String.valueOf(result), successMap11.get(contactToInsert.values().get(i).Fiscal_code__c.toUpperCase()), '', null);
                    logs.add(l);
                }
                i++;
            }
        }
        i = 0;
        if (!event11ContactsToUpdate.isEmpty()){
            for (Database.SaveResult upr : Database.update (event11ContactsToUpdate.values(), false)){
                if (upr.isSuccess()){
                    Contact c = event11ContactsToUpdate.values().get(i);
                    result = new WS_ENIInteract.Result_NotifyEvent();
                    result.SUCCESS = false;
                    result.ERRORCODE = 'KO';
                    result.MESSAGE = 'Lead già presente o utente già registrato tramite App';
                    result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                    result.FISCALCODE = c.Fiscal_code__c;
                    result.REQUESTID = successMap11ToUpdate.get(event11ContactsToUpdate.values().get(i).Email.toLowerCase());
                    result.FLOW_CODE = 'ENL-011';

                    ws.Result_NotifyEvent.add(result);

                } else{
                    result = new Result_NotifyEvent();

                    result.SUCCESS = false;
                    result.ERRORCODE = 'KO';
                    result.MESSAGE = 'Insert failed / System error';
                    result.REQUESTID = successMap11ToUpdate.get(event11ContactsToUpdate.values().get(i).Email.toLowerCase());
                    System.debug('SuccessMap11ToUpdate: ' + successMap11ToUpdate.get(event11ContactsToUpdate.values().get(i).Email.toLowerCase()));
                    result.FLOW_CODE = 'ENL-011';

                    ws.Result_NotifyEvent.add(result);
                    Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore inserimento contatto', 'Errore: ' + upr.getErrors(), String.valueOf(result), successMap11ToUpdate.get(event11ContactsToUpdate.values().get(i).Email.toLowerCase()), '', null);
                    logs.add(l);
                }
                i++;
            }
        }
    }

    private static void executeEvent12(WS_ENIInteract.Response_NotifyEvent ws, Schema.SObjectField f){
        WS_ENIInteract.Result_NotifyEvent result;
        Integer i = 0;
        if (!requiredFieldsEvent12.isEmpty()){
            for (String key : requiredFieldsEvent12.keySet()){
                result = new WS_ENIInteract.Result_NotifyEvent();
                result.SUCCESS = false;
                result.ERRORCODE = 'KO';
                result.MESSAGE = 'Mandatory fields ' + requiredFieldsEvent12.get(key).toString() + ' missing or incorrect';
                result.REQUESTID = key;

                ws.Result_NotifyEvent.add(result);
            }
        }
        if (event12ContactsToInsert.size() > 0){

            List<Contact> contactNotCheck = event12ContactsToInsert.values();
            Map<String, Contact> contactToInsert = ENL_APC_WsInteractHelper.checkContactEmail(contactNotCheck);

            for (Contact c : contactNotCheck){
                if (!contactToInsert.containsKey(c.Email.toUpperCase())){
                    //list email of existing contact
                    existEmailList.add(c.Email);
                    result = new WS_ENIInteract.Result_NotifyEvent();
                    result.SUCCESS = false;
                    result.ERRORCODE = 'KO';
                    result.MESSAGE = 'Lead già presente';
                    result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                    //result.FISCALCODE = c.Fiscal_code__c;
                    result.REQUESTID = successMap12.get(c.Fiscal_code__c.toUpperCase());
                    result.FLOW_CODE = 'ENL-012';
                    system.debug('result' + result);
                    ws.Result_NotifyEvent.add(result);
                }
            }
            if (!contactToInsert.isEmpty()){
                //contactToInsert = ENL_APC_WsInteractHelper.checkContactVoucher(contactToInsert,voucherInitilizeMap );
                //relate contact to account
                ENL_APC_WsInteractHelper.newAccount(contactToInsert);
                for (Database.UpsertResult upr : Database.upsert (contactToInsert.values(), f, false)){
                    if (upr.isSuccess()){
                        // Voucher__c vch =New Voucher__c();
                        Contact con = contactToInsert.values().get(i);
                        noEmailList.add(con.Email);
                        //vch = ENL_APC_WsInteractHelper.initializeVoucher(con,voucherInitilizeMap.get(con.Email));
                        //  vouchersToInsert.add(vch);
                        result = new WS_ENIInteract.Result_NotifyEvent();
                        result.SUCCESS = true;
                        result.ERRORCODE = 'OK';
                        result.MESSAGE = '';
                        result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                        result.FISCALCODE = con.Fiscal_code__c;
                        result.REQUESTID = successMap12.get(con.Email.toUpperCase());
                        result.FLOW_CODE = 'ENL-012';
                        result.CONTACT_KEY = '';
                        ws.Result_NotifyEvent.add(result);
                        system.debug('result' + result);


                    } else{
                        result = new Result_NotifyEvent();

                        result.SUCCESS = false;
                        result.ERRORCODE = 'KO';
                        result.MESSAGE = 'Insert failed / System error';
                        result.REQUESTID = eventId;
                        result.FLOW_CODE = 'ENL-012';

                        ws.Result_NotifyEvent.add(result);
                        Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore inserimento contatto', 'Errore: ' + upr.getErrors(), String.valueOf(result), successMap12.get(contactToInsert.values().get(i).Fiscal_code__c.toUpperCase()), '', null);
                        logs.add(l);
                    }
                    i++;
                }
                //insert vouchersToInsert;
                if (!noEmailList.isEmpty()){
                    ENL_APC_WsInteractHelper.checkExistingAndInsertVoucher(new list<String>(), noEmailList, voucherInitilizeMap, logs, eventIdMap);
                }
            

            if (!existEmailList.isEmpty()){
                ENL_APC_WsInteractHelper.checkExistingAndInsertVoucher(new list<String>(), existEmailList, voucherInitilizeMap, logInboundEvents, eventIdMap);
            }


            if (!ListFiscalCodeList.isEmpty()){
                ENL_APC_WsInteractHelper.checkExistingAndInsertVoucher(ListFiscalCodeList, new list<String>(), voucherInitilizeMap2, logs, eventIdMap);
                }
            }
        }

        if (event12ContactsToUpdate.size() > 0){
            i = 0;
            for (Database.SaveResult upr : Database.update (event12ContactsToUpdate.values(), false)){
                if (upr.isSuccess()){

                    Contact con = event12ContactsToUpdate.values().get(i);
                    result = new WS_ENIInteract.Result_NotifyEvent();
                    result.SUCCESS = true;
                    result.ERRORCODE = 'OK';
                    result.MESSAGE = '';
                    result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                    //result.FISCALCODE = con.Email;
                    result.REQUESTID = successMap12ToUpdate.get(con.Email.toUpperCase());
                    result.FLOW_CODE = 'ENL-012';
                    result.CONTACT_KEY = '';
                    ws.Result_NotifyEvent.add(result);
                    system.debug('result' + result);


                } else{
                    result = new Result_NotifyEvent();

                    result.SUCCESS = false;
                    result.ERRORCODE = 'KO';
                    result.MESSAGE = 'Insert failed / System error';
                    result.REQUESTID = successMap12ToUpdate.get(event12ContactsToUpdate.values().get(i).Email.toUpperCase());
                    result.FLOW_CODE = 'ENL-012';

                    ws.Result_NotifyEvent.add(result);
                    Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore inserimento contatto', 'Errore: ' + upr.getErrors(), String.valueOf(result), successMap12ToUpdate.get(event12ContactsToUpdate.values().get(i).Email.toUpperCase()), '', null);
                    logs.add(l);
                }
                i++;
            }
        }
    }

    private static void executeEvent13(WS_ENIInteract.Response_NotifyEvent ws, Schema.SObjectField f){
        Integer i = 0;
        for (Database.UpsertResult upr : Database.upsert (event13Contacts.values(), f, false)){
            if (upr.isSuccess()){

                Contact con = event13Contacts.values().get(i);
                WS_ENIInteract.Result_NotifyEvent result = new WS_ENIInteract.Result_NotifyEvent();

                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = '';
                result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                result.FISCALCODE = con.Fiscal_code__c;
                result.PROMO_CODE = '';
                result.VOUCHER_AMOUNT = 0.0;
                result.REQUESTID = successMap13.get(con.Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD
                result.CONTACT_KEY = con.Id;
                result.TIPOLOGIA_UTENTE = '0'; // EN: restituzione della tipologia Utente

                ws.Result_NotifyEvent.add(result);

                Log l = new Log('DEBUG', 'WS_ENIInteract.NotifyEvent', 'Result per Iscrizione nuovo cliente OLD', '', String.valueOf(result), '', '', null, con.Fiscal_code__c, '', '', 0.0, 0.0, 0, '', '', '', '', '');
                logs.add(l);

            } else{
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = false;
                result.ERRORCODE = 'Upsert failed';
                result.MESSAGE = String.valueOf(upr.getErrors());
                result.REQUESTID = successMap13.get(event13Contacts.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore aggiornamento contatto', 'Errore: ' + upr.getErrors(), String.valueOf(result), successMap13.get(event1Contacts.values().get(i).Fiscal_code__c.toUpperCase()), '', null);
                logs.add(l);
            }
            i++;

        }
    }

    private static void executeEvent14(WS_ENIInteract.Response_NotifyEvent ws, Schema.SObjectField f){
        Integer i = 0;

        Map<Id, Contact> retryUpdates = new Map<Id, Contact>();
        for (Database.UpsertResult upr : Database.upsert (otherContactsOld.values(), f, false)){
            if (!upr.isSuccess()){
                retryUpdates.put(upr.getId(), otherContactsOld.values().get(i));
            }

            i++;
        }
        //gestione record locking per errore UNABLE_TO_LOCK_ROW
        if (retryUpdates.size() > 0){
            Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT ID, Push_Notification__c, Flag_Privacy_ENI__c, Flag_Privacy_Analysis__c, Flag_Privacy_Partner__c, Cluster__c, Credit_card_association__c
                                                                FROM Contact
                                                                WHERE Id IN:retryUpdates.keySet()
                                                                FOR  UPDATE ]);

            for (Id contactID : contactMap.keySet()){
                if (retryUpdates.containsKey(contactID)){
                    Contact con = contactMap.get(contactID);
                    Contact retryContact = retryUpdates.get(contactID);
                    con.Push_Notification__c = retryContact.Push_Notification__c;
                    con.Flag_Privacy_ENI__c = retryContact.Flag_Privacy_ENI__c;
                    con.Flag_Privacy_Analysis__c = retryContact.Flag_Privacy_Analysis__c;
                    con.Flag_Privacy_Partner__c = retryContact.Flag_Privacy_Partner__c;
                    con.Cluster__c = retryContact.Cluster__c;
                    con.Credit_card_association__c = con.Credit_card_association__c;
                    contactMap.put(contactID, con);
                }
            }

            update contactMap.values();

        }
        //inserimento transaction
        i = 0;
        for (Database.SaveResult ins : Database.insert (newTransactionsOld.values(), false)){
            //...
            if (ins.isSuccess()){
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = '';
                result.REQUESTID = transactionsSucessMapOld.get(newTransactionsOld.values().get(i).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
            } else{
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = false;
                result.ERRORCODE = 'Insert failed';
                result.MESSAGE = String.valueOf(ins.getErrors());
                result.REQUESTID = transactionsSucessMapOld.get(newTransactionsOld.values().get(i).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD
                system.debug(' Errore transazione : ' + String.valueOf(ins.getErrors()));
                ws.Result_NotifyEvent.add(result);

                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore inserimento transazione', 'Error Message: ' + ins.getErrors(), String.valueOf(result), transactionsSucessMapOld.get(newTransactionsOld.values().get(i).Transaction_Id__c), '', null);
                logs.add(l);
            }

            i++;
        }
    }

    private static void executeEvent15(WS_ENIInteract.Response_NotifyEvent ws, Schema.SObjectField f){
        Integer i = 0;
        for (Database.UpsertResult upr : Database.upsert (eventPIVAContacts.values(), f, false)){
            Result_NotifyEvent result = new Result_NotifyEvent();
            if (upr.isSuccess()){
                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = '';
                result.CONTACT_KEY = upr.getId();//salesforce id of the created contact
                result.FISCALCODE = eventPIVAContacts.values().get(i).Fiscal_code__c.toUpperCase(); //codice fiscale del contatto creato
                result.TIPOLOGIA_UTENTE = '1'; // EN: restituzione della tipologia Utente
                result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                result.REQUESTID = successPIVAMap.get(eventPIVAContacts.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);

            } else{
                result.SUCCESS = false;
                result.ERRORCODE = 'Upsert failed';
                result.MESSAGE = String.valueOf(upr.getErrors());
                result.REQUESTID = successPIVAMap.get(eventPIVAContacts.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore inserimento contatto P.IVA', 'Errore: ' + upr.getErrors(), String.valueOf(result), successPIVAMap.get(eventPIVAContacts.values().get(i).Fiscal_code__c.toUpperCase()), '', null);
                logs.add(l);
                system.debug(upr.getErrors());
            }
            i++;
        }
    }

    private static void executeEvent16(WS_ENIInteract.Response_NotifyEvent ws, Schema.SObjectField f){
        Integer i = 0;
        for (Database.SaveResult upd : Database.update (event16ContactsToUpdate.values(), false)){
            Result_NotifyEvent result = new Result_NotifyEvent();
            if (upd.isSuccess()){
                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = '';
                result.CONTACT_KEY = upd.getId();//salesforce id of the created contact
                result.FISCALCODE = event16ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase(); //codice fiscale del contatto creato
                result.TIPOLOGIA_UTENTE = event16ContactsToUpdate.values().get(i).Customer_Type__c; // EN: restituzione della tipologia Utente
                result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                result.REQUESTID = successMap16.get(event16ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);

            } else{
                result.SUCCESS = false;
                result.ERRORCODE = 'Upsert failed';
                result.MESSAGE = String.valueOf(upd.getErrors());
                result.REQUESTID = successMap16.get(event16ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase());// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore aggiornamento contatto', 'Errore: ' + upd.getErrors(), String.valueOf(result), successMap16.get(event16ContactsToUpdate.values().get(i).Fiscal_code__c.toUpperCase()), '', null);
                logs.add(l);
                system.debug(upd.getErrors());
            }
            i++;
        }
    }

    private static void executeEvent17(WS_ENIInteract.Response_NotifyEvent res, Schema.SObjectField field){
        Integer count = 0;
        Map<Id, Contact> retryUpdates = new Map<Id, Contact>();
        /* upr : Database.upsert(otherContactsEvent17.values(), field, false)) {
         if(!upr.isSuccess()){
         retryUpdates.put(upr.getId(), otherContactsEvent17.values().get(count));
         }
         count++;
         }
         //gestione record locking per errore UNABLE_TO_LOCK_ROW
         if(retryUpdates.size()>0){
         Map<Id,Contact> contactMap = new Map<Id,Contact>([SELECT ID, Push_Notification__c,Flag_Privacy_ENI__c,
         Flag_Privacy_Analysis__c,Flag_Privacy_Partner__c,
         Cluster__c,Credit_card_association__c
         FROM Contact WHERE Id IN: retryUpdates.keySet() FOR UPDATE]);
         for(Id contactID : contactMap.keySet()){
         if(retryUpdates.containsKey(contactID)){
         Contact con = contactMap.get(contactID);
         Contact retryContact = retryUpdates.get(contactID);
         con.Push_Notification__c = retryContact.Push_Notification__c;
         con.Flag_Privacy_ENI__c = retryContact.Flag_Privacy_ENI__c;
         con.Flag_Privacy_Analysis__c = retryContact.Flag_Privacy_Analysis__c;
         con.Flag_Privacy_Partner__c = retryContact.Flag_Privacy_Partner__c;
         con.Cluster__c = retryContact.Cluster__c;
         con.Credit_card_association__c = con.Credit_card_association__c;
         contactMap.put(contactID, con);
         }
         }
         update contactMap.values();
         }*/
        //inserimento transaction
        count = 0;
        for (Database.SaveResult ins : Database.insert (newTransactionsEvent17.values(), false)){
            //...
            if (ins.isSuccess()){
                Result_NotifyEvent result = new Result_NotifyEvent();
                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = '';
                result.REQUESTID = transactionsSucessMapEvent17.get(newTransactionsEvent17.values().get(count).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD
                res.Result_NotifyEvent.add(result);
            } else{
                Result_NotifyEvent result = new Result_NotifyEvent();
                result.SUCCESS = false;
                result.ERRORCODE = 'Insert failed';
                result.MESSAGE = String.valueOf(ins.getErrors());
                result.REQUESTID = transactionsSucessMapEvent17.get(newTransactionsEvent17.values().get(count).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD
                res.Result_NotifyEvent.add(result);
                Log lg = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore inserimento transazione', 'Error Message: ' + ins.getErrors(), String.valueOf(result), transactionsSucessMapEvent17.get(newTransactionsEvent17.values().get(count).Transaction_Id__c), '', null);
                logs.add(lg);
            }
            count++;
        }
    }

    private static void executeEvent18(WS_ENIInteract.Response_NotifyEvent res, Schema.SObjectField field){
        WS_ENIInteract.Result_NotifyEvent result;
        Integer count = 0;
        if (!requiredFieldsEvent18.isEmpty()){
            for (String key : requiredFieldsEvent18.keySet()){
                result = new WS_ENIInteract.Result_NotifyEvent();
                result.SUCCESS = false;
                result.ERRORCODE = 'KO';
                result.MESSAGE = 'Mandatory fields ' + requiredFieldsEvent18.get(key).toString() + ' missing or incorrect';
                result.REQUESTID = key;

                res.Result_NotifyEvent.add(result);
            }
        }

        if (!event18ContactsToInsert.isEmpty()){
            //relate account to contact
            Map<String, Account> newAccountsMap = new Map<String, Account>();
            for (Contact c : event18ContactsToInsert.values()){
                String accountName = c.FirstName + ' ' + c.LastName;
                Account a = new Account(Name = accountName, Contact_code__c = c.Contact_code__c.toUpperCase());
                newAccountsMap.put(c.Contact_code__c, a);
            }
            insert newAccountsMap.values();
            for (Contact con : event18ContactsToInsert.values())
                con.AccountId = newAccountsMap.get(con.Contact_code__c).Id;
            for (Database.UpsertResult upr : Database.upsert (event18ContactsToInsert.values(), field, false)){
                if (upr.isSuccess()){
                    Contact cont = event18ContactsToInsert.values().get(count);
                    result = new WS_ENIInteract.Result_NotifyEvent();
                    result.SUCCESS = true;
                    result.ERRORCODE = 'OK';
                    result.MESSAGE = '';
                    result.EMAIL = cont.Email;
                    result.FIRST_NAME = cont.FirstName;
                    result.LAST_NAME = cont.LastName;
                    result.PRIVACY = cont.Flag_Privacy_ENI__c;
                    result.OPERATION_ID = Utils.generateOperationIdFromDateTime();
                    result.REQUESTID = successMap18.get(event18ContactsToInsert.values().get(count).Email.toUpperCase());
                    result.FLOW_CODE = 'ENL-018';
                    result.CONTACT_KEY = '';

                    res.Result_NotifyEvent.add(result);

                } else{
                    result = new Result_NotifyEvent();

                    result.SUCCESS = false;
                    result.ERRORCODE = 'KO';
                    result.MESSAGE = 'Insert failed / System error';
                    result.REQUESTID = successMap18.get(event18ContactsToInsert.values().get(count).Email.toUpperCase());
                    result.FLOW_CODE = 'ENL-018';

                    res.Result_NotifyEvent.add(result);
                    Log lg = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore inserimento contatto', 'Errore: ' + upr.getErrors(), String.valueOf(result), successMap18.get(event18ContactsToInsert.values().get(count).Email.toUpperCase()), '', null);
                    logs.add(lg);
                }
                count++;
            }
        }
    }

    /**
     * @author Christian Niro
     * @description execute Event 19
     */

    private static void executeEvent19(WS_ENIInteract.Response_NotifyEvent ws, Schema.SObjectField f){
        Integer i = 0;
        Integer j = 0;
        Integer z = 0;

        Map<Id, Contact> retryUpdates = new Map<Id, Contact>();


        List<Transaction__c> transazioniNuoveProd = new List<Transaction__c>();
        List<Transaction__c> transazioniUpdateProd = new List<Transaction__c>();


        for (Database.UpsertResult upr : Database.upsert (otherContacts.values(), f, false)){
            if (!upr.isSuccess()){
                retryUpdates.put(upr.getId(), otherContacts.values().get(i));
            }

            i++;
        }
        //gestione record locking per errore UNABLE_TO_LOCK_ROW
        if (retryUpdates.size() > 0){
            Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT ID, Push_Notification__c, Flag_Privacy_ENI__c, Flag_Privacy_Analysis__c, Flag_Privacy_Partner__c, Cluster__c, Credit_card_association__c
                                                                FROM Contact
                                                                WHERE Id IN:retryUpdates.keySet()
                                                                FOR  UPDATE ]);

            for (Id contactID : contactMap.keySet()){
                if (retryUpdates.containsKey(contactID)){
                    Contact con = contactMap.get(contactID);
                    Contact retryContact = retryUpdates.get(contactID);
                    con.Push_Notification__c = retryContact.Push_Notification__c;
                    con.Flag_Privacy_ENI__c = retryContact.Flag_Privacy_ENI__c;
                    con.Flag_Privacy_Analysis__c = retryContact.Flag_Privacy_Analysis__c;
                    con.Flag_Privacy_Partner__c = retryContact.Flag_Privacy_Partner__c;
                    con.Cluster__c = retryContact.Cluster__c;
                    con.Credit_card_association__c = con.Credit_card_association__c;
                    contactMap.put(contactID, con);
                }
            }

            update contactMap.values();

        }

        i = 0;


        for (Transaction__c trans : newTransactionsEvent19.values()){
            if (trans.Enl_Orario_Effettivo__c == null || (String.isBlank(trans.Enl_Motivo_Storno__c) && trans.Enl_Motivo_Storno__c == null)){
                transazioniNuoveProd.add(trans);
            } else{
                transazioniUpdateProd.add(trans);
            }
        }

        for (Database.SaveResult ins : Database.insert (transazioniNuoveProd, false)){
            //...

            String transactionId = ins.getId();

            
            for (List<ProdottiEmporium> products : mapListProd.values()){
                
                for (ProdottiEmporium prod : products){
                    
                    Enl_Prodotti_Emporium__c enlProd = new Enl_Prodotti_Emporium__c();
                    
                    enlProd.Name = prod.DESCRIZIONE_ARTICOLO;
                    enlProd.Enl_Numero_Ordine_c__c = WS_ENIInteract.getKeyMap(mapListProd, products);
                    enlProd.TransactionId__c = transactionId;
                    enlProd.Enl_Categoria__c = prod.CATEGORIA;
                    enlProd.Enl_Codice_Articolo__c = prod.CODICE_ARTICOLO;
                    enlProd.Enl_Descrizione_Articolo__c = prod.DESCRIZIONE_ARTICOLO;
                    enlProd.Enl_Quantita_Pezzi__c = prod.QUANTITA_PEZZI;
                    enlProd.Enl_Importo_Unitario__c = prod.IMPORTO_UNITARIO;
                    enlProd.Enl_Transaction_Code__c = transazioniNuoveProd.get(j).ENL_Transaction_Code__c;
                    if(transazioniNuoveProd.get(j).ENL_NumeroOrdineProdEmp__c == enlProd.Enl_Numero_Ordine_c__c){
                        event19Prodotti.put(enlProd.Enl_Transaction_Code__c + z, enlProd);
                        z++;
                    }
                    
                }

               
            }


            if (ins.isSuccess()){
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = '';
                result.REQUESTID = transactionsSucessMapEvent19.get(transazioniNuoveProd.get(i).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
            } else{
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = false;
                result.ERRORCODE = 'Insert failed';
                result.MESSAGE = String.valueOf(ins.getErrors());
                System.debug('Error: ' + String.valueOf(ins.getErrors()));
                result.REQUESTID = transactionsSucessMapEvent19.get(transazioniNuoveProd.get(i).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);

                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore inserimento transazione event 19', 'Error Message: ' + ins.getErrors(), String.valueOf(result), transactionsSucessMapEvent19.get(transazioniNuoveProd.get(i).Transaction_Id__c), '', null);
                logs.add(l);
            }

            i++;
            j++;
        }


        for (Database.SaveResult s : Database.insert (event19Prodotti.values(), false)){
            //...
            if (s.isSuccess()){
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = '';


                ws.Result_NotifyEvent.add(result);
            } else{
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = false;
                result.ERRORCODE = 'Insert failed';
                result.MESSAGE = String.valueOf(s.getErrors());


                ws.Result_NotifyEvent.add(result);

                
            }

            i++;
        }

        i = 0;

        if (transazioniUpdateProd.size() > 0){
            TriggerManager.skipTrigger('TransactionTrigger');
            for (Database.SaveResult ins : Database.insert (transazioniUpdateProd, false)){
                //...

                if (ins.isSuccess()){
                    Result_NotifyEvent result = new Result_NotifyEvent();

                    result.SUCCESS = true;
                    result.ERRORCODE = '';
                    result.MESSAGE = '';
                    result.REQUESTID = transactionsSucessMapEvent19.get(transazioniUpdateProd.get(i).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD

                    ws.Result_NotifyEvent.add(result);
                } else{
                    Result_NotifyEvent result = new Result_NotifyEvent();

                    result.SUCCESS = false;
                    result.ERRORCODE = 'Insert failed';
                    result.MESSAGE = String.valueOf(ins.getErrors());
                    result.REQUESTID = transactionsSucessMapEvent19.get(transazioniUpdateProd.get(i).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD

                    ws.Result_NotifyEvent.add(result);

                    Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore inserimento transazione evento 19', 'Error Message: ' + ins.getErrors(), String.valueOf(result), transactionsSucessMapEvent19.get(transazioniUpdateProd.get(i).Transaction_Id__c), '', null);
                    logs.add(l);
                }

                i++;
            }
            TriggerManager.unskipTrigger('TransactionTrigger');
        }

        Set<Id> transactionIds = new Set<Id>();        
        Map<Id, Id> linkedIdMap = new Map<Id, Id>();    
        for (Transaction__c item : updateTransactionsEvent19.values())
            //chiave: Id transazione tariffa integrata, valore: Id transazione tariffa integrata corrispondente
            transactionIds.add(item.Id);
        List<Transaction__c> existingTransactionsToBeLinked = new List<Transaction__c>();
        existingTransactionsToBeLinked = [SELECT Id, Related_transaction_id__c
                                          FROM Transaction__c
                                          WHERE Related_transaction_id__c IN:transactionIds];
        for (Transaction__c item2 : existingTransactionsToBeLinked)
            linkedIdMap.put(item2.Related_transaction_id__c, item2.Id);
        for (Transaction__c item3 : updateTransactionsEvent19.values())
            item3.Related_transaction_id__c = linkedIdMap.get(item3.Id);
        i = 0;

        for (Database.SaveResult upd : Database.update (updateTransactionsEvent19.values(), false)){
            //...
            if (upd.isSuccess()){
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = true;
                result.ERRORCODE = '';
                result.MESSAGE = '';
                result.REQUESTID = transactionsSucessMapEvent19.get(updateTransactionsEvent19.values().get(i).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);
            } else{
                Result_NotifyEvent result = new Result_NotifyEvent();

                result.SUCCESS = false;
                result.ERRORCODE = 'Update failed';
                result.MESSAGE = String.valueOf(upd.getErrors());
                System.debug('ERRORE: ' + upd.getErrors());
                result.REQUESTID = transactionsSucessMapEvent19.get(updateTransactionsEvent19.values().get(i).Transaction_Id__c);// SAME VALUE OF EVENT_ID FIELD

                ws.Result_NotifyEvent.add(result);

                Log l = new Log('ERROR', 'WS_ENIInteract.NotifyEvent', 'Errore aggiornamento transazione event 19', 'Error Message: ' + upd.getErrors(), String.valueOf(result), transactionsSucessMapEvent19.get(updateTransactionsEvent19.values().get(i).Transaction_Id__c), '', null);
                logs.add(l);
            }

            i++;
        }
    }

    /**
     * @author Christian Niro
     * @description recupero chiave mapProduct
     * @date 03/10/2022
     */

    public static String getKeyMap(Map<String,List<ProdottiEmporium>> mapListProd, List<ProdottiEmporium> valueP){

        String keyFinal ;

        for(String key : mapListProd.keySet()){

            if(mapListProd.get(key) == valueP){
                keyFinal = key;
            }
                
        }

        return keyFinal;



    }

    public class voucherValues{
        public String C_BUONO = '';
        public String E_BUONO = '';
        public voucherValues(String cb, String eb){
            C_BUONO = cb;
            E_BUONO = eb;
        }

    }

    @TestVisible
    public static Map<String, CC_Service_Station__c> queryExistingServiceStations(List<WS_ENIInteract.Request_NotifyEvent> req){

        Map<String, CC_Service_Station__c> resMap = new Map<String, CC_Service_Station__c>();
        Set<String> ssCode = new Set<String>();

        for (WS_ENIInteract.Request_NotifyEvent lis : req){
            if ((new Set<String>{ '11', '18' }).contains(lis.EVENT_TYPE) && !String.isEmpty(lis.IMPIANTO)){
                ssCode.add(lis.IMPIANTO);
            }
        }
        for (CC_Service_Station__c s : [SELECT Id, CC_Service_Station_Code__c
                                        FROM CC_Service_Station__c
                                        WHERE CC_Service_Station_Code__c IN:ssCode]){
            resMap.put(s.CC_Service_Station_Code__c, s);
        }

        return resMap;
    }

}