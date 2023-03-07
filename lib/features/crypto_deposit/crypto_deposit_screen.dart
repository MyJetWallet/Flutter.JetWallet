import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/crypto_deposit/store/crypto_deposit_disclaimer_store.dart';
import 'package:jetwallet/features/crypto_deposit/store/crypto_deposit_store.dart';
import 'package:jetwallet/features/crypto_deposit/widgets/crypto_deposit_with_address.dart';
import 'package:jetwallet/features/crypto_deposit/widgets/crypto_deposit_with_address_and_tag.dart';
import 'package:jetwallet/features/crypto_deposit/widgets/deposit_info.dart';
import 'package:jetwallet/features/crypto_deposit/widgets/show_deposit_disclaimer.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/network_bottom_sheet/show_network_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CryptoDeposit extends StatelessWidget {
  const CryptoDeposit({
    Key? key,
    required this.header,
    required this.currency,
  }) : super(key: key);

  final String header;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Provider<CryptoDepositStore>(
      create: (context) => CryptoDepositStore(currency),
      builder: (context, child) => _CryptoDepositBody(
        header: header,
        currency: currency,
      ),
      dispose: (context, state) => state.dispose(),
    );
  }
}

class _CryptoDepositBody extends StatefulObserverWidget {
  const _CryptoDepositBody({
    Key? key,
    required this.header,
    required this.currency,
  }) : super(key: key);

  final String header;
  final CurrencyModel currency;

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

    showAlert =
        kycState.withdrawalStatus != kycOperationStatus(KycStatus.allowed);
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
            size: widgetSizeFrom(sDeviceSize),
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
              style: sCaptionTextStyle.copyWith(
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
    final value = await getcryptoDepositDisclaimer(widget.currency.symbol);

    if (!mounted) return;

    if (value == CryptoDepositDisclaimer.notAccepted) {
      showDepositDisclaimer(
        slidesControllers: slidesControllers(),
        context: context,
        controller: pageController,
        assetSymbol: widget.currency.symbol,
        screenTitle: widget.header,
        kycAlertHandler: kycAlertHandler,
        showAllAlerts: showAlert,
        onDismiss: widget.currency.isSingleNetwork
            ? null
            : () => showNetworkBottomSheet(
                  context,
                  deposit.network,
                  widget.currency.depositBlockchains,
                  widget.currency.iconUrl,
                  deposit.setNetwork,
                ),
        size: widgetSizeFrom(sDeviceSize),
        requiredDocuments: kycState.requiredDocuments,
        requiredVerifications: kycState.requiredVerifications,
        verificationInProgress: kycState.verificationInProgress,
        withdrawalStatus: kycState.withdrawalStatus,
      );
    } else {
      if (!widget.currency.isSingleNetwork) {
        showNetworkBottomSheet(
          context,
          deposit.network,
          widget.currency.depositBlockchains,
          widget.currency.iconUrl,
          deposit.setNetwork,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deposit = CryptoDepositStore.of(context);

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: '${widget.header} ${widget.currency.description}',
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 122,
        child: Column(
          children: [
            const SDivider(),
            const SpaceH23(),
            SPaddingH24(
              child: SPrimaryButton2(
                icon: SShareIcon(
                  color: colors.white,
                ),
                active: true,
                name: intl.cryptoDeposit_share,
                onTap: () {
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
                      Share.share(
                        '${intl.cryptoDeposit_my} ${widget.currency.symbol}'
                        ' ${intl.cryptoDeposit_address}: '
                        '${deposit.address} '
                        '${deposit.tag != null ? ', ${intl.tag}: '
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
              onTap: widget.currency.isSingleNetwork
                  ? null
                  : () => showNetworkBottomSheet(
                        context,
                        deposit.network,
                        widget.currency.depositBlockchains,
                        widget.currency.iconUrl,
                        deposit.setNetwork,
                      ),
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
                        style: sCaptionTextStyle.copyWith(
                          color: colors.grey2,
                        ),
                      ),
                    ),
                    if (deposit.network.description.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 24,
                        ),
                        child: SSkeletonTextLoader(
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
                          style: sSubtitle2Style,
                        ),
                      ),
                    if (!widget.currency.isSingleNetwork)
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
              currency: widget.currency,
              scrollController: controller,
            )
          else
            CryptoDepositWithAddress(
              currency: widget.currency,
            ),
        ],
      ),
    );
  }
}
