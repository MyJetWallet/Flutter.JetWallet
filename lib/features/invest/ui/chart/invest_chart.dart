import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';

class InvestChart extends StatefulObserverWidget {
  const InvestChart({
    super.key,
    required this.instrument,
    required this.chartType,
    required this.chartInterval,
    required this.width,
    required this.height,
  });

  final InvestInstrumentModel instrument;
  final String chartType;
  final String chartInterval;
  final String width;
  final String height;

  @override
  State<InvestChart> createState() => _InvestChartState();
}

class _InvestChartState extends State<InvestChart> {
  late WebViewController? controllerWeb;
  late String html;

  @override
  void initState() {
    super.initState();

    html = '''
    <!DOCTYPE html>
    <html lang="en" style="width:100%;height:100%;">
    <head>
      <meta name="viewport" content="width=${widget.width},height=${widget.height},initial-scale=1">
      <title>Load file or HTML string example</title>
    </head>
    <body style="width:100%;height:100%;margin:0;">
    <!-- TradingView Widget BEGIN -->
    <div class="tradingview-widget-container" style="width:calc(100% + 2px);height:calc(100% + 2px);margin:-1px!important;">
      <div id="tradingview_a69c2"></div>
      <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
      <script type="text/javascript">
     
      new TradingView.widget(
        {
          "autosize": true,
          "symbol": "${widget.instrument.symbol!.substring(0, widget.instrument.symbol!.indexOf('.'))}",
          "interval": "${widget.chartInterval}",
          "timezone": "Etc/UTC",
          "theme": "light",
          "style": "${widget.chartType}",
          "locale": "en",
          "enable_publishing": false,
          "hide_top_toolbar": true,
          "hide_legend": true,
          "save_image": false,
          "hide_volume": true,
          "support_host": "https://www.tradingview.com",
          "datafeed": new DataFeedService(),
          "overrides": {
           "mainSeriesProperties.lineStyle.color": "#0BCA1E",
           "mainSeriesProperties.lineStyle.linestyle": 1,
           "mainSeriesProperties.lineStyle.linewidth": 2,
           "mainSeriesProperties.lineStyle.priceSource": "close",
           "mainSeriesProperties.areaStyle.color1": "#E8F9E8",
           "mainSeriesProperties.areaStyle.color2": "#E8F9E8",
           "mainSeriesProperties.areaStyle.linecolor": '#0BCA1E',
           "mainSeriesProperties.areaStyle.linestyle": 0,
           "mainSeriesProperties.areaStyle.linewidth": 2,
           "mainSeriesProperties.candleStyle.upColor": "#0BCA1E",
           "mainSeriesProperties.candleStyle.downColor": "#F50537",
           "mainSeriesProperties.candleStyle.drawWick": true,
           "mainSeriesProperties.candleStyle.drawBorder": false,
           "mainSeriesProperties.candleStyle.borderColor": "#28555a",
           "mainSeriesProperties.candleStyle.borderUpColor": "#21B3A4",
           "mainSeriesProperties.candleStyle.borderDownColor": "#ed145b",
           "mainSeriesProperties.candleStyle.wickUpColor": "#255258",
           "mainSeriesProperties.candleStyle.wickDownColor": "#622243",
           "mainSeriesProperties.candleStyle.barColorsOnPrevClose": false,
           "mainSeriesProperties.areaStyle.priceSource": "close",
           "mainSeriesProperties.priceAxisProperties.autoScale": true,
           "mainSeriesProperties.priceAxisProperties.autoScaleDisabled": false,
           "mainSeriesProperties.priceAxisProperties.percentage": false,
           "mainSeriesProperties.priceAxisProperties.percentageDisabled": false,
           "mainSeriesProperties.priceAxisProperties.logDisabled": true,
           "paneProperties.vertGridProperties.color": "rgba(255, 255, 255, 0.08)",
           "paneProperties.vertGridProperties.style": 1,
           "paneProperties.horzGridProperties.color": "rgba(255, 255, 255, 0.08)",
           "paneProperties.horzGridProperties.style": 1,
           "paneProperties.legendProperties.showStudyArguments": false,
           "paneProperties.legendProperties.showStudyTitles": false,
           "paneProperties.legendProperties.showStudyValues": false,
           "paneProperties.legendProperties.showSeriesTitle": false,
           "paneProperties.legendProperties.showSeriesOHLC": true,
           "paneProperties.legendProperties.showLegend": false,
           "paneProperties.legendProperties.showBarChange": false,
           "linetoolnote.backgroundColor": '#0BCA1E',
           "scalesProperties.lineColor": "transparent",
           "scalesProperties.textColor": "rgba(255, 255, 255, 0.2)",
           "paneProperties.background": "rgba(0,0,0,0)",
           "mainSeriesProperties.priceLineWidth": 2,
           "scalesProperties.showSeriesLastValue": true,
         },
        },
      );
      </script>
    </div>
    <!-- TradingView Widget END -->
    
    </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    final newHtml = '''
    <!DOCTYPE html>
    <html lang="en" style="width:100%;height:100%;">
    <head>
      <meta name="viewport" content="width=${widget.width},height=${widget.height},initial-scale=1">
      <title>Load file or HTML string example</title>
    </head>
    <body style="width:100%;height:100%;margin:0;">
    <!-- TradingView Widget BEGIN -->
    <div class="tradingview-widget-container" style="width:calc(100% + 2px);height:calc(100% + 2px);margin:-1px!important;">
      <div id="tradingview_a69c2"></div>
      <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
      <script type="text/javascript">
     
      new TradingView.widget(
        {
          "autosize": true,
          "symbol": "${widget.instrument.symbol!.substring(0, widget.instrument.symbol!.indexOf('.'))}",
          "interval": "${widget.chartInterval}",
          "timezone": "Etc/UTC",
          "theme": "light",
          "style": "${widget.chartType}",
          "locale": "en",
          "enable_publishing": false,
          "hide_top_toolbar": true,
          "hide_legend": true,
          "save_image": false,
          "hide_volume": true,
          "support_host": "https://www.tradingview.com",
          "datafeed": new DataFeedService(),
          "overrides": {
           "mainSeriesProperties.lineStyle.color": "#0BCA1E",
           "mainSeriesProperties.lineStyle.linestyle": 1,
           "mainSeriesProperties.lineStyle.linewidth": 2,
           "mainSeriesProperties.lineStyle.priceSource": "close",
           "mainSeriesProperties.areaStyle.color1": "#E8F9E8",
           "mainSeriesProperties.areaStyle.color2": "#E8F9E8",
           "mainSeriesProperties.areaStyle.linecolor": '#0BCA1E',
           "mainSeriesProperties.areaStyle.linestyle": 0,
           "mainSeriesProperties.areaStyle.linewidth": 2,
           "mainSeriesProperties.candleStyle.upColor": "#0BCA1E",
           "mainSeriesProperties.candleStyle.downColor": "#F50537",
           "mainSeriesProperties.candleStyle.drawWick": true,
           "mainSeriesProperties.candleStyle.drawBorder": false,
           "mainSeriesProperties.candleStyle.borderColor": "#28555a",
           "mainSeriesProperties.candleStyle.borderUpColor": "#21B3A4",
           "mainSeriesProperties.candleStyle.borderDownColor": "#ed145b",
           "mainSeriesProperties.candleStyle.wickUpColor": "#255258",
           "mainSeriesProperties.candleStyle.wickDownColor": "#622243",
           "mainSeriesProperties.candleStyle.barColorsOnPrevClose": false,
           "mainSeriesProperties.areaStyle.priceSource": "close",
           "mainSeriesProperties.priceAxisProperties.autoScale": true,
           "mainSeriesProperties.priceAxisProperties.autoScaleDisabled": false,
           "mainSeriesProperties.priceAxisProperties.percentage": false,
           "mainSeriesProperties.priceAxisProperties.percentageDisabled": false,
           "mainSeriesProperties.priceAxisProperties.logDisabled": true,
           "paneProperties.vertGridProperties.color": "rgba(255, 255, 255, 0.08)",
           "paneProperties.vertGridProperties.style": 1,
           "paneProperties.horzGridProperties.color": "rgba(255, 255, 255, 0.08)",
           "paneProperties.horzGridProperties.style": 1,
           "paneProperties.legendProperties.showStudyArguments": false,
           "paneProperties.legendProperties.showStudyTitles": false,
           "paneProperties.legendProperties.showStudyValues": false,
           "paneProperties.legendProperties.showSeriesTitle": false,
           "paneProperties.legendProperties.showSeriesOHLC": true,
           "paneProperties.legendProperties.showLegend": false,
           "paneProperties.legendProperties.showBarChange": false,
           "linetoolnote.backgroundColor": '#0BCA1E',
           "scalesProperties.lineColor": "transparent",
           "scalesProperties.textColor": "rgba(255, 255, 255, 0.2)",
           "paneProperties.background": "rgba(0,0,0,0)",
           "mainSeriesProperties.priceLineWidth": 2,
           "scalesProperties.showSeriesLastValue": true,
         },
        },
      );
      </script>
    </div>
    <!-- TradingView Widget END -->
    
    </body>
    </html>
    ''';
    if (html != newHtml) {
      html = newHtml;
      controllerWeb?.loadHtmlString(newHtml);
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height - 575,
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          controllerWeb = controller;
          controllerWeb?.loadHtmlString(html);
        },
      ),
    );
  }
}
