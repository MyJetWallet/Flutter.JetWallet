import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/signal_r/model/indices_model.dart';
import 'indices_details_spod.dart';

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
