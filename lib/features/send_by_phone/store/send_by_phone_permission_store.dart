import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_input/widgets/show_contact_picker.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_input/widgets/show_contacts_permission_settings_alert.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_input/widgets/show_use_phonebook_alert.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';

part 'send_by_phone_permission_store.g.dart';

enum PhonebookStatus { granted, dismissed, denied, undefined }

enum UserLocation { app, settings }

/// Initialization Algorithm:
/// 1. Check if Permission.contacts.status
///   1) if granted:
///       a. hide helper text ("I want to use my phonebook")
///       b. open bootomSheet with contacts
///   2) if denied:
///       a. show helper text
///       b. check UsePhonebook status from the storage
///           1) if dismissed ("Enter manually" pressed)
///               on helper text pressed show UsePhonebook popup
///           2) if denied (system permission popup was denied)
///               on helper text pressed show GoToSettings popup
///           3) if storage is empty
///               show UsePhonebook popup
///                 1. if pressed grey area
///                     save status to the storage as dissmissed
///                 2. if enter manually
///                     save status to the storage as dissmissed
///                 3. if use phonebook
///                     show system permission popup
///                       a. if granted
///                            save status to the storage as granted
///                       b. if denied
///                            save status to the storage as denied
///           4) if granted
///               (means that user granted and manually denied in settings)
///               on helper text pressed show GoToSettings popup
///
/// Additional things to consider:
/// [permission_handler: 8.3.0] has severe bug that required workaround above.
/// The bug description:
/// When tapping on greyed area of the permission popup it returns
/// PermissionStatus.permanentlyDenied but should PermissionStatus.denied
/// https://github.com/Baseflow/flutter-permission-handler/issues/757
class SendByPhonePermission = _SendByPhonePermissionBase
    with _$SendByPhonePermission;

abstract class _SendByPhonePermissionBase with Store {
  _SendByPhonePermissionBase() {
    _initPhonebookStatus();
    initPermissionState();
  }

  static final _logger = Logger('SendByPhonePermissionStore');

  @observable
  UserLocation userLocation = UserLocation.app;

  @observable
  PermissionStatus permissionStatus = PermissionStatus.denied;

  @observable
  PhonebookStatus phonebookStatus = PhonebookStatus.undefined;

  @action
  Future<void> _initPhonebookStatus() async {
    final storage = sLocalStorageService;
    final status = await storage.getValue(phonebookStatusKey);

    if (status == PhonebookStatus.granted.name) {
      _updatePhonebookStatus(PhonebookStatus.granted);
    } else if (status == PhonebookStatus.denied.name) {
      _updatePhonebookStatus(PhonebookStatus.denied);
    } else if (status == PhonebookStatus.dismissed.name) {
      _updatePhonebookStatus(PhonebookStatus.dismissed);
    } else {
      _updatePhonebookStatus(PhonebookStatus.undefined);
    }
  }

  @action
  Future<void> initPermissionState() async {
    _logger.log(notifier, 'initPermissionState');

    final status = await Permission.contacts.status;

    if (status == PermissionStatus.granted) {
      _onPermissionGranted();
    } else {
      _onPermissionDenied();
    }
  }

  @action
  void _onPermissionGranted() {
    _updatePermissionStatus(PermissionStatus.granted);
    showContactPicker(sRouter.navigatorKey.currentContext!);
  }

  @action
  void _onPermissionDenied() {
    _updatePermissionStatus(PermissionStatus.denied);
    if (phonebookStatus == PhonebookStatus.undefined) {
      _showUsePhonebook();
    }
  }

  @action
  void onHelperTextTap() {
    _logger.log(notifier, 'onHelperTextTap');

    if (phonebookStatus == PhonebookStatus.dismissed) {
      _showUsePhonebook();
    } else {
      _showGoToSettings();
    }
  }

  @action
  void _showUsePhonebook() {
    const granted = PhonebookStatus.granted;
    const dismissed = PhonebookStatus.dismissed;
    const denied = PhonebookStatus.denied;

    showUsePhonebookAlert(
      context: sRouter.navigatorKey.currentContext!,
      onUsePhonebook: () async {
        await sRouter.pop(); // close PhonebookAlert

        final permission = await Permission.contacts.request();

        if (permission == PermissionStatus.granted) {
          await _setPhonebookStatusInStorage(granted.name);
          _updatePhonebookStatus(granted);
          _updatePermissionStatus(permission);

          showContactPicker(sRouter.navigatorKey.currentContext!);
        } else {
          await _setPhonebookStatusInStorage(denied.name);
          _updatePhonebookStatus(denied);
          _updatePermissionStatus(permission);
        }
      },
      onPopupQuit: () async {
        await _setPhonebookStatusInStorage(dismissed.name);
        _updatePhonebookStatus(dismissed);
      },
    );
  }

  @action
  void _showGoToSettings() {
    showContactsPermissionSettingsAlert(
      context: sRouter.navigatorKey.currentContext!,
      onGoToSettings: () => openAppSettings().then((value) {
        sRouter.pop();
        updateUserLocation(UserLocation.settings);
      }),
    );
  }

  @action
  void _updatePermissionStatus(PermissionStatus status) {
    permissionStatus = status;
  }

  @action
  void _updatePhonebookStatus(PhonebookStatus status) {
    phonebookStatus = status;
  }

  @action
  void updateUserLocation(UserLocation location) {
    _logger.log(notifier, 'updateUserLocation');

    userLocation = location;
  }

  @action
  Future<void> _setPhonebookStatusInStorage(String status) async {
    await sLocalStorageService.setString(phonebookStatusKey, status);
  }
}
