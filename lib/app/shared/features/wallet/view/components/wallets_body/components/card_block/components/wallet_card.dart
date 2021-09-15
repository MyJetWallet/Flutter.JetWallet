import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../../screens/market/provider/market_items_pod.dart';
import '../../../../../../../../components/asset_icon.dart';
import '../../../../../../helper/market_item_from.dart';
import '../../../../../../provider/wallet_hidden_stpod.dart';

class WalletCard extends HookWidget {
  const WalletCard({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;

  @override
  Widget build(BuildContext context) {
    final marketItem = marketItemFrom(
      useProvider(marketItemsPod),
      assetId,
    );
    final hidden = useProvider(walletHiddenStPod);

    return Expanded(
      child: Container(
        height: 0.25.sh,
        margin: EdgeInsets.symmetric(
          horizontal: 24.w,
        ),
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AssetIcon(
                  imageUrl: marketItem.iconUrl,
                ),
                const SpaceW8(),
                Expanded(
                  child: Text(
                    marketItem.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => hidden.state = !hidden.state,
                  child: Icon(
                    hidden.state ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Expanded(
              child: Text(
                hidden.state ? 'Hidden' : '\$${marketItem.baseBalance}',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              hidden.state
                  ? ' '
                  : '${marketItem.assetBalance} ${marketItem.associateAsset}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
