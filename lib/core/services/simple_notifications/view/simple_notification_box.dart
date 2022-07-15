import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:simple_kit/simple_kit.dart';

class SNotificationBox extends StatelessWidget {
  const SNotificationBox({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SpaceH60(),
        Container(
          decoration: BoxDecoration(
            color: getIt.get<SimpleKit>().colors.red,
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: SErrorIcon(
                  color: getIt.get<SimpleKit>().colors.white,
                ),
              ),
              const SpaceW10(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 18,
                    bottom: 22,
                  ),
                  child: Text(
                    text,
                    maxLines: 10,
                    style: sBodyText1Style.copyWith(
                      color: getIt.get<SimpleKit>().colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
