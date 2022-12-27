import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/app/init_router/router_union.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/auth/onboarding/store/onboarding_store.dart';
import 'package:jetwallet/features/auth/onboarding/ui/widgets/animated_slide.dart';
import 'package:jetwallet/widgets/splash_screen_gradient.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

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
  const OnboardingScreenBody({Key? key}) : super(key: key);

  @override
  State<OnboardingScreenBody> createState() => _OnboardingScreenBodyState();
}

class _OnboardingScreenBodyState extends State<OnboardingScreenBody>
    with TickerProviderStateMixin {
  late final AnimationController _slidesAnimationController =
      AnimationController(
    vsync: this,
  );

  @override
  void initState() {
    OnboardingStore.of(context).init(_slidesAnimationController);
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
    final deviceSize = getIt.get<DeviceSize>().size;

    return OnboardingFullScreenGradient(
      backgroundColor: OnboardingStore.of(context).backgroundColor(
        sKit.colors,
      ),
      onTapNext: OnboardingStore.of(context).nextSlider,
      onTapBack: OnboardingStore.of(context).prevSlider,
      onLongPress: OnboardingStore.of(context).stopSlider,
      onLongPressEnd: OnboardingStore.of(context).forwardSlider,
      onPanEnd: OnboardingStore.of(context).onPanEnd,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SpaceH60(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: OnboardingStore.of(context)
                      .slides
                      .asMap()
                      .map(
                        (i, value) => MapEntry(
                          i,
                          AnimatedOnboardingSlide(
                            position: i,
                            currentIndex:
                                OnboardingStore.of(context).currentIndex,
                            animationController: _slidesAnimationController,
                          ),
                        ),
                      )
                      .values
                      .toList(),
                ),
                deviceSize.when(
                  small: () {
                    return const SpaceH20();
                  },
                  medium: () {
                    return const SpaceH40();
                  },
                ),
                deviceSize.when(
                  small: () {
                    return Baseline(
                      baselineType: TextBaseline.alphabetic,
                      baseline: 38,
                      child: Text(
                        OnboardingStore.of(context)
                            .slides[OnboardingStore.of(context).currentIndex],
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: sTextH2Style,
                      ),
                    );
                  },
                  medium: () {
                    return Baseline(
                      baselineType: TextBaseline.alphabetic,
                      baseline: 38,
                      child: Text(
                        OnboardingStore.of(context)
                            .slides[OnboardingStore.of(context).currentIndex],
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: sTextH1Style,
                      ),
                    );
                  },
                ),
                const Spacer(),
                deviceSize.when(
                  small: () {
                    return Image.asset(
                      OnboardingStore.of(context).showImages(
                        OnboardingStore.of(context).currentIndex,
                      ),
                      height: size.width * 0.7,
                    );
                  },
                  medium: () {
                    return Image.asset(
                      OnboardingStore.of(context).showImages(
                        OnboardingStore.of(context).currentIndex,
                      ),
                      height: size.width,
                    );
                  },
                ),
                const Spacer(),
                SPrimaryButton1(
                  active: true,
                  name: intl.onboarding_getStarted,
                  onTap: () {
                    sRouter.push(
                      SingInRouter(),
                    );
                  },
                ),
                if (getIt<AppStore>().env == 'stage') ...[
                  const SpaceH12(),
                  STextButton1(
                    active: true,
                    name: 'Logs',
                    onTap: () {
                      sRouter.push(
                        const LogsRouter(),
                      );
                    },
                  ),
                ] else ...[
                  const SpaceH24(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
