import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class PortfolioBalance extends StatelessWidget {
  const PortfolioBalance({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPageFrame(
      child: CustomScrollView(
        //controller: scrollController,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: colors.white,
            pinned: true,
            stretch: true,
            elevation: 0,
            expandedHeight: expandedHeight,
            collapsedHeight: 65,
            floating: true,
            automaticallyImplyLeading: false,
            flexibleSpace: SPaddingH24(
              child: NFTDetailHeader(
                title: store.nft?.name ?? '',
                fImage: '$shortUrl${store.nft!.sImage}',
                showImage: showImage,
                objectId: store.nft?.symbol ?? '',
                collectionId: store.nft?.collectionId ?? '',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
