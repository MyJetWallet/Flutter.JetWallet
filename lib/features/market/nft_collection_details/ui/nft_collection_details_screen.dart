import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

class NftCollectionDetails extends StatelessWidget {
  const NftCollectionDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Material(
      color: colors.white,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.white,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                color: Colors.white,
                icon: const SBackIcon(),
                onPressed: () {},
              ),
            ),
            expandedHeight: 160.0,
            flexibleSpace: const FlexibleSpaceBar(
              background: FlutterLogo(),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 28.0,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1547721064-da6cfb341d50',
                  ),
                ),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: SPaddingH24(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Baseline(
                    baseline: 40,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      "Archetype by Kjetil Golid",
                      maxLines: 3,
                      style: sTextH2Style,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Baseline(
                    baseline: 24,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      "Archetype explores the use of repetition as a counterweight to unruly, random structures.",
                      maxLines: 5,
                      style: sBodyText1Style,
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Baseline(
                            baseline: 21,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              intl.nft_collection_details_items,
                              style: sBodyText2Style.copyWith(
                                color: colors.grey1,
                              ),
                            ),
                          ),
                          Text(
                            '600',
                            style: sBodyText1Style,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.37,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Baseline(
                            baseline: 21,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              intl.nft_collection_details_owners,
                              style: sBodyText2Style.copyWith(
                                color: colors.grey1,
                              ),
                            ),
                          ),
                          Text(
                            '299',
                            style: sBodyText1Style,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const SDivider(),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Baseline(
                            baseline: 21,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              intl.nft_collection_details_total_volume,
                              style: sBodyText2Style.copyWith(
                                color: colors.grey1,
                              ),
                            ),
                          ),
                          Text(
                            '600',
                            style: sBodyText1Style,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Baseline(
                            baseline: 21,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              intl.nft_collection_details_best_offer,
                              style: sBodyText2Style.copyWith(
                                color: colors.grey1,
                              ),
                            ),
                          ),
                          Text(
                            '299',
                            style: sBodyText1Style,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const SDivider(),
                  const SizedBox(
                    height: 25,
                  ),
                  Baseline(
                    baseline: 32,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      intl.nft_collection_details_best_available_nfts,
                      style: sTextH4Style,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
