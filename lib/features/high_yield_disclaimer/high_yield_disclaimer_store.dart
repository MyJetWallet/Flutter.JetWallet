import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/wallet_api/models/disclaimer/disclaimers_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/disclaimer/disclaimers_response_model.dart';

part 'high_yield_disclaimer_store.g.dart';

class HighYieldDisclaimer extends _HighYieldDisclaimerBase
    with _$HighYieldDisclaimer {}

abstract class _HighYieldDisclaimerBase with Store {
  _HighYieldDisclaimerBase() {
    _init();
  }

  static final _logger = Logger('HighYieldDisclaimerStore');

  @observable
  String? imageUrl;

  @observable
  ObservableList<DisclaimerModel> disclaimers = ObservableList.of([]);

  @observable
  bool send = false;

  @observable
  bool activeButton = false;

  @observable
  String disclaimerId = '';

  @observable
  String title = '';

  @observable
  String description = '';

  @observable
  ObservableList<DisclaimerQuestionsModel> questions = ObservableList.of([]);

  @action
  Future<void> _init() async {
    _logger.log(notifier, 'init HighYieldDisclaimerNotifier');

    try {
      final response =
          await sNetwork.getWalletModule().getHighYieldDisclaimers();

      response.pick(
        onData: (data) {
          if (data.disclaimers != null) {
            final _disclaimers = <DisclaimerModel>[];
            for (final element in data.disclaimers!) {
              _disclaimers.add(
                DisclaimerModel(
                  description: element.description,
                  title: element.title,
                  disclaimerId: element.disclaimerId,
                  questions: element.questions,
                  imageUrl: element.imageUrl,
                ),
              );
            }

            disclaimers = ObservableList.of([..._disclaimers]);
            disclaimerId = _disclaimers[0].disclaimerId;
            description = _disclaimers[0].description;
            title = _disclaimers[0].title;
            imageUrl = _disclaimers[0].imageUrl;
            questions = ObservableList.of(_disclaimers[0].questions);
            activeButton = false;
          } else {
            send = true;
          }
        },
        onError: (error) {},
      );
    } catch (e) {
      _logger.log(stateFlow, 'Failed to fetch disclaimers', e);
    }
  }

  @action
  Future<void> sendAnswers(Function() afterRequest) async {
    if (!activeButton) {
      return;
    }
    _logger.log(notifier, '_sendAnswers');

    final answers = _prepareAnswers(questions);

    final model = DisclaimersRequestModel(
      disclaimerId: disclaimerId,
      answers: answers,
    );

    try {
      final _ = sNetwork.getWalletModule().postSaveDisclaimer(model);

      send = true;
      afterRequest();
    } catch (error) {
      _logger.log(stateFlow, '_sendAnswers', error);
    }
  }

  @action
  List<DisclaimerAnswersModel> _prepareAnswers(
    List<DisclaimerQuestionsModel> questions,
  ) {
    final answers = <DisclaimerAnswersModel>[];

    for (final element in questions) {
      answers.add(
        DisclaimerAnswersModel(
          clientId: '',
          disclaimerId: '',
          questionId: element.questionId,
          result: true,
        ),
      );
    }

    return answers;
  }

  @action
  bool isCheckBoxActive() {
    return activeButton;
  }

  @action
  void onCheckboxTap() {
    activeButton = !activeButton;
  }

  @action
  void disableCheckbox() {
    activeButton = false;
  }
}
