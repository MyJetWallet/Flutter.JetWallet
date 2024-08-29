import 'package:auto_route/auto_route.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/prepaid_card/store/buy_vouncher_confirmation_store.dart';
import 'package:jetwallet/features/prepaid_card/store/my_vounchers_store.dart';
import 'package:jetwallet/features/prepaid_card/utils/show_repaid_card_reditect_dialog.dart';
import 'package:jetwallet/features/transaction_history/widgets/loading_sliver_list.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/currency_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:rive/rive.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/buy_prepaid_card_intention_dto_list_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/get_purchase_card_list_request_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/services/prevent_duplication_events_servise.dart';

@RoutePage(name: 'PrepaidCardServiceRouter')
class PrepaidCardServiceScreen extends StatelessWidget {
  const PrepaidCardServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('prepaid-card-screen-key'),
      onVisibilityChanged: (info) {
        getIt.get<PreventDuplicationEventsService>().sendEvent(
              id: 'prepaid-card-screen-key',
              event: sAnalytics.prepaidCardServiceScreenView,
            );
      },
      child: Provider(
        create: (context) => MyVounchersStore(),
        dispose: (context, srore) {
          srore.dispose();
        },
        child: const _PrepaidCardServiceScreenBody(),
      ),
    );
  }
}

class _PrepaidCardServiceScreenBody extends StatefulWidget {
  const _PrepaidCardServiceScreenBody();

  @override
  State<_PrepaidCardServiceScreenBody> createState() => _PrepaidCardServiceScreenBodyState();
}

class _PrepaidCardServiceScreenBodyState extends State<_PrepaidCardServiceScreenBody> {
  final scrollController = ScrollController();

  Future<void> Function()? loadMore;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        loadMore?.call();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = MyVounchersStore.of(context);
    loadMore = store.loadMoreClosedPositions;

    final colors = SColorsLight();
    return SPageFrame(
      loaderText: '',
      header: SPaddingH24(
        child: SSmallHeader(
          title: '',
          onBackButtonTap: () {
            sAnalytics.tapOnTheBackButtonFromPrepaidCardServiceScreen();
            sRouter.maybePop();
          },
        ),
      ),
      child: Stack(
        children: [
          CustomRefreshIndicator(
            notificationPredicate: (_) => true,
            offsetToArmed: 75,
            onRefresh: store.getListMyVouchers,
            builder: (
              BuildContext context,
              Widget child,
              IndicatorController controller,
            ) {
              return Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Opacity(
                    opacity: !controller.isIdle ? 1 : 0,
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, Widget? _) {
                        return SizedBox(
                          height: controller.value * 75,
                          child: Container(
                            width: 24.0,
                            decoration: BoxDecoration(
                              color: colors.gray2,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const RiveAnimation.asset(
                              loadingAnimationAsset,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  AnimatedBuilder(
                    builder: (context, _) {
                      return Transform.translate(
                        offset: Offset(
                          0.0,
                          !controller.isIdle ? (controller.value * 75) : 0,
                        ),
                        child: child,
                      );
                    },
                    animation: controller,
                  ),
                ],
              );
            },
            child: Observer(
              builder: (context) {
                return CustomScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _TopPartOfPage(
                        isShortDescription: store.isShortDescription,
                        onTap: store.setShortDescription,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SpaceH16(),
                    ),
                    SliverToBoxAdapter(
                      child: STableHeader(
                        size: SHeaderSize.m,
                        title: intl.prepaid_card_my_vouchers,
                      ),
                    ),
                    if (store.isLoading)
                      const LoadingSliverList()
                    else if (store.listMyVouchers.isEmpty)
                      SliverToBoxAdapter(
                        child: SPlaceholder(
                          size: SPlaceholderSize.l,
                          text: intl.prepaid_card_my_vouchers_placeholder,
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return _VouncherItem(store.listMyVouchers[index]);
                          },
                          childCount: store.listMyVouchers.length,
                        ),
                      ),
                    if (store.isLoadingPagination)
                      SliverToBoxAdapter(
                        child: Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                            color: colors.gray2,
                            shape: BoxShape.circle,
                          ),
                          child: const RiveAnimation.asset(
                            loadingAnimationAsset,
                          ),
                        ),
                      ),
                    const SliverToBoxAdapter(
                      child: SafeArea(
                        child: SpaceH120(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: SButton.blue(
                text: intl.prepaid_card_buy_card,
                callback: () {
                  sAnalytics.tapOnTheBuyCardButton();
                  sRouter.push(const PrepaidCardPreBuyTabsRouter()).then((value) {
                    if (voucherHasJustBeenPurchased) {
                      store.getListMyVouchers();
                      voucherHasJustBeenPurchased = false;
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPartOfPage extends StatelessWidget {
  const _TopPartOfPage({required this.isShortDescription, required this.onTap});

  final bool isShortDescription;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return SPaddingH24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  intl.prepaid_card_prepaid_card_service,
                  style: STStyles.header5,
                  maxLines: 3,
                ),
                const SpaceH16(),
                ReadMoreText(
                  intl.prepaid_card_explanation,
                  isCollapsed: ValueNotifier<bool>(isShortDescription),
                  trimMode: TrimMode.Line,
                  colorClickableText: Colors.blue,
                  trimCollapsedText: ' ${intl.prepaid_card_more}',
                  trimExpandedText: ' ${intl.prepaid_card_less}',
                  style: STStyles.body1Medium.copyWith(
                    color: colors.gray10,
                  ),
                  moreStyle: STStyles.body1Medium.copyWith(
                    color: colors.blue,
                  ),
                  lessStyle: STStyles.body1Medium.copyWith(
                    color: colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SpaceH16(),
          SHyperlink(
            text: intl.prepaid_card_card_management,
            onTap: () {
              sAnalytics.tapOnTheCardManagementButtonOnPrepaidCardServiceScreen();
              showPrepaidCardRedirectDialog(context: context);
            },
          ),
        ],
      ),
    );
  }
}

class _VouncherItem extends StatelessWidget {
  const _VouncherItem(this.voucher);

  final PrapaidCardVoucherModel voucher;

  @override
  Widget build(BuildContext context) {
    final currency = getIt.get<FormatService>().findCurrency(
          assetSymbol: voucher.cardAsset,
          findInHideTerminalList: true,
        );
    return TransactionBaseItem(
      onTap: () {
        sAnalytics.tapOnTheAnyoucherButton(
          voucher: voucher.voucherCode ?? '',
        );
        sRouter.push(PrepaidCardDetailsRouter(voucher: voucher));
      },
      icon: NetworkIconWidget(
        currency.iconUrl,
      ),
      labele: voucher.status == BuyPrepaidCardIntentionStatus.purchasing
          ? intl.prepaid_card_in_progress
          : voucher.voucherCode ?? '',
      balanceChange: getIt<AppStore>().isBalanceHide
          ? '**** ${currency.symbol}'
          : voucher.cardAmount.toFormatSum(
              accuracy: currency.accuracy,
              symbol: currency.symbol,
            ),
      status: voucher.status == BuyPrepaidCardIntentionStatus.purchasing
          ? Status.inProgress
          : voucher.status == BuyPrepaidCardIntentionStatus.failed
              ? Status.declined
              : Status.completed,
      timeStamp: '',
      supplement: voucher.productName,
    );
  }
}
