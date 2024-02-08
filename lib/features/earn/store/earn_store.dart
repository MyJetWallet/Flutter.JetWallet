import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'earn_store.g.dart';

class EarnStore extends _EarnStoreBase with _$EarnStore {
  EarnStore() : super();

  static _EarnStoreBase of(BuildContext context) => Provider.of<EarnStore>(context, listen: false);
}

abstract class _EarnStoreBase with Store {
  _EarnStoreBase();
}
