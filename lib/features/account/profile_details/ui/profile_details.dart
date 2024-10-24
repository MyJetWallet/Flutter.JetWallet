import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/account/profile_details/utils/change_languages_popup.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

import '../../../../utils/helpers/country_code_by_user_register.dart';
import '../../../market/market_details/helper/currency_from_all.dart';

@RoutePage(name: 'ProfileDetailsRouter')
class ProfileDetails extends StatefulObserverWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    final baseAsset = sSignalRModules.baseCurrency;
    final currencies = sSignalRModules.currenciesWithHiddenList;
    final baseCurrency = currencyFromAll(currencies, baseAsset.symbol);
    final phoneNumber = countryCodeByUserRegister();

    var finalPhone = sUserInfo.phone;
    if (phoneNumber != null) {
      finalPhone = sUserInfo.phone.replaceFirst(
        phoneNumber.countryCode,
        '${phoneNumber.countryCode} ',
      );
    }

    String getTextLocale() {
      final langIndex = availableLanguages.indexWhere(
        (element) => element.langCode == getIt.get<AppStore>().locale?.languageCode,
      );

      return langIndex != -1 ? availableLanguages[langIndex].label : availableLanguages[0].label;
    }

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.profileDetails_profileDetails,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: [
          SProfileDetailsButton(
            showIcon: true,
            label: intl.profileDetails_email,
            value: getIt.get<AppStore>().authState.email.toLowerCase(),
            onTap: () {
              sRouter.push(
                PinScreenRoute(
                  union: const Change(),
                  isChangePhone: true,
                  onChangePhone: (String newPin) {
                    sRouter.replace(ChangeEmailRouter(pin: newPin));
                  },
                  onWrongPin: (String error) {},
                ),
              );
            },
          ),
          if (sUserInfo.isPhoneNumberSet)
            SProfileDetailsButton(
              showIcon: true,
              label: intl.setPhoneNumber_phoneNumber,
              value: finalPhone,
              onTap: () {
                showSendTimerAlertOr(
                  context: context,
                  or: () {
                    sRouter.push(
                      SetPhoneNumberRouter(
                        successText: intl.profileDetails_newPhoneNumberConfirmed,
                        isChangePhone: true,
                        then: () {
                          sRouter.popUntil(
                            (route) {
                              return route.settings.name == 'ProfileDetailsRouter';
                            },
                          );
                        },
                      ),
                    );
                  },
                  from: [BlockingType.phoneNumberUpdate],
                );
              },
            ),
          SProfileDetailsButton(
            showIcon: true,
            label: intl.profileDetails_baseCurrency,
            value: baseCurrency.description,
            onTap: () {
              sRouter.push(
                const DefaultAssetChangeRouter(),
              );
            },
          ),
          SProfileDetailsButton(
            isDivider: false,
            showIcon: true,
            label: intl.preferred_language,
            value: getTextLocale(),
            onTap: () async {
              await changeLanguagePopup(context);

              setState(() {});
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 42),
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
