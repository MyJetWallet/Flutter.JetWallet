import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:jetwallet/features/iban/widgets/iban_receive.dart';
import 'package:jetwallet/features/iban/widgets/iban_send.dart';
import 'package:simple_kit/core/simple_kit.dart';

import '../../../core/di/di.dart';

class IBanBody extends StatefulObserverWidget {
  const IBanBody({
    super.key,
    required this.name,
    required this.iban,
    required this.bic,
    required this.address,
    required this.initIndex,
    required this.isKyc,
  });

  final String name;
  final String iban;
  final String bic;
  final String address;
  final int initIndex;
  final bool isKyc;

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

    return TabBarView(
      physics: getIt.get<IbanStore>().isIbanOutActive && widget.isKyc
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      controller: getIt.get<IbanStore>().ibanTabController,
      children: [
        IbanReceive(
          name: getIt.get<IbanStore>().ibanName,
          iban: getIt.get<IbanStore>().ibanAddress,
          bic: getIt.get<IbanStore>().ibanBic,
          address: getIt.get<IbanStore>().ibanAddress,
        ),
        const IbanSend(),
      ],
    );
  }
}
