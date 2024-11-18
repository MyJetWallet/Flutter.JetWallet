import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/store/earn_details_store.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/active_earn_widget.dart';
import 'package:jetwallet/features/earn/widgets/earn_active_position_badge.dart';
import 'package:jetwallet/features/earn/widgets/offers_overlay_content.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

@RoutePage(name: 'EarnPositionActiveRouter')
class EarnPositionActiveScreen extends StatelessWidget {
  const EarnPositionActiveScreen({
    required this.earnPosition,
    required this.offers,
    super.key,
  });

  final EarnPositionClientModel earnPosition;
  final List<EarnOfferClientModel> offers;

  @override
  Widget build(BuildContext context) {
    sAnalytics.activeCryptoSavingsScreenView(
      earnOfferId: earnPosition.offerId,
      assetName: earnPosition.assetId,
      earnAPYrate: earnPosition.offers.firstOrNull?.apyRate?.toString() ?? Decimal.zero.toString(),
      earnDepositAmount: earnPosition.baseAmount.toString(),
      earnOfferStatus: getTextForStatusAnalytics(earnPosition.status),
      earnPlanName: earnPosition.offers.firstOrNull?.description ?? '',
      earnWithdrawalType: earnPosition.withdrawType.name,
      revenue: earnPosition.incomeAmount.toString(),
    );

    return Provider<EarnStore>(
      create: (context) => EarnStore(),
      builder: (context, child) {
        final currencies = sSignalRModules.currenciesList;
        final colors = SColorsLight();
        final currency = currencies.firstWhere(
          (currency) => currency.symbol == earnPosition.assetId,
          orElse: () => CurrencyModel.empty(),
        );

        final store = Provider.of<EarnStore>(context);

        return Provider(
          create: (context) => EarnsDetailsStore()..fetchPositionAudits(positionId: earnPosition.id),
          builder: (context, child) {
            return SPageFrame(
              loaderText: '',
              color: colors.white,
              header: GlobalBasicAppBar(
                onRightIconTap: () {
                  sRouter.push(
                    EarnsDetailsRouter(
                      positionId: earnPosition.id,
                      assetName: currency.description,
                    ),
                  );
                  sAnalytics.tapOnTheHistoryFromActiveCryptoSavingsButton(
                    assetName: earnPosition.assetId,
                    earnAPYrate: earnPosition.offers.firstOrNull?.apyRate?.toString() ?? Decimal.zero.toString(),
                    earnDepositAmount: earnPosition.baseAmount.toString(),
                    earnOfferStatus: getTextForStatusAnalytics(earnPosition.status),
                    earnPlanName: earnPosition.offers.firstOrNull?.description ?? '',
                    earnWithdrawalType: earnPosition.withdrawType.name,
                    revenue: earnPosition.incomeAmount.toString(),
                  );
                },
                onLeftIconTap: () {
                  Navigator.pop(context);
                },
                title: currency.description,
                rightIcon: Assets.svg.medium.history.simpleSvg(),
                subtitle: earnPosition.status == EarnPositionStatus.closed
                    ? earnPosition.offerName
                    : earnPosition.offers.firstOrNull?.name,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 24,
                              right: 24,
                            ),
                            child: ActiveEarnWidget(earnPosition: earnPosition),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 24,
                      left: 24,
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                    child: earnPosition.status == EarnPositionStatus.active
                        ? Column(
                            children: [
                              SButton.blue(
                                text: intl.earn_top_up,
                                callback: () {
                                  sAnalytics.tapOnTheTopUpFromActiveCryptoSavingsButton(
                                    earnOfferId: earnPosition.offerId,
                                    assetName: earnPosition.assetId,
                                    earnAPYrate:
                                        earnPosition.offers.firstOrNull?.apyRate?.toString() ?? Decimal.zero.toString(),
                                    earnDepositAmount: earnPosition.baseAmount.toString(),
                                    earnOfferStatus: getTextForStatusAnalytics(
                                      earnPosition.status,
                                    ),
                                    earnPlanName: earnPosition.offers.firstOrNull?.description ?? '',
                                    earnWithdrawalType: earnPosition.withdrawType.name,
                                    revenue: earnPosition.incomeAmount.toString(),
                                  );

                                  final offer = offers.where((off) => off.id == earnPosition.offerId);
                                  if (offer.isEmpty || offer.first.status == EarnOfferStatus.activeHide) {
                                    showStartNewEarnDialog(context);
                                  } else {
                                    sRouter.push(
                                      EarnTopUpAmountRouter(
                                        earnPosition: earnPosition,
                                      ),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              SButton.text(
                                text: intl.earn_withdraw,
                                callback: () {
                                  sAnalytics.tapOnTheWithdrawFromActiveCryptoSavingsButton(
                                    earnOfferId: earnPosition.offerId,
                                    assetName: earnPosition.assetId,
                                    earnAPYrate:
                                        earnPosition.offers.firstOrNull?.apyRate?.toString() ?? Decimal.zero.toString(),
                                    earnDepositAmount: earnPosition.baseAmount.toString(),
                                    earnOfferStatus: getTextForStatusAnalytics(
                                      earnPosition.status,
                                    ),
                                    earnPlanName: earnPosition.offers.firstOrNull?.description ?? '',
                                    earnWithdrawalType: earnPosition.withdrawType.name,
                                    revenue: earnPosition.incomeAmount.toString(),
                                  );
                                  store.startEartWithdrawFlow(
                                    earnPosition: earnPosition,
                                  );
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showStartNewEarnDialog(BuildContext context) => sShowAlertPopup(
        sRouter.navigatorKey.currentContext!,
        image: Assets.svg.brand.small.infoYellow.simpleSvg(),
        primaryText: '',
        secondaryText: intl.earn_offering_no_longer_accepts_deposits,
        primaryButtonName: intl.earn_start_new_earn,
        onPrimaryButtonTap: () async {
          await sRouter.maybePop();

          final assetOffers = offers
              .where(
                (element) => element.status == EarnOfferStatus.activeShow && element.assetId == earnPosition.assetId,
              )
              .toList();
          assetOffers.sort((a, b) => b.apyRate!.compareTo(a.apyRate!));
          if (assetOffers.isNotEmpty) {
            final currency = getIt.get<FormatService>().findCurrency(
                  findInHideTerminalList: true,
                  assetSymbol: earnPosition.assetId,
                );

            VoidCallback? contentOnTap;

            await showBasicBottomSheet(
              context: sRouter.navigatorKey.currentContext!,
              button: BasicBottomSheetButton(
                title: intl.earn_continue,
                onTap: () {
                  contentOnTap?.call();
                },
              ),
              children: [
                OffersOverlayContent(
                  offers: assetOffers,
                  currency: currency,
                  setParentOnTap: (onTap) {
                    contentOnTap = onTap;
                  },
                ),
              ],
            );
          } else {
            await sRouter.popAndPush(const OffersRouter());
          }
        },
        secondaryButtonName: intl.earn_cancel,
        onSecondaryButtonTap: () {
          sRouter.maybePop();
        },
      );
}
