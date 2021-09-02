import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:managers_view/address/api.dart';
import 'package:managers_view/address/url.dart';
import 'package:managers_view/global/variables.dart';
// import 'package:managers_view/home/menu.dart';
import 'package:managers_view/session/session_timer.dart';
import 'package:managers_view/today/order_tracking.dart';
import 'package:managers_view/variables/assets.dart';
import 'package:managers_view/variables/colors.dart';
import 'package:managers_view/widgets/buttons.dart';

class SalesmanBooked extends StatefulWidget {
  @override
  _SalesmanBookedState createState() => _SalesmanBookedState();
}

class _SalesmanBookedState extends State<SalesmanBooked> {
  bool viewSpinkit = true;
  bool viewSpinkit2 = true;
  bool emptyTranHistory = true;
  bool bookedPressed = true;
  bool smOrdered = false;
  // List _hList = [];
  bool delivered = false;
  List _list = [];

  String listCaption;
  String totalAmount;
  String tranStatus;

  final formatCurrencyAmt =
      new NumberFormat.currency(locale: "en_US", symbol: "P");
  final formatCurrencyTot =
      new NumberFormat.currency(locale: "en_US", symbol: "Php ");

  final String today =
      DateFormat("EEEE, MMM. dd, yyyy").format(new DateTime.now());

  String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());

  bool status = true;
  void initState() {
    super.initState();
    loadSalesmanInfo();
    loadBookedToday();
  }

  loadSalesmanInfo() async {
    listCaption =
        'Booked for Today: ' + GlobalVariables.newDatetodayFormat.toString();
    var getSM = await getSalesmanInformations(SalesmanData.accountcode);
    if (!mounted) return;
    setState(() {
      SalesmanData.firstname = getSM[0]['first_name'];
      SalesmanData.lastname = getSM[0]['last_name'];
      SalesmanData.department = getSM[0]['department'];
      SalesmanData.division = getSM[0]['division'];
      SalesmanData.mobile = getSM[0]['mobile'];
      SalesmanData.district = getSM[0]['district'];
      SalesmanData.area = getSM[0]['area'];
      SalesmanData.address = getSM[0]['address'];
      SalesmanData.title = getSM[0]['title'];
      SalesmanData.email = getSM[0]['email'];
      SalesmanData.status = getSM[0]['status'];
      SalesmanData.img = getSM[0]['img'];
    });
  }

  loadBookedToday() async {
    var getBT =
        await getAllBooked(SalesmanData.accountcode, GlobalVariables.newDate);
    if (!mounted) return;
    setState(() {
      _list.clear();
      _list = getBT;
      totalAmount = SalesmanData.bookedAmt;
      viewSpinkit = false;
      viewSpinkit2 = false;
    });
  }

  loadAllTransactions() async {
    totalAmount = '0.00';
    var getAT = await getAllSMTransactionsHistory(SalesmanData.accountcode);
    if (!mounted) return;
    setState(() {
      _list.clear();
      _list = getAT;
      viewSpinkit2 = false;
    });
    // totalAmount = "0.00";
    double amt = 0.00;
    _list.forEach((element) {
      if (element['tran_stat'] == 'On-Process' ||
          element['tran_stat'] == 'Pending' ||
          element['tran_stat'] == 'Approved') {
        amt = amt + double.parse(element['tot_amt']);
      }
      if (element['tran_stat'] == 'Delivered') {
        amt = amt + double.parse(element['tot_del_amt']);
      }
      totalAmount = amt.toString();
    });
    // print(_list);
  }

  clearChequeData() {
    ChequeData.bankAccNo = '';
    ChequeData.bankName = '';
    ChequeData.branchCode = '';
    ChequeData.chequeAmt = '';
    ChequeData.chequeDate = '';
    ChequeData.chequeNum = '';
    ChequeData.imgName = '';
    ChequeData.numToWords = '';
    ChequeData.payeeName = '';
    ChequeData.payorName = '';
    ChequeData.status = '';
  }

  void handleUserInteraction([_]) {
    SessionTimer sessionTimer = SessionTimer();
    sessionTimer.initializeTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    if (viewSpinkit == true) {
      return Container(
        // height: 620,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                color: Colors.white,
                height: 100,
                child: Image(
                  color: ColorsTheme.mainColor,
                  image: AssetsValues.spinImg,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        handleUserInteraction();
      },
      onPanDown: (details) {
        handleUserInteraction();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsTheme.mainColor,
          elevation: 0,
          title: Text(''),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              buildSalesmanInfo(),
              SizedBox(height: 5),
              Expanded(child: buildTransHistory()),
            ],
          ),
        ),
        // body: Stack(
        //   children: [
        //     Container(
        //       height: MediaQuery.of(context).size.height,
        //       width: MediaQuery.of(context).size.width,
        //       child: SingleChildScrollView(
        //         padding:
        //             EdgeInsets.only(left: 16, right: 16, top: 315, bottom: 5),
        //         child: Column(
        //           children: [
        //             SizedBox(
        //               height: 15,
        //             ),
        //             // buildHeaderCont(),
        //             SizedBox(
        //               height: 5,
        //             ),
        //             buildTransHistory(),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Container(
        //       height: 330,
        //       width: MediaQuery.of(context).size.width,
        //       color: Colors.white,
        //       child: SingleChildScrollView(
        //         padding:
        //             EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
        //         child: Column(
        //           children: <Widget>[
        //             SizedBox(
        //               height: 15,
        //             ),
        //             // buildHeaderCont(),
        //             buildSalesmanInfo(),
        //           ],
        //         ),
        //       ),
        //     ),
        //     // buildSummaryCont(context),
        //   ],
        // ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total : ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formatCurrencyTot.format(
                        double.parse(totalAmount),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ColorsTheme.mainColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildTransHistory() {
    if (viewSpinkit2 == true) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: Colors.white10,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                // color: Colors.white,
                height: 100,
                child: Image(
                  color: ColorsTheme.mainColor,
                  image: AssetsValues.spinImg,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (_list.isEmpty) {
      return Container(
        padding: EdgeInsets.all(50),
        margin: EdgeInsets.only(top: 50),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: ColorsTheme.mainColor,
        child: Column(
          children: <Widget>[
            Icon(
              Icons.event_busy,
              size: 100,
              color: Colors.grey[500],
            ),
            Text(
              'This salesman has no transaction today.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            )
          ],
        ),
      );
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        left: 0,
      ),
      // color: Colors.grey,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: _list.length,
        // scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          if (_list[index]['order_by'] == 'Salesman') {
            smOrdered = true;
          } else {
            smOrdered = false;
          }
          if (_list[index]['tran_stat'] == 'Delivered') {
            delivered = true;
          } else {
            delivered = false;
          }
          if (_list[index]['tran_stat'] == 'Pending') {
            tranStatus = 'On-Process';
          } else {
            tranStatus = _list[index]['tran_stat'].toString();
          }
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    CustomerData.trans = _list[index]['tran_no'];
                    CustomerData.sname = _list[index]['store_name'];
                    OrderData.trans = _list[index]['tran_no'];
                    OrderData.name = _list[index]['store_name'];
                    OrderData.pmeth = _list[index]['p_meth'];
                    OrderData.itmno = _list[index]['itm_count'];
                    OrderData.totamt = _list[index]['tot_amt'];
                    OrderData.status = _list[index]['tran_stat'];
                    OrderData.signature = _list[index]['signature'];
                    OrderData.dateReq = _list[index]['date_req'];
                    OrderData.dateApp = _list[index]['date_app'];
                    OrderData.dateDel = _list[index]['date_del'];
                    OrderData.pmtype = _list[index]['pmeth_type'];
                    CustomerData.accountCode = _list[index]['account_code'];
                    clearChequeData();

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return OrdersAndTracking();
                    }));
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    color: delivered ? Colors.green[100] : Colors.white,
                    child: Stack(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 5,
                            height: 80,
                            color: ColorsTheme.mainColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Order # ' + _list[index]['tran_no'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _list[index]['store_name'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  _list[index]['date_req'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: 105,
                                  // color: Colors.blueGrey,
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Total Amount',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        formatCurrencyTot.format(double.parse(
                                            _list[index]['tot_amt'])),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            // color: ColorsTheme.mainColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 105,
                            // color: Colors.grey,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  tranStatus,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Ordered by:',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                // if (_hList[index]['tran_stat'] ==
                                //     "Pending")
                                //   {
                                //     static String stat = _hList[index]['date_req'];
                                //   },

                                Text(
                                  _list[index]['order_by'],
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: smOrdered
                                          ? ColorsTheme.mainColor
                                          : Colors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Container buildHeaderCont() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      color: Colors.grey,
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  // GlobalVariables.menuKey = 1;
                  GlobalVariables.viewPolicy = false;
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) {
                  //   return Menu();
                  // }));
                  Navigator.pop(context);
                },
                child: Container(
                  width: 30,
                  height: 50,
                  child: Image(
                    image: AssetsValues.backImg,
                  ),
                ),
              ),
              // SizedBox(height: 30),
              // Container(
              //   // padding: EdgeInsets.only(top: 50),
              //   width: MediaQuery.of(context).size.width - 100,
              //   height: 60,
              //   // color: Colors.grey[350],
              //   alignment: Alignment.center,
              //   // color: Colors.lightGreen,
              //   child: Text(
              //     '',
              //     style: TextStyle(
              //       // color: Colors.grey,
              //       fontSize: 26,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildSalesmanInfo() {
    return Container(
      // height: 200,
      // color: Colors.grey[300],
      // color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 0, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // width: 200,
                    // height: 160,
                    // color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          SalesmanData.firstname + ' ' + SalesmanData.lastname,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              SalesmanData.title,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              " - " + SalesmanData.accountcode,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          SalesmanData.department + '-' + SalesmanData.division,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          SalesmanData.address,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          SalesmanData.mobile,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 180,
                          // color: Colors.grey[200],
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Status: ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              if (SalesmanData.status == "0")
                                Text(
                                  'Inactive',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic),
                                ),
                              if (SalesmanData.status == "1")
                                Text(
                                  'Active',
                                  style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              // Container(
              //   padding: EdgeInsets.only(top: 0),
              //   width: 100,
              //   height: 150,
              //   child: Image(
              //     image: AssetsValues.personImg,
              //   ),
              // ),
              AvatarView(
                radius: 70,
                borderWidth: 5,
                borderColor: Colors.grey,
                avatarType: AvatarType.CIRCLE,
                backgroundColor: Colors.red,
                imagePath: UrlAddress.userImg + SalesmanData.img,
                placeHolder: Container(
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
                errorWidget: Container(
                  child: Icon(
                    Icons.error,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 25,
                    // color: Colors.black,
                    width: MediaQuery.of(context).size.width - 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 20,
                          // width: 150,
                          margin: EdgeInsets.only(top: 0),
                          child: ElevatedButton(
                            style: bookedPressed
                                ? raisedButtonDialogStyle
                                : raisedButtonStyleWhite,
                            onPressed: () {
                              setState(() {
                                viewSpinkit2 = true;
                                loadBookedToday();
                                bookedPressed = true;
                                listCaption = 'Booked for Today: ' +
                                    GlobalVariables.newDatetodayFormat
                                        .toString();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Booked for Today',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: bookedPressed
                                        ? Colors.white
                                        : ColorsTheme.mainColor,
                                    fontWeight: bookedPressed
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 20,
                          // width: 150,
                          margin: EdgeInsets.only(top: 0),
                          child: ElevatedButton(
                            style: bookedPressed
                                ? raisedButtonStyleWhite
                                : raisedButtonDialogStyle,
                            onPressed: () {
                              setState(() {
                                bookedPressed = false;
                                listCaption = 'View All Transaction History';
                                viewSpinkit2 = true;
                                loadAllTransactions();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'All Transactions',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: bookedPressed
                                        ? ColorsTheme.mainColor
                                        : Colors.white,
                                    fontWeight: bookedPressed
                                        ? FontWeight.normal
                                        : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 25,
                    color: ColorsTheme.mainColor,
                    width: MediaQuery.of(context).size.width - 20,
                    padding: EdgeInsets.only(left: 10),
                    // margin: EdgeInsets.only(left: 5, top: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          listCaption,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
