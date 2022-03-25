import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../notifier/kyc_countries/kyc_countries_notipod.dart';

class EmptyState extends HookWidget {
  const EmptyState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(kycCountriesNotipod);
    final colors = useProvider(sColorPod);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SpaceH60(),
          Text(
            'No results for',
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
          ),
          Text(
            state.countryNameSearch,
            style: sTextH4Style.copyWith(
              color: colors.black,
            ),
          )
        ],
      ),
    );
  }
}
