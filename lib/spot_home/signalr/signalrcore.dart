import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/global/const.dart';
import 'package:jetwallet/spot_home/signalr/model/bidask.dart';
import 'package:signalr_core/signalr_core.dart';

class SpotSignalRCore extends StatefulWidget {
  SpotSignalRCore({Key key}) : super(key: key);

  @override
  _SpotSignalRCoreState createState() => _SpotSignalRCoreState();
}

class _SpotSignalRCoreState extends State<SpotSignalRCore> {
  HubConnection hubConnection;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SpotBidAsk spotBidAsk;

  @override
  void initState() {
    super.initState();
    initSignalR();
    print("initState passed");
  }

  @override
  Widget build(BuildContext context) {
    final totalPrices = spotBidAsk.prices.length;
    final hasData = (spotBidAsk != null && spotBidAsk.prices.length > 0);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Center(child: Text("SPOT SignalR")),
        ),
        body: ListView.builder(
            itemCount: hasData ? totalPrices : 1,
            itemBuilder: (context, index) {
              return hasData
                  ? ListTile(
                      title: Text(
                        "ID: " +
                            spotBidAsk.prices[index].id +
                            "  DateTime: " +
                            DateTime.fromMillisecondsSinceEpoch(
                                    spotBidAsk.prices[index].dateTime,
                                    isUtc: false)
                                .toString() +
                            "  Bid: " +
                            spotBidAsk.prices[index].bid.toString() +
                            "  Ask: " +
                            spotBidAsk.prices[index].ask.toString() +
                            "  Lag : " +
                            (spotBidAsk.now - spotBidAsk.prices[index].dateTime)
                                .toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Text("NO DATA");
            }));
  }

  Future<void> initSignalR() async {
    print(urlSignalR);
    hubConnection = HubConnectionBuilder()
        .withUrl(
          urlSignalR,
        )
        .build();
    print(hubConnection.state.toString());
    hubConnection.onclose((error) => print('HubConnection: Connection closed'));
    await hubConnection.start();
    print(hubConnection.state.toString());
    hubConnection.invoke("Init", args: ["User"]);
    hubConnection.on("spot-bidask", (data) {
      spotBidAsk = SpotBidAsk.fromJson(data.first);
      setState(() {});
    });
  }
}
