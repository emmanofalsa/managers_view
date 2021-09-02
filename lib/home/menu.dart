import 'dart:async';
import 'package:flutter/material.dart';
import 'package:managers_view/address/api.dart';
import 'package:managers_view/global/variables.dart';
import 'package:managers_view/notice/privacy.dart';
import 'package:managers_view/profile/profile.dart';
import 'package:managers_view/sales/sales.dart';
import 'package:managers_view/session/session_timer.dart';
import 'package:managers_view/today/today.dart';
import 'package:managers_view/variables/colors.dart';
import 'package:package_info/package_info.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  ScrollController _scrollController = ScrollController();

  final orangeColor = Colors.deepOrange;
  final yellowColor = Colors.amber;
  final blueColor = Colors.blue;

  int _currentIndex = 0;

  SessionTimer sessionTimer = SessionTimer();

  String err1 = 'No Internet Connection';
  String err2 = 'No Connection to Server';
  String err3 = 'API Error';

  bool viewPol = true;

  Timer timer;

  final List<Widget> _children = [
    Today(),
    Sales(),
    Profile(),
  ];

  // PackageInfo _packageInfo = PackageInfo(
  //   appName: 'Unknown',
  //   packageName: 'Unknown',
  //   version: 'Unknown',
  //   buildNumber: 'Unknown',
  // );

  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkStatus());
    _currentIndex = GlobalVariables.menuKey;
    GlobalVariables.dataPrivacyNoticeScrollBottom = false;
    checkStatus();
    // viewPolicy();
    _initializeTimer();
    getAppVersion();
  }

  getAppVersion() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      // String appName = packageInfo.appName;
      // String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      // String buildNumber = packageInfo.buildNumber;
      setState(() {
        print(version);
        AppData.appVersion = version;
      });
    });

    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // // String packageName = packageInfo.packageName;
    // String version = packageInfo.version;
    // // String buildNumber = packageInfo.buildNumber;
    // // _initPackageInfo();
    // setState(() {
    //   print(packageInfo.version);
    //   print('App VERSION: ' + version);
    //   AppData.appVersion = version;
    // });
  }

  // Future<void> _initPackageInfo() async {
  //   final PackageInfo info = await PackageInfo.fromPlatform();
  //   if (!mounted) return;
  //   setState(() {
  //     _packageInfo = info;
  //   });
  // }

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _initializeTimer() {
    sessionTimer.initializeTimer(context);
  }

  checkStatus() async {
    var stat = await checkStat();
    // print('HEPE FORM NOT DISPOSED!');
    if (!mounted) return;
    setState(() {
      if (stat == 'Connected') {
        NetworkData.connected = true;
        NetworkData.errorMsgShow = false;
        // upload();
        NetworkData.errorMsg = '';
        // print('Connected to Internet!');
      } else {
        if (stat == 'ERROR1') {
          NetworkData.connected = false;
          NetworkData.errorMsgShow = true;
          NetworkData.errorMsg = err1;
          NetworkData.errorNo = '1';
          // print('Network Error...');
        }
        if (stat == 'ERROR2') {
          NetworkData.connected = false;
          NetworkData.errorMsgShow = true;
          NetworkData.errorMsg = err2;
          NetworkData.errorNo = '2';
          // print('Connection to API Error...');
        }
        if (stat == 'ERROR3') {
          NetworkData.connected = false;
          NetworkData.errorMsgShow = true;
          NetworkData.errorMsg = err3;
          NetworkData.errorNo = '3';
          // print('API Error...');
        }
        if (stat == 'Updating') {
          NetworkData.connected = false;
          NetworkData.errorMsgShow = true;
          NetworkData.errorMsg = 'Updating Server';
          // print('Updating Server...');
        }
      }
    });
    checkDevice();
    if (viewPol == true) {
      if (GlobalVariables.viewPolicy == true) {
        viewPol = false;
        viewPolicy();
      }
    }
  }

  viewPolicy() {
    if (GlobalVariables.viewPolicy == true) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => false,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              _scrollController.addListener(() {
                if (_scrollController.position.pixels ==
                    _scrollController.position.maxScrollExtent) {
                  if (GlobalVariables.dataPrivacyNoticeScrollBottom == false) {
                    setState(() {
                      GlobalVariables.dataPrivacyNoticeScrollBottom = true;
                    });
                  }
                }
              });

              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        controller: _scrollController,
                        children: <Widget>[
                          DataPrivacyNotice(),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "Close",
                      style: TextStyle(
                          color:
                              GlobalVariables.dataPrivacyNoticeScrollBottom ==
                                      true
                                  ? ColorsTheme.mainColor
                                  : Colors.grey),
                    ),
                    onPressed: () {
                      if (GlobalVariables.dataPrivacyNoticeScrollBottom ==
                          true) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      );
    }
  }

  checkDevice() async {
    if (NetworkData.connected == true) {
      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // // print('Running on ${androidInfo.model}');
      // print(androidInfo.toString());
    }
  }

  void handleUserInteraction([_]) {
    SessionTimer sessionTimer = SessionTimer();
    sessionTimer.initializeTimer(context);
  }

  @override
  void dispose() {
    timer?.cancel();
    GlobalTimer.timerSessionInactivity?.cancel();
    print('Timer Disposed');
    super.dispose();
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
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTappedBar,
            type: BottomNavigationBarType.fixed,
            currentIndex:
                _currentIndex, // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                  icon: new Icon(Icons.content_paste_rounded), label: 'Today'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.leaderboard_rounded), label: 'Sales'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile')
            ],
          ),
        ),
      ),
    );
  }
}
