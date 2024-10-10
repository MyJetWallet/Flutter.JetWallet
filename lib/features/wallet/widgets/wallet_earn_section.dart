import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/deposit_card.dart';
import 'package:jetwallet/features/earn/widgets/earn_active_position_badge.dart';
import 'package:jetwallet/features/earn/widgets/earn_offer_item.dart';
import 'package:jetwallet/features/earn/widgets/earn_offers_list.dart';
import 'package:jetwallet/features/earn/widgets/offers_overlay_content.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

class WalletEarnSection extends StatelessWidget {
  const WalletEarnSection({super.key, required this.currency});

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Provider<EarnStore>(
      create: (context) => EarnStore(),
      builder: (context, child) {
        return _WalletEarnSectionBody(currency: currency);
      },
    );
  }
}

class _WalletEarnSectionBody extends StatelessWidget {
  const _WalletEarnSectionBody({required this.currency});

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<EarnStore>(context);

    final offers = store.groupedOffers.entries.where((entry) => entry.key == currency.symbol);

    final positions = store.earnPositions.where((position) => position.assetId == currency.symbol);

    final isEarnAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
      (element) => element.id == AssetPaymentProductsEnum.earnProgram,
    );

    if (isEarnAvaible && (offers.isNotEmpty || positions.isNotEmpty)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          STableHeader(
            title: intl.earn_earn,
            size: SHeaderSize.m,
          ),
          if (positions.isNotEmpty)
            _PositionsForAssetWidget(
              positions: positions.toList(),
              store: store,
            )
          else if (offers.isNotEmpty)
            _OfferForAssetWidget(entry: offers.first)
          else
            const SizedBox(),
        ],
      );
    } else {
      return const Offstage();
    }
  }
}

class _OfferForAssetWidget extends StatelessWidget {
  const _OfferForAssetWidget({required this.entry});

  final MapEntry<String, List<EarnOfferClientModel>> entry;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<EarnStore>(context);
    final currencies = sSignalRModules.currenciesList;

    final currencySymbol = entry.key;
    final currencyOffers = entry.value;
    final currency = currencies.firstWhere(
      (currency) => currency.symbol == currencySymbol,
      orElse: () => CurrencyModel.empty(),
    );

    if (!currencyOffers.any(
      (element) => element.status == EarnOfferStatus.activeShow,
    )) {
      return const Offstage();
    }

    return Column(
      children: [
        EarnOfferItem(
          isSingleOffer: currencyOffers.length == 1,
          percentage: formatApyRate(
            currencyOffers.length == 1
                ? currencyOffers.first.apyRate
                : store.highestApyOffersPerCurrency[currency.description]?.apyRate,
          ),
          cryptoName: currency.description,
          trailingIcon: NetworkIconWidget(
            currency.iconUrl,
            width: 40,
            height: 40,
          ),
          onTap: () {
            sAnalytics.tapOnTheAnyOfferButton(
              assetName: currencyOffers.first.assetId,
              sourse: 'Wallet screen',
            );
            if (currencyOffers
                    .where(
                      (element) => element.status == EarnOfferStatus.activeShow,
                    )
                    .length >
                1) {
              VoidCallback? contentOnTap;

              showBasicBottomSheet(
                context: context,
                basicBottomSheetButton: BasicBottomSheetButton(
                  title: intl.earn_continue,
                  onTap: () {
                    contentOnTap?.call();
                  },
                ),
                children: [
                  OffersOverlayContent(
                    offers: currencyOffers,
                    currency: currency,
                    setParentOnTap: (onTap) {
                      contentOnTap = onTap;
                    },
                  ),
                ],
              );
            } else {
              context.router.push(
                EarnDepositScreenRouter(offer: currencyOffers.first),
              );
            }
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _PositionsForAssetWidget extends StatelessWidget {
  const _PositionsForAssetWidget({
    required this.positions,
    required this.store,
  });

  final List<EarnPositionClientModel> positions;
  final EarnStore store;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...positions.map(
          (e) => SDepositCard(
            earnPosition: e,
            onTap: () {
              sAnalytics.tapOnTheAnyActiveEarnButton(
                assetName: e.assetId,
                earnAPYrate: getHighestApyRateAsString(e.offers) ?? '',
                earnDepositAmount: e.baseAmount.toString(),
                earnOfferStatus: getTextForStatusAnalytics(e.status),
                earnPlanName: e.offers.first.description ?? '',
                earnWithdrawalType: e.withdrawType.name,
                revenue: e.incomeAmount.toString(),
              );

              final currency = getIt.get<FormatService>().findCurrency(
                    findInHideTerminalList: true,
                    assetSymbol: e.assetId,
                  );

              context.router.push(
                EarnPositionActiveRouter(
                  earnPosition: e,
                  offers: store.filteredOffersGroupedByCurrency[currency.description] ?? [],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
