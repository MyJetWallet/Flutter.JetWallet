import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/earn/widgets/earn_offer_item.dart';
import 'package:jetwallet/features/earn/widgets/earn_offers_list.dart';
import 'package:jetwallet/features/earn/widgets/offers_overlay_content.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

class EarnDashboardSectionWidget extends StatelessWidget {
  const EarnDashboardSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<EarnStore>(
      create: (context) => EarnStore(),
      builder: (context, child) {
        return const _EarnSectionBody();
      },
    );
  }
}

class _EarnSectionBody extends StatelessWidget {
  const _EarnSectionBody();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<EarnStore>(context);

    return Observer(
      builder: (context) {
        return Column(
          children: [
            SBasicHeader(
              title: intl.earn_earn,
              buttonTitle: intl.earn_section_view,
              onTap: () {
                getIt.get<EventBus>().fire(EndReordering());
                getIt<BottomBarStore>().setHomeTab(BottomItemType.earn);
              },
            ),
            if (store.positionsTotalValueInVaseCurrency > Decimal.zero)
              const _EarnSectionDefaultState()
            else
              const _EarnSectionEmptyState(),
            const Padding(
              padding: EdgeInsets.only(
                top: 32,
                left: 24,
                right: 24,
                bottom: 8,
              ),
              child: SDivider(),
            ),
          ],
        );
      },
    );
  }
}

class _EarnSectionEmptyState extends StatelessWidget {
  const _EarnSectionEmptyState();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<EarnStore>(context);
    final currencies = sSignalRModules.currenciesList;

    return Observer(
      builder: (context) {
        return Column(
          children: [
            ...store.filteredOffersGroupedByCurrency.entries.map((entry) {
              final currencyDescription = entry.key;
              final currencyOffers = entry.value;
              final currency = currencies.firstWhere(
                (currency) => currency.description == currencyDescription,
                orElse: () => CurrencyModel.empty(),
              );

              if (!currencyOffers.any(
                (element) => element.status == EarnOfferStatus.activeShow,
              )) {
                return const Offstage();
              }

              return EarnOfferItem(
                isSingleOffer: currencyOffers.length == 1,
                percentage: formatApyRate(
                  store.highestApyOffersPerCurrency[currencyDescription]?.apyRate,
                ),
                cryptoName: currency.description,
                trailingIcon: NetworkIconWidget(
                  currency.iconUrl,
                  width: 40,
                  height: 40,
                ),
                onTap: () {
                  getIt.get<EventBus>().fire(EndReordering());
                  sAnalytics.tapOnTheAnyOfferButton(
                    assetName: currencyOffers.first.assetId,
                    sourse: 'Home screen',
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
                      button: BasicBottomSheetButton(
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
              );
            }),
          ],
        );
      },
    );
  }
}

class _EarnSectionDefaultState extends StatelessWidget {
  const _EarnSectionDefaultState();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<EarnStore>(context);

    return Observer(
      builder: (context) {
        return SPaddingH24(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _GrayBlocWidget(
                      title: intl.earn_earn,
                      value: store.isBalanceHide
                          ? store.positionsTotalValueInVaseCurrency.toFormatSum(
                              symbol: sSignalRModules.baseCurrency.symbol,
                              accuracy: sSignalRModules.baseCurrency.accuracy,
                            )
                          : '**** ${sSignalRModules.baseCurrency.symbol}',
                      description: intl.earn_section_total,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _GrayBlocWidget(
                      title: intl.earn_revenue,
                      value: store.isBalanceHide
                          ? store.positionsTotalRevenueInVaseCurrency.toFormatSum(
                              symbol: sSignalRModules.baseCurrency.symbol,
                              accuracy: sSignalRModules.baseCurrency.accuracy,
                            )
                          : '**** ${sSignalRModules.baseCurrency.symbol}',
                      description: intl.earn_section_all_time,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _ActiveEarnsParagraph(),
            ],
          ),
        );
      },
    );
  }
}

class _GrayBlocWidget extends StatelessWidget {
  const _GrayBlocWidget({
    required this.title,
    required this.value,
    required this.description,
  });

  final String title;
  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: colors.gray2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: STStyles.subtitle2,
          ),
          AutoSizeText(
            value,
            style: STStyles.subtitle1,
            maxLines: 1,
          ),
          Text(
            description,
            style: STStyles.body2Medium.copyWith(
              color: colors.gray10,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveEarnsParagraph extends StatelessWidget {
  const _ActiveEarnsParagraph();

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final store = Provider.of<EarnStore>(context);
    final currencies = sSignalRModules.currenciesList;

    return Observer(
      builder: (context) {
        final formatService = getIt.get<FormatService>();

        final iconUrls = <String>{};

        final positions = store.earnPositions;

        final sumbolsWithAmount = <({String symbol, Decimal amount})>[];

        for (final position in positions) {
          final positionAmount = formatService.convertOneCurrencyToAnotherOne(
            fromCurrency: position.assetId,
            fromCurrencyAmmount: position.baseAmount,
            toCurrency: sSignalRModules.baseCurrency.symbol,
            baseCurrency: sSignalRModules.baseCurrency.symbol,
            isMin: true,
          );
          if (sumbolsWithAmount.any((element) => element.symbol == position.assetId)) {
            final record = sumbolsWithAmount.firstWhere(
              (element) => element.symbol == position.assetId,
            );
            sumbolsWithAmount.removeWhere((element) => element.symbol == position.assetId);
            final recordWithNewSum = (
              symbol: record.symbol,
              amount: record.amount + positionAmount,
            );
            sumbolsWithAmount.add(recordWithNewSum);
          } else {
            sumbolsWithAmount.add((symbol: position.assetId, amount: positionAmount));
          }
        }

        sumbolsWithAmount.sort((a, b) => b.amount.compareTo(a.amount));

        final topMovers = sumbolsWithAmount.sublist(0, min(3, sumbolsWithAmount.length));

        for (final record in topMovers) {
          final currency = currencies.firstWhere((c) => c.symbol == record.symbol);
          iconUrls.add(currency.iconUrl);
        }
        return Row(
          children: [
            ...List.generate(
              iconUrls.length,
              (index) {
                return Row(
                  children: [
                    NetworkIconWidget(
                      iconUrls.elementAt(index),
                    ),
                    const SizedBox(width: 8),
                  ],
                );
              },
            ),
            Text(
              '${intl.earn_active_earns}: ${store.earnPositions.length}',
              style: STStyles.body2Semibold.copyWith(
                color: colors.gray10,
              ),
            ),
          ],
        );
      },
    );
  }
}
