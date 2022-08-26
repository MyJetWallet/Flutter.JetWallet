import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/constants.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../screens/account/components/crisp.dart';
import '../../set_phone_number/view/set_phone_number.dart';
import '../model/kyc_operation_status_model.dart';
import '../model/kyc_verified_model.dart';
import '../view/components/choose_documents/choose_documents.dart';
import '../view/components/kyc_verify_your_profile/kyc_verify_your_profile.dart';
import '../view/popup/show_kyc_popup.dart';

class KycAlertHandler {
  KycAlertHandler({
    required this.context,
    required this.colors,
  });

  final BuildContext context;
  final SimpleColors colors;

  void handle({
    bool navigatePop = false,
    bool kycFlowOnly = false,
    SWidgetSize size = SWidgetSize.medium,
    required Function() currentNavigate,
    required int status,
    required KycModel kycVerified,
    required bool isProgress,
  }) {
    if (isProgress) {
      _showVerifyingAlert();
      return;
    }

    if (kycFlowOnly) {
      _navigateVerifiedNavigate(
        kycVerified.requiredVerifications,
        kycVerified.requiredDocuments,
      );
      return;
    }

    if (status == kycOperationStatus(KycStatus.kycRequired)) {
      _showKycRequiredAlert(
        kycVerified,
        status,
        size,
      );
    } else if (status == kycOperationStatus(KycStatus.kycInProgress)) {
      _showVerifyingAlert();
    } else if (status == kycOperationStatus(KycStatus.allowedWithKycAlert)) {
      _showAllowedWithAlert(
        kycVerified,
        currentNavigate,
        navigatePop,
      );
    } else {
      _showBlockedAlert();
    }
  }

  void _showKycRequiredAlert(
    KycModel kycVerified,
    int status,
    SWidgetSize size,
  ) {
    final intl = context.read(intlPod);
    showKycPopup(
      context: context,
      imageAsset: verifyYourProfileAsset,
      primaryText: '${intl.kycAlertHandler_verifyYourProfile}!',
      secondaryText: '${intl.kycAlertHandler_showKycPopupSecondaryText1}\n'
          '${intl.kycAlertHandler_showKycPopupSecondaryText}:',
      primaryButtonName: intl.kycAlertHandler_continue,
      secondaryButtonName: intl.kycAlertHandler_later,
      activePrimaryButton: status == kycOperationStatus(KycStatus.kycRequired),
      onPrimaryButtonTap: () {
        Navigator.pop(context);
        _navigateVerifiedNavigate(
          kycVerified.requiredVerifications,
          kycVerified.requiredDocuments,
        );
      },
      onSecondaryButtonTap: () {
        Navigator.pop(context);
      },
      size: size,
      child: _showDocuments(kycVerified.requiredVerifications),
    );
  }

  void _showVerifyingAlert() {
    final intl = context.read(intlPod);

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
    KycModel kycVerified,
    Function() currentNavigat,
    bool navigatePop,
  ) {
    final intl = context.read(intlPod);

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
          kycVerified.requiredVerifications,
          kycVerified.requiredDocuments,
        );
      },
      onSecondaryButtonTap: () {
        _navigateTo(currentNavigat, navigatePop);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_showDocuments(kycVerified.requiredVerifications)],
      ),
    );
  }

  void _showBlockedAlert() {
    final intl = context.read(intlPod);

    showKycPopup(
      context: context,
      primaryText: '${intl.kycAlertHandler_youAreBlocked}!',
      secondaryText: '${intl.kycAlertHandler_showBlockedAlertSecondaryText1}\n'
          '${intl.kycAlertHandler_showBlockedAlertSecondaryText2}',
      primaryButtonName: intl.kycAlertHandler_support,
      onPrimaryButtonTap: () {
        Navigator.pop(context);
        Crisp.push(
          context,
          intl.crispSendMessage_hi,
        );
      },
    );
  }

  void _navigateVerifiedNavigate(
    List<RequiredVerified> requiredVerifications,
    List<KycDocumentType> documents,
  ) {
    final intl = context.read(intlPod);

    if (requiredVerifications.contains(RequiredVerified.proofOfPhone)) {
      SetPhoneNumber.push(
        context: context,
        successText: intl.kycAlertHandler_factorVerificationEnabled,
        then: () => KycVerifyYourProfile.push(
          context: context,
          requiredVerifications: requiredVerifications,
        ),
      );
    } else {
      ChooseDocuments.push(
        context: context,
        headerTitle: stringRequiredVerified(
          requiredVerifications.isEmpty
              ? RequiredVerified.proofOfIdentity
              : requiredVerifications.first,
          context,
        ),
        documents: documents,
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
    if (textNumber == 0) {
      return Baseline(
        baseline: 37.0,
        baselineType: TextBaseline.alphabetic,
        child: Text(
          '${textNumber + 1}. $title',
          style: sBodyText1Style.copyWith(
            color: colors.grey1,
          ),
        ),
      );
    } else {
      return Column(
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
  }

  List<Widget> _listRequiredVerification(
    List<RequiredVerified> requiredVerifications,
  ) {
    final intl = context.read(intlPod);

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
