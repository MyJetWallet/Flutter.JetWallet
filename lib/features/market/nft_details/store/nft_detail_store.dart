import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'nft_detail_store.g.dart';

class NFTDetailStore extends _NFTDetailStoreBase with _$NFTDetailStore {
  NFTDetailStore() : super();

  static _NFTDetailStoreBase of(BuildContext context) =>
      Provider.of<NFTDetailStore>(context, listen: false);
}

abstract class _NFTDetailStoreBase with Store {}
