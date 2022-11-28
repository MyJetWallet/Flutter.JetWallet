import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class NewsLoadingItem extends StatelessWidget {
  const NewsLoadingItem({
    Key? key,
    this.removeDivider = false,
    required this.opacity,
  }) : super(key: key);

  final bool removeDivider;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: SPaddingH24(
        child: SizedBox(
          height: 90,
          child: Column(
            children: [
              const SpaceH18(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  SSkeletonTextLoader(
                    height: 16,
                    width: 16,
                  ),
                  SpaceW12(),
                  SSkeletonTextLoader(
                    height: 10,
                    width: 109,
                  ),
                ],
              ),
              const SpaceH12(),
              Row(
                children: const [
                  SSkeletonTextLoader(
                    height: 16,
                    width: 248,
                  ),
                ],
              ),
              const SpaceH12(),
              Row(
                children: const [
                  SSkeletonTextLoader(
                    height: 16,
                    width: 130,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
