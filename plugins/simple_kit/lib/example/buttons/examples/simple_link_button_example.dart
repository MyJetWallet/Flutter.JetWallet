import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleLinkButtonExample extends StatelessWidget {
  const SimpleLinkButtonExample({Key? key}) : super(key: key);

  static const routeName = '/simple_link_button_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SLinkButton1(
            active: true,
            name: 'Link Text Button',
            onTap: () {},
          ),
          SLinkButton2(
            active: true,
            name: 'Link Text Button',
            onTap: () {},
          ),
          SLinkButton1(
            active: false,
            name: 'Link Text Button',
            onTap: () {},
          ),
          SLinkButton2(
            active: false,
            name: 'Link Text Button',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
