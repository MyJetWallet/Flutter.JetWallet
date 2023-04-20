import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:jetwallet/features/iban/widgets/iban_receive.dart';
import 'package:jetwallet/features/iban/widgets/iban_send.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/secondary_button/public/simple_secondary_button_1.dart';
import 'package:simple_kit/modules/icons/20x20/public/bank/simple_bank_icon.dart';
import 'package:simple_kit/modules/icons/20x20/public/user/simple_user_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/info/simple_info_icon.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../utils/constants.dart';
import '../../kyc/kyc_service.dart';
import 'iban_item.dart';

class IBanBody extends StatefulObserverWidget {
  const IBanBody({
    Key? key,
    required this.name,
    required this.iban,
    required this.bic,
    required this.address,
  }) : super(key: key);

  final String name;
  final String iban;
  final String bic;
  final String address;

  @override
  State<IBanBody> createState() => _IBanBodyState();
}

class _IBanBodyState extends State<IBanBody> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(saveStateToStore);
  }

  @override
  void dispose() {
    _tabController.removeListener(saveStateToStore);
    super.dispose();
  }

  void saveStateToStore() {
    getIt.get<IbanStore>().setIsReceive(_tabController.index == 0);
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return NestedScrollView(
      physics: const ClampingScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
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
                  tabs: const [
                    Tab(
                      text: 'Receive',
                    ),
                    Tab(
                      text: 'Send',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          IbanReceive(
            name: getIt.get<IbanStore>().ibanName,
            iban: getIt.get<IbanStore>().ibanAddress,
            bic: getIt.get<IbanStore>().ibanBic,
            address: getIt.get<IbanStore>().ibanAddress,
          ),
          IbanSend(),
        ],
      ),
    );

    return SingleChildScrollView(
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
                tabs: const [
                  Tab(
                    text: 'Receive',
                  ),
                  Tab(
                    text: 'Send',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                IbanReceive(
                  name: getIt.get<IbanStore>().ibanName,
                  iban: getIt.get<IbanStore>().ibanAddress,
                  bic: getIt.get<IbanStore>().ibanBic,
                  address: getIt.get<IbanStore>().ibanAddress,
                ),
                IbanSend(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
