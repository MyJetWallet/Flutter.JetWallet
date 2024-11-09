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

  int previosTabIndex = 0;

  @override
  void initState() {
    tabController = TabController(
      length: countOfTabs,
      vsync: this,
    );

    tabController.addListener(() {
      setState(() {
        if (tabController.index == 0) {
          isShowBackButtton = false;
        } else {
          isShowBackButtton = true;
        }
      });
      if (!tabController.indexIsChanging) {
        previosTabIndex = tabController.index;
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
      tabController.animateTo(currentIndex + 1);
    } else {
      final selectedBrand = ChooseCountryAndPlanStore.of(context).selectedBrand;
      final selectedCountry = ChooseCountryAndPlanStore.of(context).selectedCountry;
      if (selectedBrand != null) {
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
    tabController.animateTo(currentIndex - 1);
  }

  @override
  Widget build(BuildContext context) {
    final store = ChooseCountryAndPlanStore.of(context);

    return SPageFrame(
      loaderText: '',
      header: GlobalBasicAppBar(
        title: '',
        hasLeftIcon: isShowBackButtton,
        onLeftIconTap: () {
          _goToPreviosTab();
        },
        onRightIconTap: () {
          sRouter.popUntilRouteWithName(PrepaidCardServiceRouter.name);
        },
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
