import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/anchors/anchors_helper.dart';
import 'package:jetwallet/core/services/anchors/models/crypto_deposit/crypto_deposit_model.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/crypto_deposit/store/crypto_deposit_disclaimer_store.dart';
import 'package:jetwallet/features/crypto_deposit/store/crypto_deposit_store.dart';
import 'package:jetwallet/features/crypto_deposit/utils/show_deposite_network_bottom_sheet.dart';
import 'package:jetwallet/features/crypto_deposit/widgets/crypto_deposit_with_address.dart';
import 'package:jetwallet/features/crypto_deposit/widgets/crypto_deposit_with_address_and_tag.dart';
import 'package:jetwallet/features/crypto_deposit/widgets/deposit_info.dart';
import 'package:jetwallet/features/crypto_deposit/widgets/deposit_info_tag.dart';
import 'package:jetwallet/features/crypto_deposit/widgets/show_deposit_disclaimer.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

@RoutePage(name: 'CryptoDepositRouter')
class CryptoDeposit extends StatelessWidget {
  const CryptoDeposit({
    required this.cryptoDepositModel,
    super.key,
  });

  final CryptoDepositModel cryptoDepositModel;

  @override
  Widget build(BuildContext context) {
    return Provider<CryptoDepositStore>(
      create: (context) => CryptoDepositStore(
        assetSymbol: cryptoDepositModel.assetSymbol,
      ),
      builder: (context, child) => const _CryptoDepositBody(),
      dispose: (context, state) => state.dispose(),
    );
  }
}

class _CryptoDepositBody extends StatefulObserverWidget {
  const _CryptoDepositBody();

  @override
  State<_CryptoDepositBody> createState() => __CryptoDepositBodyState();
}

class __CryptoDepositBodyState extends State<_CryptoDepositBody> {
  bool canTapShare = true;
  late ScrollController controller;
  late PageController pageController;

  final colors = sKit.colors;

  final kycState = getIt.get<KycService>();
  final kycAlertHandler = getIt.get<KycAlertHandler>();

  late bool showAlert;

  @override
  void initState() {
    controller = ScrollController();
    pageController = PageController(viewportFraction: 0.9);

    showAlert = kycState.isSimpleKyc;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDisclaimerData();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget slidesControllers() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SmoothPageIndicator(
          controller: pageController,
          count: 2,
          effect: ScrollingDotsEffect(
            spacing: 2,
            radius: 4,
            dotWidth: 24,
            dotHeight: 2,
            maxVisibleDots: 11,
            activeDotScale: 1,
            dotColor: colors.black.withOpacity(0.3),
            activeDotColor: colors.black,
          ),
        ),
      ),
    );
  }

  Widget? alertWidget() {
    if (showAlert) {
      return GestureDetector(
        onTap: () {
          sShowAlertPopup(
            context,
            primaryText: intl.actionBuy_alertPopupSecond,
            primaryButtonName: intl.actionBuy_goToKYC,
            onPrimaryButtonTap: () {
              kycAlertHandler.handle(
                status: kycState.withdrawalStatus,
                isProgress: kycState.verificationInProgress,
                currentNavigate: () {},
                size: widgetSizeFrom(sDeviceSize),
                kycFlowOnly: true,
                requiredDocuments: kycState.requiredDocuments,
                requiredVerifications: kycState.requiredVerifications,
              );
            },
            secondaryButtonName: intl.actionBuy_gotIt,
            onSecondaryButtonTap: () {
              Navigator.pop(context);
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SErrorIcon(
              color: colors.green,
            ),
            const SpaceW10(),
            Text(
              intl.actionBuy_kycRequired,
              style: STStyles.captionMedium.copyWith(
                color: colors.grey2,
              ),
            ),
          ],
        ),
      );
    }

    return null;
  }

  Future<void> getDisclaimerData() async {
    final deposit = CryptoDepositStore.of(context);
    final value = await getcryptoDepositDisclaimer(deposit.currency.symbol);

    if (!mounted) return;

    if (value == CryptoDepositDisclaimer.notAccepted) {
      showDepositDisclaimer(
        slidesControllers: slidesControllers(),
        context: context,
        controller: pageController,
        assetSymbol: deposit.currency.symbol,
        screenTitle: intl.balanceActionButtons_receive,
        kycAlertHandler: kycAlertHandler,
        showAllAlerts: showAlert,
        onDismiss: deposit.currency.isSingleNetwork
            ? null
            : () => showDepositeNetworkBottomSheet(
                  context,
                  deposit.network,
                  deposit.currency.depositBlockchains,
                  deposit.currency.iconUrl,
                  deposit.currency.symbol,
                  deposit.setNetwork,
                  isReceive: true,
                ),
        size: widgetSizeFrom(sDeviceSize),
        requiredDocuments: kycState.requiredDocuments,
        requiredVerifications: kycState.requiredVerifications,
        verificationInProgress: kycState.verificationInProgress,
        withdrawalStatus: kycState.withdrawalStatus,
      );
    } else {
      if (!deposit.currency.isSingleNetwork) {
        showDepositeNetworkBottomSheet(
          context,
          deposit.network,
          deposit.currency.depositBlockchains,
          deposit.currency.iconUrl,
          deposit.currency.symbol,
          deposit.setNetwork,
          isReceive: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deposit = CryptoDepositStore.of(context);

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: GlobalBasicAppBar(
        title: '${intl.balanceActionButtons_receive} ${deposit.currency.description}',
        hasRightIcon: false,
      ),
      bottomNavigationBar: SizedBox(
        height: 122,
        child: Column(
          children: [
            const SDivider(),
            const SpaceH23(),
            SPaddingH24(
              child: SButton.outlined(
                icon: Assets.svg.medium.share.simpleSvg(
                  height: 18,
                ),
                text: intl.cryptoDeposit_share,
                callback: () {
                  sAnalytics.tapOnTheButtonShareOnReceiveAssetScreen(
                    asset: deposit.currency.symbol,
                    network: deposit.network.description,
                  );

                  if (canTapShare) {
                    setState(() {
                      canTapShare = false;
                    });
                    Timer(
                      const Duration(
                        seconds: 1,
                      ),
                      () => setState(() {
                        canTapShare = true;
                      }),
                    );

                    try {
                      AnchorsHelper().addCryptoDepositAnchor(deposit.currency.symbol);

                      Share.share(
                        '${intl.cryptoDeposit_my} ${deposit.currency.symbol}'
                        ' ${intl.cryptoDeposit_address}: '
                        '${deposit.address} '
                        '${deposit.tag != null ? ', ${deposit.currency.symbol == 'XRP' ? intl.tagOrMemo : intl.tag}: '
                            '${deposit.tag}' : ''} \n'
                        '${intl.cryptoDeposit_network}: '
                        '${deposit.network.description}',
                      );
                    } catch (e) {
                      rethrow;
                    }
                  }
                },
              ),
            ),
            const SpaceH42(),
          ],
        ),
      ),
      child: ListView(
        controller: controller,
        padding: EdgeInsets.zero,
        children: [
          if (deposit.tag != null)
            DepositInfoTag(
              text: '${intl.depositInfoTag_text1} ${deposit.currency.symbol}'
                  ' ${intl.depositInfoTag_text2}',
            )
          else
            DepositInfo(),
          Container(
            height: 88.0,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: InkWell(
              highlightColor: colors.grey5,
              splashColor: Colors.transparent,
              onTap: deposit.currency.isSingleNetwork
                  ? null
                  : () {
                      sAnalytics.tapOnTheButtonNetworkOnReceiveAssetScreen(
                        asset: deposit.currency.symbol,
                      );

                      sAnalytics.chooseNetworkPopupViewShowedOnReceiveAssetScreen(
                        asset: deposit.currency.symbol,
                      );

                      showDepositeNetworkBottomSheet(
                        context,
                        deposit.network,
                        deposit.currency.depositBlockchains,
                        deposit.currency.iconUrl,
                        deposit.currency.symbol,
                        deposit.setNetwork,
                        backOnClose: false,
                        isReceive: true,
                      );
                    },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colors.grey3,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                      ),
                      child: Text(
                        intl.cryptoDeposit_network,
                        style: STStyles.captionMedium.copyWith(
                          color: colors.grey2,
                        ),
                      ),
                    ),
                    if (deposit.network.description.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 24,
                        ),
                        child: SSkeletonLoader(
                          height: 16,
                          width: 80,
                        ),
                      ),
                    if (deposit.network.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 17,
                        ),
                        child: Text(
                          deposit.network.description,
                          style: STStyles.subtitle1,
                        ),
                      ),
                    if (!deposit.currency.isSingleNetwork)
                      const Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: SAngleDownIcon(),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SDivider(),
          if (deposit.tag != null)
            CryptoDepositWithAddressAndTag(
              currency: deposit.currency,
              scrollController: controller,
            )
          else
            CryptoDepositWithAddress(
              currency: deposit.currency,
            ),
        ],
      ),
    );
  }
}
