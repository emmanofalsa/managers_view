import 'package:flutter/material.dart';
import 'package:managers_view/address/api.dart';
import 'package:managers_view/global/variables.dart';
import 'package:managers_view/password/change_password.dart';
import 'package:managers_view/variables/colors.dart';
import 'package:managers_view/widgets/buttons.dart';
import 'package:managers_view/widgets/dialogs.dart';
import 'package:managers_view/widgets/spinkit.dart';

class InputPassDialog extends StatefulWidget {
  @override
  _InputPassDialogState createState() => _InputPassDialogState();
}

class _InputPassDialogState extends State<InputPassDialog> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  final oldPassController = TextEditingController();

  @override
  void dispose() {
    oldPassController.dispose();
    super.dispose();
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // color: Colors.grey,
                padding: EdgeInsets.only(top: 5, bottom: 10, right: 5, left: 5),
                // margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                    color: Colors.grey[50],
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
                  children: <Widget>[
                    Container(
                      // height: 280,
                      margin: EdgeInsets.only(bottom: 5),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      // decoration: BoxDecoration(),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  // color: Colors.grey,
                                  width: MediaQuery.of(context).size.width / 2,
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Old Password',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Container(
                                    height: 40,
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: oldPassController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 20, top: 10, bottom: 10),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        // hintText: 'Password',
                                      ),
                                      // maxLines: 5,
                                      // minLines: 3,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Password cannot be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // color: Colors.grey,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              style: raisedButtonDialogStyle,
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  var pass = oldPassController.text;
                                  if (!NetworkData.connected) {
                                    print('CLICKED!');
                                    if (NetworkData.errorNo == '1') {
                                      final action =
                                          await WarningDialogs.openDialog(
                                        context,
                                        'Network',
                                        'Please check the internet connection.',
                                        false,
                                        'OK',
                                      );
                                      if (action == DialogAction.yes) {}
                                    }
                                    if (NetworkData.errorNo == '2') {
                                      final action =
                                          await WarningDialogs.openDialog(
                                        context,
                                        'Network',
                                        'API Problem. Please contact admin.',
                                        false,
                                        'OK',
                                      );
                                      if (action == DialogAction.yes) {}
                                    }
                                    if (NetworkData.errorNo == '3') {
                                      final action =
                                          await WarningDialogs.openDialog(
                                        context,
                                        'Network',
                                        'Cannot connect to server. Try again later.',
                                        false,
                                        'OK',
                                      );
                                      if (action == DialogAction.yes) {}
                                    }
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => LoadingSpinkit(
                                              description:
                                                  'Checking Password...',
                                            ));

                                    var rsp = await loginUser(
                                        UserData.username, pass);
                                    if (rsp.isEmpty) {
                                      Navigator.pop(context);
                                      print("Wrong Password!");
                                      final action =
                                          await WarningDialogs.openDialog(
                                        context,
                                        'Validation',
                                        'Wrong Password!',
                                        false,
                                        'OK',
                                      );
                                      if (action == DialogAction.yes) {}
                                    } else {
                                      print("Correct Password!");
                                      UserData.newPassword = '';
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      // showDialog(
                                      //     barrierDismissible: false,
                                      //     context: context,
                                      //     builder: (context) =>
                                      //         ChangePassDialog());
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ChangePass();
                                      }));
                                    }
                                  }
                                }
                              },
                              child: Text(
                                'Continue',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              style: raisedButtonStyleWhite,
                              onPressed: () {
                                OrderData.pmtype = "";
                                OrderData.setSign = false;
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: ColorsTheme.mainColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Positioned(
        //   top: 0,
        //   right: 16,
        //   left: 16,
        //   child: CircleAvatar(
        //     backgroundColor: Colors.transparent,
        //     radius: 100,
        //     backgroundImage: AssetImage('assets/images/check2.gif'),
        //   ),
        // ),
        // Container(
        //   padding: EdgeInsets.only(left: 10),
        //   height: 60,
        //   width: MediaQuery.of(context).size.width,
        //   // color: Colors.deepOrange,
        //   decoration: BoxDecoration(
        //       color: Colors.deepOrange,
        //       shape: BoxShape.rectangle,
        //       borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[
        //       Text(
        //         'Confirm Password',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 24,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
