import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../simple_kit.dart';
import '../src/theme/provider/simple_theme_pod.dart';
import 'account/buttons/simple_account_buttons_example.dart';
import 'account/headers/simple_account_headers_example.dart';
import 'account/indicators/simple_account_indicators_example.dart';
import 'account/simple_account_example.dart';
import 'action_sheet/examples/simple_common_action_sheet_example.dart';
import 'action_sheet/examples/simple_menu_action_sheet_example.dart';
import 'action_sheet/simple_action_sheet_example.dart';
import 'actions/examples/simple_action_confirm_alert_example.dart';
import 'actions/examples/simple_action_confirm_description_example.dart';
import 'actions/examples/simple_action_confirm_skeleton_loader_example.dart';
import 'actions/examples/simple_action_confirm_text_example.dart';
import 'actions/examples/simple_action_price_field_example.dart';
import 'actions/examples/simple_payment_select_asset_example.dart';
import 'actions/examples/simple_payment_select_contact_example.dart';
import 'actions/examples/simple_payment_select_contact_without_name_example.dart';
import 'actions/examples/simple_payment_select_default_example.dart';
import 'actions/examples/simple_payment_select_fiat_example.dart';
import 'actions/simple_actions_example.dart';
import 'agreements/examples/simple_password_requirement_example.dart';
import 'agreements/examples/simple_privacy_policy_example.dart';
import 'agreements/simple_agreements_example.dart';
import 'asset_items/examples/simple_action_item_example.dart';
import 'asset_items/examples/simple_asset_item_example.dart';
import 'asset_items/examples/simple_fiat_item_example.dart';
import 'asset_items/examples/simple_market_item_example.dart';
import 'asset_items/examples/simple_wallet_item_example.dart';
import 'asset_items/simple_asset_items_example.dart';
import 'banners/rewards_banner/simple_rewards_banner_example.dart';
import 'banners/simple_banners_example.dart';
import 'bottom_navigation_bar/simple_bottom_navigation_bar_example.dart';
import 'buttons/examples/simple_link_button_example.dart';
import 'buttons/examples/simple_primary_button_example.dart';
import 'buttons/examples/simple_secondary_button_example.dart';
import 'buttons/examples/simple_text_button_example.dart';
import 'buttons/simple_buttons_example.dart';
import 'colors/simple_colors_example.dart';
import 'fields/examples/simple_confirmation_code_field_example.dart';
import 'fields/examples/simple_pin_code_field_example.dart';
import 'fields/examples/simple_standard_field_example.dart';
import 'fields/simple_fields_example.dart';
import 'headers/examples/simple_big_headers_example.dart';
import 'headers/examples/simple_market_headers_example.dart';
import 'headers/examples/simple_small_headers_example.dart';
import 'headers/simple_headers_example.dart';
import 'icons/examples/simple_icons_102x56_example.dart';
import 'icons/examples/simple_icons_16x16_example.dart';
import 'icons/examples/simple_icons_24x24_example.dart';
import 'icons/examples/simple_icons_36x36_example.dart';
import 'icons/examples/simple_icons_40x40_example.dart';
import 'icons/examples/simple_icons_56x56_example.dart';
import 'icons/simple_icons_example.dart';
import 'keyboards/examples/simple_numeric_keyboard_amount/simple_numeric_keyboard_amount_example.dart';
import 'keyboards/examples/simple_numeric_keyboard_amount/simple_numeric_keyboard_amount_guides.dart';
import 'keyboards/examples/simple_numeric_keyboard_pin/simple_numeric_keyboard_pin_example.dart';
import 'keyboards/examples/simple_numeric_keyboard_pin/simple_numeric_keyboard_pin_guides.dart';
import 'keyboards/simple_keyboards_example.dart';
import 'notifications/simple_notifications_example.dart';
import 'shared.dart';
import 'texts/simple_texts_example.dart';

class ExampleScreen extends ConsumerWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(sThemePod);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () {
        return CupertinoApp(
          theme: theme,
          debugShowCheckedModeBanner: false,
          initialRoute: Home.routeName,
          routes: {
            Home.routeName: (context) => const Home(),
            SimpleBannersExample.routeName: (context) {
              return const SimpleBannersExample();
            },
            SimpleRewardsBannerExample.routeName: (context) {
              return const SimpleRewardsBannerExample();
            },
            SimpleAccountExample.routeName: (context) {
              return const SimpleAccountExample();
            },
            SimpleAccountButtonsExample.routeName: (context) {
              return const SimpleAccountButtonsExample();
            },
            SimpleAccountHeadersExample.routeName: (context) {
              return const SimpleAccountHeadersExample();
            },
            SimpleAccountIndicatorsExample.routeName: (context) {
              return const SimpleAccountIndicatorsExample();
            },
            SimpleButtonsExample.routeName: (context) {
              return const SimpleButtonsExample();
            },
            SimplePrimaryButtonExample.routeName: (context) {
              return const SimplePrimaryButtonExample();
            },
            SimpleSecondaryButtonExample.routeName: (context) {
              return const SimpleSecondaryButtonExample();
            },
            SimpleTextButtonExample.routeName: (context) {
              return const SimpleTextButtonExample();
            },
            SimpleLinkButtonExample.routeName: (context) {
              return const SimpleLinkButtonExample();
            },
            SimpleColorsExample.routeName: (context) {
              return const SimpleColorsExample();
            },
            SimpleTextsExample.routeName: (context) {
              return const SimpleTextsExample();
            },
            SimpleFieldsExample.routeName: (context) {
              return const SimpleFieldsExample();
            },
            SimpleConfirmationCodeFieldExample.routeName: (context) {
              return const SimpleConfirmationCodeFieldExample();
            },
            SimplePinCodeFieldExample.routeName: (context) {
              return const SimplePinCodeFieldExample();
            },
            SimpleStandardFieldExample.routeName: (context) {
              return const SimpleStandardFieldExample();
            },
            SimpleIconsExample.routeName: (context) {
              return const SimpleIconsExample();
            },
            SimpleIcons16X16Example.routeName: (context) {
              return const SimpleIcons16X16Example();
            },
            SimpleIcons24X24Example.routeName: (context) {
              return const SimpleIcons24X24Example();
            },
            SimpleIcons36X36Example.routeName: (context) {
              return const SimpleIcons36X36Example();
            },
            SimpleIcons40X40Example.routeName: (context) {
              return const SimpleIcons40X40Example();
            },
            SimpleIcons102X56Example.routeName: (context) {
              return const SimpleIcons102X56Example();
            },
            SimpleIcons56X56Example.routeName: (context) {
              return const SimpleIcons56X56Example();
            },
            SimpleHeadersExample.routeName: (context) {
              return const SimpleHeadersExample();
            },
            SimpleSmallHeadersExample.routeName: (context) {
              return const SimpleSmallHeadersExample();
            },
            SimpleBigHeadersExample.routeName: (context) {
              return const SimpleBigHeadersExample();
            },
            SimpleMarketHeadersExample.routeName: (context) {
              return const SimpleMarketHeadersExample();
            },
            SimpleAgreementsExample.routeName: (context) {
              return const SimpleAgreementsExample();
            },
            SimplePasswordRequirementExample.routeName: (context) {
              return const SimplePasswordRequirementExample();
            },
            SimplePrivacyPolicyExample.routeName: (context) {
              return const SimplePrivacyPolicyExample();
            },
            SimpleNotificationsExample.routeName: (context) {
              return const SimpleNotificationsExample();
            },
            SimpleKeyboardsExample.routeName: (context) {
              return const SimpleKeyboardsExample();
            },
            SimpleNumericKeyboardAmountExample.routeName: (context) {
              return const SimpleNumericKeyboardAmountExample();
            },
            SimpleNumericKeyboardPinExample.routeName: (context) {
              return const SimpleNumericKeyboardPinExample();
            },
            SimpleNumericKeyboardAmountGuides.routeName: (context) {
              return const SimpleNumericKeyboardAmountGuides();
            },
            SimpleNumericKeyboardPinGuides.routeName: (context) {
              return const SimpleNumericKeyboardPinGuides();
            },
            SimpleBottomNavigationBarExample.routeName: (context) {
              return const SimpleBottomNavigationBarExample();
            },
            SimpleActionSheetExample.routeName: (context) {
              return const SimpleActionSheetExample();
            },
            SimpleCommonActionSheetExample.routeName: (context) {
              return const SimpleCommonActionSheetExample();
            },
            SimpleMenuActionSheetExample.routeName: (context) {
              return const SimpleMenuActionSheetExample();
            },
            SimpleAssetItemExample.routeName: (context) {
              return const SimpleAssetItemExample();
            },
            SimpleFiatItemExample.routeName: (context) {
              return const SimpleFiatItemExample();
            },
            SimpleActionItemExample.routeName: (context) {
              return const SimpleActionItemExample();
            },
            SimpleMarketItemExample.routeName: (context) {
              return const SimpleMarketItemExample();
            },
            SimpleWalletItemExample.routeName: (context) {
              return const SimpleWalletItemExample();
            },
            SimpleAssetItemsExample.routeName: (context) {
              return const SimpleAssetItemsExample();
            },
            SimpleActionsExample.routeName: (context) {
              return const SimpleActionsExample();
            },
            SimpleActionPriceFieldExample.routeName: (context) {
              return const SimpleActionPriceFieldExample();
            },
            SimplePaymentSelectAssetExample.routeName: (context) {
              return const SimplePaymentSelectAssetExample();
            },
            SimplePaymentSelectDefaultExample.routeName: (context) {
              return const SimplePaymentSelectDefaultExample();
            },
            SimplePaymentSelectFiatExample.routeName: (context) {
              return const SimplePaymentSelectFiatExample();
            },
            SimpleActionConfirmTextExample.routeName: (context) {
              return const SimpleActionConfirmTextExample();
            },
            SimpleActionConfrimDescriptionExample.routeName: (context) {
              return const SimpleActionConfrimDescriptionExample();
            },
            SimpleActionConfrimSkeletonLoaderExample.routeName: (context) {
              return const SimpleActionConfrimSkeletonLoaderExample();
            },
            SimpleActionConfrimAlertExample.routeName: (context) {
              return const SimpleActionConfrimAlertExample();
            },
            SimplePaymentSelectContactExample.routeName: (context) {
              return const SimplePaymentSelectContactExample();
            },
            SimplePaymentSelectContactWithoutNameExample.routeName: (context) {
              return const SimplePaymentSelectContactWithoutNameExample();
            }
          },
        );
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: const [
            ThemeSwitch(),
            NavigationButton(
              buttonName: 'Banners',
              routeName: SimpleBannersExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Account',
              routeName: SimpleAccountExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Buttons',
              routeName: SimpleButtonsExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Colors',
              routeName: SimpleColorsExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Texts',
              routeName: SimpleTextsExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Fields',
              routeName: SimpleFieldsExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Icons',
              routeName: SimpleIconsExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Headers',
              routeName: SimpleHeadersExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Agreements',
              routeName: SimpleAgreementsExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Notifications',
              routeName: SimpleNotificationsExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Keyboards',
              routeName: SimpleKeyboardsExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Bottom Navigation Bar',
              routeName: SimpleBottomNavigationBarExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Action Sheet',
              routeName: SimpleActionSheetExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Asset Items',
              routeName: SimpleAssetItemsExample.routeName,
            ),
            NavigationButton(
              buttonName: 'Actions',
              routeName: SimpleActionsExample.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
