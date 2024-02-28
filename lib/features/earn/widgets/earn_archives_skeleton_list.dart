import 'package:flutter/material.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit_updated/widgets/shared/simple_skeleton_loader.dart';

class EarnArchivesSceletonList extends StatelessWidget {
  const EarnArchivesSceletonList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: List.generate(4, (_) => const EarnArchivesSkeletonItem()).toList(),
      ),
    );
  }
}

class EarnArchivesSkeletonItem extends StatelessWidget {
  const EarnArchivesSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Container(
        height: 196,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.grey4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          const ClipOval(
                            child: SSkeletonLoader(
                              width: 40,
                              height: 40,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SSkeletonLoader(
                                width: 96,
                                height: 20,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              const SizedBox(height: 6),
                              SSkeletonLoader(
                                width: 48,
                                height: 16,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SSkeletonLoader(
                        width: 64,
                        height: 24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SSkeletonLoader(
                width: double.infinity,
                height: 100,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
