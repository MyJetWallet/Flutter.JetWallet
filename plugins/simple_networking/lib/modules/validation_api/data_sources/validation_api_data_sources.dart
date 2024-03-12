import 'package:data_channel/data_channel.dart';
import 'package:simple_networking/api_client/api_client.dart';
import 'package:simple_networking/helpers/handle_api_responses.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/validation_api/models/device_binding/post_device_binding_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/device_binding/post_device_binding_verify_model.dart';
import 'package:simple_networking/modules/validation_api/models/phone_number/phone_number_response_model.dart';
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

import '../models/phone_verification/phone_verification_full_request_model.dart';
import '../models/phone_verification_verify/phone_verification_full_verify_request_model.dart';

class ValidationApiDataSources {
  final ApiClient _apiClient;

  ValidationApiDataSources(this._apiClient);

  Future<DC<ServerRejectException, SendEmailConfirmationResponse>> postSendEmailConfirmationRequest(
    SendEmailConfirmationRequest model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/verification/request',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(responseData);

        return DC.data(SendEmailConfirmationResponse.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, bool>> postVerifyEmailConfirmationRequest(
    VerifyEmailConfirmationRequest model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/verification/verify',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        handleFullResponse<Map>(responseData);

        return DC.data(true);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, PhoneNumberResponseModel>> getPhoneNumberRequest() async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.validationApi}/phone-setup/get-number',
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = handleFullResponse<String>(responseData);

        return DC.data(PhoneNumberResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postPhoneVerificationRequestRequest(
    PhoneVerificationRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/phone-setup/request',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullNumberResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postPhoneVerificationVerifyRequest(
    PhoneVerificationVerifyRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/phone-setup/verify',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postPhoneVerificationFullRequestRequest(
    PhoneVerificationFullRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/phone-setup/verification/request',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullNumberResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postPhoneVerificationFullVerifyRequest(
    PhoneVerificationFullVerifyRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/phone-setup/verification/verify',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postDeviceBindingRequestRequest(
    PostDeviceBindingRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/device-binding/request',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullNumberResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postDeviceBindingVerifyRequest(
    PostDeviceBindingVerifyModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/device-binding/verify',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postTwoFaDisableRequest(
    TwoFaDisableRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/2fa/verify-disable',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postTwoFaEnableRequest(
    TwoFaEnableRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/2fa/verify-enable',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postTwoFaRequestDisableRequest(
    TwoFaVerificationRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/2fa/request-disable',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postTwoFaRequestEnableRequest(
    TwoFaVerificationRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/2fa/request-enable',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postTwoFaRequestVerificationRequest(
    TwoFaVerificationRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/2fa/request-verification',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postTwoFaVerifyRequest(
    TwoFaVerifyRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/2fa/verify',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postSendEmailVerificationCodeRequest(
    SendEmailVerificationCodeRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/email-verification/request',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postVerifyEmailVerificationCodeRequest(
    VerifyEmailVerificationCodeRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/email-verification/verify',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postVerifyTransferVerificationCodeRequest(
    VerifyWithdrawalVerificationCodeRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/transfer-verification/verify-code',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postVerifyWithdrawalVerificationCodeRequest(
    VerifyWithdrawalVerificationCodeRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.validationApi}/withdrawal-verification/verify-code',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  // Transfer Verification
  Future<DC<ServerRejectException, void>> postTransferVerifyCodeRequest(
    TransferVerifyCodeRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/account/transfer-verify',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }

  Future<DC<ServerRejectException, void>> postTransferResendCodeRequest(
    TransferResendCodeRequestModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/banking/account/transfer-resend-code',
        data: model.toJson(),
      );

      try {
        final responseData = response.data as Map<String, dynamic>;
        handleFullResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }
}
