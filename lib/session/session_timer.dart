import 'dart:async';

import 'package:flutter/material.dart';
import 'package:managers_view/global/variables.dart';
import 'package:managers_view/home/login.dart';

class SessionTimer {
  void initializeTimer(BuildContext context) {
    print("Reset Session Timer");
    resetTimer(context);
  }

  resetTimer(BuildContext context) {
    if (GlobalTimer.timerSessionInactivity != null) {
      print('session reset');
      GlobalTimer.timerSessionInactivity?.cancel();
    }

    GlobalTimer.timerSessionInactivity =
        Timer(const Duration(minutes: 45), () async {
      print('session over');

      // if (GlobalVariables.timerCheckIfCustomerLogIn != null) {
      //   GlobalVariables.timerCheckIfCustomerLogIn?.cancel();
      // }
      // if (GlobalVariables.timerActiveDeviceLogChecking != null) {
      //   GlobalVariables.timerActiveDeviceLogChecking?.cancel();
      // }

      // await deleteActiveUser(GlobalVariables.customerCode);
      if (GlobalTimer.timerSessionInactivity != null) {
        print('session reset');
        GlobalTimer.timerSessionInactivity?.cancel();
      }
      // GlobalVariables.menuKey = 0;
      // GlobalVariables.viewPolicy = true;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Session expired"),
            content: Row(
              children: <Widget>[
                Icon(
                  Icons.timelapse_outlined,
                  color: Colors.red,
                ),
                Text(
                  " You are inactive for 45 minutes.",
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Okay"),
                onPressed: () {
                  // Navigator.of(context)
                  //     .pushNamedAndRemoveUntil('/option', (route) => false);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyLoginPage()),
                      ModalRoute.withName('/second'));
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
