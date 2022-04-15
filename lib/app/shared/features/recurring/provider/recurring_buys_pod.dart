import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../screens/portfolio/provider/recurring_buys_spod.dart';
import '../../../models/recurring_buys_model.dart';


final recurringBuysPod = Provider.autoDispose<List<RecurringBuysModel>>((ref) {
  final recurringBuys = ref.watch(recurringBuySpod);
  final items = <RecurringBuysModel>[];

  recurringBuys.whenData((data) {
    for (final element in data.recurringBuys) {
      items.add(element);
    }
  });

  return items;
});
