import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/high_yield_buy/model/preview_high_yield_buy_input.dart';
import 'package:jetwallet/features/high_yield_buy/model/preview_high_yield_buy_union.dart';
import 'package:jetwallet/features/high_yield_buy/store/preview_high_yield_buy_store.dart';
import 'package:jetwallet/features/wallet/helper/format_date_to_hm.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

class PreviewHighYieldBuyScreen extends StatelessWidget {
  const PreviewHighYieldBuyScreen({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewHighYieldBuyInput input;

  @override
  Widget build(BuildContext context) {
    return Provider<PreviewHighYieldBuyStore>(
      create: (context) => PreviewHighYieldBuyStore(input),
      builder: (context, child) => _PreviewHighYieldBuyBody(
        input: input,
      ),
    );
  }
}

class _PreviewHighYieldBuyBody extends StatelessObserverWidget {
  const _PreviewHighYieldBuyBody({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewHighYieldBuyInput input;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;
    final state = PreviewHighYieldBuyStore.of(context);
    final loader = StackLoaderStore();
    final baseCurrency = sSignalRModules.baseCurrency;

    final from = input.fromCurrency;

    if (state.union is ExecuteLoading) {
      loader.startLoading();
    } else {
      if (loader.loading) {
        loader.finishLoading();
      }
    }

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      loading: loader,
      header: deviceSize.when(
        small: () {
          return SSmallHeader(
            title: '${intl.preview_earn_buy_confirm} '
                '${input.topUp ? intl.preview_earn_buy_top_up : input.earnOffer.title}',
          );
        },
        medium: () {
          return SMegaHeader(
            title:
                '${intl.preview_earn_buy_confirm} ${input.topUp ? intl.preview_earn_buy_top_up : input.earnOffer.title}',
            crossAxisAlignment: CrossAxisAlignment.center,
          );
        },
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceH8(),
                Center(
                  child: SActionConfirmIconWithAnimation(
                    iconUrl: input.fromCurrency.iconUrl,
                  ),
                ),
                const Spacer(),
                SActionConfirmText(
                  name:
                      '${input.topUp ? intl.preview_earn_buy_top_up : intl.preview_earn_buy_subscription} '
                      '${intl.preview_earn_buy_amount}',
                  baseline: deviceSize.when(
                    small: () => 29,
                    medium: () => 40,
                  ),
                  value: volumeFormat(
                    prefix: from.prefixSymbol,
                    accuracy: from.accuracy,
                    decimal: state.fromAssetAmount ?? Decimal.zero,
                    symbol: from.symbol,
                  ),
                ),
                if (input.earnOffer.endDate != null)
                  SActionConfirmText(
                    name: intl.preview_earn_buy_expiry_date,
                    baseline: 35.0,
                    value: formatDateToDMonthYFromDate(
                      input.earnOffer.endDate!,
                    ),
                  )
                else
                  SActionConfirmText(
                    name: intl.preview_earn_buy_term,
                    baseline: 35.0,
                    value: input.earnOffer.title,
                  ),
                deviceSize.when(
                  small: () => const SpaceH35(),
                  medium: () => const SpaceH34(),
                ),
                const SDivider(),
                SActionConfirmText(
                  name: intl.earn_buy_interest_per_day,
                  contentLoading: state.union is QuoteLoading,
                  baseline: deviceSize.when(
                    small: () => 37,
                    medium: () => 40,
                  ),
                  maxValueWidth: 170,
                  minValueWidth: 170,
                  value: volumeFormat(
                    prefix: input.fromCurrency.prefixSymbol,
                    decimal: state.expectedDailyProfit ?? Decimal.zero,
                    accuracy: input.fromCurrency.accuracy,
                    symbol: input.fromCurrency.symbol,
                  ),
                ),
                const SpaceH20(),
                Text(
                  intl.preview_earn_buy_return_warning,
                  textAlign: TextAlign.start,
                  style: sCaptionTextStyle.copyWith(color: colors.grey1),
                  maxLines: 4,
                ),
                deviceSize.when(
                  small: () => const SpaceH37(),
                  medium: () => const SpaceH36(),
                ),
                SPrimaryButton2(
                  active: state.union is QuoteSuccess,
                  name: intl.preview_earn_buy_confirm,
                  onTap: () {
                    state.earnOfferDeposit(input.earnOffer.offerId);
                  },
                ),
                const SpaceH24(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
