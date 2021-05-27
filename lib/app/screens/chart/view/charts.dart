import 'package:charts/entity/k_line_entity.dart';
import 'package:charts/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/screens/chart/notifiers/state/charts_state.dart';
import 'package:jetwallet/shared/components/loader.dart';
import '../providers/charts_init_fpod.dart';

class Charts extends HookWidget {
  const Charts();

  @override
  Widget build(BuildContext context) {
    final charts = useProvider(chartsInitFpod('BTCUSD'));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(text: 'BTCUSD'),
              Tab(text: 'ETHUSD'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            charts.when(data: (data) {
              return Chart(
                  onResolutionChanged: (resolution) {},
                  candles: data.candles
                      .map((e) => KLineEntity.fromJson(e.toJson()))
                      .toList());
            }, loading: () {
              return Loader();
            }, error: (_, __) {
              return Text('Error');
            }),
            charts.when(data: (data) {
              return Chart(
                  onResolutionChanged: (resolution) {},
                  candles: data.candles
                      .map((e) => KLineEntity.fromJson(e.toJson()))
                      .toList());
            }, loading: () {
              return Loader();
            }, error: (_, __) {
              return Text('Error');
            }),
            // Chart(
            //   candles: [], onResolutionChanged: (String) {},
            //   // authToken: authModel.token,
            //   // instrument: Instrument('BTCUSD', 'BTCUSD', 2, []),
            // ),
            // Chart(
            //   candles: [], onResolutionChanged: (String) {},
            //     // authToken: authModel.token,
            //     // instrument: Instrument('ETHUSD', 'ETHUSD', 2, []),
            //     ),
          ],
        ),
      ),
    );
  }
}

final chartInitFpod = FutureProvider.family<void, String>((ref, instrumentId) {
  return
  // final notifier = ref.watch(chartNotipod.notifier);
  // request to the API and go the data
  // notifier.initUpdate(data)
});

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final future = useProvider(chartInitFpod);
    // final state = useProvider(chartNotipod);
    // final notifier = useProvider(chartNotipod.notifier);
    return future.when(
      data: (_) {
        // return Chart(
        //     data: state.array,
        //     isLoading: state.isLoading,
        //     onCandle: () => notifier.updateCandle(),
        //     );
      },
      loading: () => Loader(),
      error: (e, _) => Text(e.toString()),
    );
  }
}
class MyNotifier extends StateNotifier<ChartsState> {
  MyNotifier() : super(const ChartsState());
  void update() {
    // make request
    state = newState;
  }
// ...
}
final myNotifierNotipod = StateNotifierProvider<MyNotifier, ChartsState>((ref) {
  return MyNotifier();
});
