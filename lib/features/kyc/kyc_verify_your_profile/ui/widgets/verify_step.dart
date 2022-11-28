import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class VerifyStep extends StatelessWidget {
  const VerifyStep({
    Key? key,
    this.completeIcon = false,
    this.isSDivider = false,
    required this.title,
    required this.color,
  }) : super(key: key);

  final bool completeIcon;
  final bool isSDivider;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 64.0,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: sSubtitle2Style.copyWith(
                    color: color,
                  ),
                ),
              ),
              if (completeIcon) const SCompleteIcon(),
            ],
          ),
        ),
        if (isSDivider) const SDivider(),
      ],
    );
  }
}
