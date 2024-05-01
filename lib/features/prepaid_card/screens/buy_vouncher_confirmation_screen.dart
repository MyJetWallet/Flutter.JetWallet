import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/prepaid_card/store/buy_vouncher_confirmation_store.dart';
import 'package:jetwallet/features/prepaid_card/utils/show_commision_explanation_bottom_sheet.dart';
import 'package:jetwallet/features/prepaid_card/utils/show_country_explanation_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/purchase_card_brand_list_response_model.dart';

@RoutePage(name: 'BuyVouncherConfirmationRoute')
class BuyVouncherConfirmationScreen extends StatelessWidget {
  const BuyVouncherConfirmationScreen({
    super.key,
    required this.brand,
    required this.amount,
    required this.country,
  });

  final PurchaseCardBrandDtoModel brand;
  final Decimal amount;
  final SPhoneNumber country;

  @override
  Widget build(BuildContext context) {
    return Provider<BuyVouncherConfirmationStore>(
      create: (context) => BuyVouncherConfirmationStore()
        ..loadPreview(
          amount: amount,
          brand: brand,
          country: country,
        ),
      builder: (context, child) => const _BuyVouncherConfirmationBody(),
    );
  }
}

class _BuyVouncherConfirmationBody extends StatelessObserverWidget {
  const _BuyVouncherConfirmationBody();

  @override
  Widget build(BuildContext context) {
    final store = BuyVouncherConfirmationStore.of(context);
    final colors = SColorsLight();

    return SPageFrameWithPadding(
      needPadding: false,
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      customLoader: store.showProcessing
          ? WaitingScreen(
              wasAction: store.wasAction,
              primaryText: intl.buy_confirmation_local_p2p_processing_title,
              onSkip: () {
                navigateToRouter();
              },
            )
          : null,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.buy_confirmation_title,
          subTitle: intl.prepaid_card_buy_voucher,
          subTitleStyle: sBodyText2Style.copyWith(
            color: colors.gray10,
          ),
          onBackButtonTap: () {
            sAnalytics.tapOnTheBackButtonFromOrderSummaryBuyCoucherScreenView(
              amount: volumeFormat(
                symbol: store.payCurrency.symbol,
                accuracy: store.payCurrency.accuracy,
                decimal: store.amount,
              ),
              country: store.country?.isoCode ?? '',
              isAvailableAppleGooglePay: store.prewievResponce?.brand.isMobile ?? false,
            );
            sRouter.maybePop();
          },
        ),
      ),
      child: CustomScrollView(
        slivers: [
          if (!(store.brand?.isMobile ?? false))
            SliverToBoxAdapter(
              child: SBannerBasic(
                text: Platform.isIOS
                    ? intl.prepaid_card_apple_pay_is_unavailable
                    : intl.prepaid_card_google_pay_is_unavailable,
                icon: Assets.svg.small.warning,
                color: colors.yellowExtralight,
                corners: BannerCorners.sharp,
              ),
            ),
          SliverToBoxAdapter(
            child: SPaddingH24(
              child: Column(
                children: [
                  WhatToWhatConvertWidget(
                    isLoading: !store.isDataLoaded,
                    fromAssetIconUrl: store.payCurrency.iconUrl,
                    fromAssetDescription: intl.prepaid_card_crypto_wallet,
                    fromAssetValue: volumeFormat(
                      symbol: store.payCurrency.symbol,
                      accuracy: store.payCurrency.accuracy,
                      decimal: store.amount,
                    ),
                    toAssetIconUrl: store.buyCurrency.iconUrl,
                    toAssetDescription: intl.prepaid_card_prepaid_card_voucher,
                    toAssetValue: volumeFormat(
                      decimal: store.amount,
                      accuracy: store.buyCurrency.accuracy,
                      symbol: store.buyCurrency.symbol,
                    ),
                  ),
                  const SDivider(),
                  const SizedBox(height: 19),
                  TwoColumnCell(
                    label: intl.prepaid_card_card_type,
                    value: store.brand?.brandName,
                    needHorizontalPadding: false,
                    leftValueIcon: (store.brand?.brandName.contains('Mastercard') ?? false)
                        ? Assets.svg.other.medium.mastercard.simpleSvg(
                            width: 20,
                            height: 20,
                          )
                        : Assets.svg.other.medium.visa.simpleSvg(
                            width: 20,
                            height: 20,
                          ),
                    valueMaxLines: 3,
                  ),
                  TwoColumnCell(
                    label: Platform.isIOS ? intl.prepaid_card_apple_pay : intl.prepaid_card_google_pay,
                    value: (store.brand?.isMobile ?? false) ? intl.prepaid_card_yes : intl.prepaid_card_no,
                    needHorizontalPadding: false,
                  ),
                  TwoColumnCell(
                    label: intl.prepaid_card_card_balance,
                    value: marketFormat(
                      decimal: store.prewievResponce?.amount ?? Decimal.zero,
                      symbol: store.buyCurrency.symbol,
                      accuracy: store.buyCurrency.accuracy,
                    ),
                    needHorizontalPadding: false,
                  ),
                  TwoColumnCell(
                    label: intl.prepaid_card_country,
                    value: store.country?.countryName,
                    needHorizontalPadding: false,
                    haveInfoIcon: true,
                    onTab: () {
                      showCountryExplanationBottomSheet(context);
                    },
                    valueMaxLines: 2,
                  ),
                  TwoColumnCell(
                    label: intl.prepaid_card_commission,
                    value: (store.prewievResponce?.commission ?? Decimal.zero) == Decimal.zero
                        ? intl.prepaid_card_free
                        : volumeFormat(
                            decimal: store.prewievResponce?.commission ?? Decimal.zero,
                            symbol: store.buyCurrency.symbol,
                          ),
                    customValueStyle: STStyles.subtitle2.copyWith(
                      color: (store.prewievResponce?.commission ?? Decimal.zero) == Decimal.zero
                          ? SColorsLight().green
                          : null,
                    ),
                    needHorizontalPadding: false,
                    haveInfoIcon: true,
                    onTab: () {
                      showCommisionExplanationBottomSheet(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  const SDivider(),
                  const SizedBox(height: 16),
                  SPolicyCheckbox(
                    height: 65,
                    firstText: intl.buy_confirmation_privacy_checkbox_1,
                    userAgreementText: intl.buy_confirmation_privacy_checkbox_2,
                    betweenText: ', ',
                    privacyPolicyText: intl.buy_confirmation_privacy_checkbox_3,
                    secondText: '',
                    activeText: '',
                    thirdText: '',
                    activeText2: '',
                    onCheckboxTap: () {
                      store.setIsBankTermsChecked();
                    },
                    onUserAgreementTap: () {
                      launchURL(context, prepaidCardTermsAndConditionsLink);
                    },
                    onPrivacyPolicyTap: () {
                      launchURL(context, privacyPolicyLink);
                    },
                    onActiveTextTap: () {},
                    onActiveText2Tap: () {},
                    isChecked: store.isBankTermsChecked,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: SPrimaryButton2(
                      active: !store.loader.loading && store.getCheckbox,
                      name: intl.previewBuyWithAsset_confirm,
                      onTap: () {
                        sAnalytics.tapOnTheConfirmButtonOnOrderSummaryBuyVoucherScreenView(
                          amount: volumeFormat(
                            symbol: store.payCurrency.symbol,
                            accuracy: store.payCurrency.accuracy,
                            decimal: store.amount,
                          ),
                          country: store.country?.isoCode ?? '',
                          isAvailableAppleGooglePay: store.prewievResponce?.brand.isMobile ?? false,
                        );
                        store.createPayment();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
