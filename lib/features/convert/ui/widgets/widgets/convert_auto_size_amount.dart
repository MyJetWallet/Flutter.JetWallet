import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';

class ConvertAutoSizeAmount extends StatelessObserverWidget {
  const ConvertAutoSizeAmount({
    super.key,
    required this.onTap,
    required this.value,
    required this.enabled,
  });

  final Function() onTap;
  final String value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Expanded(
      child: STransparentInkWell(
        onTap: onTap,
        child: AutoSizeText(
          // TODO: add reactive value (blocked by backend)
          value.isEmpty
              ? '${intl.min} 0.001'
              : formatCurrencyStringAmount(
                  value: value,
                  symbol: '',
                ),
          textAlign: TextAlign.end,
          minFontSize: 4.0,
          maxLines: 1,
          strutStyle: const StrutStyle(
            height: 1.29,
            fontSize: 28.0,
            fontFamily: 'Gilroy',
          ),
          style: TextStyle(
            height: 1.29,
            fontSize: 28.0,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            color: enabled
                ? value.isEmpty
                    ? colors.grey2
                    : colors.black
                : colors.grey2,
          ),
        ),
      ),
    );
  }
}
