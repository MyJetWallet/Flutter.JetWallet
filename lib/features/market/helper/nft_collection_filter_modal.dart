import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/nft/nft_collection_details/store/nft_collection_store.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:mobx/mobx.dart';
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
    pinned: ActionBottomSheetHeader(
      name: intl.nft_collection_filter_header,
      onCloseTap: () {},
    ),
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

              return InkWell(
                onTap: () {
                  print(store.filterValues[ind].toString());
                  print(e.value);

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
                      if (ind != 0) ...[
                        const SizedBox(
                          height: 18,
                        ),
                      ],
                      Text(
                        e.value,
                        style: sSubtitle2Style.copyWith(
                          color: isFilterSelected ? colors.blue : colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      const SDivider(),
                    ],
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
