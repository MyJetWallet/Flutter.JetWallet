import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/high_yield_disclaimer/high_yield_disclaimer_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';
import 'earn_terms_alert.dart';
import 'earn_terms_checkbox.dart';

class SubscriptionsItem extends StatelessWidget {
  const SubscriptionsItem({
    super.key,
    this.days = 0,
    this.onTap,
    required this.isHot,
    required this.earnOffer,
    required this.currency,
  });

  final bool isHot;
  final int days;
  final EarnOfferModel earnOffer;
  final CurrencyModel currency;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Provider<HighYieldDisclaimer>(
      create: (context) => HighYieldDisclaimer(),
      builder: (context, child) => _SubscriptionsItemBody(
        days: days,
        isHot: isHot,
        earnOffer: earnOffer,
        currency: currency,
        onTap: onTap,
      ),
    );
  }
}

class _SubscriptionsItemBody extends StatelessObserverWidget {
  const _SubscriptionsItemBody({
    Key? key,
    this.onTap,
    this.days = 0,
    required this.isHot,
    required this.earnOffer,
    required this.currency,
  }) : super(key: key);

  final bool isHot;
  final int days;
  final EarnOfferModel earnOffer;
  final CurrencyModel currency;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final kyc = getIt.get<KycService>();

    final disclaimer = HighYieldDisclaimer.of(context);

    final handler = getIt.get<KycAlertHandler>();
    final userInfo = sUserInfo.userInfo;
    var apy = Decimal.zero;

    for (final element in earnOffer.tiers) {
      if (element.apy > apy) {
        apy = element.apy;
      }
    }

    return Column(
      children: [
        InkWell(
          highlightColor: colors.grey5,
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            if (onTap != null) {
              onTap!.call();
            } else {
              if (userInfo.hasHighYieldDisclaimers && !disclaimer.send) {
                sShowEarnTermsAlertPopup(
                  context,
                  disclaimer as HighYieldDisclaimer,
                  willPopScope: false,
                  image: Image.asset(
                    disclaimerAsset,
                    width: 80,
                    height: 80,
                  ),
                  primaryText: intl.earn_terms_title,
                  secondaryText: intl.earn_terms_description,
                  primaryButtonName: intl.earn_terms_continue,
                  onPrimaryButtonTap: () {
                    disclaimer.sendAnswers(
                          () {
                        if (kyc.depositStatus ==
                            kycOperationStatus(KycStatus.allowed)) {
                          Navigator.pop(context);
                          sRouter.push(
                            HighYieldBuyRouter(
                              currency: currency,
                              earnOffer: earnOffer,
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                          handler.handle(
                            status: kyc.depositStatus,
                            isProgress: kyc.verificationInProgress,
                            currentNavigate: () => SubscriptionsItem(
                              days: days,
                              isHot: isHot,
                              earnOffer: earnOffer,
                              currency: currency,
                            ),
                            requiredDocuments: kyc.requiredDocuments,
                            requiredVerifications: kyc.requiredVerifications,
                          );
                        }
                      },
                    );
                  },
                  secondaryButtonName: intl.earn_terms_cancel,
                  child: EarnTermsCheckbox(
                    width: MediaQuery.of(context).size.width - 130,
                    firstText: intl.earn_terms_checkbox,
                    privacyPolicyText: intl.earn_terms_link,
                    isChecked: disclaimer.isCheckBoxActive(),
                    onCheckboxTap: () {
                      disclaimer.onCheckboxTap();
                    },
                    onPrivacyPolicyTap: () {
                      sRouter.navigate(
                        HelpCenterWebViewRouter(
                          link: privacyEarnLink,
                        ),
                      );
                    },
                    colors: colors,
                  ),
                  onSecondaryButtonTap: () {
                    disclaimer.disableCheckbox();
                    Navigator.pop(context);
                  },
                );
              } else if (kyc.depositStatus ==
                  kycOperationStatus(KycStatus.allowed)) {
                sRouter.navigate(
                  HighYieldBuyRouter(
                    currency: currency,
                    earnOffer: earnOffer,
                  ),
                );
              } else {
                handler.handle(
                  status: kyc.depositStatus,
                  isProgress: kyc.verificationInProgress,
                  currentNavigate: () => SubscriptionsItem(
                    days: days,
                    isHot: isHot,
                    earnOffer: earnOffer,
                    currency: currency,
                  ),
                  requiredDocuments: kyc.requiredDocuments,
                  requiredVerifications: kyc.requiredVerifications,
                );
              }
            }
          },
          child: Ink(
            height: 88,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: colors.grey4,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isHot
                              ? '${intl.earn_hot} ${String.fromCharCodes(
                                  Runes('\u{1F525}'),
                                )}'
                              : intl.earn_flexible,
                          style: sSubtitle2Style.copyWith(
                            color: colors.black,
                          ),
                        ),
                        if (days > 0)
                          Text(
                            '$days ${days == 1 ? intl.earn_day_remaining : intl.earn_days_remaining}',
                            style: sBodyText2Style.copyWith(
                              color: colors.grey2,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '$apy%',
                      style: sTextH2Style.copyWith(
                        color: colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SpaceH10(),
      ],
    );
  }
}