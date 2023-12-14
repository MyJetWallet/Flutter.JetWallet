import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/widgets/button/specific/specific_button.dart';
import 'package:simple_kit_updated/widgets/table/account_table/simple_account_table_base.dart';
import 'package:simple_kit_updated/widgets/table/account_table/simple_table_asset.dart';

class SimpleTableAccount extends StatelessWidget {
  const SimpleTableAccount({
    Key? key,
    required this.label,
    this.onTableAssetTap,
    this.supplement,
    this.rightValue,
    this.assetIcon,
    this.isCard = false,
    this.hasRightValue = true,
    this.hasLabelIcon = false,
    this.hasButton = false,
    this.isButtonLoading = false,
    this.buttonHasCardIcon = false,
    this.buttonHasRightArrow = true,
    this.isButtonSmall = false,
    this.isButtonLabelBold = false,
    this.buttonLabel,
    this.buttonTap,
    this.customRightWidget,
  }) : super(key: key);

  final Widget? assetIcon;
  final bool isCard;

  final VoidCallback? onTableAssetTap;

  final String label;
  final String? supplement;
  final bool hasLabelIcon;
  final bool hasRightValue;
  final String? rightValue;
  final Widget? customRightWidget;

  final bool hasButton;
  final bool isButtonLoading;
  final bool buttonHasCardIcon;
  final bool buttonHasRightArrow;
  final bool isButtonSmall;
  final bool isButtonLabelBold;
  final VoidCallback? buttonTap;
  final String? buttonLabel;

  @override
  Widget build(BuildContext context) {
    return SAccountTableBase(
      hasButton: hasButton,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SimpleTableAsset(
            onTableAssetTap: onTableAssetTap,
            isCard: isCard,
            assetIcon: assetIcon,
            needPadding: false,
            label: label,
            supplement: supplement,
            hasLabelIcon: hasLabelIcon,
            hasRightValue: hasRightValue,
            rightValue: rightValue,
            customRightWidget: customRightWidget,
          ),
          if (hasButton) ...[
            const Gap(8),
            Padding(
              padding: const EdgeInsets.only(
                left: 36,
              ),
              child: SpecificButton(
                isLoading: isButtonLoading,
                hasCardIcon: buttonHasCardIcon,
                hasRightArrow: buttonHasRightArrow,
                isButtonSmall: isButtonSmall,
                isLabelBold: isButtonLabelBold,
                label: buttonLabel ?? '',
                onTap: buttonTap,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
