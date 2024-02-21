import moment = require("moment");
import * as TradingView from "./charting_library/charting_library";

declare global {
  interface Window {
    flutter_inappwebview: {
      callHandler: (handlerName: string, ...args: any) => Promise<any>;
    };
    toggleDarkTheme: () => void;
    toggleLightTheme: () => void;
    callOnTick: (payload: string) => void;
  }
}

const onTickMap: Map<String, TradingView.SubscribeBarsCallback> = new Map();

const datafeed: TradingView.IBasicDataFeed = {
  onReady: (callback: TradingView.OnReadyCallback) => {
    window.flutter_inappwebview.callHandler("onReady").then((result) => {
      callback(result);
    });
  },
  searchSymbols: (
    userInput: string,
    exchange: string,
    symbolType: string,
    onResult: TradingView.SearchSymbolsCallback
  ) => {
    window.flutter_inappwebview
      .callHandler("searchSymbols", userInput, exchange, symbolType)
      .then((value) => {
        if (Array.isArray(value)) {
          onResult(value);
        } else {
          onResult([]);
        }
      })
      .catch((reason) => {
        onResult([]);
      });
  },
  resolveSymbol: (
    symbolName: string,
    onResolve: TradingView.ResolveCallback,
    onError: TradingView.ErrorCallback,
  ) => {
    const symbol_stub: TradingView.LibrarySymbolInfo = {
      full_name: symbolName,
      listed_exchange: '',
      name: symbolName,
      description: '',
      type: 'forex',
      session: '24x7',
      timezone: 'Etc/UTC',
      ticker: symbolName,
      exchange: symbolName,
      minmov: 1,
      pricescale:
        10 ** 2,
      has_intraday: true,
      intraday_multipliers: [
        '1',
        '60',
      ],
      has_weekly_and_monthly: true,
      has_daily: true,
      has_no_volume: true,
      has_empty_bars: false,
      supported_resolutions: ['15', '60', '240','1D'] as TradingView.ResolutionString[],
      data_status: 'streaming',
      format: 'price',
    };

    setTimeout(function () {
      onResolve(symbol_stub);
    }, 0);
  },
  getBars: (
    symbolInfo: TradingView.LibrarySymbolInfo,
    resolution: TradingView.ResolutionString,
    rangeStartDate: number,
    rangeEndDate: number,
    onResult: TradingView.HistoryCallback,
    onError: TradingView.ErrorCallback
  ) => {
    window.flutter_inappwebview
      .callHandler("getBars", symbolInfo, resolution, rangeStartDate, rangeEndDate)
      .then((value) => {
        if (value !== null && typeof value === "object") {
            if (chart != undefined) {
              if (chart.activeChart().chartType() != value.chartType) {
                chart.activeChart().setChartType(value.chartType);
              }
              if (chart.activeChart().resolution() != value.resolution) {
                chart.activeChart().setResolution(
                  value.resolution,
                  () => {
                    let from = moment();
                    switch (value.resolution) {
                      case '15':
                        from = moment().subtract(15, 'm');
                        break;

                      case '60':
                        from = moment().subtract(1, 'h');
                        break;

                      case '240':
                        from = moment().subtract(4, 'h');
                        break;

                      case '1D':
                        from = moment().subtract(1, 'd');
                        break;

                      default:
                        from = moment().subtract(15, 'm');
                        break;
                    }
                    chart.activeChart().setVisibleRange({
                      from: from.valueOf(),
                      to: moment().valueOf(),
                    });
                  },
                );
              }
            }

          try {
            onResult(value.bars, value.meta);
          } catch (e) {}
        } else if (typeof value === "string") {
          onError(value);
        } else {
          onError("Unexpected getBars return type");
        }
      })
      .catch((reason) => {
        onError("Unexpected error on getBars");
      });
  },
  subscribeBars: (
    symbolInfo: TradingView.LibrarySymbolInfo,
    resolution: TradingView.ResolutionString,
    onTick: TradingView.SubscribeBarsCallback,
    listenerGuid: string,
    onResetCacheNeededCallback: () => void
  ) => {
    onTickMap.set(listenerGuid, onTick);

    window.flutter_inappwebview.callHandler(
      "subscribeBars",
      symbolInfo,
      resolution,
      listenerGuid
    );
  },
  unsubscribeBars: (listenerGuid: string) => {
    onTickMap.delete(listenerGuid);

    window.flutter_inappwebview.callHandler("unsubscribeBars", listenerGuid);
  }
};

let chart: TradingView.IChartingLibraryWidget | undefined;

function toggleLightTheme() {
  if (chart != undefined) {
    chart.changeTheme("Light");
  }
}
window.toggleLightTheme = toggleLightTheme;

function toggleDarkTheme() {
  if (chart != undefined) {
    chart.changeTheme("Dark");
  }
}
window.toggleDarkTheme = toggleDarkTheme;

function callOnTick(payload: string) {
  const payloadObject: Record<string, any> = JSON.parse(payload);
  const listenerGuid: string | undefined = payloadObject["listenerGuid"];
  const bar: TradingView.Bar | undefined = payloadObject["bar"];
  const chartType = payloadObject["chartType"];
  const resolution = payloadObject["resolution"];

  if (listenerGuid == undefined || bar == undefined) return;
  if (chart != undefined) {
    if (chart.activeChart().chartType() != chartType) {
      chart.activeChart().setChartType(chartType);
    }
    if (chart.activeChart().resolution() != resolution) {
      chart.activeChart().setResolution(
        resolution,
        () => {
          let from = moment();
          switch (resolution) {
            case '15':
              from = moment().subtract(15, 'm');
              break;

            case '60':
              from = moment().subtract(1, 'h');
              break;

            case '240':
              from = moment().subtract(4, 'h');
              break;

            case '1D':
              from = moment().subtract(1, 'd');
              break;

            default:
              from = moment().subtract(15, 'm');
              break;
          }
          chart.activeChart().setVisibleRange({
            from: from.valueOf(),
            to: moment().valueOf(),
          });
        },
      );
    }
  }

  if (onTickMap.has(listenerGuid)) {
    const onTick = onTickMap.get(listenerGuid);
    onTick(bar);
  }
}
window.callOnTick = callOnTick;

window.addEventListener("flutterInAppWebViewPlatformReady", (event) => {
  window.flutter_inappwebview
    .callHandler("start")
    .then((options: TradingView.ChartingLibraryWidgetOptions) => {
      options.container_id = "tvchart";
      options.library_path = "public/";
      options.datafeed = datafeed;

      if (chart == undefined) {
        chart = new TradingView.widget(options);
        chart.onChartReady(() => {

          chart.subscribe("onAutoSaveNeeded", () => {
            chart.save((state) => {
              window.flutter_inappwebview.callHandler("saveData", state);
            });
          });
        });
      }
    });
});
