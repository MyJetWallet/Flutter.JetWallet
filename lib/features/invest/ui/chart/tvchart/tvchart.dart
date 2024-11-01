import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:jetwallet/features/invest/ui/chart/tvchart/tvchart_types.dart';

import '../../../../../core/di/di.dart';
import '../../../../../utils/constants.dart';
import '../../../helpers/chart_resolution_helper.dart';
import '../../../stores/chart/invest_chart_store.dart';
import '../../../stores/dashboard/invest_dashboard_store.dart';
import '../../../stores/dashboard/invest_new_store.dart';
import '../commons/localhost.dart';

class TVChart extends StatefulWidget {
  const TVChart({
    super.key,
    required this.instrument,
    required this.instrumentId,
  });

  final String instrument;
  final String instrumentId;

  @override
  _TVChartState createState() => _TVChartState();
}

class _TVChartState extends State<TVChart> with WidgetsBindingObserver {
  InAppWebViewController? _controller;
  bool _isServerRunning = false;
  bool _isLoading = false;
  bool _isError = false;
  String _isErrorMessage = '';
  bool _showBack = false;
  final Map<String, _OnTickInfo> _onTickMap = {};

  bool get _chartLoaded {
    return _controller != null && !_isLoading && !_isError;
  }

  // ignore: unused_element
  void _callOnTick(
    String listenerGuid,
    Bar bar,
    int chartType,
    String resolution,
  ) {
    if (_chartLoaded) {
      final controller = _controller!;
      final payload = <String, dynamic>{
        'listenerGuid': listenerGuid,
        'bar': bar,
        'chartType': chartType,
        'resolution': resolution,
      };

      controller.evaluateJavascript(
        source: 'window.callOnTick(`${jsonEncode(payload)}`);',
      );
    }
  }

  void _attachHandler() {
    final controller = _controller;
    if (controller == null) return;
    final investNewStore = getIt.get<InvestNewStore>();

    controller.addJavaScriptHandler(
      handlerName: 'start',
      callback: (arguments) {
        return ChartingLibraryWidgetOptions(
          debug: false,
          locale: 'en',
          symbol: widget.instrument,
          fullscreen: false,
          interval: chartResolutionTypeHelper(investNewStore.chartInterval),
          timezone: Timezone.utc,
          autosize: true,
          autoSaveDelay: 1,
          disabledFeatures: const [
            'header_widget',
            'timeframes_toolbar',
            'use_localstorage_for_settings',
            'border_around_the_chart',
            'left_toolbar',
            'symbol_info',
            'context_menus',
            'main_series_scale_menu',
            'popup_hints',
          ],
          enabledFeatures: const ['hide_left_toolbar_by_default'],
        );
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onReady',
      callback: (arguments) {
        return const DatafeedConfiguration(
          exchanges: [
            // Exchange(
            //   name: 'IDX',
            //   value: 'IDX',
            //   desc: 'Indonesia Stock Exchange',
            // ),
          ],
          supportedResolutions: ['1D'],
          currencyCodes: ['IDR'],
          supportsMarks: false,
          supportsTime: true,
          supportsTimescaleMarks: true,
          symbolsTypes: [
            DatafeedSymbolType(
              name: 'Index',
              value: 'index',
            ),
            DatafeedSymbolType(
              name: 'Stock',
              value: 'stock',
            ),
          ],
        );
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'searchSymbols',
      callback: (arguments) {},
    );

    controller.addJavaScriptHandler(
      handlerName: 'resolveSymbol',
      callback: (arguments) {
        final symbolName = arguments[0] as String;
        final symbolStub = {
          'full_name': symbolName,
          'listed_exchange': '',
          'name': symbolName,
          'description': '',
          'type': 'forex',
          'session': '24x7',
          'timezone': 'Etc/UTC',
          'ticker': symbolName,
          'exchange': symbolName,
          'minmov': 1,
          'pricescale': 100,
          'has_weekly_and_monthly': true,
          'has_daily': true,
          'has_no_volume': true,
          'has_empty_bars': false,
          'supported_resolutions': ['15', '60', '240', '1D'],
          'data_status': 'streaming',
          'format': 'price',
        };

        return symbolStub;
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'getBars',
      callback: (arguments) async {
        // Only 1 resolution on example, not needed
        // final String resolution = arguments[1];
        // final PeriodParams periodParams = PeriodParams.fromJson(arguments[2]);

        final investChartStore = getIt.get<InvestChartStore>();
        final result = await investChartStore.getAssetCandlesFull(
          widget.instrument,
          widget.instrumentId,
        );

        return {
          'bars': result
              .map(
                (e) => Bar(
                  time: e.date,
                  open: e.open,
                  high: e.high,
                  low: e.low,
                  close: e.close,
                ),
              )
              .toList(),
          'meta': {
            'noData': result.isEmpty,
          },
          'chartType': investNewStore.chartType == 0 ? 3 : 1,
          'resolution': chartResolutionTypeHelper(investNewStore.chartInterval),
        };
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'subscribeBars',
      callback: (arguments) async {
        final symbolInfo = LibrarySymbolInfo.fromJson(arguments[0] as Map<String, dynamic>);
        final resolution = arguments[1] as String;
        final listenerGuid = arguments[2] as String;

        if (_onTickMap.containsKey(listenerGuid)) {
          // Dispose existing onTick with same ID
        }

        _onTickMap[listenerGuid] = _OnTickInfo(
          symbolInfo: symbolInfo,
          resolution: resolution,
        );

        final price = getIt<InvestDashboardStore>().getPendingPriceBySymbol(widget.instrumentId);
        final lastCandle = Bar(
          open: price.toDouble(),
          close: price.toDouble(),
          high: price.toDouble(),
          low: price.toDouble(),
          time: DateTime.now().millisecondsSinceEpoch,
        );

        Timer.periodic(const Duration(seconds: 1), (timer) {
          _callOnTick(
            listenerGuid,
            lastCandle,
            investNewStore.chartType == 0 ? 3 : 1,
            chartResolutionTypeHelper(investNewStore.chartInterval),
          );
        });

        // Do request for realtime data
        // Use _callOnTick for returning realtime bar data
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'unsubscribeBars',
      callback: (arguments) {
        final listenerGuid = arguments[0] as String;

        if (_onTickMap.containsKey(listenerGuid)) {
          // Dispose existing onTick
        }
        _onTickMap.remove(listenerGuid);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'saveData',
      callback: (arguments) {},
    );
  }

  @override
  void initState() {
    super.initState();

    _isLoading = true;
    _isError = false;
    _isServerRunning = localhostManager.isRunning;
    if (!_isServerRunning) {
      localhostManager.startServer().then((_) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (mounted) {
            setState(() {
              _isServerRunning = true;
            });
          }
        });
      });
    }

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _controller = null;
    _onTickMap.forEach((key, value) {
      // Dispose all onTick request/stream
    });

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stackContent = <Widget>[];

    if (_isServerRunning) {
      stackContent.add(
        Column(
          children: [
            if (_showBack)
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.adaptive.arrow_back),
                    onPressed: () async {
                      final controller = _controller;
                      if (controller != null) {
                        if (await controller.canGoBack()) {
                          await controller.goBack();
                        }

                        setState(() {
                          _showBack = false;
                        });
                      }
                    },
                  ),
                  const Text(
                    'Return to Chart',
                  ),
                ],
              )
            else
              const SizedBox(),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: localhostManager.getUriWith(
                    path: assetsPath,
                  ),
                ),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    clearCache: true,
                    supportZoom: false,
                  ),
                ),
                // Pass all gesture to Webview
                gestureRecognizers: {
                  Factory(() => EagerGestureRecognizer()),
                },
                onWebViewCreated: (controller) {
                  _controller = controller;
                  _attachHandler();
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    _isLoading = true;
                    _isError = false;
                    _isErrorMessage = '';
                  });
                },
                onLoadStop: (controller, url) {
                  setState(() {
                    _isLoading = false;
                    _isError = false;
                    // In case host not localhost (ex: got redirected to www.tradingview.com)
                    // Give user UI to call back on Webview
                    _showBack = url != null && url.host != localhostManager.uri.host;
                  });
                },
                onLoadError: (controller, url, code, message) {
                  setState(() {
                    _isLoading = false;
                    _isError = false;
                    _isErrorMessage = '$code - $message';
                    _showBack = url != null && url.host != localhostManager.uri.host;
                  });
                },
                onLoadHttpError: (controller, url, statusCode, description) {
                  setState(() {
                    _isLoading = false;
                    _isError = false;
                    _isErrorMessage = 'HTTP $statusCode - $description';
                    _showBack = url != null && url.host != localhostManager.uri.host;
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  if (kDebugMode) {
                    final level = consoleMessage.messageLevel.toString();
                    final message = consoleMessage.message;
                    print('Webview Console $level: $message');
                  }
                },
              ),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      stackContent.add(const CircularProgressIndicator.adaptive());
    }

    if (_isError) {
      stackContent.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error),
            Text(_isErrorMessage),
          ],
        ),
      );
    }

    // ignore: avoid_unnecessary_containers
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: stackContent,
      ),
    );
  }
}

@immutable
class _OnTickInfo {
  const _OnTickInfo({
    required this.symbolInfo,
    required this.resolution,
  });
  final LibrarySymbolInfo symbolInfo;
  final String resolution;
}
