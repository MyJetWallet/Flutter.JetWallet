// ignore: import_of_legacy_library_into_null_safe
import 'package:charts/entity/instrument_entity.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:charts/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../auth/providers/auth_model_notipod.dart';

class Charts extends HookWidget {
  const Charts();

  @override
  Widget build(BuildContext context) {
    final authModel = useProvider(authModelNotipod);

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
            Chart(
              authToken: authModel.token,
              instrument: Instrument('BTCUSD', 'BTCUSD', 2, []),
            ),
            Chart(
              authToken: authModel.token,
              instrument: Instrument('ETHUSD', 'ETHUSD', 2, []),
            ),
          ],
        ),
      ),
    );
  }
}
