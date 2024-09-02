import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

part 'jars_store.g.dart';

const int jarNameLength = 18;
const int jarMaxGoal = 15000;
const int jarDescriptionLength = 60;

@lazySingleton
class JarsStore extends _JarsStoreBase with _$JarsStore {
  JarsStore() : super();

  static _JarsStoreBase of(BuildContext context) => Provider.of<JarsStore>(context);
}

abstract class _JarsStoreBase with Store {
  @observable
  ObservableList<JarResponseModel> allJar = ObservableList.of([]);

  @observable
  ObservableList<JarResponseModel> activeJar = ObservableList.of([]);

  @observable
  JarResponseModel? selectedJar;

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @action
  Future<void> initStore() async {
    try {
      final responseAll = await sNetwork.getWalletModule().postJarAllList();

      final resultAll = responseAll.data;

      if (resultAll != null) {
        allJar.clear();
        allJar.addAll(resultAll);
      }

      final responseActive = await sNetwork.getWalletModule().postJarActiveList();

      final resultActive = responseActive.data;

      if (resultActive != null) {
        activeJar.clear();
        activeJar.addAll(resultActive);
      }
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'Jars',
            message: e.toString(),
          );
    }
  }

  @action
  Future<void> refreshJarsStore() async {
    await initStore();

    if (selectedJar != null) {
      selectedJar = allJar.firstWhere((element) => element.id == selectedJar!.id);
    }
  }

  @action
  void addNewJar(JarResponseModel jar) {
    allJar = ObservableList.of([jar, ...allJar]);
    activeJar = ObservableList.of([jar, ...activeJar]);
  }

  @action
  Future<JarResponseModel?> updateJar({
    required String jarId,
    int? target,
    String? imageUrl,
    String? title,
    String? description,
  }) async {
    try {
      final response = await sNetwork.getWalletModule().postUpdateJarRequest(
            jarId: jarId,
            target: target,
            imageUrl: imageUrl,
            title: title,
            description: description,
          );

      final result = response.data;

      if (result != null) {
        selectedJar = result;
        // final activeIndex = activeJar.indexWhere((jar) {
        //   return jar.id == jarId;
        // });
        // activeJar.removeAt(activeIndex);
        // activeJar.insert(activeIndex, result);
        //
        // final allIndex = allJar.indexWhere((jar) {
        //   return jar.id == jarId;
        // });
        // allJar.removeAt(allIndex);
        // allJar.insert(allIndex, result);
        await refreshJarsStore();

        return result;
      }
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'Jars',
            message: e.toString(),
          );
    }
    return null;
  }

  @action
  Future<void> closeJar(String jarId) async {
    try {
      final response = await sNetwork.getWalletModule().postCloseJarRequest(
            jarId: jarId,
          );

      final result = response.data;

      if (result != null) {
        await refreshJarsStore();
      }
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'Jars',
            message: e.toString(),
          );
    }
  }

  @action
  void clearData() {
    activeJar = ObservableList.of([]);
    allJar = ObservableList.of([]);
  }

  Future<String?> shareJar({
    required String jarId,
    required String lang,
  }) async {
    try {
      final response = await sNetwork.getWalletModule().postShareJarRequest(
            jarId: jarId,
            lang: lang,
          );

      final result = response.data;

      if (result != null) {
        return result;
      }
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'Jars',
            message: e.toString(),
          );
    }
    return null;
  }
}
