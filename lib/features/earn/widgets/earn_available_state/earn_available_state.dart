import 'package:flutter/material.dart';

import '../earn_active_state/components/earn_active_header.dart';
import 'components/earn_available_body.dart';

class EarnAvailableState extends StatelessWidget {
  const EarnAvailableState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: const [
          EarnActiveHeader(),
          EarnAvailableBody(),
        ],
      ),
    );
  }
}
