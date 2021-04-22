import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/global/const.dart';
import 'package:jetwallet/spot_home/signalr/bidask/model/bidask_model.dart';
import 'package:signalr_core/signalr_core.dart';

class BidAskWidget extends StatefulWidget {
  const BidAskWidget({Key? key}) : super(key: key);

  @override
  _BidAskWidgetState createState() => _BidAskWidgetState();
}

class _BidAskWidgetState extends State<BidAskWidget> {
  late HubConnection hubConnection;
  late SpotBidAsk currentTick, lastTick;

  @override
  void initState() {
    super.initState();
    _initSignalR();
  }

  @override
  Widget build(BuildContext context) {
    var totalPrices = 0;
    var hasData = false;
    var hasLastTick = false;
    final formatter = NumberFormat('######0.0000');

    totalPrices = currentTick.prices.length;
    hasData = currentTick.prices.isNotEmpty;
    hasLastTick = lastTick.prices.length == currentTick.prices.length;

    return hasData
        ? ListView.builder(
            itemCount: totalPrices,
            itemBuilder: (context, index) {
              num delta = 0;
              if (hasLastTick) {
                if (currentTick.prices[index].id == lastTick.prices[index].id) {
                  delta = currentTick.prices[index].bid -
                      lastTick.prices[index].bid;
                }

                return ListTile(
                    title: Center(
                      child: FittedBox(
                        child: Row(
                          children: [
                            Text(
                              currentTick.prices[index].id,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                            _tickWidget(delta),
                          ],
                        ),
                      ),
                    ),
                    subtitle: Center(
                      child: Text(
                        'DateTime: ${DateTime.fromMillisecondsSinceEpoch(currentTick.prices[index].dateTime)}  Lag : ${currentTick.now - currentTick.prices[index].dateTime}ms',
                        style:
                            const TextStyle(color: Colors.white60, fontSize: 8),
                      ),
                    ),
                    leading: Column(
                      children: [
                        const Text('BID',
                            style: TextStyle(color: Colors.amber)),
                        Text(formatter.format(currentTick.prices[index].bid),
                            style: const TextStyle(color: Colors.amberAccent)),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        const Text('ASK',
                            style: TextStyle(color: Colors.yellow)),
                        Text(formatter.format(currentTick.prices[index].ask),
                            style: const TextStyle(color: Colors.yellowAccent))
                      ],
                    ));
              } else {
                const SizedBox();
              }
              return const SizedBox();
            },
          )
        : const Text('NO DATA');
  }

  Widget _tickWidget(num d) {
    final delta = d;
    if (delta > 0) {
      return Row(
        children: const [
          Icon(
            Icons.trending_up,
            color: Colors.green,
          ),
        ],
      );
    }
    if (delta < 0) {
      return Row(
        children: const [
          Icon(
            Icons.trending_down,
            color: Colors.red,
          ),
        ],
      );
    } else {
      return Row(
        children: const [
          Icon(
            Icons.trending_flat,
            color: Colors.blue,
          ),
        ],
      );
    }
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
    await hubConnection.invoke('Init', args: ['User']);
    hubConnection.on('spot-bidask', (data) {
      lastTick = currentTick;
      currentTick = SpotBidAsk.fromJson(data!.first as Map<String, dynamic>);
      setState(() {});
    });
  }
}
