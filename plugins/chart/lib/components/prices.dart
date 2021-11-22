import 'package:flutter/material.dart';

import '../entity/candle_entity.dart';

class Prices extends StatelessWidget {
  const Prices(this.candle);

  final CandleEntity? candle;

  @override
  Widget build(BuildContext context) {
    return candle != null ? Column(
      children: [
        Text(
          'Open: ${candle?.open.toString()}',
          style: const TextStyle(color: Colors.white),
        ),
        Text(
          'Close: ${candle?.close.toString()}',
          style: const TextStyle(color: Colors.white),
        ),
        Text(
          'High: ${candle?.high.toString()}',
          style: const TextStyle(color: Colors.white),
        ),
        Text(
          'Low: ${candle?.low.toString()}',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ) : Container();
  }
}
