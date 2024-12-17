import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';

class NetworkItem extends StatelessWidget {
  const NetworkItem({
    super.key,
    required this.iconUrl,
    required this.network,
    required this.selected,
    required this.onTap,
  });

  final String iconUrl;
  final String network;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return InkWell(
      highlightColor: colors.gray2,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 64,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  top: 10,
                ),
                child: NetworkIconWidget(
                  iconUrl,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 7,
                  ),
                  child: Text(
                    network,
                    style: STStyles.subtitle1.copyWith(
                      color: selected ? colors.blue : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
