import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:jetwallet/features/invest/ui/chart/tvchart/tvchart_types.dart';

import '../../../../../utils/constants.dart';
import '../commons/localhost.dart';
import '../commons/tzdt.dart';
import '../data/historical.dart';

class TVChart extends StatefulWidget {
  const TVChart({super.key});

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
  void _callOnTick(String listenerGuid, Bar bar) {
    if (_chartLoaded) {
      final controller = _controller!;
      final payload = <String, dynamic>{
        'listenerGuid': listenerGuid,
        'bar': bar,
      };

      controller.evaluateJavascript(
        source: 'window.callOnTick(`${jsonEncode(payload)}`);',
      );
    }
  }

  void _attachHandler() {
    final controller = _controller;
    if (controller == null) return;

    controller.addJavaScriptHandler(
      handlerName: 'start',
      callback: (arguments) {
        return ChartingLibraryWidgetOptions(
          debug: false,
          locale: 'en',
          symbol: 'IDX:COMPOSITE',
          fullscreen: false,
          interval: '1D',
          timezone: Timezone.asiaJakarta,
          autosize: true,
          autoSaveDelay: 1,
          savedData: _savedData,
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
        final result = historical.getSymbol(symbolName);

        if (result != null) {
          return result.getLibrarySymbolInfo();
        } else {
          return 'Symbol not found!';
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'getBars',
      callback: (arguments) async {
        final symbolInfo =
            LibrarySymbolInfo.fromJson(arguments[0] as Map<String, dynamic>);
        // Only 1 resolution on example, not needed
        // final String resolution = arguments[1];
        // final PeriodParams periodParams = PeriodParams.fromJson(arguments[2]);

        print('arguments');
        print(arguments);
        final symbol = historical.getSymbol(symbolInfo.name);
        if (symbol == null) {
          return 'Symbol not found';
        } else {
          final result = await symbol.getDataRange(
            tzMillisecond((arguments[2] as int) * 1000),
            tzMillisecond((arguments[3] as int) * 1000),
          );

          return {
            'bars': result
                .map(
                  (e) => Bar(
                    time: e.dt.millisecondsSinceEpoch,
                    open: e.open,
                    high: e.high,
                    low: e.low,
                    close: e.close,
                    volume: e.volume,
                  ),
                )
                .toList(),
            'meta': {
              'noData': result.isEmpty,
            },
          };
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'subscribeBars',
      callback: (arguments) {

        final symbolInfo =
            LibrarySymbolInfo.fromJson(arguments[0] as Map<String, dynamic>);
        final resolution = arguments[1] as String;
        final listenerGuid = arguments[2] as String;

        if (_onTickMap.containsKey(listenerGuid)) {
          // Dispose existing onTick with same ID
        }

        _onTickMap[listenerGuid] = _OnTickInfo(
          symbolInfo: symbolInfo,
          resolution: resolution,
        );

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
      callback: (arguments) {
        if (arguments[0] is Map<String, dynamic>) {
          _savedData = arguments[0] as Map<String, dynamic>;
        }
      },
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
                    _showBack =
                        url != null && url.host != localhostManager.uri.host;
                  });
                },
                onLoadError: (controller, url, code, message) {
                  setState(() {
                    _isLoading = false;
                    _isError = false;
                    _isErrorMessage = '$code - $message';
                    _showBack =
                        url != null && url.host != localhostManager.uri.host;
                  });
                },
                onLoadHttpError: (controller, url, statusCode, description) {
                  setState(() {
                    _isLoading = false;
                    _isError = false;
                    _isErrorMessage = 'HTTP $statusCode - $description';
                    _showBack =
                        url != null && url.host != localhostManager.uri.host;
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

Map<String, dynamic>? _savedData;

@immutable
class _OnTickInfo {
  const _OnTickInfo({
    required this.symbolInfo,
    required this.resolution,
  });
  final LibrarySymbolInfo symbolInfo;
  final String resolution;
}
