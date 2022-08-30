import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/kyc/choose_documents/store/choose_documents_store.dart';
import 'package:jetwallet/features/kyc/choose_documents/store/kyc_country_store.dart';
import 'package:jetwallet/features/kyc/choose_documents/ui/widgets/kyc_country.dart';
import 'package:jetwallet/features/kyc/choose_documents/ui/widgets/show_kyc_country_picker.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

class ChooseDocuments extends StatelessObserverWidget {
  const ChooseDocuments({
    Key? key,
    required this.headerTitle,
  }) : super(key: key);

  final String headerTitle;

  @override
  Widget build(BuildContext context) {
    final countries = getIt.get<KycCountryStore>();
    final state = getIt.get<ChooseDocumentsStore>();

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
                              intl.kycChooseDocuments_scanYourDocument,
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
                            context,
                          ),
                          active: state.documents[index].active,
                          onTap: () {
                            state.activeDocument(
                              state.documents[index],
                            );
                          },
                        ),
                      const SpaceH10(),
                    ],
                    const Spacer(),
                    SPaddingH24(
                      child: SDocumentsRecommendations(
                        primaryText1: intl.sDocumentRecommendation_primaryText1,
                        primaryText2: intl.sDocumentRecommendation_primaryText2,
                        primaryText3: intl.sDocumentRecommendation_primaryText3,
                        primaryText4: intl.sDocumentRecommendation_primaryText4,
                        primaryText5: intl.sDocumentRecommendation_primaryText5,
                        primaryText6: intl.sDocumentRecommendation_primaryText6,
                      ),
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
                sAnalytics.identityParametersChoosed(
                  countries.activeCountry!.countryName,
                  state.getActiveDocument().document.name,
                );

                final status = await Permission.camera.request();

                if (status == PermissionStatus.granted) {
                  sAnalytics.kycCameraAllowed();

                  await sRouter.push(const UploadKycDocumentsRouter());
                } else {
                  await sRouter.push(
                    AllowCameraRoute(
                      permissionDescription:
                          '${intl.chooseDocuments_permissionDescriptionText1} '
                          '${intl.chooseDocument_camera}',
                      then: () => sRouter.replace(
                        const UploadKycDocumentsRouter(),
                      ),
                    ),
                  );
                }
              },
              name: intl.chooseDocument_chooseDocument,
              active: state.activeButton(),
            ),
          ),
        ],
      ),
    );
  }
}
