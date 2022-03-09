import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../components/show_network_bottom_sheet.dart';
import '../../../models/currency_model.dart';
import '../notifier/crypto_deposit_notipod.dart';
import '../provider/crypto_deposit_disclaimer_fpod.dart';
import 'components/crypto_deposit_with_address.dart';
import 'components/crypto_deposit_with_address_and_tag/crypto_deposit_with_address_and_tag.dart';
import 'components/deposit_info.dart';
import 'components/show_deposit_disclaimer.dart';

class CryptoDeposit extends HookWidget {
  const CryptoDeposit({
    Key? key,
    required this.header,
    required this.currency,
  }) : super(key: key);

  final String header;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    useProvider(cryptoDepositDisclaimerFpod(currency.symbol).select((_) {}));
    final deposit = useProvider(cryptoDepositNotipod(currency));
    final depositN = useProvider(cryptoDepositNotipod(currency).notifier);

    return ProviderListener<AsyncValue<CryptoDepositDisclaimer>>(
      provider: cryptoDepositDisclaimerFpod(currency.symbol),
      onChange: (context, asyncValue) {
        asyncValue.whenData((value) {
          if (value == CryptoDepositDisclaimer.notAccepted) {
            showDepositDisclaimer(
              context: context,
              assetSymbol: currency.symbol,
              onDismiss: currency.isSingleNetwork
                  ? null
                  : () => showNetworkBottomSheet(
                        context,
                        deposit.network,
                        currency.depositBlockchains,
                        currency.iconUrl,
                        depositN.setNetwork,
                      ),
            );
          } else {
            if (!currency.isSingleNetwork) {
              showNetworkBottomSheet(
                context,
                deposit.network,
                currency.depositBlockchains,
                currency.iconUrl,
                depositN.setNetwork,
              );
            }
          }
        });
      },
      child: SPageFrame(
        header: SPaddingH24(
          child: SSmallHeader(
            title: '$header ${currency.description}',
          ),
        ),
        child: Column(
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
                onTap: currency.isSingleNetwork
                    ? null
                    : () => showNetworkBottomSheet(
                          context,
                          deposit.network,
                          currency.depositBlockchains,
                          currency.iconUrl,
                          depositN.setNetwork,
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
                          'Network',
                          style: sCaptionTextStyle.copyWith(
                            color: colors.grey2,
                          ),
                        ),
                      ),
                      if (deposit.network.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 24,
                          ),
                          child: SSkeletonTextLoader(
                            height: 16,
                            width: 80,
                          ),
                        ),
                      if (deposit.network.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 17,
                          ),
                          child: Text(
                            deposit.network,
                            style: sSubtitle2Style,
                          ),
                        ),
                      if (!currency.isSingleNetwork)
                        const Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: SAngleDownIcon(),
                        )
                    ],
                  ),
                ),
              ),
            ),
            const SDivider(),
            if (deposit.tag != null)
              CryptoDepositWithAddressAndTag(
                currency: currency,
              )
            else
              CryptoDepositWithAddress(
                currency: currency,
              ),
            const SDivider(),
            const SpaceH24(),
            SPaddingH24(
              child: SPrimaryButton2(
                icon: SShareIcon(
                  color: colors.white,
                ),
                active: true,
                name: 'Share',
                onTap: () => Share.share(
                  'My ${currency.symbol} Address: ${deposit.address} '
                  '${deposit.tag != null ? ', Tag: ${deposit.tag}' : ''}',
                ),
              ),
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
