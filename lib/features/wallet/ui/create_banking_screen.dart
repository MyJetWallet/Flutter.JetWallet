import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/my_wallets/helper/show_create_personal_account.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/20x20/public/tick/simple_tick_icon.dart';
import 'package:simple_kit/modules/icons/40x40/public/user/simple_user_icon.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'CreateBankingRoute')
class CreateBankingScreen extends StatelessWidget {
  const CreateBankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loading = StackLoaderStore();

    return SPageFrameWithPadding(
      loaderText: intl.loader_please_wait,
      loading: loading,
      header: SSmallHeader(
        title: intl.create_banking_add_account,
      ),
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
          Flexible(
            child: Text(
              intl.create_banking_personal_account,
              maxLines: 6,
              style: sTextH4Style,
            ),
          ),
          const SpaceH8(),
          Flexible(
            child: Text(
              intl.create_banking_transfer_eur,
              maxLines: 6,
              style: sSubtitle3Style.copyWith(
                color: sKit.colors.grey1,
              ),
            ),
          ),
          const SpaceH20(),
          Row(
            children: [
              const STickLongIcon(),
              const SpaceW12(),
              Text(
                intl.create_banking_conditions_1,
                style: sBodyText2Style,
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
                style: sBodyText2Style,
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
                  style: sBodyText2Style,
                ),
              ),
            ],
          ),
          const Spacer(flex: 5),
          SPrimaryButton2(
            active: true,
            name: intl.create_continue,
            onTap: () {
              sAnalytics.eurWalletTapOnContinuePersonalEUR();

              showCreatePersonalAccount(context, loading);
            },
          ),
          const SpaceH24(),
        ],
      ),
    );
  }
}
