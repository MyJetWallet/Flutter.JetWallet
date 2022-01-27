import 'package:charts/model/resolution_string_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class LoadingChartView extends HookWidget {
  const LoadingChartView({
    Key? key,
    required this.height,
    required this.showLoader,
  }) : super(key: key);

  final double height;
  final bool showLoader;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Container(
      height: height,
      width: double.infinity,
      color: colors.grey5,
      child: Stack(
        children: [
          if (showLoader)
            const Positioned(
              left: 0,
              right: 0,
              top: 80,
              child: LoaderSpinner(),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _resolutionButton(
                    text: Period.day,
                    showUnderline: true,
                  ),
                  _resolutionButton(
                    text: Period.week,
                    showUnderline: false,
                  ),
                  _resolutionButton(
                    text: Period.month,
                    showUnderline: false,
                  ),
                  _resolutionButton(
                    text: Period.year,
                    showUnderline: false,
                  ),
                  _resolutionButton(
                    text: Period.all,
                    showUnderline: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resolutionButton({
    void Function()? onTap,
    required String text,
    required bool showUnderline,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 36,
          margin: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (onTap != null) {
                onTap();
              }
            },
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (showUnderline)
          Container(
            width: 36,
            height: 3,
            margin: const EdgeInsets.only(
              top: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.black,
            ),
          )
        else
          const SizedBox(
            height: 8,
          )
      ],
    );
  }
}
