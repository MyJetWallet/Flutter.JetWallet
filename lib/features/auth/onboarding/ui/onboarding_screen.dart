import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/auth/onboarding/store/onboarding_store.dart';
import 'package:jetwallet/features/auth/onboarding/ui/widgets/animated_slide.dart';
import 'package:jetwallet/widgets/splash_screen_gradient.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'OnboardingRoute')
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<OnboardingStore>(
      create: (context) => OnboardingStore(),
      builder: (context, child) => const OnboardingScreenBody(),
      dispose: (context, state) => state.dispose(),
    );
  }
}

class OnboardingScreenBody extends StatefulObserverWidget {
  const OnboardingScreenBody({super.key});

  @override
  State<OnboardingScreenBody> createState() => _OnboardingScreenBodyState();
}

class _OnboardingScreenBodyState extends State<OnboardingScreenBody> with TickerProviderStateMixin {
  late final AnimationController _slidesAnimationController = AnimationController(
    vsync: this,
  );

  @override
  void initState() {
    OnboardingStore.of(context).init(_slidesAnimationController);
    sAnalytics.signInFlowWelcomeView();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    OnboardingStore.of(context).precacheImages(context);
  }

  @override
  void dispose() {
    _slidesAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final colors = sKit.colors;

    final onboardingStore = OnboardingStore.of(context);

    return OnboardingFullScreenGradient(
      backgroundColor: colors.grey5,
      onTapNext: onboardingStore.nextSlider,
      onTapBack: onboardingStore.prevSlider,
      onLongPress: onboardingStore.stopSlider,
      onLongPressEnd: onboardingStore.forwardSlider,
      onPanEnd: onboardingStore.onPanEnd,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SpaceH53(),
            Expanded(
              child: Center(
                child: Builder(
                  builder: (context) {
                    late double imageSize;
                    switch (onboardingStore.currentIndex) {
                      case 0:
                        imageSize = 300;
                        break;
                      case 1:
                        imageSize = 252.38;
                        break;
                      case 2:
                        imageSize = 240;
                        break;
                      default:
                        imageSize = size.width * 0.7;
                    }

                    return Image.asset(
                      onboardingStore.showImages(
                        onboardingStore.currentIndex,
                      ),
                      height: imageSize,
                    );
                  },
                ),
              ),
            ),
            Baseline(
              baselineType: TextBaseline.alphabetic,
              baseline: 38,
              child: Text(
                onboardingStore.slidesLabeles[onboardingStore.currentIndex],
                maxLines: 4,
                textAlign: TextAlign.center,
                style: sTextH2Style,
              ),
            ),
            const SpaceH16(),
            Baseline(
              baselineType: TextBaseline.alphabetic,
              baseline: 38,
              child: Text(
                onboardingStore.slidesDescrictions[onboardingStore.currentIndex],
                maxLines: 3,
                textAlign: TextAlign.center,
                style: sSubtitle2Style.copyWith(
                  color: colors.grey1,
                ),
              ),
            ),
            const SpaceH32(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: onboardingStore.slidesLabeles
                  .asMap()
                  .map(
                    (i, value) => MapEntry(
                      i,
                      AnimatedOnboardingSlide(
                        position: i,
                        currentIndex: onboardingStore.currentIndex,
                        animationController: _slidesAnimationController,
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
            const SpaceH24(),
            SPrimaryButton1(
              active: true,
              name: intl.onboarding_getStarted,
              onTap: () {
                sAnalytics.signInFlowTapGetStarted();
                sAnalytics.signInFlowEnterEmailView();
                sRouter.push(
                  SingInRouter(),
                );
              },
            ),
            if (getIt<AppStore>().env == 'stage') ...[
              SizedBox(
                height: 58,
                child: STextButton1(
                  active: true,
                  name: 'Logs',
                  onTap: () {
                    sRouter.push(
                      const LogsRouter(),
                    );
                  },
                ),
              ),
            ] else ...[
              const SpaceH58(),
            ],
          ],
        ),
      ),
    );
  }
}
