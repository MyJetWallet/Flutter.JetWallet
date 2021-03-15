import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/global/const.dart';
import 'package:signalr_core/signalr_core.dart';

class SpotSignalR extends StatefulWidget {
  SpotSignalR({Key key}) : super(key: key);

  @override
  _SpotSignalRState createState() => _SpotSignalRState();
}

class _SpotSignalRState extends State<SpotSignalR> {
  HubConnection hubConnection;
  String initResultString = "Not connected";
  Object initResult;

  @override
  void initState() {
    super.initState();
    initSignalR();
    print("initState passed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Text(" Init result: " + initResultString),
                onPressed: () {
                  /*print("Pressed!");
                  //await hubConnection.start();
                  /* if (hubConnection.state == HubConnectionState.connected) {
                    await hubConnection.invoke(
                      "Init",
                    );
                    print("Connected!");
                  }*/
                  setState(() {
                    // if (initResult != null) initResultString = initResult.toString();
                  });*/
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initSignalR() async {
    print(urlSignalR);
    hubConnection = HubConnectionBuilder()
        .withUrl(
          urlSignalR,
        )
        .build();
    print(hubConnection.toString());
    hubConnection.onclose(
        (error) => print('initSignalR: HubConnection: Connection closed'));
    //await hubConnection.start();
    print(hubConnection.state.toString());

    // hubConnection.on("pong", _handlePong());
  }

  _handlePong() {}
}
