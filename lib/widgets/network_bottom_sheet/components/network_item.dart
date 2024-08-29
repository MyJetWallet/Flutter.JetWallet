import 'package:flutter/material.dart';
import 'package:jetwallet/widgets/currency_icon_widget.dart';
import 'package:simple_kit/simple_kit.dart';

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
    final colors = sKit.colors;

    return InkWell(
      highlightColor: colors.grey5,
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
                    style: sSubtitle2Style.copyWith(
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
