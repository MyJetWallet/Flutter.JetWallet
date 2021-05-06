import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/screens/wallet/wallet_view_model.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WalletViewModel>(
      converter: (store) => WalletViewModel.fromStore(store),
      builder: (context, vm) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'BALANCE',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const Text(
                'USD 0',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  'Currencies',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: vm.assetBalanceList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Image.network(
                            vm.assetBalanceList[index].icon,
                            width: 40,
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(vm.assetBalanceList[index].description),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Text(vm
                                        .assetBalanceList[index].balance
                                        .toString()),
                                  ),
                                  Text(vm.assetBalanceList[index].symbol),
                                ],
                              ),
                              const Text(
                                'USD 0',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
