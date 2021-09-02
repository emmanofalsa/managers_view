import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:managers_view/address/api.dart';
import 'package:managers_view/global/variables.dart';
import 'package:managers_view/variables/colors.dart';
import 'package:managers_view/widgets/buttons.dart';
import 'package:managers_view/widgets/snackbar.dart';
import 'package:managers_view/widgets/spinkit.dart';

class ResetPass extends StatefulWidget {
  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  bool hasUppercase = false;
  bool hasDigits = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;
  bool hasMinLength = false;
  bool passReq = false;
  bool viewSpinkit = true;
  bool _obscureText = true;
  bool _obscureText2 = true;

  // List _userdata = [];
  List device = [];
  // List _deviceData = [];
  String response = '';
  String loginDialog = '';
  String err1 = 'No Internet Connection';
  String err2 = 'No Connection to Server';
  String err3 = 'API Error';
  String message = '';

  final orangeColor = ColorsTheme.mainColor;
  final yellowColor = Colors.amber;
  final blueColor = Colors.blue;

  Timer timer;

  // static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  // Map<String, dynamic> _deviceData = <String, dynamic>{};

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final newPassController = TextEditingController();
  final confPassController = TextEditingController();

  bool isPasswordCompliant(String password, [int minLength = 7]) {
    if (password == null || password.isEmpty) {
      return false;
    }

    hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    hasDigits = password.contains(new RegExp(r'[0-9]'));
    hasLowercase = password.contains(new RegExp(r'[a-z]'));
    hasSpecialCharacters =
        password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    hasMinLength = password.length > minLength;

    return hasDigits &
        hasUppercase &
        hasLowercase &
        hasSpecialCharacters &
        hasMinLength;
  }

  @override
  void initState() {
    super.initState();
    // initPlatformState();
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
    newPassController.dispose();
    confPassController.dispose();
    timer?.cancel();
    print('Timer Disposed');
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 24),
                    //   width: 200,
                    //   height: 200,
                    //   child: Center(
                    //     child: Image(
                    //       image: AssetImage('assets/images/dtruck.png'),
                    //     ),
                    //   ),
                    // ),
                    Text(
                      "Reset Password",
                      style: TextStyle(
                          color: ColorsTheme.mainColor,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      /*curve: Curves.easeInOutBack,*/
                      // height: 250,
                      width: MediaQuery.of(context).size.width,
                      // color: Colors.grey,
                      margin: EdgeInsets.only(top: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: SingleChildScrollView(
                        child: buildSignInTextField(),
                      ),
                    ),
                    buildNextButton(),
                    buildPassReq(),
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
                  'E-COMMERCE(DISTRIBUTION APP) V1.' +
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
      ),
    );
  }

  Container buildNextButton() {
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Column(
        children: [
          ElevatedButton(
            style: raisedButtonLoginStyle,
            onPressed: () async {
              setState(() {
                if (!mounted) {
                  print(hasUppercase);
                }
              });
              if (_formKey.currentState.validate()) {
                var npass = newPassController.text;
                if (!NetworkData.connected) {
                  if (NetworkData.errorNo == '1') {
                    showGlobalSnackbar(
                        'Connectivity',
                        'Please connect to internet.',
                        Colors.red[900],
                        Colors.white);
                  }
                  if (NetworkData.errorNo == '2') {
                    showGlobalSnackbar(
                        'Connectivity',
                        'API Problem. Please contact admin.',
                        Colors.red[900],
                        Colors.white);
                  }
                  if (NetworkData.errorNo == '3') {
                    showGlobalSnackbar(
                        'Connectivity',
                        'Cannot connect to server. Try again later.',
                        Colors.red[900],
                        Colors.white);
                  }
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => LoadingSpinkit(
                            description: 'Resetting Password...',
                          ));

                  var cPass = await changeManagerPassword(
                      GlobalVariables.fpassusercode, npass);
                  print(cPass);
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Confirm",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 60,
          // ),
          // Text(message),
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
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
              ],
              // onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              onEditingComplete: () => node.nextFocus(),
              // onEditingComplete: () {
              //   if (_formKey.currentState.validate()) {}
              // },

              obscureText: _obscureText,
              controller: newPassController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    _toggle();
                  },
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hintText: 'Enter new password',
                // suffixIcon: IconButton(
                //   icon: Icon(
                //     _obscureText ? Icons.visibility_off : Icons.visibility,
                //     color: Colors.grey,
                //     size: 30,
                //   ),
                //   onPressed: () {
                //     _toggle();
                //   },
                // ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Field cannot be empty';
                }
                passReq = isPasswordCompliant(value);
                if (!passReq) {
                  return 'Invalid Password';
                }
                return null;
              },
            ),
            SizedBox(
              height: 25,
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              // onFieldSubmitted: (_) => node.unfocus(),
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
              ],
              obscureText: _obscureText2,
              controller: confPassController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText2 ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    _toggle2();
                  },
                ),
                hintText: 'Confirm password',
                // suffixIcon: IconButton(
                //   icon: Icon(
                //     _obscureText2 ? Icons.visibility_off : Icons.visibility,
                //     color: Colors.grey,
                //     size: 30,
                //   ),
                //   onPressed: () {
                //     _toggle2();
                //   },
                // ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Field cannot be empty';
                }
                if (value != newPassController.text) {
                  return "Password does not match";
                }
                return null;
              },
            ),
          ]))
    ]);
  }

  Container buildPassReq() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30),
      // width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '* Must have a minimum of 8 characters',
            style: TextStyle(
              fontSize: 12,
              // color: ColorsTheme.mainColor,
              color: hasMinLength ? Colors.green : ColorsTheme.mainColor,
            ),
          ),
          Text(
            '* Must include at least 1 uppercase',
            style: TextStyle(
              fontSize: 12,
              // color: ColorsTheme.mainColor,
              color: hasUppercase ? Colors.green : ColorsTheme.mainColor,
            ),
          ),
          Text(
            '* Must include at least 1 lowercase',
            style: TextStyle(
              fontSize: 12,
              // color: ColorsTheme.mainColor,
              color: hasLowercase ? Colors.green : ColorsTheme.mainColor,
            ),
          ),
          Text(
            '* Must include at least 1 digit ',
            style: TextStyle(
              fontSize: 12,
              // color: ColorsTheme.mainColor,
              color: hasDigits ? Colors.green : ColorsTheme.mainColor,
            ),
            // textAlign: TextAlign.left,
          ),
          Text(
            '* Must include at least 1 special character: ! @ # % ^ & * ( ) , . ? : { } | < > ]',
            style: TextStyle(
              fontSize: 12,
              // color: ColorsTheme.mainColor,
              color:
                  hasSpecialCharacters ? Colors.green : ColorsTheme.mainColor,
            ),
            // textAlign: TextAlign.left,
          ),
          // Text(message),
        ],
      ),
    );
  }
}
