import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:managers_view/address/api.dart';
import 'package:managers_view/global/variables.dart';
import 'package:managers_view/session/session_timer.dart';
import 'package:managers_view/today/booked.dart';
import 'package:managers_view/today/delivered.dart';
import 'package:managers_view/variables/colors.dart';
import 'package:managers_view/widgets/buttons.dart';

class Today extends StatefulWidget {
  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
  DateTime pickedDate;
  List _rspList = [];
  // List _bookedList = [];
  bool bookedPressed = true;
  bool todayDate = true;

  Timer timer;

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  String today = DateFormat("EEEE, MMM. dd, yyyy").format(new DateTime.now());

  String date = DateFormat("yyyy-MM-dd").format(new DateTime.now());

  final formatCurrency =
      new NumberFormat.currency(locale: "en_US", symbol: "P");

  void initState() {
    super.initState();
    // getBookedOrders();
    //
    if (mounted) {
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkOption());
    }

    super.initState();
    // GlobalVariables.dataPrivacyNoticeScrollBottom = false;
    checkOption();
  }

  checkOption() {
    if (bookedPressed) {
      getBookedOrders();
    } else {
      getDeliveredOrders();
    }
  }

  getBookedOrders() async {
    var getB = await getBooked(date);
    if (!mounted) return;
    setState(() {
      _rspList = getB;
    });
    // print('BOOKED ORDERS-----> ' + _rspList.toString());
    // print(date);
    GlobalVariables.newDate = date;
    GlobalVariables.newDatetodayFormat = today;
  }

  getDeliveredOrders() async {
    var getD = await getDelivered(date);
    if (!mounted) return;
    setState(() {
      _rspList = getD;
    });
    // print('DELIVERED ORDERS-----> ' + _rspList.toString());
  }

  _pickDate() async {
    pickedDate = DateTime.now();
    DateTime dt = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (dt != null)
      setState(() {
        pickedDate = dt;
        today = DateFormat("EEEE, MMM. dd, yyyy").format(dt);
        date = DateFormat("yyyy-MM-dd").format(dt);
        GlobalVariables.newDate = date;
        GlobalVariables.newDatetodayFormat = today;
      });
    if (today != DateFormat("EEEE, MMM. dd, yyyy").format(new DateTime.now())) {
      todayDate = false;
    } else {
      todayDate = true;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    print('Timer Disposed');
    super.dispose();
  }

  void handleUserInteraction([_]) {
    SessionTimer sessionTimer = SessionTimer();
    sessionTimer.initializeTimer(context);
  }

  @override
  Widget build(BuildContext context) {
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
          toolbarHeight: 90,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Today",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: ColorsTheme.mainColor,
                    fontSize: 45,
                    fontWeight: FontWeight.bold),
              ),
              // buildDateCont(),
              // buildOption(),
              // SizedBox(height: 50),
            ],
          ),
        ),
        body: Column(
          children: [
            buildDateCont(),
            buildOption(),
            Container(
              // color: Colors.white,
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 5),
                child: Column(
                  children: [
                    buildtranCont(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDateCont() {
    return Container(
      padding: EdgeInsets.all(0),
      width: MediaQuery.of(context).size.width,
      // color: Colors.green,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              _pickDate();
            },
            child: Text(
              today,
              style: TextStyle(
                  fontSize: 16,
                  color: todayDate ? ColorsTheme.mainColor : Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Container buildOption() {
    return Container(
      // height: 50,
      width: MediaQuery.of(context).size.width - 40,
      margin: EdgeInsets.only(top: 0, bottom: 0),
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new SizedBox(
            width: (MediaQuery.of(context).size.width - 45) / 2,
            height: 35,
            child: ElevatedButton(
              style: raisedButtonStyleWhite,
              onPressed: () {
                setState(() {
                  // viewSpinkit = true;
                  getBookedOrders();
                  bookedPressed = true;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Booked Orders",
                      // recognizer: _tapGestureRecognizer,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            bookedPressed ? FontWeight.bold : FontWeight.normal,
                        decoration: TextDecoration.underline,
                        color:
                            bookedPressed ? ColorsTheme.mainColor : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          new SizedBox(
            width: (MediaQuery.of(context).size.width - 45) / 2,
            height: 35,
            child: ElevatedButton(
              style: raisedButtonStyleWhite,
              onPressed: () {
                setState(() {
                  getDeliveredOrders();
                  bookedPressed = false;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                      text: TextSpan(
                    text: "Delivered Orders",
                    // recognizer: _tapGestureRecognizer,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          bookedPressed ? FontWeight.normal : FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color:
                          bookedPressed ? Colors.grey : ColorsTheme.mainColor,
                    ),
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildtranCont() {
    if (_rspList.isEmpty) {
      return Container(
        padding: EdgeInsets.all(80),
        margin: EdgeInsets.only(top: 0),
        height: MediaQuery.of(context).size.height - 250,
        width: MediaQuery.of(context).size.width,
        // color: ColorsTheme.mainColor,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.not_interested,
              size: 100,
              color: Colors.grey[500],
            ),
            Text(
              'No transaction found today.',
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
        // padding: EdgeInsets.all(50),
        margin: EdgeInsets.only(top: 0),
        height: MediaQuery.of(context).size.height - 250,
        width: MediaQuery.of(context).size.width,
        // color: Colors.grey,
        child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: _rspList.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                child: GestureDetector(
                  onTap: () {
                    if (bookedPressed) {
                      SalesmanData.bookedAmt = _rspList[index]['total'];
                      SalesmanData.accountcode = _rspList[index]['sm_code'];
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SalesmanBooked();
                      }));
                    } else {
                      HepeData.deliveredAmt = _rspList[index]['total'];
                      HepeData.accountcode = _rspList[index]['hepe_code'];
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return HepeDelivered();
                      }));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8, top: 0),
                    padding: EdgeInsets.only(right: 20),
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
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
                            width: MediaQuery.of(context).size.width / 2 + 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _rspList[index]['first_name'] +
                                      ' ' +
                                      _rspList[index]['last_name'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  _rspList[index]['department'] +
                                      '-' +
                                      _rspList[index]['division'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
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
                            // width: 138,
                            // color: Colors.blueGrey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Total Amount',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  formatCurrency.format(
                                      double.parse(_rspList[index]['total'])),
                                  // 'Tot amt',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: ColorsTheme.mainColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
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
              );
            }));
  }

  Container buildHeader() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        "Today",
        textAlign: TextAlign.right,
        style: TextStyle(
            color: ColorsTheme.mainColor,
            fontSize: 45,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
