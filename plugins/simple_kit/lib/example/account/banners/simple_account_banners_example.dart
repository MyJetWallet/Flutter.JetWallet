import 'package:flutter/material.dart';
import '../../../simple_kit.dart';

class SimpleAccountBannersExample extends StatelessWidget {
  const SimpleAccountBannersExample({Key? key}) : super(key: key);

  static const routeName = '/simple_account_banner_list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            SimpleAccountBannerList(),
          ],
        ),
      ),
    );
  }
}
