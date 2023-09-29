import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/kyc/choose_documents/store/choose_documents_store.dart';
import 'package:jetwallet/features/kyc/choose_documents/store/kyc_country_store.dart';
import 'package:jetwallet/features/kyc/choose_documents/ui/widgets/kyc_country.dart';
import 'package:jetwallet/features/kyc/choose_documents/ui/widgets/show_kyc_country_picker.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/kyc/components/simple_document_recommendation.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../core/services/sumsub_service/sumsub_service.dart';

@RoutePage(name: 'KycVerificationSumsubRouter')
class KycVerificationSumsub extends StatefulObserverWidget {
  const KycVerificationSumsub({
    super.key,
    this.onFinish,
    this.isBanking = false,
  });

  final VoidCallback? onFinish;
  final bool? isBanking;

  @override
  State<KycVerificationSumsub> createState() => _KycVerificationSumsubState();
}

class _KycVerificationSumsubState extends State<KycVerificationSumsub> {
  @override
  void initState() {
    sAnalytics.kycFlowVerifyYourIdentify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final countries = getIt.get<KycCountryStore>();
    final state = getIt.get<ChooseDocumentsStore>();
    final colors = sKit.colors;
    final loading = StackLoaderStore();

    return SPageFrame(
      loading: loading,
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.kycAlertHandler_verifyYourIdentity,
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
                        sAnalytics.kycFlowCoutryOfIssueShow();
                        showKycCountryPicker(context);
                      },
                    ),
                    const SDivider(),
                    const SpaceH20(),
                    SPaddingH24(
                      child: Text(
                        intl.kycChooseDocuments_proceedYourDocument,
                        style: sBodyText1Style,
                        maxLines: 5,
                      ),
                    ),
                    const SpaceH16(),
                    Container(
                      width: MediaQuery.of(context).size.width - 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          width: 3,
                          color: colors.grey4,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(21),
                        child: Column(
                          children: [
                            for (var index = 0; index < state.documents.length; index++) ...[
                              if (state.documents[index].document != KycDocumentType.selfieImage)
                                Row(
                                  children: [
                                    iconKycDocumentType(
                                      state.documents[index].document,
                                      context,
                                    ),
                                    const SpaceW12(),
                                    Text(
                                      stringKycDocumentType(
                                        state.documents[index].document,
                                        context,
                                      ),
                                      style: sSubtitle2Style,
                                    ),
                                  ],
                                ),
                              if (index != (state.documents.length - 1)) const SpaceH16(),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SpaceH24(),
                    SPaddingH24(
                      child: Column(
                        children: [
                          SDocumentRecommendation(
                            primaryText: '${intl.sDocumentRecommendation_primaryText1}:',
                          ),
                          Text(
                            intl.sDocumentRecommendation_primaryTextNew,
                            style: sBodyText1Style.copyWith(
                              color: colors.grey1,
                              height: 1.8,
                            ),
                            maxLines: 5,
                          ),
                        ],
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
                sAnalytics.kycFlowTapContinueOnVerifyYourIdentity(
                  country: countries.activeCountry?.countryName ?? '',
                  documentList: state.documents
                      .map(
                        (element) => stringKycDocumentType(
                          element.document,
                          context,
                        ),
                      )
                      .toString(),
                );

                loading.startLoadingImmediately();

                sAnalytics.kycFlowVerifyWait(
                  country: countries.activeCountry?.countryName ?? '',
                );

                sAnalytics.kycFlowSumsubShow(
                  country: countries.activeCountry?.countryName ?? '',
                );

                await getIt<SumsubService>().launch(
                  onFinish: widget.onFinish,
                  isBanking: widget.isBanking ?? false,
                );

                loading.finishLoadingImmediately();
              },
              name: intl.kycVerifyYourProfile_continue,
              active: true,
            ),
          ),
        ],
      ),
    );
  }
}
