import 'dart:async';
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:managers_view/address/api.dart';
import 'package:managers_view/global/variables.dart';
import 'package:managers_view/home/menu.dart';
import 'package:managers_view/password/change_password.dart';
import 'package:managers_view/password/forget_password.dart';
import 'package:managers_view/variables/assets.dart';
import 'package:managers_view/variables/colors.dart';
import 'package:managers_view/widgets/buttons.dart';
import 'package:managers_view/widgets/snackbar.dart';

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  List _userdata = [];
  List device = [];
  List _userAttempt = [];
  // List _deviceData = [];
  String loginDialog = '';
  String err1 = 'No Internet Connection';
  String err2 = 'API Error';
  String err3 = 'No Connection to Server';

  final orangeColor = Colors.deepOrange;
  final yellowColor = Colors.amber;
  final blueColor = Colors.blue;

  Timer timer;

  // static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  // Map<String, dynamic> _deviceData = <String, dynamic>{};

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool viewSpinkit = true;
  bool _obscureText = true;
  String message = '';

  // @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();
  // }

  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkStatus());
    super.initState();
    checkStatus();
  }

  checkStatus() async {
    var stat = await checkStat();
    // print(stat);
    // setState(() {
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
        // print('Cannot connect to the Server...');
      }
      if (stat == 'Updating') {
        NetworkData.connected = false;
        NetworkData.errorMsgShow = true;
        NetworkData.errorMsg = 'Updating Server';
        NetworkData.errorNo = '4';
        // print('Updating Server...');
      }
    }
    // });
    // initPlatformState();
  }

  checkFailureAttempts() async {
    _userAttempt.forEach((element) {
      if (element['username'] == usernameController.text &&
          int.parse(element['attempt'].toString()) >= 3) {
        print('ACCOUNT WILL BE LOCKED OUT');
        showGlobalSnackbar(
            'Information',
            'This account has been locked due to excessive login failures. Please contact your administrator.',
            Colors.blue,
            Colors.white);
        if (NetworkData.connected) {
          updateManagersStatusOnline(usernameController.text);
        }
      }
    });
  }

  // Future<void> initPlatformState() async {
  //   Map<String, dynamic> deviceData;

  //   try {
  //     if (Platform.isAndroid) {
  //       deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
  //     }
  //   } on PlatformException {
  //     deviceData = <String, dynamic>{
  //       'Error:': 'Failed to get platform version.'
  //     };
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     _deviceData = deviceData;
  //   });
  // }

  // Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  //   return <String, dynamic>{
  //     'version.securityPatch': build.version.securityPatch,
  //     'version.sdkInt': build.version.sdkInt,
  //     'version.release': build.version.release,
  //     'version.previewSdkInt': build.version.previewSdkInt,
  //     'version.incremental': build.version.incremental,
  //     'version.codename': build.version.codename,
  //     'version.baseOS': build.version.baseOS,
  //     'board': build.board,
  //     'bootloader': build.bootloader,
  //     'brand': build.brand,
  //     'device': build.device,
  //     'display': build.display,
  //     'fingerprint': build.fingerprint,
  //     'hardware': build.hardware,
  //     'host': build.host,
  //     'id': build.id,
  //     'manufacturer': build.manufacturer,
  //     'model': build.model,
  //     'product': build.product,
  //     'supported32BitAbis': build.supported32BitAbis,
  //     'supported64BitAbis': build.supported64BitAbis,
  //     'supportedAbis': build.supportedAbis,
  //     'tags': build.tags,
  //     'type': build.type,
  //     'isPhysicalDevice': build.isPhysicalDevice,
  //     'androidId': build.androidId,
  //     'systemFeatures': build.systemFeatures,
  //   };
  // }

  @override
  void dispose() {
    timer?.cancel();
    usernameController.dispose();
    passwordController.dispose();
    print('Timer Disposed');
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Image(
                        image: AssetsValues.loginImg,
                      ),
                    ),
                  ),
                  Text(
                    "Administrator's Login",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    /*curve: Curves.easeInOutBack,*/
                    height: 250,
                    width: 350,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: SingleChildScrollView(
                      child: buildSignInTextField(),
                    ),
                  ),
                  buildSignInButton(),
                  buildForgetPass(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: 30,
              // color: Colors.grey,
              child: Text(
                "E-COMMERCE(ADMINISTRATOR'S VIEWING APP) V1." +
                    GlobalVariables.appVersion +
                    ' COPYRIGHT 2020',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildSignInButton() {
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Column(
        children: [
          ElevatedButton(
            style: raisedButtonLoginStyle,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                if (!NetworkData.connected) {
                  showGlobalSnackbar(
                      'Connectivity',
                      'Please connect to internet.',
                      Colors.red[900],
                      Colors.white);
                } else {
                  checkFailureAttempts();
                  var username = usernameController.text;
                  var password = passwordController.text;
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => LoggingInBox());

                  var rsp = await loginUser(username, password);
                  // _userdata = rsp;
                  print(rsp);
                  if (rsp == '') {
                    loginDialog = 'Account not Found!';
                  } else {
                    print(rsp);
                    //Username found but incorrect password
                    if (rsp['username'].toString() == username &&
                        rsp['success'].toString() == '0') {
                      if (_userAttempt.isEmpty) {
                        // print(rsp);
                        _userAttempt.add(rsp);
                        // _userAttempt = rsp;
                        // _userAttempt = json.decode(json.encode(rsp));
                        // print(_userAttempt);
                      } else {
                        int x = 0;
                        bool found = false;
                        _userAttempt.forEach((element) {
                          x++;
                          if (username.toString() ==
                              element['username'].toString()) {
                            element['attempt'] =
                                (int.parse(element['attempt'].toString()) + 1)
                                    .toString();
                            found = true;
                          } else {
                            if (_userAttempt.length == x && !found) {
                              _userAttempt
                                  .addAll(json.decode(json.encode(rsp)));
                            }
                          }
                          print(_userAttempt);
                        });
                      }
                      loginDialog = 'Account not Found!';
                    } else {
                      // _userdata = rsp;
                      _userdata.add(rsp);
                      loginDialog = 'Found!';
                    }
                  }

                  // showDialog(
                  //     barrierDismissible: false,
                  //     context: context,
                  //     builder: (context) => LoggingInBox());

                  if (loginDialog == 'Account not Found!') {
                    print("Invalid username or Password");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Invalid username or Password")),
                    );
                    Navigator.pop(context);
                  } else {
                    if (rsp['status'] == '0') {
                      showGlobalSnackbar(
                          'Information',
                          'This account has been locked due to excessive login failures. Please contact your administrator.',
                          Colors.blue,
                          Colors.white);
                    } else {
                      // showDialog(
                      //     barrierDismissible: false,
                      //     context: context,
                      //     builder: (context) => LoggingInBox());

                      // UserData.id = rsp['user_code'];
                      UserData.firstname = rsp['first_name'];
                      UserData.lastname = rsp['last_name'];
                      UserData.department = rsp['department'];
                      UserData.division = rsp['division'];
                      UserData.district = rsp['district'];
                      UserData.position = rsp['title'];
                      UserData.contact = rsp['mobile'];
                      UserData.postal = rsp['postal_code'];
                      UserData.email = rsp['email'];
                      UserData.address = rsp['address'];
                      UserData.routes = rsp['area'];
                      UserData.passwordAge = rsp['password_date'];
                      UserData.username = username;

                      viewSpinkit = false;
                      if (viewSpinkit == false) {
                        dispose();
                        DateTime a = DateTime.parse(UserData.passwordAge);
                        final date1 = DateTime(a.year, a.month, a.day);

                        final date2 = DateTime.now();
                        final difference = date2.difference(date1).inDays;

                        if (difference >= 90) {
                          GlobalVariables.passExp = true;
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChangePass();
                          }));
                        } else {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return Menu();
                          }));
                          print("Login Successful!");
                        }
                      }
                    }
                  }
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Text(message),
        ],
      ),
    );
  }

  Column buildSignInTextField() {
    final node = FocusScope.of(context);
    return Column(children: [
      Form(
          key: _formKey,
          child: Column(children: <Widget>[
            TextFormField(
              textInputAction: TextInputAction.next,
              // onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              onEditingComplete: () => node.nextFocus(),
              controller: usernameController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hintText: 'Username',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Username cannot be empty';
                }
                return null;
              },
            ),
            SizedBox(
              height: 25,
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => node.unfocus(),
              obscureText: _obscureText,
              controller: passwordController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hintText: 'Password',
                suffixIcon: GestureDetector(
                  onLongPressStart: (_) async {
                    _toggle();
                  },
                  onLongPressEnd: (_) {
                    setState(() {
                      _toggle();
                    });
                  },
                  child: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onPressed: () {
                      // _toggle();
                    },
                  ),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Password cannot be empty';
                }
                return null;
              },
            ),
          ]))
    ]);
  }

  Container buildForgetPass() {
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (NetworkData.connected == true) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return ForgetPass();
                }));
                // print('Forget Password Form');
              } else {
                // showDialog(
                //     context: context,
                //     builder: (context) => UnableDialog(
                //           title: 'Connection Problem!',
                //           description: 'Check Internet Connection' +
                //               ' to use this feature.',
                //           buttonText: 'Okay',
                //         ));
                showGlobalSnackbar(
                    'Connectivity',
                    'Please connect to internet.',
                    Colors.red[900],
                    Colors.white);
              }
              // ForgetPassData.type = 'Salesman';
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return ForgetPass();
              // }));
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 12,
                color: ColorsTheme.mainColor,
              ),
            ),
          ),
          // Text(message),
        ],
      ),
    );
  }
}

class ConfirmBox extends StatefulWidget {
  final String title, description, buttonText;

  ConfirmBox({this.title, this.description, this.buttonText});

  @override
  _ConfirmBoxState createState() => _ConfirmBoxState();
}

class _ConfirmBoxState extends State<ConfirmBox> {
  final String changeStat = 'Delivered';

  // DateTime date = DateTime.parse(
  //     DateFormat("yyyy-MM-dd H:mm:ss").format(new DateTime.now()));

  // final String date =
  //     DateFormat("yyyy-MM-dd H:mm:ss").format(new DateTime.now());

  // setStatus() {
  //   print(date);
  //   var result = getStatus(UserData.trans, changeStat, date);
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: confirmContent(context),
    );
  }

  confirmContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 50, bottom: 16, right: 5, left: 5),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 5),
                height: 70,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                // decoration: BoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        widget.description,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: raisedButtonLoginStyle,
                      onPressed: () => {
                        Navigator.pop(context),
                        Navigator.pop(context),
                      },
                      child: Text(
                        widget.buttonText,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10),
          height: 40,
          width: MediaQuery.of(context).size.width,
          // color: ColorsTheme.mainColor,
          decoration: BoxDecoration(
              color: ColorsTheme.mainColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LoggingInBox extends StatefulWidget {
  @override
  _LoggingInBoxState createState() => _LoggingInBoxState();
}

class _LoggingInBoxState extends State<LoggingInBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      // child: confirmContent(context),
      child: loadingContent(context),
    );
  }

  loadingContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            // width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 50, bottom: 16, right: 5, left: 5),
            margin: EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.transparent,
                    // blurRadius: 10.0,
                    // offset: Offset(0.0, 10.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Logging in as Administrator...',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
                SpinKitCircle(
                  color: ColorsTheme.mainColor,
                ),
              ],
            )),
      ],
    );
  }
}
