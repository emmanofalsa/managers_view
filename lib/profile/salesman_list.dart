import 'dart:math';

import 'package:avatar_view/avatar_view.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:managers_view/address/api.dart';
import 'package:managers_view/address/url.dart';
import 'package:managers_view/variables/colors.dart';
// import 'package:managers_view/global/variables.dart';

class SalesmanList extends StatefulWidget {
  @override
  _SalesmanListState createState() => _SalesmanListState();
}

class _SalesmanListState extends State<SalesmanList> {
  List _smList = [];
  Color random;
  bool viewspinkit = true;
  final txtController = TextEditingController();
  void initState() {
    super.initState();
    loadAllSalesmanInfo();
  }

  loadAllSalesmanInfo() async {
    var getS = await getAllSalesmanInfo();
    if (!mounted) return;
    setState(() {
      _smList = getS;
      if (_smList.isNotEmpty) {
        // if (!mounted) return;
        setState(() {
          viewspinkit = false;
        });
      }
    });

    print(_smList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorsTheme.mainColor,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Salesman',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          elevation: 0,
        ),
        backgroundColor: ColorsTheme.mainColor,
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: viewspinkit
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SpinKitFadingCircle(
                            color: ColorsTheme.mainColor,
                            size: 50,
                          ),
                          Text(
                            "Loading Salesman...",
                            style: TextStyle(color: ColorsTheme.mainColor),
                          )
                        ],
                      )
                    : ListView.builder(
                        itemCount: _smList.length,
                        itemBuilder: (context, index) {
                          random = Colors.primaries[
                              Random().nextInt(Colors.primaries.length)];
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Card(
                                    elevation: 0.0,
                                    color: Color(0x00000000),
                                    child: FlipCard(
                                      direction: FlipDirection.HORIZONTAL,
                                      speed: 1000,
                                      onFlipDone: (status) {
                                        print(status);
                                      },
                                      front: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 150,
                                              decoration: BoxDecoration(
                                                color: random,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(50),
                                                    topRight:
                                                        Radius.circular(50),
                                                    bottomRight:
                                                        Radius.circular(50)),
                                                // borderRadius:
                                                //     BorderRadius.all(
                                                //         Radius.circular(50))
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.only(
                                                                    topRight: Radius.circular(
                                                                      50,
                                                                    ),
                                                                    bottomRight: Radius.circular(50))),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  _smList[index]
                                                                          [
                                                                          'first_name'] +
                                                                      ' ' +
                                                                      _smList[index]
                                                                          [
                                                                          'last_name'],
                                                                  style: TextStyle(
                                                                      color:
                                                                          random,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                Text(
                                                                  _smList[index]
                                                                      [
                                                                      'user_code'],
                                                                  style: TextStyle(
                                                                      color:
                                                                          random,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .phone_circle_fill,
                                                                      color:
                                                                          random,
                                                                    ),
                                                                    Text(
                                                                      _smList[index]
                                                                          [
                                                                          'mobile'],
                                                                      style: TextStyle(
                                                                          color:
                                                                              random,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  AvatarView(
                                                    radius: 60,
                                                    borderWidth: 5,
                                                    borderColor: Colors.white,
                                                    avatarType:
                                                        AvatarType.CIRCLE,
                                                    backgroundColor: Colors.red,
                                                    imagePath: UrlAddress
                                                            .userImg +
                                                        _smList[index]['img']
                                                            .toString(),
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
                                                  SizedBox(
                                                    width: 10,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      back: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                                height: 150,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    50),
                                                            topRight:
                                                                Radius.circular(
                                                                    50),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    50))),
                                                child: Row(
                                                  children: [],
                                                )),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          );
                        }),
              ),
            ),
          ],
        ));
  }
}
