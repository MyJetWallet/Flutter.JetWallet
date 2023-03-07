import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/nft/nft_collection_details/store/nft_collection_store.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

void showNFTCollectionFilterModalSheet(
  BuildContext context,
  NFTCollectionDetailStore store, {
  bool isAvailableNFT = true,
}) {
  final colors = sKit.colors;

  sShowBasicModalBottomSheet(
    onDissmis: () {},
    context: context,
    horizontalPinnedPadding: 0.0,
    removeBottomSheetBar: true,
    removePinnedPadding: true,
    horizontalPadding: 0,
    pinned: ActionBottomSheetHeader(
      name: intl.nft_collection_filter_header,
      onCloseTap: () {},
    ),
    pinnedBottom: const SpaceH40(),
    children: [
      Observer(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: store.filterValues.map((e) {
              final ind = store.filterValues.indexOf(e);

              final isFilterSelected = isAvailableNFT
                  ? store.availableFilter != null
                      ? store.availableFilter == e
                          ? true
                          : false
                      : false
                  : store.soldFilter != null
                      ? store.soldFilter == e
                          ? true
                          : false
                      : false;

              return SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    store.activeFilter(
                      e,
                      isAvailableNFT,
                    );

                    Navigator.of(context).pop();
                  },
                  child: SPaddingH24(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SpaceH18(),
                        Baseline(
                          baseline: 24,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            e.value,
                            style: sSubtitle2Style.copyWith(
                              color:
                                  isFilterSelected ? colors.blue : colors.black,
                            ),
                          ),
                        ),
                        const SpaceH22(),
                        if (store.filterValues.length - 1 != ind) ...[
                          const SDivider(),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    ],
  );
}
