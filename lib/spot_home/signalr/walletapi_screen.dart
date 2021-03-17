import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/spot_home/signalr/bidask/widgets/bidask_widget.dart';

class WalletAPIScreen extends StatelessWidget {
  WalletAPIScreen({Key key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _getLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.01,
                horizontal: MediaQuery.of(context).size.width * 0.01,
              ),
              width: MediaQuery.of(context).size.width * 0.47,
              height: MediaQuery.of(context).size.height * 0.96,
              decoration: BoxDecoration(border: Border.all(color: Colors.teal)),
              child: BidAskWidget()),
          Container(
            width: MediaQuery.of(context).size.width * 0.02,
          ),
          Container(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.01,
                horizontal: MediaQuery.of(context).size.width * 0.01,
              ),
              width: MediaQuery.of(context).size.width * 0.47,
              height: MediaQuery.of(context).size.height * 0.96,
              decoration: BoxDecoration(border: Border.all(color: Colors.teal)),
              child: BidAskWidget()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Center(child: Text("SPOT Wallet API Integration")),
        ),
        body: _getLayout(context));
  }
}
