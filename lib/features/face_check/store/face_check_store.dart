import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:mobx/mobx.dart';

part 'face_check_store.g.dart';

class FaceCheckStore = _FaceCheckStoreBase with _$FaceCheckStore;

abstract class _FaceCheckStoreBase with Store {
  StackLoaderStore loader = StackLoaderStore();

  @observable
  bool isFaceCheckCheckStatus = false;

  Future<void> runPreloadLoader() async {
    isFaceCheckCheckStatus = false;
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

        getIt.get<StartupService>().pushHome();
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
