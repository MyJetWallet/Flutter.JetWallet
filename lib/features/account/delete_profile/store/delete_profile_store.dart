import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/wallet_api/models/profile/profile_delete_reasons_model.dart';

part 'delete_profile_store.g.dart';

@lazySingleton
class DeleteProfileStore = _DeleteProfileStoreBase with _$DeleteProfileStore;

abstract class _DeleteProfileStoreBase with Store {
  _DeleteProfileStoreBase() {
    _init();
  }

  @observable
  ObservableList<ProfileDeleteReasonsModel> deleteReason = ObservableList.of([]);

  @observable
  ObservableList<ProfileDeleteReasonsModel> selectedDeleteReason = ObservableList.of([]);

  @observable
  bool confitionCheckbox = false;

  @observable
  StackLoaderStore loader = StackLoaderStore()..finishLoadingImmediately();

  @action
  Future<void> _init() async {
    final walletApi = sNetwork.getWalletModule();

    final request = await walletApi.postProfileDeleteReasons(intl.localeName);

    request.pick(
      onData: (data) async {
        deleteReason = ObservableList.of(data);
        selectedDeleteReason = ObservableList.of([]);
      },
      onError: (error) {},
    );
  }

  @action
  bool isAlreadySelected(int index) {
    return selectedDeleteReason.contains(deleteReason[index]);
  }

  @action
  void selectDeleteReason(int index) {
    if (isAlreadySelected(index)) {
      selectedDeleteReason.removeWhere((element) => element == deleteReason[index]);
    } else {
      selectedDeleteReason.add(deleteReason[index]);
    }
  }

  @action
  Future<void> deleteProfile() async {
    loader.startLoadingImmediately();
    final walletApi = sNetwork.getWalletModule();

    await walletApi.postProfileDelete(
      getIt.get<AppStore>().authState.deleteToken,
      selectedDeleteReason.map((e) => e.reasonId!).toList(),
    );

    await getIt.get<LogoutService>().logout(
          'delete profile',
          callbackAfterSend: () {},
        );
    loader.finishLoading();
  }

  @action
  void clickCheckbox() {
    confitionCheckbox = !confitionCheckbox;
  }
}
