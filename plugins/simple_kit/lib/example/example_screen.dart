import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../simple_kit.dart';
import '../src/theme/provider/simple_theme_pod.dart';
import 'agreements/examples/simple_password_requirement_example.dart';
import 'agreements/examples/simple_privacy_policy_example.dart';
import 'agreements/simple_agreements_example.dart';
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
import 'icons/examples/simple_icons_20x20_example.dart';
import 'icons/examples/simple_icons_24x24_example.dart';
import 'icons/examples/simple_icons_36x36_example.dart';
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
        return MaterialApp(
          theme: theme,
          debugShowCheckedModeBanner: false,
          initialRoute: Home.routeName,
          routes: {
            Home.routeName: (context) => const Home(),
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
            SimpleIcons20X20Example.routeName: (context) {
              return const SimpleIcons20X20Example();
            },
            SimpleIcons24X24Example.routeName: (context) {
              return const SimpleIcons24X24Example();
            },
            SimpleIcons36X36Example.routeName: (context) {
              return const SimpleIcons36X36Example();
            },
            SimpleIcons102X56Example.routeName: (context) {
              return const SimpleIcons102X56Example();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            ThemeSwitch(),
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
          ],
        ),
      ),
    );
  }
}
