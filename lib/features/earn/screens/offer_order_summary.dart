import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/earn/store/earn_offer_order_summary_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

@RoutePage(name: 'OfferOrderSummaryRouter')
class OfferOrderSummaryScreen extends StatelessWidget {
  const OfferOrderSummaryScreen({
    super.key,
    required this.offer,
    required this.amount,
  });

  final EarnOfferClientModel offer;
  final Decimal amount;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Provider<OfferOrderSummaryStore>(
      create: (context) => OfferOrderSummaryStore(
        offer: offer,
        amount: amount,
      ),
      builder: (context, child) {
        final store = OfferOrderSummaryStore.of(context);

        return SPageFrameWithPadding(
          loading: store.loader,
          loaderText: intl.register_pleaseWait,
          customLoader: store.showProcessing
              ? WaitingScreen(
                  primaryText: intl.buy_confirmation_local_p2p_processing_title,
                  onSkip: () {
                    navigateToRouter();
                  },
                )
              : null,
          header: SSmallHeader(
            title: intl.earn_order_summary,
            subTitle: intl.earn_send,
            subTitleStyle: sBodyText2Style.copyWith(
              color: colors.grey1,
            ),
          ),
          child: const _OfferOrderSummaruBody(),
        );
      },
    );
  }
}

class _OfferOrderSummaruBody extends StatelessWidget {
  const _OfferOrderSummaruBody();

  @override
  Widget build(BuildContext context) {
    final store = OfferOrderSummaryStore.of(context);

    return Observer(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WhatToWhatConvertWidget(
              isLoading: false,
              fromAssetIconUrl: store.currency.iconUrl,
              fromAssetDescription: '${intl.earn_crypto_wallet} ${store.currency.symbol}',
              fromAssetValue: store.currency.volumeAssetBalance,
              fromAssetBaseAmount:
                  '≈${volumeFormat(decimal: store.baseCryptoAmount, symbol: store.fiatSymbol, accuracy: store.eurCurrency.accuracy)}',
              toAssetIconUrl: store.currency.iconUrl,
              toAssetDescription: '${intl.earn_earn} ${store.offer.name}',
              toAssetValue: volumeFormat(decimal: store.selectedAmount, symbol: store.currency.symbol),
              toAssetBaseAmount:
                  '≈${volumeFormat(decimal: store.baseAmount, symbol: store.fiatSymbol, accuracy: store.eurCurrency.accuracy)}',
            ),
            const SDivider(),
            const SizedBox(height: 19),
            if (store.offer.apyRate != null)
              TwoColumnCell(
                label: intl.earn_apy_rate,
                value: '${store.offer.apyRate!.toStringAsFixed(2)} %',
                needHorizontalPadding: false,
              ),
            TwoColumnCell(
              label: intl.earn_earning_term,
              value: store.offer.withdrawType == WithdrawType.instant ? intl.earn_instant : intl.earn_flexible,
              needHorizontalPadding: false,
            ),
            const SizedBox(height: 7),
            ProcessingFeeRowWidget(
              fee: '0 ${store.currency.symbol}',
            ),
            const SizedBox(height: 16),
            const SDivider(),
            const SizedBox(height: 16),
            SPaddingH24(
              child: SPolicyCheckbox(
                onPrivacyPolicyTap: () {
                  //! Alex S. add modal
                  print('test');
                },
                onUserAgreementTap: () {},
                firstText: intl.earn_i_have_read_and_agreed_to,
                userAgreementText: '',
                betweenText: ' ',
                privacyPolicyText: intl.earn_terms_and_conditions,
                isChecked: store.isTermsAndConditionsChecked,
                onCheckboxTap: () {
                  store.toggleCheckbox();
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SPrimaryButton2(
                active: store.isTermsAndConditionsChecked,
                name: intl.previewBuyWithAsset_confirm,
                onTap: () {
                  store.confirm();
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
