import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/prepaid_card/screens/buy_voucher_text_first_screen.dart';
import 'package:jetwallet/features/prepaid_card/screens/buy_voucher_text_second_screen.dart';
import 'package:jetwallet/features/prepaid_card/screens/buy_voucher_text_third_screen.dart';
import 'package:jetwallet/features/prepaid_card/screens/choose_country_and_plan_screen.dart';
import 'package:jetwallet/features/prepaid_card/store/choose_country_and_plan_store.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'PrepaidCardPreBuyTabsRouter')
class PrepaidCardPreBuyTabsScreen extends StatelessWidget {
  const PrepaidCardPreBuyTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => ChooseCountryAndPlanStore()..init(),
      lazy: false,
      child: const _PrepaidCardPreBuyTabsBody(),
    );
  }
}

class _PrepaidCardPreBuyTabsBody extends StatefulWidget {
  const _PrepaidCardPreBuyTabsBody();

  @override
  State<_PrepaidCardPreBuyTabsBody> createState() => _PrepaidCardPreBuyTabsBodyState();
}

class _PrepaidCardPreBuyTabsBodyState extends State<_PrepaidCardPreBuyTabsBody> with TickerProviderStateMixin {
  late TabController tabController;
  static const int countOfTabs = 4;

  bool isShowBackButtton = false;

  @override
  void initState() {
    tabController = TabController(
      length: countOfTabs,
      vsync: this,
    );

    sAnalytics.guideToUsingScreenView();

    tabController.addListener(() {
      setState(() {
        if (tabController.index == 0) {
          isShowBackButtton = false;
        } else {
          isShowBackButtton = true;
        }
      });
      if (!tabController.indexIsChanging) {
        switch (tabController.index) {
          case 0:
            sAnalytics.guideToUsingScreenView();
          case 1:
            sAnalytics.privacyScreenView();
          case 2:
            sAnalytics.voucherActivationScreenView();
          case 3:
            sAnalytics.choosePrepaidCardScreenView();
          default:
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _goToNextTab() {
    final currentIndex = tabController.index;
    if (currentIndex < countOfTabs - 1) {
      switch (tabController.index) {
        case 0:
          sAnalytics.tapOnTheNextButtonOnGuideToUsingScreen();
        case 1:
          sAnalytics.tapOnTheNextButtonOnPrivacyScreen();
        case 2:
          sAnalytics.tapOnTheNextButtonOnVoucherActivationScreen();
        default:
      }
      tabController.animateTo(currentIndex + 1);
    } else {
      final selectedBrand = ChooseCountryAndPlanStore.of(context).selectedBrand;
      final selectedCountry = ChooseCountryAndPlanStore.of(context).selectedCountry;
      if (selectedBrand != null) {
        sAnalytics.tapOnTheNextButtonOnChoosePrepaidCardScreen();
        sRouter.push(
          BuyVouncherAmountRouter(
            selectedBrand: selectedBrand,
            country: selectedCountry,
          ),
        );
      }
    }
  }

  void _goToPreviosTab() {
    final currentIndex = tabController.index;
    switch (currentIndex) {
      case 1:
        sAnalytics.tapOnTheBackButtonOnPrivacyScreen();
      case 2:
        sAnalytics.tapOnTheBackButtonOnVoucherActivationScreen();
      case 3:
        sAnalytics.tapOnTheBackButtonOnChoosePrepaidCardScreen();
      default:
    }
    tabController.animateTo(currentIndex - 1);
  }

  @override
  Widget build(BuildContext context) {
    final store = ChooseCountryAndPlanStore.of(context);

    return SPageFrame(
      loaderText: '',
      header: SPaddingH24(
        child: SSmallHeader(
          title: '',
          showCloseButton: true,
          showBackButton: isShowBackButtton,
          onBackButtonTap: () {
            _goToPreviosTab();
          },
          onCLoseButton: () {
            switch (tabController.index) {
              case 0:
                sAnalytics.tapOnTheCloseButtonOnGuideToUsingScreen();
              case 1:
                sAnalytics.tapOnTheCloseButtonOnPrivacyScreen();
              case 2:
                sAnalytics.tapOnTheCloseButtonOnVoucherActivationScreen();
              case 3:
                sAnalytics.tapOnTheCloseButtonOnChoosePrepaidCardScreen();
              default:
            }
            sRouter.popUntilRouteWithName(PrepaidCardServiceRouter.name);
          },
        ),
      ),
      child: Stack(
        children: [
          TabBarView(
            controller: tabController,
            children: const [
              BuyVoucherTextFirstScreen(),
              BuyVoucherTextSecondScreen(),
              BuyVoucherTextThirdScreen(),
              ChooseCountryAndPlanScreen(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Observer(
                builder: (context) {
                  return SButton.black(
                    text: intl.prepaid_card_next,
                    callback: store.selectedBrand == null && tabController.index == countOfTabs - 1
                        ? null
                        : () {
                            _goToNextTab();
                          },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
