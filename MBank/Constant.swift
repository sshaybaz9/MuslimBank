    //
    //  Constant.swift
    //  
    //
    //  Created by Mac on 23/02/18.
    //
    //
//9890654050
    import Foundation


    struct Constant {
        
        static let Domain = "https://mbankmobileapp.com:8443/Mbank_api_test/"
        
        static let DomainTest = "https://mbankmobileapp.com:8443/Mbank_api/"
        
        struct POST {
        struct VERIFICATION {
        static let VERIFY = Domain + "verification.php";
        }
        struct SETUPLOGINPIN {
        static let  SETUPPIN = Domain + "setuppin.php";
        }
        struct SETUPPINVERIFICATION {
        static let SETUPPINVERIFY = Domain + "setuppinverification.php";
        }
            struct DASHBOARDLOGIN {
        static let  LOGIN = Domain + "dashboardlogin.php";
        }
            struct GUESTLOGINDASHBOARD{
                static let GUESTLOGIN = "guestlogintodashboard.php"
            }
        struct PTOPTRANSFER {
        static let TRANSFER = Domain + "transact.php";
        }
        struct GETSTATEMENT {
        static  let STATEMENT = Domain + "getministatement.php";
        }
        struct PTOATRANSFER {
        static let TRANSFER = Domain + "transactptoa.php";
        }
        struct GENERATEMMID {
        static let MMIDGEN = Domain + "generatemmid.php";
        }
        struct DISABLEMMID {
        static let MMIDDIS = Domain + "disablemmid.php";
        }
        struct TRANSENQUIRY {
        static let TRANSENQ = Domain + "transactioninquiry.php";
        }
        struct BALANCEINQUIRY {
        static  let INQUIRY = Domain + "balanceinquiry.php";
        }
        struct VERIFYMOBILEUPDATEACTIVATIONCODE {
        static let VMUA = Domain + "verifyupdatemobileactivation.php";
        }
        struct VERIFYACTIVATIONCODE {
        static let VERIFY = Domain + "verifyactivationcode.php";
        }
        struct GETOTPFORPINCHANGE {
        static let GETOTP = Domain + "getotpforpinchange.php";
        }
        struct  VERIFYOTP {
        static let  verifyOtp = Domain + "verifyotp.php";
        }
        struct OPENFD {
        static let openfd = Domain + "fdaccountopening.php";
        }
        struct OPENRD {
        static  let openrd = Domain + "rdaccountopening.php";
        }
        struct GETNEARBYATMS {
        static let atms = Domain + "getplaces.php";
        }
        struct  SCHEMELIST {
        static let schemelist = Domain + "schemeslist.php";
        }
        struct DEPOSITLIST{
        static let depositlist = Domain + "rdfdlist.php";
        }
        struct GETSECRET {
        static let secret = Domain + "getsecret.php";
        }
        struct SAVEPROFILE {
        static let saveprofile = Domain + "saveprofile.php";
        }
        
        struct TRANSACTIONHISTORYLIST {
        static let transactionHistory = Domain + "gettranshistory.php";
        }
        
        struct CHANGELOGINPIN {
        static let changeLoginPin = Domain + "changeloginpin.php";
        }
        
        struct RETRIEVEMMID {
        static let retrievemmid = Domain + "retrievemmid.php";
        }
        
        struct SHOWMINISTATEMENT {
        static let ministatement = Domain + "cbsministatement.php";
        }
        
        struct UPDATERATING {
        static let updaterating = Domain + "updaterating.php";
        }
        
        struct ADDPAYEE {
        static let addPayee = Domain + "addbeneficiary.php";
        }
        
        struct FETCHALLPAYEE{
        static let fetchpayee = Domain + "fetchallpayees.php";
        }
        
        struct VERIFYMOBILENO {
        static let verifymobileno = Domain + "verifywithmobile.php";
        }
        
        struct VERIFYGENERICOTP {
        static let  verifygenericotp = Domain + "verifygenericotp.php";
        }
        
        struct DELETEPAYEE {
        static let deletePayee = Domain + "deletepayee.php";
        }
        
        struct TRANSACTIONOTP {
        static  let getTransactionOtp = Domain + "gettransactionotpp.php";
        }
        
        struct TRANSACTIONOTPVERIFICATION {
        static  let transactionotpVerification = Domain + "verifytransactionotpp.php";
        }
        
        struct GETTRANSACCOUNTS {
        static let transaccounts = Domain + "getTransAccounts.php";
        }
        }
    }
