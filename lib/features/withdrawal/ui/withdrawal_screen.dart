import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/currency_withdraw/model/address_validation_union.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_address.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_ammount.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_confirm.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_preview.dart';
import 'package:jetwallet/widgets/network_bottom_sheet/show_network_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

class WithdrawalScreen extends StatelessWidget {
  const WithdrawalScreen({
    super.key,
    required this.withdrawal,
  });

  final WithdrawalModel withdrawal;

  @override
  Widget build(BuildContext context) {
    return Provider<WithdrawalStore>(
      create: (context) => WithdrawalStore()..init(withdrawal),
      builder: (context, child) => const WithdrawalScreenBody(),
      dispose: (context, value) => value.dispose(),
    );
  }
}

class WithdrawalScreenBody extends StatefulObserverWidget {
  const WithdrawalScreenBody({super.key});

  @override
  State<WithdrawalScreenBody> createState() => _WithdrawalScreenBodyState();
}

class _WithdrawalScreenBodyState extends State<WithdrawalScreenBody> {
  @override
  Widget build(BuildContext context) {
    final store = WithdrawalStore.of(context);

    return PageView(
      controller: store.withdrawStepController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        WithdrawalAddressScreen(),
        WithdrawalAmmountScreen(),
        WithdrawalPreviewScreen(),
        WithdrawalConfirmScreen(),
      ],
    );
  }
}
