// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:managers_view/address/url.dart';
import 'package:managers_view/global/variables.dart';

class ChequePage extends StatefulWidget {
  @override
  _ChequePageState createState() => _ChequePageState();
}

class _ChequePageState extends State<ChequePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Cheque Information')),
      ),
      body: Center(
          child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[100],
            child: Image.network(UrlAddress.chequeImg + ChequeData.imgName),
          ),
        ],
      )),
    );
  }
}
