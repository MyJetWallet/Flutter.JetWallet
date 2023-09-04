import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

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
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewInsets.bottom -
          220,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              intl.emptySearchResult_noResultsFor,
              style: sBodyText1Style.copyWith(
                color: colors.grey1,
              ),
            ),
            Text(
              text ?? '',
              style: sTextH4Style.copyWith(
                color: colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
