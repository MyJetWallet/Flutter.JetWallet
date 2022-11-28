import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'nft_receive_store.g.dart';

class NftReceiveStore extends _NftReceiveStoreBase with _$NftReceiveStore {
  NftReceiveStore() : super();

  static _NftReceiveStoreBase of(BuildContext context) =>
      Provider.of<NftReceiveStore>(context, listen: false);
}

abstract class _NftReceiveStoreBase with Store {
  @observable
  String address = '';

  @observable
  String? tag;

  @observable
  bool canShare = false;
  @action
  void setCanShare(bool value) => canShare = value;

  @action
  Future<void> init() async {
    final response = await sNetwork.getWalletModule().postDepositNFTAddress();

    response.pick(
      onData: (data) {
        print(data);

        address = data.address!;
        tag = data.memo;

        canShare = true;

        print(address);
      },
      onError: (error) {
        print(error);

        sNotification.showError(
          error.cause,
          id: 1,
        );
      },
    );
  }
}
