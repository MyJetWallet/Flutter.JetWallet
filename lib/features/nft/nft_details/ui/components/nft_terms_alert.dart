import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/nft/nft_details/store/nft_detail_store.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/services/device_size/device_size.dart';
import '../../../../../core/services/remote_config/remote_config_values.dart';
import '../../../../../utils/helpers/widget_size_from.dart';
import '../../../../earn/widgets/earn_subscription/components/earn_terms_checkbox.dart';

void sShowNftTermsAlertPopup(
  BuildContext context,
  NFTDetailStore store, {
  Function()? onWillPop,
  Function()? onSecondaryButtonTap,
  Function()? onPrivacyPolicyTap,
  String? secondaryText,
  String? secondaryText2,
  String? secondaryText3,
  String? secondaryButtonName,
  Widget? image,
  Widget? topSpacer,
  Widget? child,
  bool willPopScope = true,
  bool barrierDismissible = true,
  bool isNeedPrimaryButton = true,
  bool isActive = false,
  SButtonType primaryButtonType = SButtonType.primary1,
  required String primaryText,
  required String primaryButtonName,
  required Function() onPrimaryButtonTap,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return NftTermsAlert(
        store: store,
        onWillPop: onWillPop,
        onSecondaryButtonTap: onSecondaryButtonTap,
        onPrivacyPolicyTap: onPrivacyPolicyTap,
        secondaryText: secondaryText,
        secondaryText2: secondaryText2,
        secondaryText3: secondaryText3,
        secondaryButtonName: secondaryButtonName,
        image: image,
        topSpacer: topSpacer,
        willPopScope: willPopScope,
        barrierDismissible: barrierDismissible,
        isNeedPrimaryButton: isNeedPrimaryButton,
        primaryText: primaryText,
        primaryButtonName: primaryButtonName,
        onPrimaryButtonTap: onPrimaryButtonTap,
        isActive: isActive,
        child: child,
      );
    },
  );
}

class NftTermsAlert extends StatefulObserverWidget {
  const NftTermsAlert({
    Key? key,
    required this.store,
    this.onWillPop,
    this.onSecondaryButtonTap,
    this.onPrivacyPolicyTap,
    this.secondaryText,
    this.secondaryText2,
    this.secondaryText3,
    this.secondaryButtonName,
    this.image,
    this.topSpacer,
    this.child,
    this.willPopScope = true,
    this.barrierDismissible = true,
    this.activePrimaryButton = true,
    this.isNeedPrimaryButton = true,
    this.isActive = false,
    this.primaryButtonType = SButtonType.primary1,
    required this.primaryText,
    required this.primaryButtonName,
    required this.onPrimaryButtonTap,
  }) : super(key: key);

  final NFTDetailStore store;
  final Function()? onWillPop;
  final Function()? onSecondaryButtonTap;
  final Function()? onPrivacyPolicyTap;
  final String? secondaryText;
  final String? secondaryText2;
  final String? secondaryText3;
  final String? secondaryButtonName;
  final Widget? image;
  final Widget? topSpacer;
  final Widget? child;
  final bool willPopScope;
  final bool barrierDismissible;
  final bool activePrimaryButton;
  final bool isNeedPrimaryButton;
  final bool isActive;
  final SButtonType primaryButtonType;
  final String primaryText;
  final String primaryButtonName;
  final Function() onPrimaryButtonTap;

  @override
  _NftTermsAlertState createState() =>
      _NftTermsAlertState();
}

class _NftTermsAlertState extends State<NftTermsAlert> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkClicked() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final disclaimer = widget.store;
    final deviceSize = sDeviceSize;

    return WillPopScope(
      onWillPop: () {
        widget.onWillPop?.call();
        Navigator.pop(context);

        return Future.value(widget.willPopScope);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Dialog(
            insetPadding: (Platform.isAndroid ||
                widgetSizeFrom(deviceSize) == SWidgetSize.small)
                ? const EdgeInsets.all(24.0)
                : const EdgeInsets.symmetric(horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Column(
                children: [
                  widget.topSpacer ?? const SpaceH40(),
                  if (widget.image != null)
                    widget.image ?? const SizedBox.shrink()
                  else
                    Image.asset(
                      ellipsisAsset,
                      height: 80,
                      width: 80,
                      package: 'simple_kit',
                    ),
                  Baseline(
                    baseline: 40.0,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      widget.primaryText,
                      maxLines: (widget.secondaryText != null) ? 5 : 12,
                      textAlign: TextAlign.center,
                      style: sTextH5Style.copyWith(
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                  const SpaceH7(),
                  if (widget.secondaryText != null)
                    RichText(
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      text: TextSpan(
                        text: '${widget.secondaryText} ',
                        style: sBodyText1Style.copyWith(
                          color: colors.grey1,
                        ),
                        children: [
                          TextSpan(
                            text: '${widget.secondaryText2} ',
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onPrivacyPolicyTap,
                            style: sBodyText1Style.copyWith(
                              color: colors.blue,
                            ),
                          ),
                          TextSpan(
                            text: '${widget.secondaryText3} ',
                            style: sBodyText1Style.copyWith(
                              color: colors.grey1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.isNeedPrimaryButton) ...[
                    const SpaceH36(),
                  ] else ...[
                    const SpaceH20(),
                  ],

                  SizedBox(
                    width: MediaQuery.of(context).size.width - 96,
                    child: EarnTermsCheckbox(
                      firstText: '${intl.nft_disclaimer_checkBoxText} ',
                      privacyPolicyText: intl.nft_disclaimer_terms,
                      width: MediaQuery.of(context).size.width - 130,
                      isChecked: widget.store.isCheckBoxActive(),
                      onCheckboxTap: () {
                        checkClicked();
                        disclaimer.onCheckboxTap();
                      },
                      onPrivacyPolicyTap: () {
                        sRouter.navigate(
                          HelpCenterWebViewRouter(
                            link: nftTermsLink,
                          ),
                        );
                      },
                      colors: colors,
                    ),
                  ),
                  if (widgetSizeFrom(deviceSize) == SWidgetSize.small)
                    const SpaceH20(),
                  if (widget.isNeedPrimaryButton) ...[
                    if (widget.primaryButtonType == SButtonType.primary1)
                      SPrimaryButton1(
                        name: widget.primaryButtonName,
                        active: isChecked,
                        onTap: () => widget.onPrimaryButtonTap(),
                      )
                    else if (widget.primaryButtonType == SButtonType.primary2)
                      SPrimaryButton2(
                        name: widget.primaryButtonName,
                        active: isChecked,
                        onTap: () => widget.onPrimaryButtonTap(),
                      )
                    else
                      SPrimaryButton3(
                        name: widget.primaryButtonName,
                        active: isChecked,
                        onTap: () => widget.onPrimaryButtonTap(),
                      ),
                    if (widget.onSecondaryButtonTap != null &&
                        widget.secondaryButtonName != null) ...[
                      const SpaceH10(),
                      STextButton1(
                        name: widget.secondaryButtonName ?? '',
                        active: true,
                        onTap: () => widget.onSecondaryButtonTap!(),
                      ),
                    ],
                    const SpaceH20(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
