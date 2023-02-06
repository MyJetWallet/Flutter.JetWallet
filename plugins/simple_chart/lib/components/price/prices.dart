import 'package:flutter/material.dart';

import '../../simple_chart.dart';

class Prices extends StatelessWidget {
  const Prices(Key? key, this.candle) : super(key: key);

  final CandleModel? candle;

  @override
  Widget build(BuildContext context) {
    return candle != null
        ? Column(
            children: [
              Text(
                'Open: ${candle?.open}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'Close: ${candle?.close}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'High: ${candle?.high}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'Low: ${candle?.low}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          )
        : Container();
  }
}
