import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';

bool showBlockchainButton(String network) {
  final block = findBlockchaonByDescription(network);

  return block.blockchainExplorerUrlTemplate.isNotEmpty;
}

BlockchainModel findBlockchaonByDescription(String value) {
  return sSignalRModules.blockchainsModel!.blockchains
      .firstWhere((element) => element.description == value);
}

String getBlockChainURL(String network) {
  final block = findBlockchaonByDescription(network);

  //https://goerli.etherscan.io/tx/{txHash}

  return block.blockchainExplorerUrlTemplate;
}
