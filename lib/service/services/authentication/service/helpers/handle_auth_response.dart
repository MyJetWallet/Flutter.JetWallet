import '../../model/authenticate/authentication_model.dart';

AuthenticationModel handleAuthResponse(Map<String, dynamic> json) {
  final response = AuthResponseModel.fromJson(json);

  final result = response.result;

  if (result == 0) {
    return response.authModel!;
  } else {
    _validateResultResponse(result);
    throw 'Something went wrong';
  }
}

void handleAuthResult(Map<String, dynamic> json) {
  final result = json['result'] as int;

  if (result != 0) {
    _validateResultResponse(result);
  }
}

void _validateResultResponse(int result) {
  if (result == -9) {
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
