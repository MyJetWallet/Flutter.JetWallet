import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/global/const.dart';
import 'package:signalr_flutter/signalr_flutter.dart';

class SpotSignalR extends StatefulWidget {
  SpotSignalR({Key key}) : super(key: key);

  @override
  _SpotSignalRState createState() => _SpotSignalRState();
}

class _SpotSignalRState extends State<SpotSignalR> {
  String _signalRStatus = 'Unknown';
  SignalR signalR;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initSignalR();
    print("initState passed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cast_connected),
        onPressed: () async {
          await signalR.connect();
          print("Connect");
        },
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text("SPOT SignalR"),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextButton(
                child: Text(" Init result: $_signalRStatus\n"),
                onPressed: _buttonTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initSignalR() async {
    print(urlSignalR);
    signalR = SignalR('http://20.50.189.25:8080', "signalr",
        hubMethods: ["Init"],
        statusChangeCallback: _onStatusChange,
        hubCallback: _onNewMessage);
  }

  _onStatusChange(dynamic status) {
    if (mounted) {
      setState(() {
        _signalRStatus = status as String;
      });
    }
  }

  _onNewMessage(String methodName, dynamic message) {
    print('MethodName = $methodName, Message = $message');
  }

  _buttonTapped() async {
    final res = await signalR.invokeMethod<dynamic>("Init",
        arguments: ["DimaWallet"]).catchError((error) {
      print(error.toString());
    });
    final snackBar = SnackBar(content: Text('SignalR Method Response: $res'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
