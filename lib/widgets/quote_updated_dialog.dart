import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

/// TODO(ELI) update this dialog
/// TODO (remove legacy code)
void showQuoteUpdatedDialog({
  required BuildContext context,
  required Function() onPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return CupertinoAlertDialog(
        title: Text(
          intl.quoteUpdatedDialog_alert,
        ),
        content: Text(
          intl.quoteUpdatedDialog_quoteUpdated,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              onPressed();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text(
              '${intl.quoteUpdatedDialog_gotIt}!',
            ),
          ),
        ],
      );
    },
  );
}
