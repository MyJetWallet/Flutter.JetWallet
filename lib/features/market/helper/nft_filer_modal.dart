import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/store/market_filter_store.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/helper/nft_market.dart';
import 'package:jetwallet/utils/models/nft_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/secondary_button/light/simple_light_secondary_button_1.dart';
import 'package:simple_kit/modules/icons/24x24/public/circle_done/circle_done.dart';
import 'package:simple_kit/simple_kit.dart';

void showNFTFilterModalSheet(
  BuildContext context,
  MarketFilterStore filterStore,
) {
  final colors = sKit.colors;

  final filters = getNFTFilterList();

  sShowBasicModalBottomSheet(
    onDissmis: () {
      filterStore.nftFilterReset();
    },
    context: context,
    scrollable: true,
    horizontalPinnedPadding: 0.0,
    pinned: ActionBottomSheetHeader(
      name: intl.market_nft_show,
      onCloseTap: () {
        filterStore.nftFilterReset();
      },
    ),
    pinnedBottom: Material(
      color: colors.white,
      child: SFloatingButtonFrame(
        button: SimpleLightSecondaryButton1(
          active: true,
          name: intl.market_nft_done,
          onTap: () {
            filterStore.filterDone();

            Navigator.pop(context);
          },
        ),
      ),
    ),
    children: [
      Observer(
        builder: (context) {
          return Column(
            children: filters.map((e) {
              final ind = filters.indexOf(e);

              return filterItem(
                e,
                filterStore: filterStore,
                isLast: filters.length - 1 == ind,
                isSelected: filterStore.nftFilterSelected.contains(e),
              );
            }).toList(),
          );
        },
      ),
    ],
  );
}

Widget filterItem(
  NftCollectionCategoryEnum item, {
  required MarketFilterStore filterStore,
  bool isLast = false,
  bool isSelected = false,
}) {
  final colors = sKit.colors;

  return InkWell(
    onTap: () {
      filterStore.nftFilterAction(item);
    },
    child: SPaddingH24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 18,
          ),
          Row(
            children: [
              Text(
                item.name,
                style: sSubtitle2Style.copyWith(
                  color: isSelected ? colors.blue : colors.black,
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                const SCircleDone(),
              ],
            ],
          ),
          const SizedBox(
            height: 22,
          ),
          if (!isLast) ...[
            const SDivider(),
          ],
        ],
      ),
    ),
  );
}
