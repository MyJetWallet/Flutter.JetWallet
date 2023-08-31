import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/kyc/choose_documents/store/choose_documents_store.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/kyc/upload_documents/store/upload_kyc_documents_store.dart';
import 'package:jetwallet/features/kyc/upload_documents/ui/widgets/create_kyc_banners_list.dart';
import 'package:jetwallet/features/kyc/upload_documents/models/upload_kyc_documents_union.dart';
import 'package:jetwallet/features/kyc/upload_documents/ui/widgets/document_page_view.dart';
import 'package:jetwallet/features/kyc/upload_documents/ui/widgets/page_indicator.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'UploadKycDocumentsRouter')
class UploadKycDocuments extends StatelessWidget {
  const UploadKycDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<UploadKycDocumentsStore>(
      create: (context) => UploadKycDocumentsStore(),
      builder: (context, child) => const _UploadKycDocumentsBody(),
    );
  }
}

class _UploadKycDocumentsBody extends StatelessObserverWidget {
  const _UploadKycDocumentsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final store = UploadKycDocumentsStore.of(context);
    final colors = sKit.colors;

    final activeDocument =
        getIt.get<ChooseDocumentsStore>().getActiveDocument();

    final banners = createKycBannersList(
      documentFirstSide: store.documentFirstSide,
      documentSecondSide: store.documentSecondSide,
      colors: colors,
      notifier: store,
    );

    return ReactionBuilder(
      builder: (context) {
        return reaction<UploadKycDocumentsUnion>(
          (_) => store.union,
          (result) {
            result.maybeWhen(
              error: (error) {
                store.loader.finishLoadingImmediately();
              },
              done: () {
                store.loaderSuccess.startLoading();
                Timer(
                  const Duration(seconds: 2),
                  () {
                    sRouter.navigate(const KycSelfieRouter());
                  },
                );
              },
              orElse: () {},
            );
          },
          fireImmediately: true,
        );
      },
      child: SPageFrame(
        loaderText: (store.loaderSuccess.loading)
            ? intl.uploadKycDocuments_done
            : intl.uploadKycDocuments_pleaseWait,
        loading: store.loader,
        loadSuccess: store.loaderSuccess,
        header: SPaddingH24(
          child: SSmallHeader(
            title: '${intl.uploadKycDocuments_upload} ${stringKycDocumentType(
              activeDocument?.document ?? KycDocumentType.unknown,
              context,
            )}',
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
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (store.numberSide == 0)
                                ? intl.uploadKycDocuments_frontSide
                                : intl.uploadKycDocuments_backSide,
                            style: sSubtitle2Style,
                          ),
                        ],
                      ),
                      const SpaceH16(),
                      DocumentPageView(
                        pageController: store.pageViewController,
                        onPageChanged: (int index) {
                          store.changeDocumentSide(index);
                        },
                        itemCount: _documentPageViewCount(
                          activeDocument?.document,
                        ),
                        banners: banners,
                      ),
                      const SpaceH18(),
                      PageIndicator(
                        documentType: activeDocument?.document,
                      ),
                      const Spacer(),
                      const SpaceH10(),
                      SPaddingH24(
                        child: SDocumentsRecommendations(
                          primaryText1:
                              intl.sDocumentRecommendation_primaryText1,
                          primaryText2:
                              intl.sDocumentRecommendation_primaryText2,
                          primaryText3:
                              intl.sDocumentRecommendation_primaryText3,
                          primaryText4:
                              intl.sDocumentRecommendation_primaryText4,
                          primaryText5:
                              intl.sDocumentRecommendation_primaryText5,
                          primaryText6:
                              intl.sDocumentRecommendation_primaryText6,
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
                  await store.documentPageViewLogic(
                    activeDocument!.document,
                    '',
                    () {},
                  );
                },
                name: store.buttonName(),
                active: store.activeScanButton(),
                icon: store.buttonIcon
                    ? const SArrowUpIcon()
                    : const SWhitePhotoIcon(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _documentPageViewCount(KycDocumentType? document) {
    return (document != KycDocumentType.passport) ? 2 : 1;
  }
}
