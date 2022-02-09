import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../model/kyc_operation_status_model.dart';
import '../../../notifier/choose_documents/choose_documents_notipod.dart';
import '../../../notifier/kyc_countries/kyc_countries_notipod.dart';
import '../allow_camera/allow_camera.dart';
import '../upload_documents/upload_kyc_documents.dart';
import 'components/kyc_country.dart';
import 'components/show_kyc_country_picker.dart';

class ChooseDocuments extends HookWidget {
  const ChooseDocuments({
    Key? key,
    required this.headerTitle,
  }) : super(key: key);

  final String headerTitle;

  static void pushReplacement({
    required BuildContext context,
    required String headerTitle,
  }) {
    navigatorPushReplacement(
      context,
      ChooseDocuments(
        headerTitle: headerTitle,
      ),
    );
  }

  static void push({
    required BuildContext context,
    required String headerTitle,
    required List<KycDocumentType> documents,
  }) {
    navigatorPush(
      context,
      ChooseDocuments(
        headerTitle: headerTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final countries = useProvider(kycCountriesNotipod);
    final state = useProvider(chooseDocumentsNotipod);
    final notifier = useProvider(chooseDocumentsNotipod.notifier);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: headerTitle,
        ),
      ),
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    KycCountry(
                      activeCountry: countries.activeCountry!,
                      openCountryList: () {
                        showKycCountryPicker(context);
                      },
                    ),
                    const SDivider(),
                    const SpaceH20(),
                    SPaddingH24(
                      child: Row(
                        children: [
                          Baseline(
                            baseline: 18,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              'Please scan your document',
                              style: sBodyText1Style,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpaceH16(),
                    for (var index = 0;
                        index < state.documents.length;
                        index++) ...[
                      if (state.documents[index].document !=
                              KycDocumentType.selfieImage &&
                          state.documents[index].document !=
                              KycDocumentType.residentPermit)
                        SChooseDocument(
                          primaryText: stringKycDocumentType(
                            state.documents[index].document,
                          ),
                          active: state.documents[index].active,
                          onTap: () {
                            notifier.activeDocument(state.documents[index]);
                          },
                        ),
                      const SpaceH10(),
                    ],
                    const Spacer(),
                    const SPaddingH24(
                      child: SDocumentsRecommendations(),
                    ),
                    const SpaceH120(),
                  ],
                ),
              ),
            ],
          ),
          SFloatingButtonFrame(
            button: SPrimaryButton2(
              onTap: () async {
                final status = await Permission.camera.status;
                if (status == PermissionStatus.granted) {
                  UploadKycDocuments.push(
                    context: context,
                  );
                } else {
                  AllowCamera.push(
                    context: context,
                  );
                }
              },
              name: 'Choose document',
              active: notifier.activeButton(),
            ),
          ),
        ],
      ),
    );
  }
}
