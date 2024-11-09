import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'SimpleCardLabelRouter')
class SimpleCardLabelScreen extends StatefulWidget {
  const SimpleCardLabelScreen({
    super.key,
    required this.initLabel,
    required this.accountId,
  });

  final String initLabel;
  final String accountId;

  @override
  State<SimpleCardLabelScreen> createState() => _CJAccountLabelScreenState();
}

class _CJAccountLabelScreenState extends State<SimpleCardLabelScreen> {
  late final TextEditingController labelController;
  final StackLoaderStore loader = StackLoaderStore();

  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();

    labelController = TextEditingController(
      text: widget.initLabel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.loader_please_wait,
      loading: loader,
      color: sKit.colors.grey5,
      header: GlobalBasicAppBar(
        title: intl.wallet_account_label,
        hasRightIcon: false,
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: AutofillGroup(
              child: FocusScope(
                autofocus: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SFieldDividerFrame(
                      child: SStandardField(
                        labelText: intl.edit_card_lable_card_label,
                        maxLines: 1,
                        maxLength: 20,
                        controller: labelController,
                        textInputAction: TextInputAction.next,
                        onChanged: (text) {
                          if (text.trim().isNotEmpty && text.trim().length <= 20) {
                            setState(() {
                              isButtonActive = true;
                            });
                          } else {
                            setState(() {
                              isButtonActive = false;
                            });
                          }
                        },
                        hideSpace: true,
                      ),
                    ),
                    const Spacer(),
                    SPaddingH24(
                      child: Material(
                        color: sKit.colors.grey5,
                        child: SButton.blue(
                          text: intl.iban_edit_save_changes,
                          callback: isButtonActive
                              ? () async {
                                  loader.startLoadingImmediately();

                                  try {
                                    final resp = await sNetwork.getWalletModule().postAccountChangeLabel(
                                          accountId: widget.accountId,
                                          label: labelController.text.trim(),
                                        );

                                    if (resp.hasError) {
                                      sNotification.showError(
                                        resp.error?.cause ?? intl.something_went_wrong,
                                        id: 1,
                                        needFeedback: true,
                                      );
                                      loader.finishLoadingImmediately();
                                    } else {
                                      Navigator.pop(
                                        context,
                                        labelController.text.trim(),
                                      );
                                    }
                                  } catch (e) {
                                    sNotification.showError(
                                      intl.something_went_wrong_try_again,
                                    );
                                    loader.finishLoadingImmediately();
                                  }
                                }
                              : null,
                        ),
                      ),
                    ),
                    const SpaceH42(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
