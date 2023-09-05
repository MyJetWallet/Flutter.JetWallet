import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/crypto_deposit/model/crypto_deposit_union.dart';
import 'package:jetwallet/features/crypto_deposit/store/crypto_deposit_store.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/services/device_size/device_size.dart';
import '../../../core/services/notification_service.dart';
import '../../../utils/helpers/widget_size_from.dart';

// Header, ShareButton bar, DepositInfo, NetworkSelector
const screenWidgets = 120 + 122 + 88 + 40 + 28;
const sAddressFieldWithCopyHeight = 146;

class CryptoDepositWithAddressAndTag extends StatefulObserverWidget {
  const CryptoDepositWithAddressAndTag({
    super.key,
    required this.currency,
    required this.scrollController,
  });

  final CurrencyModel currency;
  final ScrollController scrollController;

  @override
  State<CryptoDepositWithAddressAndTag> createState() =>
      _CryptoDepositWithAddressAndTagState();
}

class _CryptoDepositWithAddressAndTagState
    extends State<CryptoDepositWithAddressAndTag> {
  late ScrollController controller;
  late PageController pageController;

  int currentPage = 0;

  final colors = sKit.colors;

  @override
  void initState() {
    controller = ScrollController();
    pageController = PageController(viewportFraction: 0.6);
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.round();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final qrBoxSize = mediaQuery.size.width * 0.6;
    final logoSize = mediaQuery.size.width * 0.2;
    final deposit = CryptoDepositStore.of(context);
    final screenHeight = mediaQuery.size.height;
    final deviceSize = sDeviceSize;

    final extraScrollArea =
        screenHeight - qrBoxSize - screenWidgets - sAddressFieldWithCopyHeight;

    var widgetHeight = extraScrollArea.isNegative
        ? screenHeight - screenWidgets + extraScrollArea.abs()
        : screenHeight - screenWidgets;
    if (widgetSizeFrom(deviceSize) == SWidgetSize.small) {
      widgetHeight += 36;
    }

    return SizedBox(
      height: widgetHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(),
          Stack(
            children: [
              SizedBox(
                height: qrBoxSize + 34,
                child: PageView.builder(
                  controller: pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (_, index) {
                    return Opacity(
                      opacity: currentPage != index ? 0.6 : 1,
                      child: Stack(
                        children: [
                          if (index == 0)
                            Column(
                              children: [
                                const SpaceH17(),
                                SQrCodeBox(
                                  loading: deposit.union is Loading,
                                  data: deposit.address,
                                  qrBoxSize: qrBoxSize,
                                  logoSize: logoSize,
                                ),
                                const SpaceH17(),
                              ],
                            )
                          else
                            Column(
                              children: [
                                const SpaceH17(),
                                SQrCodeBox(
                                  loading: deposit.union is Loading,
                                  data: deposit.tag!,
                                  qrBoxSize: qrBoxSize,
                                  logoSize: logoSize,
                                ),
                                const SpaceH4(),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (currentPage == 0) {
                    pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.linear,
                    );
                  } else {
                    pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.linear,
                    );
                  }
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: colors.grey5,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          intl.cryptoDeposit_address,
                          style: sSubtitle3Style.copyWith(
                            color: colors.grey3,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 32),
                        Text(
                          intl.tag,
                          style: sSubtitle3Style.copyWith(
                            color: colors.grey3,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (currentPage == 0)
                Positioned(
                  left: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        intl.cryptoDeposit_address,
                        style: sSubtitle3Style.copyWith(
                          color: colors.white,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Positioned(
                  right: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        intl.tag,
                        style: sSubtitle3Style.copyWith(
                          color: colors.white,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          if (currentPage == 1)
            SAddressFieldWithCopy(
              header: intl.tag,
              value: deposit.tag!,
              realValue: deposit.tag,
              afterCopyText: intl.cryptoDepositWithAddress_tagCopied,
              valueLoading: deposit.union is Loading,
              longString: true,
              expanded: true,
              then: () {
                sAnalytics.tapOnTheButtonCopyOnReceiveAssetScreen(
                  asset: deposit.currency.symbol,
                  network: deposit.network.description,
                );
                
                sNotification.showError(
                  intl.copy_message,
                  id: 1,
                  isError: false,
                );
              },
            )
          else
            SAddressFieldWithCopy(
              header: '${widget.currency.symbol}'
                  ' ${intl.cryptoDepositWithAddressAndTag_walletAddress}',
              value: deposit.address,
              realValue: deposit.address,
              afterCopyText: intl.cryptoDepositWithAddressAndTag_addressCopied,
              valueLoading: deposit.union is Loading,
              longString: true,
              expanded: true,
              then: () {
                sNotification.showError(
                  intl.copy_message,
                  id: 1,
                  isError: false,
                );
              },
            ),
        ],
      ),
    );
  }
}
