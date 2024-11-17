import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/button/progress_bar/progress_bar.dart';

class LimitsButton extends StatelessWidget {
  const LimitsButton({
    super.key,
    this.isLoading = false,
    this.hasSecondItem = true,
    this.hasHeader = true,
    this.title = '',
    this.subtitle = '',
    this.icon,
    this.onIconPressed,
    this.indicationTitle1 = '',
    this.progress1 = 0,
    this.indicationValue1 = '',
    this.indicationLable1 = '',
    this.indicationTitle2 = '',
    this.progress2 = 0,
    this.indicationValue2 = '',
    this.indicationLable2 = '',
  });

  final bool isLoading;
  final bool hasSecondItem;
  final bool hasHeader;

  final String title;
  final String subtitle;

  final Widget? icon;
  final void Function()? onIconPressed;

  final String indicationTitle1;
  final double progress1;
  final String indicationValue1;
  final String indicationLable1;

  final String indicationTitle2;
  final double progress2;
  final String indicationValue2;
  final String indicationLable2;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return isLoading
        ? const _LoadingStateWidget()
        : Container(
            //height: 203,
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: colors.gray4,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasHeader) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: STStyles.header6,
                          ),
                          if (subtitle != '')
                            Text(
                              subtitle,
                              style: STStyles.body1Bold.copyWith(
                                color: colors.gray10,
                              ),
                            ),
                        ],
                      ),
                      if (icon != null)
                        IconButton(
                          onPressed: onIconPressed,
                          icon: icon!,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        )
                      else
                        const SizedBox()
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
                Row(
                  children: [
                    Expanded(
                      child: _LimitBlocWidget(
                        title: indicationTitle1,
                        progress: progress1,
                        value: indicationValue1,
                        indicationLable: indicationLable1,
                      ),
                    ),
                    if (hasSecondItem) ...[
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: _LimitBlocWidget(
                          title: indicationTitle2,
                          progress: progress2,
                          value: indicationValue2,
                          indicationLable: indicationLable2,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          );
  }
}

class _LimitBlocWidget extends StatelessWidget {
  const _LimitBlocWidget({
    required this.title,
    required this.progress,
    required this.value,
    required this.indicationLable,
  });

  final String title;
  final double progress;
  final String value;
  final String indicationLable;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: STStyles.body1Bold,
        ),
        Text(
          value,
          style: STStyles.header6.copyWith(
            color: progress == 1 ? colors.red : colors.black,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        ProgressBar(
          value: progress,
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              indicationLable,
              style: STStyles.body2Bold.copyWith(
                color: colors.gray10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LoadingStateWidget extends StatelessWidget {
  const _LoadingStateWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 203,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SSkeletonLoader(
            width: 64,
            height: 24,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(
            height: 8,
          ),
          SSkeletonLoader(
            width: 120,
            height: 16,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(
            height: 38,
          ),
          const Row(
            children: [
              Expanded(
                child: _LoadingLimitBlock(),
              ),
              Expanded(
                child: _LoadingLimitBlock(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingLimitBlock extends StatelessWidget {
  const _LoadingLimitBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SSkeletonLoader(
          width: 120,
          height: 16,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(
          height: 8,
        ),
        SSkeletonLoader(
          width: 64,
          height: 24,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
