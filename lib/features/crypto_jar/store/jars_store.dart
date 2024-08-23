import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

part 'jars_store.g.dart';

@lazySingleton
class JarsStore extends _JarsStoreBase with _$JarsStore {
  JarsStore() : super();

  static _JarsStoreBase of(BuildContext context) => Provider.of<JarsStore>(context, listen: false);
}

abstract class _JarsStoreBase with Store {
  @observable
  ObservableList<JarResponseModel> allJar = ObservableList.of([]);

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @action
  Future<void> initStore() async {
    try {
      final response = await sNetwork.getWalletModule().postJarAllList();

      final result = response.data;

      if (result != null) {
        allJar.addAll(result);
      }
      // final newJar = [
      //   JarResponseModel(
      //     id: '1',
      //     tokenId: '1',
      //     balance: 0,
      //     target: 100,
      //     assetSymbol: 'USDT',
      //     imageUrl: '',
      //     ownerName: 'o',
      //     title: 'Test',
      //     description: '123',
      //     status: JarStatus.active,
      //   ),
      //   JarResponseModel(
      //     id: '1',
      //     tokenId: '1',
      //     balance: 1000,
      //     target: 1000,
      //     assetSymbol: 'USDT',
      //     imageUrl: '',
      //     ownerName: 'o',
      //     title: 'Test123',
      //     description: '123',
      //     status: JarStatus.closed,
      //   ),
      //   JarResponseModel(
      //     id: '1',
      //     tokenId: '1',
      //     balance: 35,
      //     target: 100,
      //     assetSymbol: 'USDT',
      //     imageUrl: '',
      //     ownerName: 'o',
      //     title: 'Test333',
      //     description: '123',
      //     status: JarStatus.active,
      //   ),
      // ];
      // allJar = ObservableList.of(newJar);
    } catch (e) {
      print('#@#@#@#@ $e');
    }
  }
}
