import '../../dto/authentication/auth_response_dto.dart';
import '../../model/authentication/auth_model.dart';

AuthModel handleAuthResponse(AuthResponseDto dto) {
  final result = dto.result;

  if (result == 0) {
    return dto.data.toModel();
  } else if (result == -9) {
    throw 'Expired';
  } else if (result == -8) {
    throw 'SystemError';
  } else if (result == -7) {
    throw 'PersonalDataNotValid';
  } else if (result == -6) {
    throw 'FileNotFound';
  } else if (result == -5) {
    throw 'FileWrongExtension';
  } else if (result == -4) {
    throw 'OldPasswordNotMatch';
  } else if (result == -3) {
    throw 'UserNotExist';
  } else if (result == -2) {
    throw 'UserExists';
  } else if (result == -1) {
    throw 'InvalidUserNameOrPassword';
  } else if (result == -999) {
    throw 'ForceUpdate';
  } else {
    throw 'Something went wrong';
  }
}
