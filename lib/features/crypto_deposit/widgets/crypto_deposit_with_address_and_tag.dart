import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/crypto_deposit/model/crypto_deposit_union.dart';
import 'package:jetwallet/features/crypto_deposit/store/crypto_deposit_store.dart';
import 'package:jetwallet/features/crypto_deposit/widgets/expansion_panel_without_icon.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

const _copyMessageFullyVisiblePosition = 113.0;

class CryptoDepositWithAddressAndTag extends StatelessObserverWidget {
  const CryptoDepositWithAddressAndTag({
    Key? key,
    required this.currency,
    required this.scrollController,
  }) : super(key: key);

  final CurrencyModel currency;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final qrBoxSize = mediaQuery.size.width * 0.6;
    final logoSize = mediaQuery.size.width * 0.2;
    final deposit = CryptoDepositStore.of(context);

    return ExpansionPanelListWithoutIcon(
      elevation: 0,
      expansionCallback: (int index, bool isExpanded) {
        deposit.switchAddress();
      },
      expandedHeaderPadding: EdgeInsets.zero,
      children: [
        ExpansionPanelWithoutIcon(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return SAddressFieldWithCopy(
              header: '${currency.symbol}'
                  ' ${intl.cryptoDepositWithAddressAndTag_walletAddress}',
              value: deposit.address,
              realValue: deposit.address,
              afterCopyText: intl.cryptoDepositWithAddressAndTag_addressCopied,
              valueLoading: deposit.union is Loading,
              longString: true,
              expanded: true,
              actionIcon: deposit.isAddressOpen
                  ? const SAngleUpIcon()
                  : const SAngleDownIcon(),
              onTap: () {
                deposit.switchAddress();
              },
              then: () {
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
              header: intl.tag,
              value: deposit.tag!,
              realValue: deposit.tag,
              afterCopyText: intl.cryptoDepositWithAddress_tagCopied,
              valueLoading: deposit.union is Loading,
              longString: true,
              expanded: true,
              then: () {},
              actionIcon: deposit.isAddressOpen
                  ? const SAngleDownIcon()
                  : const SAngleUpIcon(),
              onTap: () {
                deposit.switchAddress();
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
