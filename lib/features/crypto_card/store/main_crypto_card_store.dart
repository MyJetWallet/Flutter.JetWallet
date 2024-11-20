import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'main_crypto_card_store.g.dart';

class MainCryptoCardStore extends _MainCryptoCardStoreBase with _$MainCryptoCardStore {
  MainCryptoCardStore() : super();

  _MainCryptoCardStoreBase of(BuildContext context) => Provider.of<MainCryptoCardStore>(context);
}

abstract class _MainCryptoCardStoreBase with Store {}
