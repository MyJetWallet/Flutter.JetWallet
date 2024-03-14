import 'package:data_channel/data_channel.dart';
import 'package:simple_networking/api_client/api_client.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/validation_api/data_sources/validation_api_data_sources.dart';
import 'package:simple_networking/modules/validation_api/models/device_binding/post_device_binding_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/device_binding/post_device_binding_verify_model.dart';
import 'package:simple_networking/modules/validation_api/models/phone_number/phone_number_response_model.dart';
import 'package:simple_networking/modules/validation_api/models/phone_verification/phone_verification_full_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/phone_verification/phone_verification_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/phone_verification_verify/phone_verification_verify_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/send_email/send_email_confirmation_request.dart';
import 'package:simple_networking/modules/validation_api/models/send_email/send_email_confirmation_response.dart';
import 'package:simple_networking/modules/validation_api/models/transfer_verification/transfer_resend_code_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/transfer_verification/transfer_verify_code_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/two_fa_disable/two_fa_disable_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/two_fa_enable/two_fa_enable_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/two_fa_verification/two_fa_verification_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/two_fa_verify/two_fa_verify_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/validation/send_email_verification_code_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/validation/verify_email_verification_code_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/validation/verify_withdrawal_verification_code_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/verify_email/verify_email_confirmation_request.dart';

import '../models/phone_verification_verify/phone_verification_full_verify_request_model.dart';

class ValidationApiRepository {
  ValidationApiRepository(this._apiClient) {
    _validationApiDataSources = ValidationApiDataSources(_apiClient);
  }

  final ApiClient _apiClient;
  late final ValidationApiDataSources _validationApiDataSources;

  Future<DC<ServerRejectException, SendEmailConfirmationResponse>> postSendEmailConfirmation(
    SendEmailConfirmationRequest model,
  ) async {
    return _validationApiDataSources.postSendEmailConfirmationRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, bool>> postVerifyEmailConfirmation(
    VerifyEmailConfirmationRequest model,
  ) async {
    return _validationApiDataSources.postVerifyEmailConfirmationRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, PhoneNumberResponseModel>> getPhoneNumber() async {
    return _validationApiDataSources.getPhoneNumberRequest();
  }

  Future<DC<ServerRejectException, void>> postPhoneVerificationRequest(
    PhoneVerificationRequestModel model,
  ) async {
    return _validationApiDataSources.postPhoneVerificationRequestRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postPhoneVerificationVerify(
    PhoneVerificationVerifyRequestModel model,
  ) async {
    return _validationApiDataSources.postPhoneVerificationVerifyRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postPhoneVerificationFullRequest(
    PhoneVerificationFullRequestModel model,
  ) async {
    return _validationApiDataSources.postPhoneVerificationFullRequestRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postPhoneVerificationFullVerify(
    PhoneVerificationFullVerifyRequestModel model,
  ) async {
    return _validationApiDataSources.postPhoneVerificationFullVerifyRequest(
      model,
    );
  }

  /// Device Binding

  Future<DC<ServerRejectException, void>> postDeviceBindingRequest(
    PostDeviceBindingRequestModel model,
  ) async {
    return _validationApiDataSources.postDeviceBindingRequestRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postDeviceBindingVerify(
    PostDeviceBindingVerifyModel model,
  ) async {
    return _validationApiDataSources.postDeviceBindingVerifyRequest(
      model,
    );
  }

  /// TWO_FA

  Future<DC<ServerRejectException, void>> postTwoFaDisable(
    TwoFaDisableRequestModel model,
  ) async {
    return _validationApiDataSources.postTwoFaDisableRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postTwoFaEnable(
    TwoFaEnableRequestModel model,
  ) async {
    return _validationApiDataSources.postTwoFaEnableRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postTwoFaRequestDisable(
    TwoFaVerificationRequestModel model,
  ) async {
    return _validationApiDataSources.postTwoFaRequestDisableRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postTwoFaRequestEnable(
    TwoFaVerificationRequestModel model,
  ) async {
    return _validationApiDataSources.postTwoFaRequestEnableRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postTwoFaRequestVerification(
    TwoFaVerificationRequestModel model,
  ) async {
    return _validationApiDataSources.postTwoFaRequestVerificationRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postTwoFaVerify(
    TwoFaVerifyRequestModel model,
  ) async {
    return _validationApiDataSources.postTwoFaVerifyRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postSendEmailVerificationCode(
    SendEmailVerificationCodeRequestModel model,
  ) async {
    return _validationApiDataSources.postSendEmailVerificationCodeRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postVerifyEmailVerificationCode(
    VerifyEmailVerificationCodeRequestModel model,
  ) async {
    return _validationApiDataSources.postVerifyEmailVerificationCodeRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postVerifyTransferVerificationCode(
    VerifyWithdrawalVerificationCodeRequestModel model,
  ) async {
    return _validationApiDataSources.postVerifyTransferVerificationCodeRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postVerifyWithdrawalVerificationCode(
    VerifyWithdrawalVerificationCodeRequestModel model,
  ) async {
    return _validationApiDataSources.postVerifyWithdrawalVerificationCodeRequest(
      model,
    );
  }

  // Transfer Verification
  Future<DC<ServerRejectException, void>> postTransferVerifyCode(
    TransferVerifyCodeRequestModel model,
  ) async {
    return _validationApiDataSources.postTransferVerifyCodeRequest(
      model,
    );
  }

  Future<DC<ServerRejectException, void>> postTransferResendCode(
    TransferResendCodeRequestModel model,
  ) async {
    return _validationApiDataSources.postTransferResendCodeRequest(
      model,
    );
  }
}
