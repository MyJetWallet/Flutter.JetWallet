import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/providers/service_providers.dart';

/// TODO(ELI) update this dialog
/// TODO (remove legacy code)
void showQuoteUpdatedDialog({
  required BuildContext context,
  required Function() onPressed,
}) {
  final intl = context.read(intlPod);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return CupertinoAlertDialog(
        title: Text(
          intl.quoteUpdatedDialog_title,
        ),
        content: Text(
          intl.quoteUpdatedDialog_content,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              onPressed();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text(
              '${intl.gotIt}!',
            ),
          )
        ],
      );
    },
  );
}
