import 'package:flutter/material.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

void showKycPopup({
  String? imageAsset,
  String? secondaryButtonName,
  Function()? onSecondaryButtonTap,
  Widget? child,
  bool activePrimaryButton = true,
  SWidgetSize size = SWidgetSize.medium,
  required BuildContext context,
  required String primaryText,
  required String secondaryText,
  required String primaryButtonName,
  required Function() onPrimaryButtonTap,
}) {
  sShowAlertPopup(
    context,
    image: imageAsset != null
        ? Image.asset(
            imageAsset,
            height: 80,
            width: 80,
          )
        : null,
    primaryText: primaryText,
    secondaryText: secondaryText,
    child: child,
    primaryButtonName: primaryButtonName,
    secondaryButtonName: secondaryButtonName,
    onPrimaryButtonTap: onPrimaryButtonTap,
    onSecondaryButtonTap: onSecondaryButtonTap,
    activePrimaryButton: activePrimaryButton,
  );
}
