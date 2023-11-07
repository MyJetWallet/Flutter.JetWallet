import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_request.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_sevsitive_response.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/notification_service.dart';
import '../ui/set_up_password_screen.dart';

part 'simple_card_store.g.dart';

@lazySingleton
class SimpleCardStore = _SimpleCardStoreBase with _$SimpleCardStore;


abstract class _SimpleCardStoreBase with Store {

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  bool showDetails = false;
  @action
  bool setShowDetails(bool value) => showDetails = value;

  @observable
  bool isFrozen = true;
  @action
  void setFrozen(bool value) {
    if (showDetails) {
      setShowDetails(false);
    }
    isFrozen = value;
  }

  @observable
  SimpleCardSensitiveResponse? cardSensitiveData = SimpleCardSensitiveResponse(
    cardExpDate: '12/24',
    cardCvv: '234',
    cardHolderName: 'Test Test',
    cardNumber: '2444 4444 4444 4444',
  );

  @observable
  SimpleCardModel? card = SimpleCardModel(
    cardId: '',
    cardPan: '',
    cardExpDate: '',
    cardType: 'Virtual card',
    currency: 'EUR',
    nameOnCard: '',
    balance: Decimal.zero,
    status: AccountStatusCard.active,
  );

  @action
  void setCardInfo(SimpleCardModel? cardData) {
    card = cardData;
  }

  @action
  Future<void> createCard(String pin) async {
    loader.startLoading();

    try {
      final response = await sNetwork.getWalletModule().postSimpleCardCreate(
        data: SimpleCardCreateRequest(
          requestId: DateTime.now().microsecondsSinceEpoch.toString(),
          pin: pin,
        ),
      );

      response.pick(
        onData: (data) async {
          print('response.pick');
          print(data);
          // setCardInfo(data.card);
          final context = getIt.get<AppRouter>().navigatorKey.currentContext;
          Navigator.pop(context!);
          await Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              barrierColor: Colors.white,
              pageBuilder: (BuildContext _, __, ___) {
                return const SetUpPasswordScreen();
              },
              transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                  ) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                final tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          ).then((value) async {});
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            duration: 4,
            id: 1,
            needFeedback: true,
          );

          loader.finishLoading();
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        duration: 4,
        id: 1,
        needFeedback: true,
      );

      loader.finishLoading();
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        duration: 4,
        id: 1,
        needFeedback: true,
      );

      loader.finishLoading();
    }
  }

}
