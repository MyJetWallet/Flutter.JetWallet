import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

part 'create_jar_store.g.dart';

@lazySingleton
class CreateJarStore extends _CreateJarStoreBase with _$CreateJarStore {
  CreateJarStore() : super();

  static _CreateJarStoreBase of(BuildContext context) => Provider.of<CreateJarStore>(context);
}

abstract class _CreateJarStoreBase with Store {
  @observable
  bool loading = false;

  @action
  Future<JarResponseModel?> createNewJar(String title, int goal) async {
    loading = true;

    try {
      final response = await sNetwork.getWalletModule().postCreateJar(
            assetSymbol: 'USDT',
            blockchain: getIt.get<AppStore>().env == 'stage' ? 'fireblocks-eth-sepolia' : 'fireblocks-tron',
            target: goal,
            imageUrl: '',
            title: title,
            description: null,
          );

      if (response.hasData) {
        final result = response.data;

        if (result != null) {
          loading = false;
          return result;
        }
      } else {
        if (response.hasError) {
          loading = false;
          sNotification.showError(response.error!.cause);
        }
      }
    } catch (e) {
      loading = false;
      sNotification.showError(intl.something_went_wrong_try_again);

      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'JarCreate',
            message: e.toString(),
          );
    }
    return null;
  }
}
