import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/send_gift/model/send_gift_info_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/remote_config/remote_config_values.dart';
import '../store/receiver_datails_store.dart';
import '../widgets/email_field_tab.dart';
import '../widgets/gift_policy_checkbox.dart';
import '../widgets/phone_number_field_tab.dart';

@RoutePage(name: 'GiftReceiversDetailsRouter')
class GiftReceiversDetailsScreen extends StatefulWidget {
  const GiftReceiversDetailsScreen({super.key, required this.sendGiftInfo});

  final SendGiftInfoModel sendGiftInfo;

  @override
  State<GiftReceiversDetailsScreen> createState() => _GiftReceiversDetailsScreenState();
}

class _GiftReceiversDetailsScreenState extends State<GiftReceiversDetailsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final store = ReceiverDatailsStore()..getInitialCheck();

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _tabController.addListener(() {
      store.selectedContactType = _tabController.index == 0 ? ReceiverContacrType.email : ReceiverContacrType.phone;
    });
    super.initState();
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
      loaderText: intl.loader_please_wait,
      color: colors.grey5,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.send_gift_Receiver_details,
        ),
      ),
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                if (usePhoneForSendGift) ...[
                  ColoredBox(
                    color: colors.white,
                    child: SPaddingH24(
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
                  ),
                  Container(
                    color: colors.white,
                    height: 16,
                  ),
                ],
                SizedBox(
                  height: 88,
                  child: usePhoneForSendGift
                      ? TabBarView(
                          controller: _tabController,
                          children: [
                            ColoredBox(
                              color: colors.white,
                              child: Observer(
                                builder: (context) {
                                  return EmailFieldTab(store: store);
                                },
                              ),
                            ),
                            Observer(
                              builder: (_) => PhoneNumberFieldTab(
                                store: store,
                              ),
                            ),
                          ],
                        )
                      : ColoredBox(
                          color: colors.white,
                          child: Observer(
                            builder: (context) {
                              return EmailFieldTab(store: store);
                            },
                          ),
                        ),
                ),
                const Spacer(),
                SPaddingH24(
                  child: Observer(
                    builder: (context) {
                      return GiftPolicyCheckbox(
                        isChecked: store.checkIsSelected,
                        onCheckboxTap: store.onChangedCheck,
                      );
                    },
                  ),
                ),
                Observer(
                  builder: (context) {
                    return InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        store.onButtonTaped();
                      },
                      child: SPaddingH24(
                        child: SButton.blue(
                          text: intl.setPhoneNumber_continue,
                          callback: store.isformValid
                              ? () {
                                  sRouter.push(
                                    GiftAmountRouter(
                                      sendGiftInfo: widget.sendGiftInfo.copyWith(
                                        email: store.email,
                                        phoneBody: store.phoneBody,
                                        phoneCountryCode: store.phoneCountryCode,
                                        selectedContactType: store.selectedContactType,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                ColoredBox(
                  color: colors.grey5,
                  child: const SpaceH40(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
