import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/global/const.dart';
import 'package:signalr_core/signalr_core.dart';

class SpotSignalRCore extends StatefulWidget {
  SpotSignalRCore({Key key}) : super(key: key);

  @override
  _SpotSignalRCoreState createState() => _SpotSignalRCoreState();
}

class _SpotSignalRCoreState extends State<SpotSignalRCore> {
  HubConnection hubConnection;
  String _signalRStatus = 'Unknown';
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
          await hubConnection.start();
          print("Connect $hubConnection.state \n");
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
    /*try {
      var respX = await http.get(urlSignalR);
      print("response Arrived ${respX.statusCode}");
    } catch (err) {
      print("error arrived as $err");
    }*/

    hubConnection = HubConnectionBuilder()
        .withUrl(
          urlSignalR,
        )
        .build();
    print(hubConnection.state.toString());
    hubConnection.onclose(
        (error) => print('initSignalR: HubConnection: Connection closed'));
    await hubConnection.start();
    print(hubConnection.state.toString());
  }

  _buttonTapped() async {
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
  }
}
