import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/providers/device_size/media_query_pod.dart';
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
  }) : super(key: key);

  final CurrencyModel currency;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = useProvider(mediaQueryPod);
    final qrBoxSize = mediaQuery.size.width * 0.6;
    final logoSize = mediaQuery.size.width * 0.24;
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
              header: '${currency.symbol} Wallet address',
              value: shortAddressForm(deposit.address),
              realValue: deposit.address,
              afterCopyText: 'Address copied',
              valueLoading: deposit.union is Loading,
              actionIcon: deposit.isAddressOpen
                  ? const SAngleUpIcon()
                  : const SAngleDownIcon(),
              onTap: () {
                depositN.switchAddress();
              },
              scrollToFullCopyMessage: () {
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
              header: 'Tag',
              value: deposit.tag!,
              realValue: deposit.tag,
              afterCopyText: 'Tag copied',
              valueLoading: deposit.union is Loading,
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
              ),
            ],
          ),
          isExpanded: !deposit.isAddressOpen,
        ),
      ],
    );
  }
}
