import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/providers/service_providers.dart';

class DeleteReasonsScreen extends ConsumerWidget {
  const DeleteReasonsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final intl = watch(intlPod);
    final colors = watch(sColorPod);

    return SPageFrame(
      header: SPaddingH24(
        child: SBigHeader(
          title: intl.deleteProfileReasons_header,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: SPaddingH24(
        child: Column(
          children: [
            Text(
              intl.deleteProfileReasons_subText,
              style: sBodyText1Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
