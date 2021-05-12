import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth/ui/auth.dart';
import 'router/ui/router.dart';
import 'shared/theme/theme_data.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: AppRouter.routeName,
      routes: {
        AppRouter.routeName: (context) => AppRouter(),
        Authentication.routeName: (context) => Authentication(),
      },
    );
  }
}
