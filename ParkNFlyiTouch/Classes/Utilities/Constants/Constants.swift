
//Useful objects
var naviController: BaseNavigationController?

//Storyboards
let kLogin = "Login"
let kMain = "Main"
let kOnlot = "Onlot"
let kCheckOut = "CheckOut"

//App Specific
#if arch(i386) || arch(x86_64)
let kDeviceIdentifer: String = "" //Parknfly-Dev...ParkNFlyDemo1...somnathk
#else
let kDeviceIdentifer: String = ""
#endif

let kPasscode: Int = 20600 //Hard coded passcode

//Special Server Functionality
let kLax = "LAXPOS"

//Webserivces
let kLoginWebservice = "LoginWebservice"
let kGetFacilityConfig = "GetFacilityConfig"
let kGetDeviceIdByDeviceAddress = "GetDeviceIdByDeviceAddress"
let kGetProductSet = "GetProductSet"
let kGetAllLocation = "GetAllLocation"
let KGetVehicleMake = "getVehicleMake"
let kGetiTouchConfig = "GetiTouchConfig"
let kLoadFrequentParkerByFPCardNoForReservation = "LoadFrequentParkerByFPCardNoForReservation"
let kLoadFrequentParkerByFPCardNoForFPCard = "LoadFrequentParkerByFPCardNoForFPCard"
let kLoadFrequentParkerByFPCardNoByPhoneNoOfReservation = "LoadFrequentParkerByFPCardNoForPhoneNo"
let kLoadFrequentParkerByFPCardNoByPhoneNoOfFpCard = "LoadFrequentParkerByFPCardNoForPhoneNoForFpCardNo"
let kLoadMultipleFrequentParkerByFPCardNo = "LoadMultipleFrequentParkerByFPCardNo"
let kLoadFrequentParkerByFPCardNo = "LoadFrequentParkerByFPCardNo"
let kLoadTicketsByPhoneNumber = "GetAllTicketsPhoneSearch"
let kLoadDetailsByLastName = "GetAllReservationsBySearchParam"
let kLoadTicketsByVIN = "GetTicketByBarcodeVIN"
let kLoadTicketsByTag = "GetTicketByBarcodeTag"
let kLoadReservationDetailsByReservationForCheckout = "GetAllReservationsBySearchParamReservation"
let kLoadTicketsByLastName = "GetAllTicketsLastNameSearch"
let kGetTicketForFPCardNo = "GetTicketForFPCardNo"
let kGetTicketForReservationNo = "GetTicketForReservationNo"
let kGetTicketByBarcode = "GetTicketByBarcode"
let kUpdateValetInfoForTablet = "UpdateValetInfoForTablet"
let kAddTicketUpdateValetInfoForTabletService = "AddTicketUpdateValetInfoForTabletService"
let kValidateNumberService = "ValidateNumber"
let kGenerateTicketForTablet = "GenerateTicketForTablet"
let kGetServiceTypesByFacilityIDService = "GetServiceTypesByFacilityIDService"
let kGetProductSetAddonTypeService = "GetProductSetAddonTypeService"
let kSaveDamagesAndValuablesService = "SaveDamagesAndValuablesService"
let kVehicleInfoByVIN = "VehicleInfoByVIN"
let kUpdateVehicleInfoService = "UpdateVehicleInfo"
let kCalculateRate = "CalculateRate"
let kGetAvailableDiscounts = "GetAvailableDiscounts"
let kGetDiscountsByBarcodeOrName = "GetDiscountsByBarcodeOrName"
let kGetDiscountsFromClubCode = "GetDiscountsFromClubCode"
let kValidateCardTypeEncryptedNumber = "ValidateCardTypeEncryptedNumber"
let kValidateCardTypeEncryptedNumberForIdentifier = "ValidateCardTypeEncryptedNumberForIdentifier"
let kValidateCardTypeEncryptedNumberForBarcode = "ValidateCardTypeEncryptedNumberForBarcode"
let kValidateCardTypeEncryptedNumberForLookUP = "ValidateCardTypeEncryptedNumberForLookUP"
let kGetDiscountsAssoicatedWithLoyalty = "GetDiscountsAssoicatedWithLoyalty"
let kValidateDiscountsRules = "ValidateDiscountsRules"
let kProcessPayment = "PaymentProcess"
let kGetCreditCardAssociatedWithFP = "GetCreditCardAssociatedWithFP"
let kServiceHistoryBYTagOrVIN = "ServiceHistoryBYTagOrVIN"
let kGetLocationHistoryOfTicket = "GetLocationHistoryOfTicket"
let kGetTicketFromServer = "GetTicketFromServer"
let kShiftClose = "ShiftClose"
let kAddUpdateVehicle = "AddUpdateVehicle"
let kGetVehicleInfomation = "GetVehicleInfomation"
let kInsertCustomLogFromClient = "InsertCustomLogFromClient"
let kCheckIsTicketAlreadyExistService = "CheckIsTicketAlreadyExistService"
let kGetContractCard = "GetContractCard"

//Genetal Constants
let kParkingTypeActionSheet = "ParkingTypeActionSheet"
let kCreditCardTypeActionSheet = "CreditCardTypeActionSheet"
let kLocationNamesActionSheet =  "LocationNamesActionSheet"
let kGetAllTicketNotes = "GetAllTicketNotes"
let kAddTicketNotes = "AddTicketNotes"

//Dictionary Keys Constants
let kInnerText = "innerText"
let kAttributedData = "attributedData"

///Discount card type
let kDiscountCouponCode = "DiscountCouponCode"
let kAAA = "AAA"
let kCAP = "CAP"

//enum for main screen
enum FlowStatus {
    case kCheckInFlow
    case kCheckOutFlow
    case kOnLotFlow
}

//enum for colors
enum Colors: Int64 {
    case kMaroon = 1
    case kRed = 2
    case kBlue = 3
    case kGreen = 4
    case kYellow = 5
    case kOrange = 6
    case kPurple = 7
    case kGoldenrod = 8
    case kDarkGray = 9
    case kGray = 10
    case kWhite = 11
    case kBlack = 12
}

enum ScanType {
    case kPreprintedTicket
    case kVINNumber
    case kPreprintedTicketForLookup
}
