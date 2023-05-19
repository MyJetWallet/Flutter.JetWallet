import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:jetwallet/features/iban/widgets/iban_receive.dart';
import 'package:jetwallet/features/iban/widgets/iban_send.dart';
import 'package:simple_kit/core/simple_kit.dart';

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
    required this.initIndex,
    required this.isLoading,
  }) : super(key: key);

  final String name;
  final String iban;
  final String bic;
  final String address;
  final int initIndex;
  final bool isLoading;

  @override
  State<IBanBody> createState() => _IBanBodyState();
}

class _IBanBodyState extends State<IBanBody> with TickerProviderStateMixin {
  //late TabController _tabController;

  @override
  void initState() {
    super.initState();

    //getIt.get<IbanStore>().ibanTabController!.animateTo(widget.initIndex,);
    //_tabController = TabController(length: 2, vsync: this);

    //_tabController.addListener(saveStateToStore);
  }

  @override
  void dispose() {
    //_tabController.removeListener(saveStateToStore);
    super.dispose();
  }

  void saveStateToStore() {
    //getIt.get<IbanStore>().setIsReceive(_tabController.index == 0);
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return TabBarView(
      physics: widget.isLoading && !getIt.get<IbanStore>().isIbanOutActive
          ? const NeverScrollableScrollPhysics()
          : const ClampingScrollPhysics(),
      controller: getIt.get<IbanStore>().ibanTabController,
      children: [
        IbanReceive(
          name: getIt.get<IbanStore>().ibanName,
          iban: getIt.get<IbanStore>().ibanAddress,
          bic: getIt.get<IbanStore>().ibanBic,
          address: getIt.get<IbanStore>().ibanAddress,
        ),
        IbanSend(),
      ],
    );
  }
}
