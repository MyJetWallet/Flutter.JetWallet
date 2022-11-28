import 'package:flutter/material.dart';

import 'components/earn_active_body.dart';
import 'components/earn_active_header.dart';

class EarnActiveState extends StatelessWidget {
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
