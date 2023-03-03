import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/nft/nft_confirm/store/nft_confirm_store.dart';
import 'package:jetwallet/features/nft/nft_confirm/store/nft_promo_code_store.dart';
import 'package:jetwallet/features/nft/nft_confirm/ui/show_nft_promo_code.dart';
import 'package:jetwallet/features/nft/nft_confirm/model/nft_promo_code_union.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/circle_done/circle_done.dart';
import 'package:simple_kit/modules/icons/24x24/public/circle_done/circle_selected_done.dart';
import 'package:simple_kit/simple_kit.dart';

class NFTPromoButton extends StatefulObserverWidget {
  const NFTPromoButton({super.key});

  @override
  State<NFTPromoButton> createState() => _NFTPromoButtonState();
}

class _NFTPromoButtonState extends State<NFTPromoButton> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    late Color currentColor;
    late Widget currentIcon;

    final isPromoValid = getIt.get<NFTPromoCodeStore>().promoStatus is Valid &&
        getIt.get<NFTPromoCodeStore>().discount != null;

    if (isPromoValid) {
      currentColor = colors.black;
      currentIcon = const SizedBox(
        width: 20,
        height: 20,
        child: SCircleDoneSelected(),
      );
    } else {
      currentColor = colors.black;
      currentIcon = SGiftPortfolioIcon(color: colors.black);
    }

    return InkWell(
      onTap: () {
        showNFTPromoCodeBottomSheet(
          () {
            NFTConfirmStore.of(context).validate();
          },
        );
      },
      onHighlightChanged: (value) {
        setState(() {
          highlighted = value;
        });
      },
      highlightColor: colors.grey5,
      splashColor: Colors.transparent,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Ink(
        height: 56.0,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              currentIcon,
              const SpaceW12(),
              if (isPromoValid) ...[
                Text(
                  '${intl.nft_promo_code}: ${getIt.get<NFTPromoCodeStore>().promoCode}',
                  style: sButtonTextStyle.copyWith(
                    color: currentColor,
                  ),
                ),
              ] else ...[
                Text(
                  intl.nft_detail_i_have_promo,
                  style: sButtonTextStyle.copyWith(
                    color: currentColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
