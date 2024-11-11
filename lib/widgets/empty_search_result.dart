import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class EmptySearchResult extends StatelessObserverWidget {
  const EmptySearchResult({
    required this.text,
    super.key,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SizedBox(
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom - 220,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              intl.emptySearchResult_noResultsFor,
              style: STStyles.body1Medium.copyWith(
                color: colors.grey1,
              ),
            ),
            Text(
              text ?? '',
              style: STStyles.header5,
            ),
          ],
        ),
      ),
    );
  }
}
