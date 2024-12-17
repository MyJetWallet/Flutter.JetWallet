import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/global_loader.dart';
import 'package:jetwallet/features/my_wallets/helper/show_create_personal_account.dart';
import 'package:jetwallet/features/my_wallets/helper/show_wallet_verify_account.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

part 'get_personal_iban_store.g.dart';

class GetPersonalIbanStore extends _GetPersonalIbanStoreBase with _$GetPersonalIbanStore {
  GetPersonalIbanStore() : super();

  static GetPersonalIbanStore of(BuildContext context) => Provider.of<GetPersonalIbanStore>(context, listen: false);
}

abstract class _GetPersonalIbanStoreBase with Store {
  @observable
  StackLoaderStore loading = StackLoaderStore();

  @action
  void startLoading() {
    loading.startLoadingImmediately();
  }

  @action
  void stopLoading() {
    loading.finishLoading();
  }

  @action
  Future<void> openAnAccount(BuildContext context) async {
    try {
      startLoading();

      final resp = await getIt.get<SNetwork>().simpleNetworking.getWalletModule().postAccountCreate(
            const Uuid().v1(),
          );

      if (resp.hasError) {
        sNotification.showError(
          intl.something_went_wrong_try_again,
          id: 1,
        );

        loading.finishLoadingImmediately();
      } else {
        if (resp.data!.simpleKycRequired || resp.data!.addressSetupRequired) {
          showWalletVerifyAccount(
            context,
            after: _afterVerification,
            isBanking: false,
          );
        } else if (resp.data!.bankingKycRequired) {
          showCreatePersonalAccount(
            context,
            loading,
            _afterVerification,
          );
        } else {
          await sRouter.maybePop();
        }
      }
    } catch (e) {
      sNotification.showError(intl.something_went_wrong_try_again);
    } finally {
      loading.finishLoadingImmediately();
    }
  }

  void _afterVerification() {
    sRouter.popUntilRoot();

    getIt.get<GlobalLoader>().setLoading(false);

    sNotification.showError(intl.let_us_create_account, isError: false);
  }
}
