import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/phone_verification/ui/phone_verification.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../market/market_details/helper/currency_from_all.dart';

class ProfileDetails extends StatelessObserverWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = sUserInfo.userInfo;
    final baseAsset = sSignalRModules.baseCurrency;
    final currencies = sSignalRModules.currenciesWithHiddenList;
    final baseCurrency = currencyFromAll(currencies, baseAsset.symbol);

    final infoImage = Image.asset(
      phoneChangeAsset,
      width: 80,
      height: 80,
      package: 'simple_kit',
    );

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.profileDetails_profileDetails,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: [
          SProfileDetailsButton(
            label: intl.profileDetails_email,
            value: getIt.get<AppStore>().authState.email,
            onTap: () {},
          ),
          if (userInfo.isPhoneNumberSet)
            SProfileDetailsButton(
              label: intl.profileDetails_changePhoneNumber,
              value: userInfo.phone,
              onTap: () {
                sAnalytics.accountChangePhone();
                sAnalytics.accountChangePhoneWarning();

                sShowAlertPopup(
                  context,
                  willPopScope: false,
                  primaryText: intl.profileDetails_payAttention,
                  secondaryText: '${intl.profileDetails_changePhoneAlert2} '
                      '$changePhoneLockHours ${intl.hours}.',
                  primaryButtonName: intl.profileDetails_continue,
                  image: infoImage,
                  onPrimaryButtonTap: () {
                    sAnalytics.accountChangePhoneContinue();

                    Navigator.pop(context);
                    sRouter.push(
                      SetPhoneNumberRouter(
                        successText:
                            intl.profileDetails_newPhoneNumberConfirmed,
                        isChangePhone: true,
                        then: () {
                          sRouter.popUntil(
                            (route) {
                              return route.settings.name ==
                                  'ProfileDetailsRouter';
                            },
                          );
                        },
                      ),
                    );
                  },
                  secondaryButtonName: intl.profileDetails_cancel,
                  onSecondaryButtonTap: () {
                    sAnalytics.accountChangePhoneCancel();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          SProfileDetailsButton(
            label: intl.profileDetails_defaultCurrency,
            value: baseCurrency.description,
            onTap: () {
              sRouter.push(
                const DefaultAssetChangeRouter(),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: SSecondaryButton1(
              active: true,
              icon: const SCircleMinusIcon(),
              name: intl.profileDetails_deleteProfile,
              onTap: () {
                sShowAlertPopup(
                  context,
                  primaryText: '${intl.profileDetails_deleteProfile}?',
                  secondaryText: intl.profileDetails_deleteProfileDescr,
                  primaryButtonName: intl.profileDetails_deleteProfile,
                  primaryButtonType: SButtonType.primary3,
                  onPrimaryButtonTap: () => {
                    sRouter.push(
                      const DeleteProfileRouter(),
                    ),
                  },
                  isNeedCancelButton: true,
                  cancelText: intl.profileDetails_cancel,
                  onCancelButtonTap: () => {Navigator.pop(context)},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
