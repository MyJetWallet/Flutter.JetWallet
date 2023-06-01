import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_card_response.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_request_model.dart';

part 'send_globally_confirm_store.g.dart';

class SendGloballyConfirmStore extends _SendGloballyConfirmStoreBase
    with _$SendGloballyConfirmStore {
  SendGloballyConfirmStore() : super();

  static SendGloballyConfirmStore of(BuildContext context) =>
      Provider.of<SendGloballyConfirmStore>(context, listen: false);
}

abstract class _SendGloballyConfirmStoreBase with Store {
  StackLoaderStore loader = StackLoaderStore();

  SendToBankCardResponse? data;

  CurrencyModel sendCurrency = currencyFrom(
    sSignalRModules.currenciesList,
    'EUR',
  );

  @action
  void init(SendToBankCardResponse val) {
    data = val;

    sendCurrency = currencyFrom(
      sSignalRModules.currenciesList,
      data!.asset!,
    );
  }

  Future<void> confirmSendGlobally(SendToBankRequestModel model) async {
    loader.startLoadingImmediately();

    final response = await getIt
        .get<SNetwork>()
        .simpleNetworking
        .getWalletModule()
        .sendToBankCard(
          model,
        );

    loader.finishLoadingImmediately();

    if (response.hasError) {
      await showFailureScreen(response.error?.cause ?? '');
    } else {
      await showSuccessScreen(model);
    }
  }

  @action
  Future<void> showFailureScreen(String error) {
    return sRouter.push(
      FailureScreenRouter(
        primaryText: intl.failed,
        secondaryText: error,
        primaryButtonName: intl.withdrawalConfirm_close,
        onPrimaryButtonTap: () {
          navigateToRouter();
        },
      ),
    );
  }

  @action
  Future<void> showSuccessScreen(SendToBankRequestModel model) {
    return sRouter
        .push(
          SuccessScreenRouter(
            primaryText: intl.send_globally_success,
            secondaryText:
                '${intl.send_globally_success_secondary} ${volumeFormat(
              prefix: sendCurrency.prefixSymbol,
              decimal: model.amount ?? Decimal.zero,
              accuracy: sendCurrency.accuracy,
              symbol: sendCurrency.symbol,
            )}'
                '\n${intl.send_globally_success_secondary_2}',
            showProgressBar: true,
            bottomWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: SAccountWaitingIcon(
                    color: sKit.colors.grey2,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    intl.send_globally_success_info,
                    style: sBodyText1Style.copyWith(
                      fontSize: 12,
                      color: sKit.colors.grey2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .then(
          (value) => sRouter.replaceAll([
            const HomeRouter(
              children: [
                PortfolioRouter(),
              ],
            ),
          ]),
        );
  }
}
