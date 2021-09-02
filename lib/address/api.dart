import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:managers_view/address/url.dart';
import 'package:managers_view/encrypt/encrypt.dart';
import 'package:retry/retry.dart';
import 'dart:convert';

Future getReturnedTranList() async {
  // String url = UrlAddress.url + '/getreturnedlist';
  var url = Uri.parse(UrlAddress.url + '/getreturnedlist');
  final response = await retry(
      () => http.post(url, headers: {"Accept": "Application/json"}, body: {}));
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future checkStat() async {
  try {
    // String url = UrlAddress.url + '/checkstat';
    var url = Uri.parse(UrlAddress.url + '/checkstat');
    final response =
        await http.post(url, headers: {"Accept": "Application/json"}, body: {});
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  } on SocketException {
    return 'ERROR1';
  } on HttpException {
    return 'ERROR2';
  } on FormatException {
    return 'ERROR3';
  }
}

Future loginUser(String username, String password) async {
  // String url = UrlAddress.url + '/managersignin';
  var url = Uri.parse(UrlAddress.url + '/managersignin');
  final response = await retry(() => http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'username': encrypt(username), 'password': encrypt(password)}));
  var convertedDatatoJson = jsonDecode(response.body);
  return convertedDatatoJson;
}

Future getSalesType() async {
  // var url = Uri.parse(UrlAddress.url + '/getsalestype');
  var url = Uri.parse(UrlAddress.url + '/getsalestype');
  final response =
      await http.post(url, headers: {"Accept": "Application/json"}, body: {});
  var convertedDatatoJson = jsonDecode(response.body);
  return convertedDatatoJson;
}

Future getTotalSalesType() async {
  // Uri url = UrlAddress.url + '/gettotalsalestype';
  var url = Uri.parse(UrlAddress.url + '/gettotalsalestype');
  final response =
      await http.post(url, headers: {"Accept": "Application/json"}, body: {});
  var convertedDatatoJson = jsonDecode(response.body);
  return convertedDatatoJson;
}

Future getBooked(String date) async {
  // String url = UrlAddress.url + '/gettotalbooked';
  var url = Uri.parse(UrlAddress.url + '/gettotalbooked');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"}, body: {'date_req': date});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getDelivered(String date) async {
  // String url = UrlAddress.url + '/gettotaldelivered';
  var url = Uri.parse(UrlAddress.url + '/gettotaldelivered');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"}, body: {'date_del': date});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getSalesmanInformations(String code) async {
  // String url = UrlAddress.url + '/getsminfo';
  var url = Uri.parse(UrlAddress.url + '/getsminfo');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'user_code': encrypt(code)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getHepeInformations(String code) async {
  // String url = UrlAddress.url + '/gethepeinfo';
  var url = Uri.parse(UrlAddress.url + '/gethepeinfo');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'user_code': encrypt(code)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getAllBooked(String code, String date) async {
  // String url = UrlAddress.url + '/getallbooked';
  var url = Uri.parse(UrlAddress.url + '/getallbooked');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'sm_code': encrypt(code), 'date_req': encrypt(date)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getAllDelivered(String code, String date) async {
  // String url = UrlAddress.url + '/getalldelivered';
  var url = Uri.parse(UrlAddress.url + '/getalldelivered');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'hepe_code': encrypt(code), 'date_del': encrypt(date)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getAllSMTransactionsHistory(String code) async {
  // String url = UrlAddress.url + '/getsmhistory';
  var url = Uri.parse(UrlAddress.url + '/getsmhistory');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'sm_code': encrypt(code)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getAllHEPETransactionsHistory(String code) async {
  // String url = UrlAddress.url + '/gethepehistory';
  var url = Uri.parse(UrlAddress.url + '/gethepehistory');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'hepe_code': encrypt(code)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getOrders(String transNo) async {
  // String url = UrlAddress.url + '/getorders';
  var url = Uri.parse(UrlAddress.url + '/getorders');
  final response = await http.post(url, headers: {
    "Accept": "Application/json"
  }, body: {
    'tran_no': encrypt(transNo),
  });
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getRemovedOrders(String transNo) async {
  // String url = UrlAddress.url + '/getremovedorders';
  var url = Uri.parse(UrlAddress.url + '/getremovedorders');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'tran_no': encrypt(transNo)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getUnservedOrders(String transNo) async {
  // String url = UrlAddress.url + '/getunservedorders';
  var url = Uri.parse(UrlAddress.url + '/getunservedorders');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'tran_no': encrypt(transNo)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getReturnedOrders(String transNo) async {
  // String url = UrlAddress.url + '/getreturnedorders';
  var url = Uri.parse(UrlAddress.url + '/getreturnedorders');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'tran_no': encrypt(transNo)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getDeliveredOrders(String transNo) async {
  // String url = UrlAddress.url + '/getdeliveredorders';
  var url = Uri.parse(UrlAddress.url + '/getdeliveredorders');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'tran_no': encrypt(transNo)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future checkDiscounted(String usercode) async {
  // String url = UrlAddress.url + '/checkdiscounted';
  var url = Uri.parse(UrlAddress.url + '/checkdiscounted');
  final response = await http.post(url, headers: {
    "Accept": "Application/json"
  }, body: {
    'account_code': usercode,
  });
  var convertedDatatoJson = jsonDecode(response.body);
  return convertedDatatoJson;
}

Future getCheque(String transNo) async {
  // String url = UrlAddress.url + '/getcheque';
  var url = Uri.parse(UrlAddress.url + '/getcheque');
  final response = await http.post(url, headers: {
    "Accept": "Application/json"
  }, body: {
    'tran_no': encrypt(transNo),
  });
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getDailySales(String type) async {
  // String url = UrlAddress.url + '/getdailysales';
  var url = Uri.parse(UrlAddress.url + '/getdailysales');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'pmeth_type': encrypt(type)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getWeeklySales(String type) async {
  // String url = UrlAddress.url + '/getweeklysales';
  var url = Uri.parse(UrlAddress.url + '/getweeklysales');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'pmeth_type': encrypt(type)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getMonthlySales(String type) async {
  // String url = UrlAddress.url + '/getmonthlysales';
  var url = Uri.parse(UrlAddress.url + '/getmonthlysales');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'pmeth_type': encrypt(type)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getYearlySales(String type) async {
  // String url = UrlAddress.url + '/getyearlysales';
  var url = Uri.parse(UrlAddress.url + '/getyearlysales');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'pmeth_type': encrypt(type)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getCustomerDailySales(String type) async {
  // String url = UrlAddress.url + '/getcustdailysales';
  var url = Uri.parse(UrlAddress.url + '/getcustdailysales');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'pmeth_type': encrypt(type)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getCustomerWeeklySales(String type) async {
  // String url = UrlAddress.url + '/getcustweeklysales';
  var url = Uri.parse(UrlAddress.url + '/getcustweeklysales');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'pmeth_type': encrypt(type)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getCustomerMonthlySales(String type) async {
  // String url = UrlAddress.url + '/getcustmonthlysales';
  var url = Uri.parse(UrlAddress.url + '/getcustmonthlysales');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'pmeth_type': encrypt(type)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getCustomerYearlySales(String type) async {
  // String url = UrlAddress.url + '/getcustyearlysales';
  var url = Uri.parse(UrlAddress.url + '/getcustyearlysales');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'pmeth_type': encrypt(type)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getItemDailySales() async {
  // String url = UrlAddress.url + '/getitemdailysales';
  var url = Uri.parse(UrlAddress.url + '/getitemdailysales');
  final response =
      await http.post(url, headers: {"Accept": "Application/json"}, body: {});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getItemWeeklySales() async {
  // String url = UrlAddress.url + '/getitemweeklysales';
  var url = Uri.parse(UrlAddress.url + '/getitemweeklysales');
  final response =
      await http.post(url, headers: {"Accept": "Application/json"}, body: {});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getItemMonthlySales() async {
  // String url = UrlAddress.url + '/getitemmonthlysales';
  var url = Uri.parse(UrlAddress.url + '/getitemmonthlysales');
  final response =
      await http.post(url, headers: {"Accept": "Application/json"}, body: {});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getItemYearlySales() async {
  // String url = UrlAddress.url + '/getitemyearlysales';
  var url = Uri.parse(UrlAddress.url + '/getitemyearlysales');
  final response =
      await http.post(url, headers: {"Accept": "Application/json"}, body: {});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future changeManagerPassword(String code, String pass) async {
  // String url = UrlAddress.url + '/changemanagerpassword';
  var url = Uri.parse(UrlAddress.url + '/changemanagerpassword');
  final response = await retry(() => http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'user_code': encrypt(code), 'password': encrypt(pass)}));
  var convertedDatatoJson = jsonDecode(response.body);
  return convertedDatatoJson;
}

Future checkManagerusername(String username) async {
  // String url = 'http://172.16.44.122/my_store/signin';
  // String url = UrlAddress.url + '/checkmanager';
  var url = Uri.parse(UrlAddress.url + '/checkmanager');
  final response = await http.post(url,
      headers: {"Accept": "Application/json"},
      body: {'username': encrypt(username)});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future addSmsCode(String username, String code, String mobile) async {
  // String url = UrlAddress.url + '/addsmscode';
  var url = Uri.parse(UrlAddress.url + '/addsmscode');
  final response = await retry(() => http.post(url, headers: {
        "Accept": "Application/json"
      }, body: {
        'username': encrypt(username),
        'smscode': encrypt(code),
        'mobile': encrypt(mobile)
      }));
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future checkSmsCode(String username, String code) async {
  // String url = UrlAddress.url + '/checksmscode';
  var url = Uri.parse(UrlAddress.url + '/checksmscode');
  final response = await retry(() => http.post(url, headers: {
        "Accept": "Application/json"
      }, body: {
        'username': encrypt(username),
        'smscode': encrypt(code),
      }));
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future updateManagersStatusOnline(String username) async {
  String stat = '0';
  // String url = UrlAddress.url + '/updatemgstatus';
  var url = Uri.parse(UrlAddress.url + '/updatemgstatus');
  final response = await retry(() => http.post(url, headers: {
        "Accept": "Application/json"
      }, body: {
        'username': encrypt(username),
        'status': encrypt(stat),
      }));
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getMGPasswordHistory(String userId, String password) async {
  // String url = UrlAddress.url + '/checkmgpasshistory';
  var url = Uri.parse(UrlAddress.url + '/checkmgpasshistory');
  // var passwordF = md5.convert(utf8.encode(password));
  final response = await retry(() => http.post(url, headers: {
        "Accept": "Application/json"
      }, body: {
        'account_code': encrypt(userId),
        'password': encrypt(password),
      }));
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future checkAppversion(tvar) async {
  var url = Uri.parse(UrlAddress.url + '/checkappversion');
  // var passwordF = md5.convert(utf8.encode(password));
  final response = await retry(() => http.post(url,
      headers: {"Accept": "Application/json"}, body: {'tvar': encrypt(tvar)}));
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getAllMessageHead() async {
  var url = Uri.parse(UrlAddress.url + '/getallmessagehead');
  // var passwordF = md5.convert(utf8.encode(password));
  final response = await retry(
      () => http.post(url, headers: {"Accept": "Application/json"}, body: {}));
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getAllMessageLog() async {
  // String url = UrlAddress.url + '/getallmessagehead';
  var url = Uri.parse(UrlAddress.url + '/getallmessageheadlog');
  // var passwordF = md5.convert(utf8.encode(password));
  final response = await retry(
      () => http.post(url, headers: {"Accept": "Application/json"}, body: {}));
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getMessage(ref) async {
  // String url = UrlAddress.url + '/getmessage';
  var url = Uri.parse(UrlAddress.url + '/getmessage');
  // var passwordF = md5.convert(utf8.encode(password));
  final response = await retry(() => http.post(url,
      headers: {"Accept": "Application/json"}, body: {'ref_no': encrypt(ref)}));
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future sendMsg(code, ref, msg) async {
  // String url = UrlAddress.url + '/addreply';
  var url = Uri.parse(UrlAddress.url + '/addreply');
  // var passwordF = md5.convert(utf8.encode(password));
  final response = await retry(() => http.post(url, headers: {
        "Accept": "Application/json"
      }, body: {
        'account_code': encrypt(code),
        'ref_no': encrypt(ref),
        'msg_body': encrypt(msg)
      }));
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future changeMsgStat(ref) async {
  // String url = UrlAddress.url + '/changemsgstat';
  var url = Uri.parse(UrlAddress.url + '/changemsgstat');
  // var passwordF = md5.convert(utf8.encode(password));
  final response = await retry(() => http.post(url,
      headers: {"Accept": "Application/json"}, body: {'ref_no': encrypt(ref)}));
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getAllSalesmanInfo() async {
  // String url = UrlAddress.url + '/getsminfo';
  var url = Uri.parse(UrlAddress.url + '/getallsminfo');
  final response =
      await http.post(url, headers: {"Accept": "Application/json"}, body: {});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}

Future getAllHepeInfo() async {
  // String url = UrlAddress.url + '/getsminfo';
  var url = Uri.parse(UrlAddress.url + '/getallhepeinfo');
  final response =
      await http.post(url, headers: {"Accept": "Application/json"}, body: {});
  var convertedDatatoJson = jsonDecode(decrypt(response.body));
  return convertedDatatoJson;
}
