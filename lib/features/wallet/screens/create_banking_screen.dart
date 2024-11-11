import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/global_loader.dart';
import 'package:jetwallet/features/my_wallets/helper/show_create_personal_account.dart';
import 'package:jetwallet/features/my_wallets/helper/show_wallet_verify_account.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/20x20/public/tick/simple_tick_icon.dart';
import 'package:simple_kit/modules/icons/40x40/public/user/simple_user_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:uuid/uuid.dart';

@RoutePage(name: 'CreateBankingRoute')
class CreateBankingScreen extends StatefulWidget {
  const CreateBankingScreen({super.key});

  @override
  State<CreateBankingScreen> createState() => _CreateBankingScreenState();
}

class _CreateBankingScreenState extends State<CreateBankingScreen> {
  String requestId = '';

  var isClicked = false;
  final loading = StackLoaderStore();

  // ignore: unused_field
  late Timer _timer;

  @override
  void initState() {
    requestId = const Uuid().v1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.loader_please_wait,
      loading: loading,
      header: GlobalBasicAppBar(
        title: intl.create_banking_add_account,
        hasRightIcon: false,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceH16(),
            Center(
              child: Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(20),
                decoration: const ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color.fromRGBO(137, 187, 91, 1), Color(0xFFBEF275)],
                  ),
                  shape: OvalBorder(),
                ),
                child: const SUserTopIcon(),
              ),
            ),
            const SpaceH32(),
            Text(
              intl.create_banking_personal_account,
              maxLines: 6,
              style: STStyles.header5,
            ),
            const SpaceH8(),
            Text(
              intl.create_banking_transfer_eur,
              maxLines: 6,
              style: STStyles.subtitle2.copyWith(
                color: sKit.colors.grey1,
              ),
            ),
            const SpaceH20(),
            Row(
              children: [
                const STickLongIcon(),
                const SpaceW12(),
                Text(
                  intl.create_banking_conditions_1,
                  style: STStyles.body2Medium,
                ),
              ],
            ),
            const SpaceH12(),
            Row(
              children: [
                const STickLongIcon(),
                const SpaceW12(),
                Text(
                  intl.create_banking_conditions_2,
                  style: STStyles.body2Medium,
                ),
              ],
            ),
            const SpaceH12(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const STickLongIcon(),
                const SpaceW12(),
                Flexible(
                  child: Text(
                    intl.create_banking_conditions_3,
                    maxLines: 3,
                    style: STStyles.body2Medium,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 5),
            SButton.blue(
              text: intl.create_continue,
              callback: () async {
                if (!isClicked) {
                  isClicked = true;
                  loading.startLoadingImmediately();
                  isClicked = false;
                  try {
                    sAnalytics.eurWalletTapOnContinuePersonalEUR();
        
                    final resp =
                        await getIt.get<SNetwork>().simpleNetworking.getWalletModule().postAccountCreate(requestId);
        
                    if (resp.hasError) {
                      sNotification.showError(
                        intl.something_went_wrong_try_again,
                        id: 1,
                        needFeedback: true,
                      );
        
                      loading.finishLoadingImmediately();
        
                      sRouter.popUntilRoot();
                    } else {
                      if (resp.data!.simpleKycRequired || resp.data!.addressSetupRequired) {
                        sAnalytics.eurWalletVerifyYourAccount();
        
                        showWalletVerifyAccount(
                          context,
                          after: _afterVerification,
                          isBanking: false,
                        );
                      } else if (resp.data!.bankingKycRequired) {
                        showCreatePersonalAccount(
                          context,
                          loading,
                          _afterVerification,
                        );
                      } else {
                        await sRouter.maybePop();
                      }
                    }
                  } catch (e) {
                    sNotification.showError(intl.something_went_wrong_try_again);
                  } finally {
                    if (loading.loading) {
                      loading.finishLoadingImmediately();
                    }
                  }
                }
              },
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }

  void _afterVerification() {
    sRouter.popUntilRoot();

    getIt.get<GlobalLoader>().setLoading(false);

    sNotification.showError(intl.let_us_create_account, isError: false);
    sAnalytics.eurWalletShowToastLestCreateAccount();
  }
}
