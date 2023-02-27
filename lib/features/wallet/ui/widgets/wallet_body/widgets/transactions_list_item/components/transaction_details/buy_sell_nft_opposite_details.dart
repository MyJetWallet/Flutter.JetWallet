import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../../../core/router/app_router.dart';
import '../../../../../../../helper/nft_by_symbol.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class BuySellNftOppositeDetails extends StatelessObserverWidget {
  const BuySellNftOppositeDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final nftAsset = getNftItem(
      transactionListItem,
      sSignalRModules.allNftList,
    );

    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsItem(
            text: '${intl.transaction} ID',
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: shortAddressFormTwo(transactionListItem.operationId),
                ),
                const SpaceW10(),
                SIconButton(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: transactionListItem.operationId,
                      ),
                    );

                    onCopyAction('${intl.transaction} ID');
                  },
                  defaultIcon: const SCopyIcon(),
                  pressedIcon: const SCopyPressedIcon(),
                ),
              ],
            ),
          ),
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.buySellDetails_forText,
            value: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                sRouter.push(
                  NFTDetailsRouter(
                    nftSymbol: nftAsset.symbol!,
                    userNFT: nftAsset.sellPrice == null,
                  ),
                );
              },
              child: Text(
                nftAsset.name ?? 'NFT',
                style: sSubtitle3Style.copyWith(
                  color: colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          const SpaceH40(),
        ],
      ),
    );
  }
}
