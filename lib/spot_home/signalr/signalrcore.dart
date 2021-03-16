import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/global/const.dart';
import 'package:signalr_core/signalr_core.dart';

import 'package:universal_io/io.dart';

class SpotSignalRCore extends StatefulWidget {
  SpotSignalRCore({Key key}) : super(key: key);

  @override
  _SpotSignalRCoreState createState() => _SpotSignalRCoreState();
}

class _SpotSignalRCoreState extends State<SpotSignalRCore> {
  HubConnection hubConnection;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<dynamic> uidata = ["Received data:"];

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
      appBar: AppBar(title: Center(child: Text("SPOT SignalR"))),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cast_connected),
        onPressed: () async {
          if (hubConnection.state != HubConnectionState.connected) {
            await hubConnection.start();
            print("Connect $hubConnection.state \n");
          }
        },
      ),*/
      body: ListView.builder(
        itemCount: uidata.length,
        itemBuilder: (BuildContext context, int index) {
          return Text(
            uidata[index],
            style: TextStyle(color: Colors.white),
          );
        },
      ),
    );
  }

  Future<void> initSignalR() async {
    print(urlSignalR);
    hubConnection = HubConnectionBuilder()
        .withUrl(
          urlSignalR,
          /*HttpConnectionOptions(
              accessTokenFactory: () => Future.value('test'),
              // client: IOClient(HttpClient()..badCertificateCallback = (x, y, z) => true),
              logging: (level, message) => print(message),
            )*/
        )
        .build();
    print(hubConnection.state.toString());
    hubConnection.onclose((error) => print('HubConnection: Connection closed'));
    await hubConnection.start();
    print(hubConnection.state.toString());
    hubConnection.invoke("Init", args: ["User"]);
    hubConnection.on("spot-bidask", (data) {
      uidata.add(data.toString());
      setState(() {});
    });
  }

  /* _buttonTapped() async {
    print(hubConnection.state);
    if (hubConnection.state == HubConnectionState.connected) {
      final res = await hubConnection.invoke(
        "Init",
        args: ["Dima"],
      ).catchError((error) {
        print(error.toString());
      });

      final snackBar = SnackBar(content: Text('SignalR Method Response: $res'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }*/
}
