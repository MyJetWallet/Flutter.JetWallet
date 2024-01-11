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
      
        class DataFeedService {
          static config = {
            supported_resolutions: ['1', '60', '1D', '1M'],
            supports_search: false,
            supports_group_request: false,
            supports_marks: false,
            supports_timescale_marks: false,
          };
        
          activeSession;
          stream;
          instruments;
          nextTimeTries;
        
          constructor(
            activeSession,
            instrumentId,
            instruments
          ) {}
        
          onReady = (callback) => {};
          searchSymbols = (
            userInput,
            exchange,
            symbolType,
            onResult
          ) => {};
          resolveSymbol = (
            symbolName,
            onResolve,
            onError
          ) => {};
        
          getBars = async (
            symbolInfo,
            resolution,
            rangeStartDate,
            rangeEndDate,
            onResult,
            onError
          ) => {
            return [
               {open: 200.643026, high: 200.70921986, low: 196.4822695, close: 196.84160757, date: 1694761200000},
               {open: 196.6392901, high: 198.60285094, low: 197.59274993, close: 197.80043425, date: 1695654000000},
               {open: 198.35398732, high: 200.48245199, low: 198.59994324, close: 200.17027717, date: 1695682800000},
               {open: 200.06613757, high: 201.52116402, low: 199.92441421, close: 199.43310658, date: 1695711600000},
               {open: 199.87699877, high: 200.74746901, low: 199.8864604, close: 199.86753714, date: 1695740400000},
               {open: 199.98107852, high: 201.54210028, low: 200.7473983, close: 201.20151372, date: 1695769200000},
               {open: 202.5026168, high: 205.19554667, low: 202.45503854, close: 201.11333143, date: 1695798000000},
               {open: 201.39960011, high: 202.28506141, low: 201.04731981, close: 201.27582595, date: 1695826800000},
             ];
          };
          subscribeBars = (
            symbolInfo,
            resolution,
            onTick,
            listenerGuid,
            onResetCacheNeededCallback
          ) => {};
          unsubscribeBars = (subscriberUID) => {};
          calculateHistoryDepth = (
            resolution,
            resolutionBack,
            intervalBack
          ) => {};
          getMarks = (
            symbolInfo,
            from,
            to,
            onDataCallback,
            resolution
          ) => {};
          getTimeScaleMarks = (
            symbolInfo,
            from,
            to,
            onDataCallback,
            resolution
          ) => {};
          getServerTime = (callback) => {};
        }
     
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
      
        class DataFeedService {
          static config = {
            supported_resolutions: ['1', '60', '1D', '1M'],
            supports_search: false,
            supports_group_request: false,
            supports_marks: false,
            supports_timescale_marks: false,
          };
        
          activeSession;
          stream;
          instruments;
          nextTimeTries;
        
          constructor(
            activeSession,
            instrumentId,
            instruments
          ) {}
        
          onReady = (callback) => {};
          searchSymbols = (
            userInput,
            exchange,
            symbolType,
            onResult
          ) => {};
          resolveSymbol = (
            symbolName,
            onResolve,
            onError
          ) => {};
        
          getBars = async (
            symbolInfo,
            resolution,
            rangeStartDate,
            rangeEndDate,
            onResult,
            onError
          ) => {
            return [
               {open: 200.643026, high: 200.70921986, low: 196.4822695, close: 196.84160757, date: 1694761200000},
               {open: 196.6392901, high: 198.60285094, low: 197.59274993, close: 197.80043425, date: 1695654000000},
               {open: 198.35398732, high: 200.48245199, low: 198.59994324, close: 200.17027717, date: 1695682800000},
               {open: 200.06613757, high: 201.52116402, low: 199.92441421, close: 199.43310658, date: 1695711600000},
               {open: 199.87699877, high: 200.74746901, low: 199.8864604, close: 199.86753714, date: 1695740400000},
               {open: 199.98107852, high: 201.54210028, low: 200.7473983, close: 201.20151372, date: 1695769200000},
               {open: 202.5026168, high: 205.19554667, low: 202.45503854, close: 201.11333143, date: 1695798000000},
               {open: 201.39960011, high: 202.28506141, low: 201.04731981, close: 201.27582595, date: 1695826800000},
             ];
          };
          subscribeBars = (
            symbolInfo,
            resolution,
            onTick,
            listenerGuid,
            onResetCacheNeededCallback
          ) => {};
          unsubscribeBars = (subscriberUID) => {};
          calculateHistoryDepth = (
            resolution,
            resolutionBack,
            intervalBack
          ) => {};
          getMarks = (
            symbolInfo,
            from,
            to,
            onDataCallback,
            resolution
          ) => {};
          getTimeScaleMarks = (
            symbolInfo,
            from,
            to,
            onDataCallback,
            resolution
          ) => {};
          getServerTime = (callback) => {};
        }
     
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
