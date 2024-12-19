import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/models/remote_config_union.dart';
import 'package:jetwallet/core/services/route_query_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/app/timer_service.dart';
import 'package:simple_networking/modules/signal_r/models/crypto_card_otps_message_model.dart';

Future<void> pushCryptoCardOtpCodeScreen(CryptoCardOtpsModel cryptoCardOtp) async {
  if (getIt.isRegistered<AppStore>() &&
      getIt.get<AppStore>().remoteConfigStatus is Success &&
      getIt.get<AppStore>().authorizedStatus is Home &&
      getIt<TimerService>().isPinScreenOpen == false) {
    await sRouter.push(CryptoCardOtpCodeRoute(cryptoCardOtp: cryptoCardOtp));
  } else {
    getIt<RouteQueryService>().addToQuery(
      RouteQueryModel(
        func: () async {
          await sRouter.push(CryptoCardOtpCodeRoute(cryptoCardOtp: cryptoCardOtp));
        },
      ),
    );
  }
}
