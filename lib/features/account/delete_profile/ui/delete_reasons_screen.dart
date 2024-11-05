import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/account/delete_profile/store/delete_profile_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'DeleteReasonsScreenRouter')
class DeleteReasonsScreen extends StatelessObserverWidget {
  const DeleteReasonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = getIt.get<DeleteProfileStore>();

    return PopScope(
      canPop: !store.loader.loading,
      child: SPageFrame(
      loaderText: intl.register_pleaseWait,
      loading: store.loader,
      header: SPaddingH24(
        child: SMegaHeader(
          titleAlign: TextAlign.start,
          title: intl.deleteProfileReasons_header,
          showBackButton: false,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 42,
        ),
        child: SButton.blue(
          callback: store.selectedDeleteReason.isNotEmpty
              ? () async {
            await store.deleteProfile();
          }
              : null,
          text: intl.deleteProfileReasons_continue,
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
                          color: store.isAlreadySelected(index) ? colors.blue : colors.grey1,
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
    ),);
  }
}
