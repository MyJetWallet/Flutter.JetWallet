import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:provider/provider.dart';

@RoutePage(name: 'WithdrawRouter')
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
      builder: (context, child) => const AutoRouter(),
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

    return const AutoRouter();
    /*
      store.withdrawalType == WithdrawalType.Asset
          ? const [
              WithdrawalAddressScreen(),
              WithdrawalAmmountScreen(),
              WithdrawalPreviewScreen(),
              WithdrawalConfirmScreen(),
            ]
          : const [
              WithdrawalAddressScreen(),
              WithdrawalPreviewScreen(),
              WithdrawalConfirmScreen(),
            ],
    );
    */
  }
}
