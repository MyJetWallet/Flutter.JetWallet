import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/crypto_jar/store/jar_update_store.dart';
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

  @action
  void setSelectedJar(JarResponseModel? value) {
    selectedJar = value;
  }

  @action
  void setSelectedJarById(String jarId) {
    final index = allJar.indexWhere(
      (jar) => jar.id == jarId,
    );

    if (index != -1) {
      selectedJar = allJar[index];
    } else {
      selectedJar = null;
    }
  }

  @observable
  double? limit;

  @action
  void setLimit(double value) {
    limit = value;
  }

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

        activeJar.clear();
        for (var i = 0; i < allJar.length; i++) {
          if (allJar[i].status != JarStatus.closed) {
            activeJar.add(allJar[i]);
          }
        }
      }

      final responseLimit = await sNetwork.getWalletModule().postWithdrawJarLimitRequest(
        {
          'assetSymbol': 'USDT',
        },
      );

      responseLimit.pick(
        onData: (data) {
          setLimit(data.limit);
        },
        onError: (error) {},
      );
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
    if (activeJar.where((jar) => jar.status == JarStatus.creating).isNotEmpty) {
      getIt.get<JarUpdateStore>().start(refreshJarsStore);
    } else {
      getIt.get<JarUpdateStore>().stop();
    }

    if (selectedJar != null) {
      setSelectedJar(allJar.firstWhere((element) => element.id == selectedJar!.id));
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
        setSelectedJar(result);

        await refreshJarsStore();

        return selectedJar;
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
    selectedJar = null;
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
