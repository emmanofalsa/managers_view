import 'dart:math';

import 'package:avatar_view/avatar_view.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:managers_view/address/api.dart';
import 'package:managers_view/address/url.dart';
import 'package:managers_view/variables/colors.dart';

class JefeList extends StatefulWidget {
  @override
  _JefeListState createState() => _JefeListState();
}

class _JefeListState extends State<JefeList> {
  List _hepeList = [];
  Color random;
  bool viewspinkit = true;
  final txtController = TextEditingController();
  void initState() {
    super.initState();
    loadAllHepemanInfo();
  }

  loadAllHepemanInfo() async {
    var getH = await getAllHepeInfo();
    if (!mounted) return;
    setState(() {
      _hepeList = getH;
      if (_hepeList.isNotEmpty) {
        // if (!mounted) return;
        setState(() {
          viewspinkit = false;
        });
      }
    });

    print(_hepeList);
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
                  'Jefe de Viaje',
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
                    )),
                child: viewspinkit
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SpinKitFadingCircle(
                            color: ColorsTheme.mainColor,
                            size: 50,
                          ),
                          Text(
                            "Loading Jefe de Viaje...",
                            style: TextStyle(color: ColorsTheme.mainColor),
                          )
                        ],
                      )
                    : ListView.builder(
                        itemCount: _hepeList.length,
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
                                                                  _hepeList[index]
                                                                          [
                                                                          'first_name'] +
                                                                      ' ' +
                                                                      _hepeList[
                                                                              index]
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
                                                                  _hepeList[
                                                                          index]
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
                                                                      _hepeList[
                                                                              index]
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
                                                        _hepeList[index]['img']
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
                                                // color: Colors.grey,
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
            )
          ],
        ));
  }
}
