import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/iban/widgets/iban_item.dart';
import 'package:jetwallet/features/iban/widgets/iban_terms_container.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

void showDepositDetails(
  BuildContext context,
  VoidCallback onClose,
  bool isCJAccount,
  SimpleBankingAccount bankingAccount,
) {
  if (isCJAccount) {
    sShowBasicModalBottomSheet(
      context: context,
      pinned: SBottomSheetHeader(
        name: intl.account_bottom_sheet_header,
      ),
      scrollable: true,
      onDissmis: onClose,
      children: [
        const SpaceH12(),
        IbanTermsContainer(
          text1: intl.iban_terms_1,
          text2: intl.iban_terms_3,
        ),
        const SpaceH8(),
        IBanItem(
          name: intl.iban_benificiary,
          text: sSignalRModules.bankingProfileData?.simple?.account?.bankName ?? 'Simple Europe UAB',
        ),
        IBanItem(
          name: intl.iban_iban,
          text: sSignalRModules.bankingProfileData?.simple?.account?.iban ?? '',
        ),
        IBanItem(
          name: intl.iban_bic,
          text: sSignalRModules.bankingProfileData?.simple?.account?.bic ?? '',
        ),
        IBanItem(
          name: intl.iban_address,
          text: sSignalRModules.bankingProfileData?.simple?.account?.address ?? '',
        ),
        const SpaceH42(),
      ],
    );
  } else {
    sShowBasicModalBottomSheet(
      context: context,
      pinned: SBottomSheetHeader(
        name: intl.account_bottom_sheet_header,
      ),
      scrollable: true,
      onDissmis: onClose,
      children: [
        const SpaceH12(),
        IbanTermsContainer(
          text1: intl.iban_terms_1,
          text2: intl.iban_terms_5,
        ),
        const SpaceH8(),
        IBanItem(
          name: intl.iban_benificiary,
          text: '${sUserInfo.firstName} ${sUserInfo.lastName}',
        ),
        IBanItem(
          name: intl.iban_iban,
          text: bankingAccount.iban ?? '',
        ),
        IBanItem(
          name: intl.iban_bic,
          text: bankingAccount.bic ?? '',
        ),
        IBanItem(
          name: intl.iban_address,
          text: bankingAccount.address ?? '',
        ),
        const SpaceH42(),
      ],
    );
  }
}
