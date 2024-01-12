import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'CJAccountLabelRouter')
class CJAccountLabelScreen extends StatefulObserverWidget {
  const CJAccountLabelScreen({
    super.key,
    required this.initLabel,
    required this.accountId,
  });

  final String initLabel;
  final String accountId;

  @override
  State<CJAccountLabelScreen> createState() => _CJAccountLabelScreenState();
}

class _CJAccountLabelScreenState extends State<CJAccountLabelScreen> {
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
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.wallet_account_label,
          onBackButtonTap: () => Navigator.pop(context),
        ),
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
                        labelText: intl.wallet_account_label_input,
                        maxLines: 1,
                        maxLength: 30,
                        controller: labelController,
                        textInputAction: TextInputAction.next,
                        onChanged: (text) {
                          if (text.isNotEmpty && text.length <= 20) {
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
                        child: SPrimaryButton2(
                          active: isButtonActive,
                          name: intl.iban_edit_save_changes,
                          onTap: () async {
                            sAnalytics.eurWalletTapSaveChanges();
                            loader.startLoadingImmediately();

                            try {
                              final resp = await sNetwork.getWalletModule().postAccountChangeLabel(
                                    accountId: widget.accountId,
                                    label: labelController.text.trim(),
                                  );

                              if (resp.hasError) {
                                sNotification.showError(
                                  resp.error?.cause ?? '',
                                  id: 1,
                                  needFeedback: true,
                                );
                                loader.finishLoadingImmediately();
                              } else {
                                Navigator.pop(context, labelController.text.trim());
                              }
                            } catch (e) {
                              sNotification.showError(intl.something_went_wrong_try_again);
                              loader.finishLoadingImmediately();
                            }
                          },
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
