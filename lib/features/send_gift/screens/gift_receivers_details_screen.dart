import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/l10n/i10n.dart';
import '../store/receiver_datails_store.dart';
import '../widgets/continue_button.dart';
import '../widgets/email_field_tab.dart';
import '../widgets/gift_policy_checkbox.dart';
import '../widgets/phone_number_field_tab.dart';

@RoutePage(name: 'GiftReceiversDetailsRouter')
class GiftReceiversDetailsScreen extends StatefulWidget {
  const GiftReceiversDetailsScreen({super.key});

  @override
  State<GiftReceiversDetailsScreen> createState() =>
      _GiftReceiversDetailsScreenState();
}

class _GiftReceiversDetailsScreenState extends State<GiftReceiversDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final store = ReceiverDatailsStore()..getInitialCheck();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _tabController.addListener(() {
      store.selectedContactType = _tabController.index == 0
          ? ReceiverContacrType.email
          : ReceiverContacrType.phone;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPageFrame(
      color: colors.white,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.send_gift_Receiver_details,
        ),
      ),
      child: Column(
        children: [
          SPaddingH24(
            child: Container(
              height: 32,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.grey5,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                labelColor: colors.white,
                labelStyle: sSubtitle3Style,
                unselectedLabelColor: colors.grey1,
                unselectedLabelStyle: sSubtitle3Style,
                splashBorderRadius: BorderRadius.circular(16),
                tabs: [
                  Tab(
                    text: intl.send_gift_e_mail,
                  ),
                  Tab(
                    text: intl.send_gift_phone,
                  ),
                ],
              ),
            ),
          ),
          const SpaceH30(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Observer(
                  builder: (context) {
                    return EmailFieldTab(store: store);
                  },
                ),
                Observer(
                  builder: (_) => PhoneNumberFieldTab(
                    store: store,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          ColoredBox(
            color: colors.grey5,
            child: SPaddingH24(
              child: Observer(
                builder: (context) {
                  return GiftPolicyCheckbox(
                    isChecked: store.checkIsSelected,
                    onCheckboxTap: store.onChangedCheck,
                  );
                },
              ),
            ),
          ),
          ContinueButton(store: store),
          ColoredBox(
            color: colors.grey5,
            child: const SpaceH42(),
          ),
        ],
      ),
    );
  }
}
