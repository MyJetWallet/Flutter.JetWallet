import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/dashed_divider/dashed_divider.dart';
import 'model/candle_model.dart';
import 'model/candle_type_enum.dart';
import 'model/chart_info_model.dart';
import 'model/info_window_model.dart';
import 'renderer/chart_painter.dart';

class KChartWidget extends StatefulWidget {
  const KChartWidget(
    this.datas, {
    required this.candleType,
    required this.candleResolution,
    required this.candleWidth,
    required this.onCandleSelected,
    required this.formatPrice,
    required this.isAssetChart,
    required this.isInvestChart,
    required this.chartWidth,
    this.selectedCandlePadding,
    this.prefix = '',
    this.accuracy,
  });

  final List<CandleModel> datas;
  final ChartType candleType;

  final Function(ChartInfoModel?) onCandleSelected;
  final String Function({
    required bool onlyFullPart,
    required Decimal decimal,
    required int accuracy,
    required String symbol,
    required String prefix,
  }) formatPrice;

  final String prefix;
  final String candleResolution;
  final double candleWidth;
  final double? selectedCandlePadding;
  final bool isAssetChart;
  final bool isInvestChart;
  final double chartWidth;
  final int? accuracy;

  @override
  _KChartWidgetState createState() => _KChartWidgetState();
}

class _KChartWidgetState extends State<KChartWidget> with TickerProviderStateMixin {
  double _scaleX = 1.0;
  double _scrollX = 0.0;
  double _selectX = 0.0;
  bool isScale = false;
  bool isDrag = false;
  bool isLongPress = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  late StreamController<InfoWindowModel?> _infoWindowStream;
  late AnimationController _scrollXController;

  @override
  void initState() {
    super.initState();
    _infoWindowStream = StreamController<InfoWindowModel>();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 850),
      vsync: this,
    );
    _animation = Tween(begin: 0.9, end: 0.1).animate(_controller)..addListener(reRenderView);
    _scrollXController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: double.negativeInfinity,
      upperBound: double.infinity,
    );
    _scrollListener();
  }

  void _scrollListener() {
    _scrollXController.addListener(() {
      _scrollX = _scrollXController.value;
      if (_scrollX <= 0) {
        _scrollX = 0;
        _stopAnimation();
      } else if (_scrollX >= ChartPainter.maxScrollX) {
        _scrollX = ChartPainter.maxScrollX;
        //TODO(Vova): get new data was invoked here
        _stopAnimation();
      } else {
        reRenderView();
      }
    });
    _scrollXController.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        isDrag = false;
        reRenderView();
      }
    });
  }

  @override
  void didUpdateWidget(KChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.datas != widget.datas) {
      //  mScrollX = mSelectX = 0.0;
      _selectX = 0.0;
    }
  }

  @override
  void dispose() {
    _infoWindowStream.close();
    _controller.dispose();
    _scrollXController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.datas.isEmpty) {
      _scrollX = _selectX = 0.0;
      _scaleX = 1.0;
    }
    return GestureDetector(
      // onHorizontalDragDown: (details) {
      //   _stopAnimation();
      //   isDrag = true;
      // },
      // onHorizontalDragUpdate: (details) {
      //   if (isScale || isLongPress) return;
      //   if (details.primaryDelta != null) {
      //     _scrollX = (details.primaryDelta! / _scaleX + _scrollX)
      //         .clamp(0.0, ChartPainter.maxScrollX)
      //         .toDouble();
      //   }
      //   reRenderView();
      // },
      // onHorizontalDragEnd: (DragEndDetails details) {
      //   // isDrag = false;
      //   // logical pixels per second
      //   if (WidgetsBinding.instance != null) {
      //     final tolerance = Tolerance(
      //       velocity: 1.0 /
      //           (0.050 * WidgetsBinding.instance!.window.devicePixelRatio),
      //       distance: 1.0 /
      //           WidgetsBinding
      //               .instance!.window.devicePixelRatio, // logical pixels
      //     );
      //
      //     if (details.primaryVelocity != null) {
      //       final simulation = ClampingScrollSimulation(
      //         position: _scrollX,
      //         velocity: details.primaryVelocity!,
      //         tolerance: tolerance,
      //       );
      //       _scrollXController.animateWith(simulation);
      //     }
      //   }
      // },
      // onHorizontalDragCancel: () => isDrag = false,
      // onScaleStart: (_) {
      // isScale = true;
      // },
      // onScaleUpdate: (details) {
      // if (isDrag || isLongPress) return;
      // _scaleX = (_lastScale * details.scale).clamp(0.5, 2.2);
      // reRenderView();
      // },
      // onScaleEnd: (_) {
      // isScale = false;
      // _lastScale = _scaleX;
      // },
      onHorizontalDragDown: (details) {
        HapticFeedback.selectionClick();

        isLongPress = true;
        if (_selectX != details.globalPosition.dx) {
          _selectX = details.globalPosition.dx - (widget.selectedCandlePadding ?? 0);
          reRenderView();
        }
      },
      onHorizontalDragUpdate: (details) {
        HapticFeedback.selectionClick();

        if (_selectX != details.globalPosition.dx) {
          _selectX = details.globalPosition.dx - (widget.selectedCandlePadding ?? 0);
          reRenderView();
        }
      },
      onHorizontalDragEnd: (details) {
        HapticFeedback.selectionClick();

        isLongPress = false;
        // _infoWindowStream.sink.add(null);
        widget.onCandleSelected(null);
        reRenderView();
      },
      onTapUp: (details) {
        HapticFeedback.selectionClick();

        isLongPress = false;
        // _infoWindowStream.sink.add(null);
        widget.onCandleSelected(null);
        reRenderView();
      },
      onVerticalDragEnd: (details) {
        HapticFeedback.selectionClick();

        isLongPress = false;
        // _infoWindowStream.sink.add(null);
        widget.onCandleSelected(null);
        reRenderView();
      },
      child: Stack(
        children: <Widget>[
          if (widget.isInvestChart)
            const DashedDivider(
              topPadding: 14,
              addLeftPadding: false,
            ),
          if (!isLongPress && widget.isAssetChart)
            const DashedDivider(
              topPadding: 20,
            ),
          if (!isLongPress && widget.isAssetChart)
            const DashedDivider(
              topPadding: 118,
            ),
          if (!isLongPress && widget.isAssetChart)
            const DashedDivider(
              topPadding: 212,
            ),
          CustomPaint(
            size: Size(widget.chartWidth + 3, double.infinity),
            painter: ChartPainter(
              datas: widget.datas,
              scaleX: _scaleX,
              scrollX: _scrollX,
              selectX: _selectX,
              isLongPass: isLongPress,
              candleType: widget.candleType,
              sink: _infoWindowStream.sink,
              opacity: _animation.value,
              resolution: widget.candleResolution,
              candleWidth: widget.candleWidth,
              controller: _controller,
              onCandleSelected: widget.onCandleSelected,
              formatPrice: widget.formatPrice,
              isAssetChart: widget.isAssetChart,
              chartWidth: widget.chartWidth,
              prefix: widget.prefix,
              accuracy: widget.accuracy,
              isInvestChart: widget.isInvestChart,
            ),
          ),
        ],
      ),
    );
  }

  void _stopAnimation() {
    if (_scrollXController.isAnimating) {
      _scrollXController.stop();
      isDrag = false;
      reRenderView();
    }
  }

  void reRenderView() => setState(() {});
}
