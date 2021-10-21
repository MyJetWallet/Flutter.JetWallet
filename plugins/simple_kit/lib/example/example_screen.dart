import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../src/theme/provider/simple_theme_pod.dart';
import 'buttons/examples/simple_link_button_example.dart';
import 'buttons/examples/simple_primary_button_example.dart';
import 'buttons/examples/simple_secondary_button_example.dart';
import 'buttons/examples/simple_text_button_example.dart';
import 'buttons/simple_buttons_example.dart';
import 'colors/simple_colors_example.dart';
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
          ],
        ),
      ),
    );
  }
}
