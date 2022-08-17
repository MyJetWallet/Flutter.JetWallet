import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/providers/device_size/media_query_pod.dart';
import '../../../../../../../shared/providers/service_providers.dart';
import '../../../../../helpers/short_address_form.dart';
import '../../../../../models/currency_model.dart';
import '../../../notifier/crypto_deposit_notipod.dart';
import '../../../notifier/crypto_deposit_union.dart';
import 'components/expansion_panel_without_icon.dart';

const _copyMessageFullyVisiblePosition = 113.0;

class CryptoDepositWithAddressAndTag extends HookWidget {
  const CryptoDepositWithAddressAndTag({
    Key? key,
    required this.currency,
    required this.scrollController,
    this.showAlert = false,
    this.alert,
  }) : super(key: key);

  final CurrencyModel currency;
  final ScrollController scrollController;
  final bool showAlert;
  final Widget? alert;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final mediaQuery = useProvider(mediaQueryPod);
    final qrBoxSize = mediaQuery.size.width * 0.6;
    final logoSize = mediaQuery.size.width * 0.2;
    final deposit = useProvider(cryptoDepositNotipod(currency));
    final depositN = useProvider(
      cryptoDepositNotipod(currency).notifier,
    );

    return ExpansionPanelListWithoutIcon(
      elevation: 0,
      expansionCallback: (int index, bool isExpanded) {
        depositN.switchAddress();
      },
      expandedHeaderPadding: EdgeInsets.zero,
      children: [
        ExpansionPanelWithoutIcon(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return SAddressFieldWithCopy(
              header: '${currency.symbol}'
                  ' ${intl.cryptoDepositWithAddressAndTag_walletAddress}',
              value: shortAddressForm(deposit.address),
              realValue: deposit.address,
              afterCopyText: intl.cryptoDepositWithAddressAndTag_addressCopied,
              valueLoading: deposit.union is Loading,
              actionIcon: deposit.isAddressOpen
                  ? const SAngleUpIcon()
                  : const SAngleDownIcon(),
              onTap: () {
                depositN.switchAddress();
              },
              then: () {
                sAnalytics.receiveCopy(asset: currency.description);
                if (scrollController.offset >
                    _copyMessageFullyVisiblePosition) {
                  scrollController.animateTo(
                    _copyMessageFullyVisiblePosition,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                }
              },
            );
          },
          body: Column(
            children: [
              const SpaceH17(),
              SQrCodeBox(
                loading: deposit.union is Loading,
                data: deposit.address,
                qrBoxSize: qrBoxSize,
                logoSize: logoSize,
                showAlert: showAlert,
                alert: alert,
              ),
              const SpaceH17(),
            ],
          ),
          isExpanded: deposit.isAddressOpen,
        ),
        ExpansionPanelWithoutIcon(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return SAddressFieldWithCopy(
              header: intl.tag,
              value: deposit.tag!,
              realValue: deposit.tag,
              afterCopyText: intl.cryptoDepositWithAddress_tagCopied,
              valueLoading: deposit.union is Loading,
              then: () {
                sAnalytics.receiveCopy(asset: currency.description);
              },
              actionIcon: deposit.isAddressOpen
                  ? const SAngleDownIcon()
                  : const SAngleUpIcon(),
              onTap: () {
                depositN.switchAddress();
              },
            );
          },
          body: Column(
            children: [
              const SpaceH17(),
              SQrCodeBox(
                loading: deposit.union is Loading,
                data: deposit.tag!,
                qrBoxSize: qrBoxSize,
                logoSize: logoSize,
                showAlert: showAlert,
                alert: alert,
              ),
            ],
          ),
          isExpanded: !deposit.isAddressOpen,
        ),
      ],
    );
  }
}
