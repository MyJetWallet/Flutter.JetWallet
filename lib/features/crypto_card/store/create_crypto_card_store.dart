import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'create_crypto_card_store.g.dart';

@lazySingleton
class CreateCryptoCardStore extends _CreateCryptoCardStoreBase with _$CreateCryptoCardStore {
  CreateCryptoCardStore() : super();

  _CreateCryptoCardStoreBase of(BuildContext context) => Provider.of<CreateCryptoCardStore>(context);
}

abstract class _CreateCryptoCardStoreBase with Store {}
