import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/widgets/result_screens/failure_screen/widgets/failure_animation.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../features/kyc/upload_documents/store/upload_kyc_documents_store.dart';

class VerifyingScreen extends StatelessWidget {
  const VerifyingScreen({
    Key? key,
    required this.cardId,
    required this.onSuccess,
  }) : super(key: key);

  final String cardId;
  final Function() onSuccess;

  @override
  Widget build(BuildContext context) {
    return Provider<UploadKycDocumentsStore>(
      create: (context) => UploadKycDocumentsStore(),
      builder: (context, child) =>
        _VerifyingScreenBody(
          cardId: cardId,
          onSuccess: onSuccess,
        ),
    );
  }
}

class _VerifyingScreenBody extends StatelessObserverWidget {
  const _VerifyingScreenBody({
    Key? key,
    required this.cardId,
    required this.onSuccess,
  }) : super(key: key);

  final Function() onSuccess;
  final String cardId;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final store = UploadKycDocumentsStore.of(context);
    final deviceSize = sDeviceSize;

    store.getVerificationId(onSuccess, cardId);

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: SPageFrameWithPadding(
        child: Column(
          children: [
            const SpaceH86(),
            const Spacer(),
            Image.asset(
              verifyingNowAsset,
              width: widgetSizeFrom(deviceSize) == SWidgetSize.small
                  ? 160 : 225,
              height: widgetSizeFrom(deviceSize) == SWidgetSize.small
                  ? 160 : 225,
            ),
            const Spacer(),
            Baseline(
              baseline: 92.0,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                intl.cardVerification_verifyingNow,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: sTextH2Style,
              ),
            ),
            Baseline(
              baseline: 31.4,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                intl.cardVerification_verificationProcess,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: sBodyText1Style.copyWith(
                  color: colors.grey1,
                ),
              ),
            ),
            const SpaceH90(),
            SPrimaryButton1(
              active: true,
              name: intl.cardVerification_notifyAndSkip,
              onTap: () {
                store.skipWaiting();
                sRouter.popUntilRoot();
              },
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
