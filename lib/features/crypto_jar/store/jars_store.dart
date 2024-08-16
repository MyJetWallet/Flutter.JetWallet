import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

part 'jars_store.g.dart';

@lazySingleton
class JarsStore = _JarsStoreBase with _$JarsStore;

abstract class _JarsStoreBase with Store {
  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  List<JarResponseModel> allJar = [];

  @action
  Future<void> initStore() async {
    try {
      final response = await sNetwork.getWalletModule().postJarAllList();

      final result = response.data;

      if (result != null) {
        allJar.addAll(result);
      }
    } catch (e) {
      print('3213112 $e');
    }
  }
}