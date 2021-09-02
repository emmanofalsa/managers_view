import 'dart:async';

import 'dart:ui';

class AppData {
  static String appName = "E-COMMERCE(MANAGER'S VIEWING)";
  static String appVersion;
  static String appYear = ' COPYRIGHT 2021';
  static bool appUptodate = true;
  static String updesc = 'MGAPP';
}

class GlobalVariables {
  static String itmQty;
  static int menuKey = 0;
  static String tranNo;
  static bool isDone = false;
  static bool showSign = false;
  static bool showCheque = false;
  static List itemlist = [];
  static List favlist = [];
  static List returnList = [];
  static bool emptyFav = true;
  static bool processedPressed = false;
  static String minOrder;
  static bool outofStock = false;
  static bool consolidatedOrder = false;
  static String appVersion = '01';
  static String updateType = '';
  static bool updateSpinkit = true;
  static bool uploaded = false;
  static String tableProcessing = '';
  static List processList = [];
  // static List<String> processList = List<String>();
  // processList['process'] = '';
  static bool viewPolicy = true;
  static bool dataPrivacyNoticeScrollBottom = false;
  static String fpassUsername;
  static String fpassmobile;
  static String fpassusercode;
  static String newDate;
  static String newDatetodayFormat;
  static bool passExp = false;
}

class GlobalTimer {
  static Timer timerSessionInactivity;
}

class NetworkData {
  static Timer timer;
  static bool connected = false;
  static bool errorMsgShow = true;
  static String errorMsg;
  static bool uploaded = false;
  static String errorNo;
}

class ForgetPassData {
  static String type;
  static String smsCode;
  static String number;
}

class UserData {
  static String id;
  static String firstname;
  static String lastname;
  static String position;
  static String department;
  static String division;
  static String district;
  static String contact;
  static String postal;
  static String email;
  static String address;
  static String routes;
  // static String trans;
  static String sname;
  static String username;
  static String newPassword;
  static String passwordAge;
}

class SalesData {
  static String salesToday;
  static String salesWeekly;
  static String salesMonthly;
  static String salesYearly;
  static String salesmanSalesType;
  static String customerSalesType;
  static String itemSalesType;
  static String overallSalesType;
  static String smTotalCaption;
  static String custTotalCaption;
  static String itmTotalCaption;
}

class CustomerData {
  static String trans;
  static String sname;
  static String id;
  static String accountCode;
  static String groupCode;
  static String province;
  static String city;
  static String district;
  static String accountName;
  static String accountDescription;
  static String contactNo;
  static String paymentType;
  static String status;
  static String colorCode;
  static Color custColor;
  static String creditLimit;
  static String creditBal;
  static bool discounted = false;
  static List tranNoList = [];
}

class SalesmanData {
  static String firstname;
  static String lastname;
  static String accountcode;
  static String department;
  static String division;
  static String mobile;
  static String img;
  static String district;
  static String area;
  static String address;
  static String title;
  static String email;
  static String status;
  static String bookedAmt;
  static String totalAmt;
}

class HepeData {
  static String firstname;
  static String lastname;
  static String accountcode;
  static String department;
  static String division;
  static String mobile;
  static String img;
  static String district;
  static String area;
  static String address;
  static String title;
  static String email;
  static String status;
  static String deliveredAmt;
  static String totalAmt;
}

class OrderData {
  static String trans;
  static String pmeth;
  static String name;
  static String dateReq;
  static String dateApp;
  static String dateDel;
  static String itmno;
  static String address;
  static String contact;
  static String qty;
  static String smcode;
  static String totamt;
  static String retAmt;
  static String totalDisc;
  static String grandTotal;
  static bool visible = true;
  static String status;
  static String changeStat;
  static String signature;
  static String pmtype;
  static bool setPmType = false;
  static bool setSign = false;
  static bool setChequeImg = false;
  static List tranLine = [];
  static bool returnOrder = false;
  static String returnReason;
}

class ChequeData {
  static String payeeName;
  static String payorName;
  static String bankName;
  static String chequeNum;
  static String branchCode;
  static String bankAccNo;
  static String chequeDate;
  static String status;
  static String chequeAmt;
  static String numToWords;
  static String imgName;
  static bool changeImg = false;
}

class ChatData {
  static String senderName;
  static String accountCode;
  static String accountName;
  static String accountNum;
  static String refNo;
  static String status;
  static bool newNotif = false;
}
