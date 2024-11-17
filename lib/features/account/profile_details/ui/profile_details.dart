import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/account/delete_profile/store/delete_profile_store.dart';
import 'package:jetwallet/features/account/profile_details/utils/change_languages_popup.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
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
      header: GlobalBasicAppBar(
        title: intl.profileDetails_profileDetails,
        hasRightIcon: false,
      ),
      child: Column(
        children: [
          SCopyable(
            label: intl.profileDetails_email,
            value: getIt.get<AppStore>().authState.email.toLowerCase(),
            icon: Assets.svg.medium.edit.simpleSvg(),
            onIconTap: () {
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: SDivider(withHorizontalPadding: true),
          ),
          if (sUserInfo.isPhoneNumberSet) ...[
            SCopyable(
              label: intl.setPhoneNumber_phoneNumber,
              value: finalPhone,
              icon: Assets.svg.medium.edit.simpleSvg(),
              onIconTap: () {
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: SDivider(withHorizontalPadding: true),
            ),
          ],
          SCopyable(
            label: intl.profileDetails_baseCurrency,
            value: baseCurrency.description,
            icon: Assets.svg.medium.edit.simpleSvg(),
            onIconTap: () {
              sRouter.push(
                const DefaultAssetChangeRouter(),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: SDivider(withHorizontalPadding: true),
          ),
          SCopyable(
            label: intl.preferred_language,
            value: getTextLocale(),
            icon: Assets.svg.medium.edit.simpleSvg(),
            onIconTap: () async {
              await changeLanguagePopup(context);

              setState(() {});
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 42),
            child: SButton.outlined(
              icon: const SCircleMinusIcon(),
              text: intl.profileDetails_deleteProfile,
              callback: () {
                sShowAlertPopup(
                  context,
                  primaryText: '${intl.profileDetails_deleteProfile}?',
                  secondaryText: intl.profileDetails_deleteProfileDescr,
                  primaryButtonName: intl.profileDetails_yes,
                  isPrimaryButtonRed: true,
                  onPrimaryButtonTap: deleteAcc,
                  isNeedCancelButton: true,
                  cancelText: intl.profileDetails_no,
                  onCancelButtonTap: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void deleteAcc() {
    getIt.get<DeleteProfileStore>().loadDeleteReason();

    final currencies = sSignalRModules.currenciesList;
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);

    var totalBalance = Decimal.zero;
    for (final item in itemsWithBalance) {
      totalBalance += item.baseBalance;
    }

    final simpleCoinBalance = sSignalRModules.smplWalletModel.profile.balance;

    if (totalBalance > Decimal.zero || simpleCoinBalance > Decimal.zero) {
      sRouter.push(
        DeleteProfileRouter(
          totalBalance: totalBalance,
          simpleCoinBalance: simpleCoinBalance,
        ),
      );
    } else {
      sRouter.push(
        const EmailConfirmationRouter(),
      );
    }
  }
}
