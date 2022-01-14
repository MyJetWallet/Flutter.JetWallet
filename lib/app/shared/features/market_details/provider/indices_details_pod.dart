import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/shared/features/market_details/provider/indices_details_spod.dart';
import 'package:jetwallet/service/services/signal_r/model/indices_model.dart';

final indicesDetailsPod = Provider.autoDispose<List<IndexModel>>((ref) {
  final indices = ref.watch(indicesDetailsSpod);
  final items = <IndexModel>[];

  indices.whenData((value) {
    for (final index in value.indices) {
      items.add(index);
    }
  });

  return items;
});
