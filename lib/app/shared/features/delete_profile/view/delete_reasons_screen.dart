import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../notifier/delete_profile_notipod.dart';

class DeleteReasonsScreen extends ConsumerWidget {
  const DeleteReasonsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final intl = watch(intlPod);
    final colors = watch(sColorPod);

    final state = watch(deleteProfileNotipod);
    final stateNotifier = watch(deleteProfileNotipod.notifier);

    return SPageFrame(
      header: SPaddingH24(
        child: SMegaHeader(
          titleAlign: TextAlign.start,
          title: intl.deleteProfileReasons_header,
          showBackButton: false,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: SPrimaryButton2(
          active: state.selectedDeleteReason.isNotEmpty,
          onTap: () async {
            await stateNotifier.deleteProfile();
          },
          name: intl.deleteProfileReasons_continue,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 7,
            ),
            SPaddingH24(
              child: Text(
                intl.deleteProfileReasons_subText,
                maxLines: 3,
                style: sBodyText1Style.copyWith(
                  color: colors.grey1,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListView.separated(
              itemCount: state.deleteReason.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SDivider(),
              itemBuilder: (context, index) {
                return InkWell(
                  highlightColor: colors.grey5,
                  onTap: () {
                    stateNotifier.selectDeleteReason(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.deleteReason[index].reasonText ?? '',
                          style: sSubtitle2Style,
                        ),
                        const Spacer(),
                        SCompleteIcon(
                          color: stateNotifier.isAlreadySelected(index)
                              ? colors.blue
                              : colors.grey1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
