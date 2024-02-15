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
    console.log('ready call');
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
    console.log('searchSymbols call');
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
    console.log('resolveSymbol call');
    window.flutter_inappwebview
      .callHandler("resolveSymbol", symbolName)
      .then((value) => {
        if (value !== null && typeof value === "object") {
          console.log(JSON.stringify(value));
          console.log(JSON.stringify(value as TradingView.LibrarySymbolInfo));
          onResolve(value as TradingView.LibrarySymbolInfo);
        } else if (typeof value === "string") {
          onError(value);
        } else {
          onError("Unexpected resolveSymbol return type");
        }
      })
      .catch((reason) => {
        onError("Unexpected error on resolveSymbol");
      });
  },
  getBars: (
    symbolInfo: TradingView.LibrarySymbolInfo,
    resolution: TradingView.ResolutionString,
    rangeStartDate: number,
    rangeEndDate: number,
    onResult: TradingView.HistoryCallback,
    onError: TradingView.ErrorCallback
  ) => {
    console.log('getBars call');
    window.flutter_inappwebview
      .callHandler("getBars", symbolInfo, resolution, rangeStartDate, rangeEndDate)
      .then((value) => {
        if (value !== null && typeof value === "object") {
            console.log('getBars success');
            console.log(JSON.stringify(value.bars));

          try {
            onResult(value.bars, value.meta);
          } catch (e) {
            console.log('error');
            console.log(e);
          }
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
    console.log('subscribeBars');
    onTickMap.set(listenerGuid, onTick);
    console.log('subscribeBars 1');

    window.flutter_inappwebview.callHandler(
      "subscribeBars",
      symbolInfo,
      resolution,
      listenerGuid
    );
  },
  unsubscribeBars: (listenerGuid: string) => {
    console.log('unsubscribeBars');
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

  if (listenerGuid == undefined || bar == undefined) return;

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
        console.log(TradingView.version());
        console.log(JSON.stringify(options));
        console.log(JSON.stringify(typeof TradingView));
        console.log(JSON.stringify(typeof datafeed));
        console.log(JSON.stringify(typeof TradingView.widget));
        chart = new TradingView.widget(options);
        console.log(2);
        chart.onChartReady(() => {
            console.log('chart ready');

          chart.subscribe("onAutoSaveNeeded", () => {
            console.log('onAutoSaveNeeded subscribe');
            chart.save((state) => {
                console.log('chart saveData');
              window.flutter_inappwebview.callHandler("saveData", state);
            });
          });
        });
      }
    });
});
