import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/signal_r/model/recurring_buys_model.dart';
import 'recurring_buys_spod.dart';

final recurringBuysPod = Provider.autoDispose<List<RecurringBuysModel>>((ref) {
  final recurringBuys = ref.watch(recurringBuySpod);
  final items = <RecurringBuysModel>[];

  recurringBuys.whenData((data) {
    for (final element in data.recurringBuys) {
      items.add(element);
    }
  });

  return items;
},
  name: 'recurringBuysPod',
);
