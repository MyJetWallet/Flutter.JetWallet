import 'package:charts/main.dart';
import 'package:flutter/material.dart';

import '../../../../../../shared/components/loader.dart';

class LoadingChartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Chart(
          onResolutionChanged: (resolution) {},
          onChartTypeChanged: (chartType) {},
          candles: const [],
        ),
        const Loader(),
      ],
    );
  }
}
