import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/kyc/helper/show_kyc_popup.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

@lazySingleton
class KycAlertHandler {
  final BuildContext context = sRouter.navigatorKey.currentContext!;
  final SimpleColors colors = sKit.colors;

  // ignore: long-parameter-list
  void handle({
    bool navigatePop = false,
    bool kycFlowOnly = false,
    bool needGifteExplanationPopup = false,
    SWidgetSize size = SWidgetSize.medium,
    required Function() currentNavigate,
    required int status,
    required bool isProgress,
    required List<RequiredVerified> requiredVerifications,
    required List<KycDocumentType> requiredDocuments,
  }) {
    if (isProgress) {
      _showVerifyingAlert();

      return;
    }

    if (kycFlowOnly) {
      _navigateVerifiedNavigate(
        requiredVerifications,
        requiredDocuments,
      );

      return;
    }

    if (status == kycOperationStatus(KycStatus.kycRequired) && needGifteExplanationPopup) {
      _showGeftExplanationAlert(
        requiredVerifications.isNotEmpty,
        requiredVerifications,
        requiredDocuments,
        status,
        size,
      );
    } else if (status == kycOperationStatus(KycStatus.kycRequired)) {
      _showKycRequiredAlert(
        requiredVerifications.isNotEmpty,
        requiredVerifications,
        requiredDocuments,
        status,
        size,
      );
    } else if (status == kycOperationStatus(KycStatus.kycInProgress)) {
      _showVerifyingAlert();
    } else if (status == kycOperationStatus(KycStatus.allowedWithKycAlert)) {
      _showAllowedWithAlert(
        requiredVerifications,
        requiredDocuments,
        currentNavigate,
        navigatePop,
      );
    } else if (status == kycOperationStatus(KycStatus.blocked)) {
      _showBlockedAlert();
    }
  }

  void _showKycRequiredAlert(
    bool isRequiredVerifications,
    List<RequiredVerified> requiredVerifications,
    List<KycDocumentType> requiredDocuments,
    int status,
    SWidgetSize size,
  ) {
    sRouter.push(
      KycVerificationRouter(requiredVerifications: requiredVerifications),
    );
  }

  void _showVerifyingAlert() {
    sAnalytics.kycFlowVerifyingNowPopup();

    showKycPopup(
      context: context,
      imageAsset: verifyingNowAsset,
      primaryText: intl.kycAlertHandler_showVerifyingAlertPrimaryText,
      secondaryText: intl.kycAlertHandler_showVerifyingAlertSecondaryText,
      primaryButtonName: intl.kycAlertHandler_done,
      onPrimaryButtonTap: () {
        Navigator.pop(context);
      },
    );
  }

  void _showAllowedWithAlert(
    List<RequiredVerified> requiredVerifications,
    List<KycDocumentType> requiredDocuments,
    Function() currentNavigat,
    bool navigatePop,
  ) {
    showKycPopup(
      context: context,
      imageAsset: verifyYourProfileAsset,
      primaryText: '${intl.kycAlertHandler_verifyYourProfile}!',
      secondaryText: '${intl.kycAlertHandler_showKycPopupSecondaryText1}\n'
          '${intl.kycAlertHandler_showKycPopupSecondaryText}:',
      primaryButtonName: intl.kycAlertHandler_continue,
      secondaryButtonName: intl.kycAlertHandler_later,
      onPrimaryButtonTap: () {
        Navigator.pop(context);
        _navigateVerifiedNavigate(
          requiredVerifications,
          requiredDocuments,
        );
      },
      onSecondaryButtonTap: () {
        _navigateTo(currentNavigat, navigatePop);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_showDocuments(requiredVerifications)],
      ),
    );
  }

  void _showBlockedAlert() {
    sAnalytics.kycFlowYouBlockedPopup();

    showKycPopup(
      context: context,
      primaryText: '${intl.kycAlertHandler_youAreBlocked}!',
      secondaryText: '${intl.kycAlertHandler_showBlockedAlertSecondaryText1}\n'
          '${intl.kycAlertHandler_showBlockedAlertSecondaryText2}',
      primaryButtonName: intl.kycAlertHandler_support,
      onPrimaryButtonTap: () {
        Navigator.pop(context);

        sAnalytics.kycFlowYouBlockedSupportTap();

        sRouter.push(
          CrispRouter(
            welcomeText: intl.crispSendMessage_hi,
          ),
        );
      },
    );
  }

  void _showGeftExplanationAlert(
    bool isRequiredVerifications,
    List<RequiredVerified> requiredVerifications,
    List<KycDocumentType> requiredDocuments,
    int status,
    SWidgetSize size,
  ) {
    showKycPopup(
      context: context,
      imageAsset: verifyYourProfileAsset,
      primaryText: '${intl.kycAlertHandler_verifyYourProfile}!',
      secondaryText: 'Please verify your account\n to claim your gift',
      primaryButtonName: 'Verify',
      secondaryButtonName: intl.kycAlertHandler_later,
      onPrimaryButtonTap: () {
        _showKycRequiredAlert(
          requiredVerifications.isNotEmpty,
          requiredVerifications,
          requiredDocuments,
          status,
          size,
        );
      },
      onSecondaryButtonTap: () {
        sRouter.pop();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SDivider(),
          _documentText('Secure your account', 0),
          _documentText('Verify your identity', 1),
          _documentText('Claim your gift', 2),
          const SpaceH36(),
        ],
      ),
    );
  }

  void _navigateVerifiedNavigate(
    List<RequiredVerified> requiredVerifications,
    List<KycDocumentType> documents,
  ) {
    if (requiredVerifications.contains(RequiredVerified.proofOfPhone)) {
      sRouter.push(
        SetPhoneNumberRouter(
          successText: intl.kycAlertHandler_factorVerificationEnabled,
          then: () => sRouter.push(
            KycVerifyYourProfileRouter(
              requiredVerifications: requiredVerifications,
            ),
          ),
        ),
      );
    } else {
      sRouter.push(
        KycVerificationSumsubRouter(),
      );
    }
  }

  void _navigateTo(Function() currentNavigate, bool navigatePop) {
    if (navigatePop) {
      Navigator.of(context).pop();
    }
    currentNavigate();
  }

  Widget _showDocuments(List<RequiredVerified> requiredVerifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SDivider(),
        ..._listRequiredVerification(requiredVerifications),
        const SpaceH36(),
      ],
    );
  }

  Widget _documentText(String title, int textNumber) {
    return textNumber == 0
        ? Baseline(
            baseline: 37.0,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              '${textNumber + 1}. $title',
              style: sBodyText1Style.copyWith(
                color: colors.grey1,
              ),
            ),
          )
        : Column(
            children: [
              const SpaceH17(),
              Text(
                '${textNumber + 1}. $title',
                style: sBodyText1Style.copyWith(
                  color: colors.grey1,
                ),
              ),
            ],
          );
  }

  List<Widget> _listRequiredVerification(
    List<RequiredVerified> requiredVerifications,
  ) {
    final requiredVerified = <Widget>[];

    for (var i = 0; i < requiredVerifications.length; i++) {
      if (requiredVerifications[i] == RequiredVerified.proofOfIdentity) {
        requiredVerified.add(
          _documentText(intl.kycAlertHandler_verifyYourIdentity, i),
        );
      } else if (requiredVerifications[i] == RequiredVerified.proofOfAddress) {
        requiredVerified.add(
          _documentText(intl.kycAlertHandler_addressVerification, i),
        );
      } else if (requiredVerifications[i] == RequiredVerified.proofOfFunds) {
        requiredVerified.add(
          _documentText(intl.kycAlertHandler_proofSourceOfFunds, i),
        );
      } else if (requiredVerifications[i] == RequiredVerified.proofOfPhone) {
        requiredVerified.add(
          _documentText(intl.kycAlertHandler_secureYourAccount, i),
        );
      }
    }

    return requiredVerified;
  }
}
