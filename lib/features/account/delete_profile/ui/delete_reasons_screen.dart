import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/account/delete_profile/store/delete_profile_store.dart';
import 'package:simple_kit/simple_kit.dart';

class DeleteReasonsScreen extends StatelessObserverWidget {
  const DeleteReasonsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = getIt.get<DeleteProfileStore>();

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
          active: store.selectedDeleteReason.isNotEmpty,
          onTap: () async {
            await store.deleteProfile();
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
              itemCount: store.deleteReason.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SDivider(),
              itemBuilder: (context, index) {
                return InkWell(
                  highlightColor: colors.grey5,
                  onTap: () {
                    store.selectDeleteReason(index);
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
                          store.deleteReason[index].reasonText ?? '',
                          style: sSubtitle2Style,
                        ),
                        const Spacer(),
                        SCompleteIcon(
                          color: store.isAlreadySelected(index)
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
