import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:managers_view/address/api.dart';
import 'package:managers_view/address/url.dart';
import 'package:managers_view/global/variables.dart';
// import 'package:managers_view/profile/customer_list.dart';
import 'package:managers_view/profile/jefe_list.dart';
import 'package:managers_view/profile/message_inbox.dart';
import 'package:managers_view/profile/notice.dart';
import 'package:managers_view/profile/oldpass.dart';
import 'package:managers_view/profile/salesman_list.dart';
import 'package:managers_view/session/session_timer.dart';
import 'package:managers_view/variables/colors.dart';
import 'package:managers_view/widgets/dialogs.dart';
import 'package:managers_view/widgets/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List ver = [];
  bool checking = false;
  // ScrollController _scrollController = ScrollController();

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.white,
    minimumSize: Size(40, 20),
    padding: EdgeInsets.symmetric(horizontal: 10),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  void initState() {
    super.initState();
    // AppData.appVersion = '1.0.0';
    checkVersion();
    GlobalVariables.dataPrivacyNoticeScrollBottom = false;
  }

  checkVersion() async {
    if (NetworkData.connected) {
      checking = true;
      var res = await checkAppversion(AppData.updesc);
      print(res);
      // print(AppData.updesc);
      // print(AppData.appVersion);
      if (!mounted) return;
      setState(() {
        ver = res;
        print(ver);
      });
      if (ver.isNotEmpty) {
        setState(() {
          checking = false;
          print(ver[0]['tdesc']);
          if (ver[0]['tdesc'] == AppData.appVersion) {
            AppData.appUptodate = true;
          } else {
            AppData.appUptodate = false;
          }
        });
      }
    }
  }

  void _launchURL() async => await canLaunch(UrlAddress.appLink)
      ? await launch(UrlAddress.appLink)
      : throw 'Could not launch $UrlAddress.appLink';

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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Profile",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: ColorsTheme.mainColor,
                    fontSize: 45,
                    fontWeight: FontWeight.bold),
              ),
              // SizedBox(height: 50),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  // buildHeader(),
                  buildInfo(context),
                  SizedBox(height: 15),
                  buildMessages(context),
                  SizedBox(height: 3),
                  buildSalesman(context),
                  SizedBox(height: 3),
                  buildJefe(context),
                  SizedBox(height: 3),
                  buildCustomer(context),
                  SizedBox(height: 15),
                  buildChangePass(context),
                  SizedBox(height: 3),
                  buildPrivacyNot(context),
                  SizedBox(height: 15),
                  buildLogout(context),
                  SizedBox(height: 10),
                  buildVersionUp(context),
                  Visibility(
                      visible: !AppData.appUptodate,
                      child: buildUpdateButton(context))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'E-COMMERCE(MY NETGOSYO APP)'
                      ' COPYRIGHT 2020',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildUpdateButton(BuildContext context) {
    return Container(
      // height: 60,
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.only(right: 15),
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: raisedButtonStyle,
            onPressed: () {
              _launchURL();
            },
            child: Text(
              'Update',
              style: TextStyle(fontSize: 10),
            ),
          )
        ],
      ),
    );
  }

  Container buildVersionUp(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      // color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                'Version: ' + AppData.appVersion,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 10,
                ),
              ),
              checking
                  ? Row(
                      children: [
                        Text(
                          'Checking for new updates ',
                          style: TextStyle(
                            color: ColorsTheme.mainColor,
                            fontSize: 10,
                          ),
                        ),
                        SpinKitCircle(
                          color: ColorsTheme.mainColor,
                          size: 18,
                        ),
                      ],
                    )
                  : AppData.appUptodate
                      ? Text(
                          'You are on latest version',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 10,
                          ),
                        )
                      : Text(
                          'A new update is available',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 10,
                          ),
                        )
            ],
          ),
        ],
      ),
    );
  }

  Container buildInfo(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 8,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Icon(
              Icons.account_circle,
              color: Colors.grey[700],
              size: 24,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                UserData.firstname + " " + UserData.lastname,
                style: TextStyle(
                  color: Colors.grey[850],
                  fontSize: 14,
                ),
              ),
              Text(
                UserData.position +
                    '(' +
                    UserData.department +
                    ' - ' +
                    UserData.division +
                    ')',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
              Text(
                UserData.address + ', ' + UserData.postal,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
              Text(
                UserData.contact,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container buildChangePass(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          if (NetworkData.connected == true) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => InputPassDialog());
          } else {
            // final action = await WarningDialogs.openDialog(
            //   context,
            //   'Network',
            //   'Connection Problem.',
            //   false,
            //   'OK',
            // );
            // if (action == DialogAction.yes) {}
            showGlobalSnackbar('Connectivity', 'Please connect to internet.',
                Colors.red[900], Colors.white);
          }
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.lock_open,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                'Change Password',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Container buildMessages(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          if (NetworkData.connected == true) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => MessageInbox());
          } else {
            showGlobalSnackbar('Connectivity', 'Please connect to internet.',
                Colors.red[900], Colors.white);
          }
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                CupertinoIcons.bubble_left_bubble_right_fill,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                'Messages',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Container buildSalesman(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          if (NetworkData.connected == true) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => SalesmanList());
          } else {
            showGlobalSnackbar('Connectivity', 'Please connect to internet.',
                Colors.red[900], Colors.white);
          }
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                CupertinoIcons.person_crop_rectangle,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                'Salesman',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Container buildJefe(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          if (NetworkData.connected == true) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => JefeList());
          } else {
            showGlobalSnackbar('Connectivity', 'Please connect to internet.',
                Colors.red[900], Colors.white);
          }
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                CupertinoIcons.person_crop_rectangle_fill,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                'Jefe de Viaje',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Container buildCustomer(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          // if (NetworkData.connected == true) {
          //   showDialog(
          //       barrierDismissible: false,
          //       context: context,
          //       builder: (context) => CustomerList());
          // } else {
          //   showGlobalSnackbar('Connectivity', 'Please connect to internet.',
          //       Colors.red[900], Colors.white);
          // }
          showGlobalSnackbar(
              'Information',
              'This feature is currently unavailable.',
              ColorsTheme.mainColor,
              Colors.white);
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                CupertinoIcons.rectangle_stack_person_crop,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                'Customer',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Container buildLogout(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          final action = await Dialogs.openDialog(context, 'Confirmation',
              'Are you sure you want to logout?', true, 'No', 'Yes');
          if (action == DialogAction.yes) {
            GlobalVariables.menuKey = 0;
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/splash', (Route<dynamic> route) => false);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LOGOUT',
              style: TextStyle(
                  color: ColorsTheme.mainColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Container buildPrivacyNot(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ViewNotice();
          }));
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.description,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                'Privacy Notice',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
