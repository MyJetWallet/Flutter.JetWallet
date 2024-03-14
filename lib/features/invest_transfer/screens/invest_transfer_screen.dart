import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/invest_transfer/screens/invest_deposite_amount_screen.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/widgets/navigation/segment_control/models/segment_control_data.dart';
import 'package:simple_kit_updated/widgets/navigation/segment_control/segment_control.dart';

@RoutePage(name: 'InvestTransferRoute')
class InvestTransferScreen extends StatefulWidget {
  const InvestTransferScreen({
    super.key,
  });

  @override
  State<InvestTransferScreen> createState() => _InvestAmountScreen();
}

class _InvestAmountScreen extends State<InvestTransferScreen> with TickerProviderStateMixin {
  late TabController tabController;

  final countOfTabs = 2;

  @override
  void initState() {
    tabController = TabController(
      length: countOfTabs,
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: '',
          onBackButtonTap: () {
            sRouter.pop();
          },
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SPaddingH24(
                child: SegmentControl(
                  tabController: tabController,
                  shrinkWrap: true,
                  items: [
                    SegmentControlData(
                      type: SegmentControlType.iconText,
                      text: intl.invest_deposit,
                      icon: Assets.svg.medium.addCash,
                    ),
                    SegmentControlData(
                      type: SegmentControlType.iconText,
                      text: intl.withdrawal_withdraw_verb,
                      icon: Assets.svg.medium.withdrawal,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                InvestDepositeAmountScreen(),
                InvestDepositeAmountScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
