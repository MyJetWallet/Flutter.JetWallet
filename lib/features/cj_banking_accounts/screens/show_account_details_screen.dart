import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/anchors/anchors_helper.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/iban/widgets/iban_item.dart';
import 'package:jetwallet/features/iban/widgets/iban_terms_container.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

void showAccountDetails({
  required BuildContext context,
  required VoidCallback onClose,
  required SimpleBankingAccount bankingAccount,
}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.white,
      pageBuilder: (BuildContext context, _, __) {
        return _AccountDetailsBody(bankingAccount: bankingAccount);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  ).then((value) {
    onClose();
  });
}

class _AccountDetailsBody extends StatelessWidget {
  const _AccountDetailsBody({required this.bankingAccount});

  final SimpleBankingAccount bankingAccount;

  @override
  Widget build(BuildContext context) {
    final isCJAccount = bankingAccount.isClearjuctionAccount;

    return SPageFrame(
      loaderText: '',
      header: GlobalBasicAppBar(
        title: intl.account_bottom_sheet_header,
        hasLeftIcon: false,
        onRightIconTap: () {
          sRouter.maybePop();
        },
      ),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: isCJAccount
                  ? [
                      IbanTermsContainer(
                        text1: intl.iban_deposit_text,
                        text2: intl.iban_terms_3,
                      ),
                      const SpaceH8(),
                      IBanItem(
                        name: intl.iban_benificiary,
                        text: sSignalRModules.bankingProfileData?.simple?.account?.bankName ?? 'Simple Europe UAB',
                        afterCopy: () {
                          unawaited(
                            AnchorsHelper().addBankingAccountDetailsAnchor(
                              sSignalRModules.bankingProfileData?.simple?.account?.accountId ?? '',
                            ),
                          );

                          sAnalytics.eurWalletTapCopyDeposit(
                            isCJ: true,
                            eurAccountLabel: bankingAccount.label ?? '',
                            isHasTransaction: false,
                            copyType: intl.iban_benificiary,
                          );
                        },
                      ),
                      IBanItem(
                        name: intl.iban_iban,
                        text: sSignalRModules.bankingProfileData?.simple?.account?.iban ?? '',
                        afterCopy: () {
                          unawaited(
                            AnchorsHelper().addBankingAccountDetailsAnchor(
                              sSignalRModules.bankingProfileData?.simple?.account?.accountId ?? '',
                            ),
                          );

                          sAnalytics.eurWalletTapCopyDeposit(
                            isCJ: true,
                            eurAccountLabel: bankingAccount.label ?? '',
                            isHasTransaction: false,
                            copyType: intl.iban_iban,
                          );
                        },
                      ),
                      IBanItem(
                        name: intl.iban_bic,
                        text: sSignalRModules.bankingProfileData?.simple?.account?.bic ?? '',
                        afterCopy: () {
                          AnchorsHelper().addBankingAccountDetailsAnchor(
                            sSignalRModules.bankingProfileData?.simple?.account?.accountId ?? '',
                          );

                          sAnalytics.eurWalletTapCopyDeposit(
                            isCJ: true,
                            eurAccountLabel: bankingAccount.label ?? '',
                            isHasTransaction: false,
                            copyType: intl.iban_bic,
                          );
                        },
                      ),
                      IBanItem(
                        name: intl.iban_address,
                        text: sSignalRModules.bankingProfileData?.simple?.account?.address ?? '',
                        afterCopy: () {
                          AnchorsHelper().addBankingAccountDetailsAnchor(
                            sSignalRModules.bankingProfileData?.simple?.account?.accountId ?? '',
                          );

                          sAnalytics.eurWalletTapCopyDeposit(
                            isCJ: true,
                            eurAccountLabel: bankingAccount.label ?? '',
                            isHasTransaction: false,
                            copyType: intl.iban_address,
                          );
                        },
                      ),
                      const SpaceH42(),
                    ]
                  : [
                      const SpaceH12(),
                      IbanTermsContainer(
                        text1: intl.iban_deposit_text,
                        text2: intl.iban_terms_5,
                      ),
                      const SpaceH8(),
                      IBanItem(
                        name: intl.iban_benificiary,
                        text: '${bankingAccount.holderFirstName} ${bankingAccount.holderLastName}',
                        afterCopy: () {
                          AnchorsHelper().addBankingAccountDetailsAnchor(bankingAccount.accountId ?? '');

                          sAnalytics.eurWalletTapCopyDeposit(
                            isCJ: false,
                            eurAccountLabel: bankingAccount.label ?? '',
                            isHasTransaction: false,
                            copyType: intl.iban_benificiary,
                          );
                        },
                      ),
                      IBanItem(
                        name: intl.iban_iban,
                        text: bankingAccount.iban ?? '',
                        afterCopy: () {
                          AnchorsHelper().addBankingAccountDetailsAnchor(bankingAccount.accountId ?? '');

                          sAnalytics.eurWalletTapCopyDeposit(
                            isCJ: false,
                            eurAccountLabel: bankingAccount.label ?? '',
                            isHasTransaction: false,
                            copyType: intl.iban_iban,
                          );
                        },
                      ),
                      IBanItem(
                        name: intl.iban_bic,
                        text: bankingAccount.bic ?? '',
                        afterCopy: () {
                          AnchorsHelper().addBankingAccountDetailsAnchor(bankingAccount.accountId ?? '');

                          sAnalytics.eurWalletTapCopyDeposit(
                            isCJ: false,
                            eurAccountLabel: bankingAccount.label ?? '',
                            isHasTransaction: false,
                            copyType: intl.iban_bic,
                          );
                        },
                      ),
                      IBanItem(
                        name: intl.iban_address,
                        text: bankingAccount.address ?? '',
                        afterCopy: () {
                          AnchorsHelper().addBankingAccountDetailsAnchor(bankingAccount.accountId ?? '');

                          sAnalytics.eurWalletTapCopyDeposit(
                            isCJ: false,
                            eurAccountLabel: bankingAccount.label ?? '',
                            isHasTransaction: false,
                            copyType: intl.iban_address,
                          );
                        },
                      ),
                      const SpaceH42(),
                    ],
            ),
          ),
        ],
      ),
    );
  }
}
