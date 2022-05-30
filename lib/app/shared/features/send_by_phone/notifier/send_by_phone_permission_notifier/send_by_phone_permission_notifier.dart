import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/services/local_storage_service.dart';
import '../../view/screens/send_by_phone_input/components/show_contact_picker.dart';
import '../../view/screens/send_by_phone_input/components/show_contacts_permission_settings_alert.dart';
import '../../view/screens/send_by_phone_input/components/show_use_phonebook_alert.dart';
import 'send_by_phone_permission_state.dart';

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
class SendByPhonePermissionNotifier
    extends StateNotifier<SendByPhonePermissionState> {
  SendByPhonePermissionNotifier(this.read)
      : super(const SendByPhonePermissionState()) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _initPhonebookStatus();
    initPermissionState();
  }

  static final _logger = Logger('SendByPhonePermissionNotifier');

  final Reader read;

  late BuildContext _context;

  Future<void> _initPhonebookStatus() async {
    final storage = read(localStorageServicePod);
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

  Future<void> initPermissionState() async {
    _logger.log(notifier, 'initPermissionState');

    final status = await Permission.contacts.status;

    if (status == PermissionStatus.granted) {
      _onPermissionGranted();
    } else {
      _onPermissionDenied();
    }
  }

  void _onPermissionGranted() {
    _updatePermissionStatus(PermissionStatus.granted);
    showContactPicker(_context);
  }

  void _onPermissionDenied() {
    _updatePermissionStatus(PermissionStatus.denied);
    if (state.phonebookStatus == PhonebookStatus.undefined) {
      _showUsePhonebook();
    }
  }

  void onHelperTextTap() {
    _logger.log(notifier, 'onHelperTextTap');

    if (state.phonebookStatus == PhonebookStatus.dismissed) {
      _showUsePhonebook();
    } else {
      _showGoToSettings();
    }
  }

  void _showUsePhonebook() {
    const granted = PhonebookStatus.granted;
    const dismissed = PhonebookStatus.dismissed;
    const denied = PhonebookStatus.denied;

    showUsePhonebookAlert(
      context: _context,
      onUsePhonebook: () async {
        if (!mounted) return;
        Navigator.pop(_context); // close PhonebookAlert

        final permission = await Permission.contacts.request();

        if (permission == PermissionStatus.granted) {
          await _setPhonebookStatusInStorage(granted.name);
          _updatePhonebookStatus(granted);
          _updatePermissionStatus(permission);
          if (!mounted) return;
          showContactPicker(_context);
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

  void _showGoToSettings() {
    showContactsPermissionSettingsAlert(
      context: _context,
      onGoToSettings: () => openAppSettings().then((value) {
        Navigator.pop(_context);
        updateUserLocation(UserLocation.settings);
      }),
    );
  }

  void _updatePermissionStatus(PermissionStatus status) {
    state = state.copyWith(permissionStatus: status);
  }

  void _updatePhonebookStatus(PhonebookStatus status) {
    state = state.copyWith(phonebookStatus: status);
  }

  void updateUserLocation(UserLocation location) {
    _logger.log(notifier, 'updateUserLocation');

    state = state.copyWith(userLocation: location);
  }

  Future<void> _setPhonebookStatusInStorage(String status) async {
    await read(localStorageServicePod).setString(phonebookStatusKey, status);
  }
}
