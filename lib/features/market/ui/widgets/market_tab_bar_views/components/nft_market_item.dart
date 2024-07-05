import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class NftMarketItem extends StatelessWidget {
  const NftMarketItem({
    super.key,
    this.last = false,
    required this.image,
    required this.name,
    required this.descr,
    required this.onTap,
  });

  final String image;
  final String name;
  final String descr;
  final bool last;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return InkWell(
      highlightColor: colors.grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 88.0,
          child: Column(
            children: [
              const SpaceH22(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: image,
                    fadeOutDuration: const Duration(milliseconds: 500),
                    fadeInDuration: const Duration(milliseconds: 250),
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) => const SSkeletonTextLoader(
                      height: 24,
                      width: 24,
                    ),
                    errorWidget: (context, url, error) => const SSkeletonTextLoader(
                      height: 24,
                      width: 24,
                    ),
                  ),
                  /*
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: Image.network(
                      image,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  */
                  const SpaceW10(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Baseline(
                          baseline: 18.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            name,
                            style: sSubtitle2Style,
                          ),
                        ),
                        Baseline(
                          baseline: 18.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            descr,
                            style: sBodyText2Style.copyWith(
                              color: colors.grey3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (!last)
                const SDivider(
                  width: double.infinity,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
