import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/intercom/intercom_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/widgets/result_screens/widgets/result_screen_description.dart';
import 'package:jetwallet/widgets/result_screens/widgets/result_screen_title.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

WebViewController? _kycwebViewController;

@RoutePage(name: 'KycAidWebViewRouter')
class KycAidWebViewScreen extends StatefulWidget {
  const KycAidWebViewScreen({required this.url});

  final String url;

  @override
  State<KycAidWebViewScreen> createState() => _KycAidWebViewScreenState();
}

class _KycAidWebViewScreenState extends State<KycAidWebViewScreen> {
  WebViewController controller = WebViewController();

  bool showSplashScreen = true;

  @override
  void initState() {
    Permission.camera.request();

    if (_kycwebViewController != null) {
      setState(() {
        controller = _kycwebViewController!;
      });
    } else {
      loadKycAidWebViewController(url: widget.url).then((_) {
        setState(() {
          controller = _kycwebViewController!;
        });
      });
    }

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showSplashScreen = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _kycwebViewController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: SimpleLargeAppbar(
        title: intl.kyc_identity_verification,
        hasRightIcon: true,
        rightIcon: SafeGesture(
          onTap: () async {
            if (showZendesk) {
              await getIt.get<IntercomService>().showMessenger();
            } else {
              await sRouter.push(
                CrispRouter(
                  welcomeText: intl.crispSendMessage_hi,
                ),
              );
            }
          },
          child: Assets.svg.medium.chat.simpleSvg(),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}..add(
                      Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer(),
                      ),
                    ),
                  controller: controller,
                ),
                if (showSplashScreen) const _SplashScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> loadKycAidWebViewController({required String url, bool preload = false}) async {
  late final PlatformWebViewControllerCreationParams params;
  if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    params = WebKitWebViewControllerCreationParams(
      allowsInlineMediaPlayback: true,
    );
  } else {
    params = const PlatformWebViewControllerCreationParams();
  }

  final controller = WebViewController.fromPlatformCreationParams(
    params,
    onPermissionRequest: (request) async {
      await request.grant();
    },
  );

  if (controller.platform is AndroidWebViewController) {
    await (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
  }

  await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
  await controller.setBackgroundColor(Colors.white);
  await controller.setNavigationDelegate(
    NavigationDelegate(
      onNavigationRequest: (NavigationRequest request) {
        final uri = Uri.parse(request.url);
        if (uri.path.contains('success')) {
          Navigator.push(
            sRouter.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const _VerifyingScreen()),
          );
          return NavigationDecision.navigate;
        }

        return NavigationDecision.navigate;
      },
    ),
  );
  await controller.enableZoom(false);
  if (preload) {
    await controller.loadRequest(Uri.parse(url));
  } else {
    unawaited(controller.loadRequest(Uri.parse(url)));
  }

  _kycwebViewController = controller;
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return Container(
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: MediaQuery.of(context).padding.top,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      color: colors.white,
      child: Center(
        child: Column(
          children: [
            const Spacer(
              flex: 2,
            ),
            Column(
              children: [
                Lottie.asset(
                  processingAnimationAsset,
                  width: 80,
                  height: 80,
                ),
                const SpaceH24(),
                ResultScreenTitle(
                  title: intl.waitingScreen_processing,
                ),
              ],
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class _VerifyingScreen extends StatelessWidget {
  const _VerifyingScreen();

  void onClose() {
    navigateToRouter();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SPageFrame(
        loaderText: intl.register_pleaseWait,
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: MediaQuery.of(context).padding.top,
            bottom: MediaQuery.of(context).padding.bottom + 16,
          ),
          child: Column(
            children: [
              const Spacer(
                flex: 2,
              ),
              Column(
                children: [
                  Lottie.asset(
                    successJsonAnimationAsset,
                    width: 80,
                    height: 80,
                    repeat: false,
                  ),
                  const SpaceH24(),
                  ResultScreenTitle(
                    title: intl.kycChooseDocuments_verifyingNow,
                  ),
                  const SpaceH16(),
                  ResultScreenDescription(
                    text: intl.kycChooseDocuments_willBeNotified,
                  ),
                ],
              ),
              const Spacer(
                flex: 3,
              ),
              SButton.black(
                text: intl.kycAlertHandler_done,
                callback: () {
                  onClose();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
