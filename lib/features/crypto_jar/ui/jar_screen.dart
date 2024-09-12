import 'package:auto_route/auto_route.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/crypto_jar/helpers/jar_extension.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transactions_list.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:jetwallet/widgets/loaders/loader.dart';
import 'package:rive/rive.dart' as rive;
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart' as sk;
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

@RoutePage(name: 'JarRouter')
class JarScreen extends StatefulWidget {
  const JarScreen({
    required this.hasLeftIcon,
    super.key,
  });

  final bool hasLeftIcon;

  @override
  State<JarScreen> createState() => _JarScreenState();
}

class _JarScreenState extends State<JarScreen> {
  bool showViewAllButtonOnHistory = false;

  @override
  void initState() {
    super.initState();

    final store = getIt.get<JarsStore>();
    final selectedJar = store.selectedJar!;

    store.refreshJarsStore();

    sAnalytics.jarScreenViewJar(
      jarName: selectedJar.title,
      asset: 'USDT',
      network: 'TRC20',
      target: selectedJar.target.toInt(),
      balance: selectedJar.balanceInJarAsset,
      isOpen: selectedJar.status == JarStatus.active,
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = getIt.get<JarsStore>();

    final colors = sk.sKit.colors;

    final kycState = getIt.get<KycService>();

    final accuracy = getIt
        .get<FormatService>()
        .findCurrency(
          assetSymbol: store.selectedJar!.assetSymbol,
        )
        .accuracy;

    return PopScope(
      canPop: widget.hasLeftIcon,
      child: sk.SPageFrame(
        loaderText: '',
        color: colors.white,
        header: GlobalBasicAppBar(
          title: '',
          hasLeftIcon: widget.hasLeftIcon,
          hasRightIcon: !widget.hasLeftIcon,
          rightIcon: Assets.svg.medium.close.simpleSvg(),
          onRightIconTap: () {
            getIt.get<JarsStore>().refreshJarsStore();
            getIt<AppRouter>().popUntil((route) {
              return route.settings.name == HomeRouter.name;
            });
          },
        ),
        child: Observer(
          builder: (context) {
            final selectedJar = store.selectedJar!;

            return CustomRefreshIndicator(
              notificationPredicate: (_) => true,
              offsetToArmed: 10,
              onRefresh: () async {
                await getIt.get<JarsStore>().refreshJarsStore();
              },
              builder: (BuildContext context, Widget child, IndicatorController controller) {
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
                                color: colors.grey5,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const rive.RiveAnimation.asset(
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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Align(
                      child: selectedJar.getIcon(height: 200.0, width: 200.0),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 24,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: sk.SPaddingH24(
                      child: Text(
                        intl.jar_crypto_jar,
                        style: STStyles.body2Semibold.copyWith(
                          color: SColorsLight().gray10,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: sk.SPaddingH24(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedJar.title,
                              style: STStyles.header5.copyWith(
                                color: SColorsLight().black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            getIt<AppStore>().isBalanceHide
                                ? '**** ${sSignalRModules.baseCurrency.symbol}'
                                : Decimal.parse(selectedJar.balance.toString()).toFormatCount(
                                    accuracy: sSignalRModules.baseCurrency.accuracy,
                                    symbol: sSignalRModules.baseCurrency.symbol,
                                  ),
                            style: STStyles.header5.copyWith(
                              color: SColorsLight().black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: sk.SPaddingH24(
                      child: Text(
                        getIt<AppStore>().isBalanceHide
                            ? '******* ${selectedJar.assetSymbol}'
                            : '${Decimal.parse(selectedJar.balanceInJarAsset.toString()).toFormatCount(
                                accuracy: accuracy,
                                symbol: selectedJar.assetSymbol,
                              )} / ${Decimal.parse(selectedJar.target.toString()).toFormatCount(
                                accuracy: 0,
                                symbol: selectedJar.assetSymbol,
                              )}',
                        style: STStyles.body1Medium.copyWith(
                          color: SColorsLight().gray10,
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 36.0,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: sk.SPaddingH24(
                      child: _buildButtons(
                        kycState,
                        selectedJar,
                        colors,
                        accuracy,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 44.0,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SBasicHeader(
                      title: intl.jar_transactions,
                      buttonTitle: intl.wallet_history_view_all,
                      showLinkButton: showViewAllButtonOnHistory,
                      onTap: () {
                        sAnalytics.jarTapOnButtonViewAllTrxOnJarScreen();

                        sRouter.push(
                          JarTransactionHistoryRouter(
                            jarId: selectedJar.id,
                            jarTitle: selectedJar.title,
                          ),
                        );
                      },
                    ),
                  ),
                  TransactionsList(
                    scrollController: ScrollController(),
                    jarId: selectedJar.id,
                    onItemTapLisener: (symbol) {},
                    source: TransactionItemSource.history,
                    mode: TransactionListMode.preview,
                    onData: (items) {
                      if (items.length >= 5) {
                        if (mounted) {
                          setState(() {
                            showViewAllButtonOnHistory = true;
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtons(KycService kycState, JarResponseModel selectedJar, SimpleColors colors, int accuracy) {
    if (selectedJar.status != JarStatus.closed && selectedJar.status != JarStatus.creating) {
      return Row(
        children: [
          const Spacer(),
          _buildButton(
            intl.jar_share,
            Assets.svg.medium.share.simpleSvg(color: SColorsLight().white),
            SColorsLight().blueDark,
            () {
              if (kycState.depositStatus == kycOperationStatus(KycStatus.blocked)) {
                sk.showNotification(context, intl.operation_bloked_text);
              } else {
                showSendTimerAlertOr(
                  context: context,
                  from: [BlockingType.deposit],
                  or: () {
                    sAnalytics.jarTapOnButtonShareOnJar();

                    getIt<AppRouter>().push(
                      const JarShareRouter(),
                    );
                  },
                );
              }
            },
          ),
          const SizedBox(
            width: 8.0,
          ),
          _buildButton(
            intl.jar_withdraw,
            Assets.svg.medium.withdrawal.simpleSvg(color: SColorsLight().white),
            SColorsLight().black,
            () {
              if (selectedJar.balance > 0) {
                if (kycState.withdrawalStatus == kycOperationStatus(KycStatus.blocked)) {
                  sk.showNotification(context, intl.operation_bloked_text);
                } else {
                  showSendTimerAlertOr(
                    context: context,
                    from: [BlockingType.withdrawal],
                    or: () {
                      sAnalytics.jarTapOnButtonWithdrawOnJar(
                        asset: selectedJar.assetSymbol,
                        network: 'TRC20',
                        target: selectedJar.target.toInt(),
                        balance: selectedJar.balanceInJarAsset,
                        isOpen: selectedJar.status == JarStatus.active,
                      );

                      sRouter.push(
                        WithdrawRouter(
                          withdrawal: WithdrawalModel(
                            currency: currencyFrom(
                              sSignalRModules.currenciesList,
                              selectedJar.assetSymbol,
                            ),
                            jar: selectedJar,
                          ),
                        ),
                      );
                    },
                  );
                }
              }
            },
            selectedJar.balance > 0,
          ),
          const SizedBox(
            width: 8.0,
          ),
          _buildButton(
            intl.jar_close,
            Assets.svg.medium.close.simpleSvg(color: SColorsLight().white),
            SColorsLight().black,
            () {
              if (kycState.withdrawalStatus == kycOperationStatus(KycStatus.blocked)) {
                sk.showNotification(context, intl.operation_bloked_text);

                return;
              } else {
                showSendTimerAlertOr(
                  context: context,
                  from: [BlockingType.withdrawal],
                  or: () {
                    sAnalytics.jarTapOnButtonCloseOnJar(
                      asset: selectedJar.assetSymbol,
                      network: 'TRC20',
                      target: selectedJar.target.toInt(),
                      balance: selectedJar.balanceInJarAsset,
                      isOpen: selectedJar.status == JarStatus.active,
                    );

                    if (selectedJar.balance != 0) {
                      sShowAlertPopup(
                        sRouter.navigatorKey.currentContext!,
                        image: Assets.svg.brand.small.infoYellow.simpleSvg(),
                        primaryText: '',
                        secondaryText: intl.jar_close_withdrawal_hint(
                          getIt<AppStore>().isBalanceHide
                              ? '**** ${sSignalRModules.baseCurrency.symbol}'
                              : Decimal.parse(selectedJar.balanceInJarAsset.toString()).toFormatCount(
                                  accuracy: accuracy,
                                  symbol: selectedJar.assetSymbol,
                                ),
                          selectedJar.assetSymbol,
                          (getIt.get<JarsStore>().limit ?? 5000).toInt(),
                        ),
                        primaryButtonName: intl.jar_confirm,
                        onPrimaryButtonTap: () {
                          sAnalytics.jarTapOnButtonConfirmCloseOnJarClosePopUp(
                            asset: selectedJar.assetSymbol,
                            network: 'TRC20',
                            target: selectedJar.target.toInt(),
                            balance: selectedJar.balanceInJarAsset,
                            isOpen: selectedJar.status == JarStatus.active,
                          );

                          Navigator.pop(context);
                          sRouter.push(
                            WithdrawRouter(
                              withdrawal: WithdrawalModel(
                                currency: currencyFrom(
                                  sSignalRModules.currenciesList,
                                  selectedJar.assetSymbol,
                                ),
                                jar: selectedJar,
                              ),
                            ),
                          );
                        },
                        secondaryButtonName: intl.jar_cancel,
                        onSecondaryButtonTap: () {
                          sAnalytics.jarTapOnButtonCancelCloseOnJarClosePopUp(
                            asset: selectedJar.assetSymbol,
                            network: 'TRC20',
                            target: selectedJar.target.toInt(),
                            balance: selectedJar.balanceInJarAsset,
                            isOpen: selectedJar.status == JarStatus.active,
                          );

                          Navigator.pop(context);
                        },
                      );
                    } else {
                      sShowAlertPopup(
                        sRouter.navigatorKey.currentContext!,
                        image: Assets.svg.brand.small.infoBlue.simpleSvg(),
                        primaryText: '',
                        secondaryText: intl.jar_action_close_jar('"${selectedJar.title}"'),
                        primaryButtonName: intl.jar_confirm,
                        onPrimaryButtonTap: () {
                          sAnalytics.jarTapOnButtonConfirmCloseOnJarClosePopUp(
                            asset: selectedJar.assetSymbol,
                            network: 'TRC20',
                            target: selectedJar.target.toInt(),
                            balance: selectedJar.balanceInJarAsset,
                            isOpen: selectedJar.status == JarStatus.active,
                          );

                          getIt.get<JarsStore>().closeJar(selectedJar.id);
                          getIt<AppRouter>().push(
                            JarClosedConfirmationRouter(
                              name: selectedJar.title,
                            ),
                          );
                        },
                        secondaryButtonName: intl.jar_cancel,
                        onSecondaryButtonTap: () {
                          sAnalytics.jarTapOnButtonCancelCloseOnJarClosePopUp(
                            asset: selectedJar.assetSymbol,
                            network: 'TRC20',
                            target: selectedJar.target.toInt(),
                            balance: selectedJar.balanceInJarAsset,
                            isOpen: selectedJar.status == JarStatus.active,
                          );
                          Navigator.pop(context);
                        },
                      );
                    }
                  },
                );
              }
            },
          ),
          const SizedBox(
            width: 8.0,
          ),
          _buildButton(
            intl.jar_more,
            Assets.svg.medium.more.simpleSvg(color: SColorsLight().white),
            SColorsLight().black,
            () {
              sAnalytics.jarTapOnButtonMoreOnJar();

              sShowBasicModalBottomSheet(
                context: context,
                color: colors.white,
                pinned: ActionBottomSheetHeader(
                  name: intl.jar_actions,
                ),
                horizontalPinnedPadding: 0.0,
                removePinnedPadding: true,
                children: [
                  SafeGesture(
                    onTap: () {
                      sAnalytics.jarTapOnButtonChangeJarNameOnJarAction();

                      Navigator.pop(context);
                      getIt<AppRouter>().push(
                        EnterJarNameRouter(
                          isCreatingNewJar: false,
                          jar: selectedJar,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        children: [
                          Assets.svg.medium.jar.simpleSvg(
                            color: SColorsLight().blue,
                          ),
                          const SizedBox(width: 15.0),
                          Text(
                            intl.jar_change_jar_name,
                            style: STStyles.subtitle1.copyWith(
                              color: SColorsLight().black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeGesture(
                    onTap: () {
                      sAnalytics.jarTapOnButtonChangeGoalOnJarAction();

                      Navigator.pop(context);
                      getIt<AppRouter>().push(
                        EnterJarGoalRouter(
                          name: selectedJar.title,
                          description: selectedJar.description ?? '',
                          isCreatingNewJar: false,
                          jar: selectedJar,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        children: [
                          Assets.svg.medium.goal.simpleSvg(
                            color: SColorsLight().blue,
                          ),
                          const SizedBox(width: 15.0),
                          Text(
                            intl.jar_change_jar_goal,
                            style: STStyles.subtitle1.copyWith(
                              color: SColorsLight().black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeGesture(
                    onTap: () {
                      sAnalytics.jarTapOnButtonChangeDescriptionOnJarAction();

                      Navigator.pop(context);
                      getIt<AppRouter>().push(
                        EnterJarDescriptionRouter(
                          name: selectedJar.title,
                          isCreatingNewJar: false,
                          jar: selectedJar,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        children: [
                          Assets.svg.medium.edit.simpleSvg(
                            color: SColorsLight().blue,
                          ),
                          const SizedBox(width: 15.0),
                          Text(
                            intl.jar_change_jar_description,
                            style: STStyles.subtitle1.copyWith(
                              color: SColorsLight().black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 58.0),
                ],
              );
            },
          ),
          const Spacer(),
        ],
      );
    } else {
      if (selectedJar.status == JarStatus.closed) {
        return Container(
          height: 36.0,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 6.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: SColorsLight().gray2,
          ),
          child: Row(
            children: [
              Assets.svg.medium.closeAlt.simpleSvg(
                height: 20.0,
                width: 20.0,
                color: SColorsLight().gray8,
              ),
              const Spacer(),
              Text(
                intl.jar_closed,
                style: STStyles.body1Bold.copyWith(
                  color: SColorsLight().gray8,
                ),
              ),
              const Spacer(),
              const SizedBox(
                width: 20.0,
              ),
            ],
          ),
        );
      } else {
        return Container(
          height: 36.0,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 6.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: SColorsLight().gray2,
          ),
          child: Row(
            children: [
              SizedBox(
                height: 17.0,
                width: 17.0,
                child: Loader(
                  color: SColorsLight().black,
                  strokeWidth: 3.0,
                ),
              ),
              const Spacer(),
              Text(
                intl.jar_creating,
                style: STStyles.body1Bold.copyWith(
                  color: SColorsLight().black,
                ),
              ),
              const Spacer(),
              const SizedBox(
                width: 17.0,
              ),
            ],
          ),
        );
      }
    }
  }

  Widget _buildButton(String text, Widget icon, Color color, Function() onTap, [bool active = true]) {
    return SafeGesture(
      onTap: onTap,
      child: Opacity(
        opacity: active ? 1 : 0.2,
        child: SizedBox(
          height: 76.0,
          width: 76.0,
          child: Column(
            children: [
              Container(
                height: 48.0,
                width: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                child: Center(
                  child: icon,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                text,
                style: STStyles.captionSemibold.copyWith(
                  color: SColorsLight().black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
