import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';

part 'face_check_store.g.dart';

class FaceCheckStore = _FaceCheckStoreBase with _$FaceCheckStore;

abstract class _FaceCheckStoreBase with Store {
  StackLoaderStore loader = StackLoaderStore();

  @observable
  bool isFaceCheckCheckStatus = false;

  Future<void> runPreloadLoader() async {
    loader.startLoadingImmediately();

    Future.delayed(const Duration(seconds: 5), () {
      loader.finishLoadingImmediately();
    });
  }

  @action
  Future<void> checkStatus() async {
    if (!isFaceCheckCheckStatus) {
      loader.startLoadingImmediately();

      final status = await getFaceCheckStatus();

      if (status == 2) {
        loader.finishLoadingImmediately();

        getIt.get<StartupService>().pinVerified();
      } else if (status == 0) {
        loader.finishLoadingImmediately();
      }
    }
  }

  @action
  Future<int> getFaceCheckStatus() async {
    isFaceCheckCheckStatus = true;

    final request = await sNetwork.getWalletModule().postFaceCheckStatus();

    if (request.hasError) {
      isFaceCheckCheckStatus = false;

      return 0;
    } else {
      if (request.data == 2) {
        isFaceCheckCheckStatus = false;

        return request.data ?? 2;
      } else if (request.data == 1) {
        await Future.delayed(const Duration(seconds: 1));

        return getFaceCheckStatus();
      } else {
        return 0;
      }
    }
  }
}
