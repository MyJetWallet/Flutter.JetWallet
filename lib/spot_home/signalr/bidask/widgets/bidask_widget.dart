import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/global/const.dart';
import 'package:jetwallet/spot_home/signalr/bidask/model/bidask_model.dart';
import 'package:signalr_core/signalr_core.dart';

class BidAskWidget extends StatefulWidget {
  BidAskWidget({Key key}) : super(key: key);

  @override
  _BidAskWidgetState createState() => _BidAskWidgetState();
}

class _BidAskWidgetState extends State<BidAskWidget> {
  HubConnection hubConnection;
  SpotBidAsk spotBidAsk;

  @override
  void initState() {
    super.initState();
    _initSignalR();
  }

  @override
  Widget build(BuildContext context) {
    int totalPrices = 0;
    bool hasData = false;
    final formatter = NumberFormat("######.0000");

    if (spotBidAsk != null) {
      totalPrices = spotBidAsk.prices.length ?? 0;
      hasData = (spotBidAsk != null && spotBidAsk.prices.length > 0);
    }
    return hasData
        ? ListView.builder(
            itemCount: totalPrices,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Center(
                    child: FittedBox(
                      child: Text(
                        spotBidAsk.prices[index].id,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  subtitle: Center(
                    child: FittedBox(
                      child: Text(
                        "DateTime: " +
                            DateTime.fromMillisecondsSinceEpoch(
                                    spotBidAsk.prices[index].dateTime,
                                    isUtc: false)
                                .toString() +
                            "  Lag : " +
                            (spotBidAsk.now - spotBidAsk.prices[index].dateTime)
                                .toString() +
                            "ms",
                        style: TextStyle(color: Colors.white60, fontSize: 10),
                      ),
                    ),
                  ),
                  leading: FittedBox(
                    child: Column(
                      children: [
                        Text("BID", style: TextStyle(color: Colors.amber)),
                        Text(formatter.format(spotBidAsk.prices[index].bid),
                            style: TextStyle(color: Colors.amberAccent))
                      ],
                    ),
                  ),
                  trailing: FittedBox(
                    child: Column(
                      children: [
                        Text("ASK", style: TextStyle(color: Colors.yellow)),
                        Text(formatter.format(spotBidAsk.prices[index].ask),
                            style: TextStyle(color: Colors.yellowAccent))
                      ],
                    ),
                  ));
            })
        : Text("NO DATA");
  }

  Future<void> _initSignalR() async {
    hubConnection = HubConnectionBuilder()
        .withUrl(
          urlSignalR,
        )
        .build();
    hubConnection.onclose(
        (error) => print('HubConnection: Connection closed with $error'));
    await hubConnection.start();
    hubConnection.invoke("Init", args: ["User"]);
    hubConnection.on("spot-bidask", (data) {
      spotBidAsk = SpotBidAsk.fromJson(data.first);
      setState(() {});
    });
  }
}
