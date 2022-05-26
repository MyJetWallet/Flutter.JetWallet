import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'components/earn_active_body.dart';
import 'components/earn_active_header.dart';

class EarnActiveState extends HookWidget {
  const EarnActiveState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SliverToBoxAdapter(
      child: Column(
        children: const [
          EarnActiveHeader(),
          EarnActiveBody(),
        ],
      ),
    );
  }
}
