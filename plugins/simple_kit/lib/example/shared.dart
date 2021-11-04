import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../src/current_theme_stpod.dart';

void showSnackBar(BuildContext context, [String? text]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text ?? 'Tapped'),
      duration: const Duration(microseconds: 1),
    ),
  );
}

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final currentTheme = watch(currentThemeStpod);

    return Switch(
      value: currentTheme.state != STheme.light,
      onChanged: (toggle) {
        if (currentTheme.state == STheme.dark) {
          currentTheme.state = STheme.light;
        } else {
          currentTheme.state = STheme.dark;
        }
      },
    );
  }
}

class NavigationButton extends StatelessWidget {
  const NavigationButton({
    Key? key,
    required this.buttonName,
    required this.routeName,
  }) : super(key: key);

  final String buttonName;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, routeName),
      child: Center(
        child: Text(
          buttonName,
        ),
      ),
    );
  }
}
