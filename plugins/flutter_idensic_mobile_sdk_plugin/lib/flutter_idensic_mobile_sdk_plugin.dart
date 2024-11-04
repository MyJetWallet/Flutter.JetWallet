import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum SNSMobileSDKStatus {
  Ready,
  Initial,
  Incomplete,
  Pending,
  Approved,
  Failed,
  FinallyRejected,
  TemporarilyDeclined,
  ActionCompleted
}

enum SNSMobileSDKErrorType {
  Unknown,
  InvalidParameters,
  Unauthorized,
  InitialLoadingFailed,
  ApplicantNotFound,
  ApplicantMisconfigured,
  NetworkError,
  UnexpectedError,
  InititlizationError,
}

enum SNSMobileSDKAnswerType {
  Unknown,
  Ignored,
  Red,
  Yellow,
  Green,
  Error,
}

enum SNSActionResultHandlerReaction {
  Continue,
  Cancel,
}

typedef SNSTokenExpirationHandler = Future<String?> Function();
typedef SNSReady = Function();
typedef SNSStatusChangedHandler = Function(SNSMobileSDKStatus newStatus, SNSMobileSDKStatus oldStatus);
typedef SNSActionResultHandler = Future<SNSActionResultHandlerReaction> Function(SNSMobileSDKActionResult result);
typedef SNSEventHandler = Function(SNSMobileSDKEvent event);

class SNSMobileSDK {
  MethodChannel _channel = MethodChannel('sumsub.com/flutter_idensic_mobile_sdk_plugin');

  static SNSMobileSDKBuilder init(String? accessToken, SNSTokenExpirationHandler onTokenExpiration) {
    return SNSMobileSDKBuilder().withAccessToken(accessToken, onTokenExpiration);
  }

  final String? apiUrl;
  final String? accessToken;
  final Locale? locale;
  final Map<String, String>? applicantConf;
  final Map<String, String>? strings;
  final Map<String, dynamic>? preferredDocumentDefinitions;
  final Map<String, dynamic>? settings;
  final Map<String, dynamic>? theme;
  final SNSTokenExpirationHandler? onTokenExpiration;
  final SNSStatusChangedHandler? onStatusChanged;
  final SNSActionResultHandler? onActionResult;
  final SNSEventHandler? onEvent;
  final bool isAnalyticsEnabled;
  final bool isDebug;
  final int autoCloseOnApprove;

  SNSMobileSDK._builder(SNSMobileSDKBuilder builder)
      : apiUrl = builder.apiUrl,
        accessToken = builder.accessToken,
        locale = builder.locale,
        applicantConf = builder.applicantConf,
        preferredDocumentDefinitions = builder.preferredDocumentDefinitions,
        strings = builder.strings,
        settings = builder.settings,
        theme = builder.theme,
        onTokenExpiration = builder.onTokenExpiration,
        onStatusChanged = builder.onStatusChanged,
        onActionResult = builder.onActionResult,
        onEvent = builder.onEvent,
        isAnalyticsEnabled = builder.isAnalyticsEnabled,
        isDebug = builder.isDebug,
        autoCloseOnApprove = builder.autoCloseOnApprove;

  void dismiss() {
    _channel.invokeMethod('dismiss');
  }

  Future<SNSMobileSDKResult> launch() async {
    _channel.setMethodCallHandler(_onMethodCallHandler);
    final Map<dynamic, dynamic>? map = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'onLaunchSDK', _toArguments()); // as FutureOr<Map<dynamic, dynamic>>);
    return Future.value(SNSMobileSDKResult.fromMap(map!));
  }

  Future<String?> _onMethodCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onTokenExpiration":
        return onTokenExpiration!();
      case "onError":
        return null;
      case "onStatusChanged":
        return onStatusChanged!(_toStatus(call.arguments[0] as String?), _toStatus(call.arguments[1] as String?))
            as Future<String?>;
      case "onEvent":
        return onEvent!(_toEvent(call.arguments[0] as Map<dynamic, dynamic>)) as Future<String?>;
      case "onActionResult":
        final SNSActionResultHandlerReaction reaction =
            await onActionResult!(_toActionResult(call.arguments[0] as Map<dynamic, dynamic>));
        return Future.value(_fromActionResultHandlerReaction(reaction));
      default:
        print('Unknown method ${call.method}');
        throw MissingPluginException();
    }
  }

  Map<String, dynamic> _toArguments() {
    return {
      "apiUrl": apiUrl,
      "accessToken": accessToken,
      "languageCode": locale?.languageCode,
      "applicantConf": applicantConf,
      "preferredDocumentDefinitions": preferredDocumentDefinitions,
      "strings": strings,
      "settings": settings,
      "theme": theme,
      "isAnalyticsEnabled": isAnalyticsEnabled,
      "isDebug": isDebug,
      "hasOnStatusChanged": onStatusChanged != null,
      "hasOnEvent": onEvent != null,
      "hasOnActionResult": onActionResult != null,
      "autoCloseOnApprove": autoCloseOnApprove,
    };
  }
}

class SNSMobileSDKBuilder {
  // builder
  String? apiUrl;
  String? accessToken;
  Locale? locale;
  String? supportEmail;
  Map<String, String>? applicantConf;
  Map<String, String>? strings;
  Map<String, dynamic>? settings;
  Map<String, dynamic>? preferredDocumentDefinitions;
  Map<String, dynamic>? theme;
  SNSTokenExpirationHandler? onTokenExpiration;
  SNSStatusChangedHandler? onStatusChanged;
  SNSActionResultHandler? onActionResult;
  SNSEventHandler? onEvent;
  bool isAnalyticsEnabled = true;
  bool isDebug = false;
  int autoCloseOnApprove = 3;

  SNSMobileSDKBuilder();

  SNSMobileSDKBuilder withAccessToken(String? accessToken, SNSTokenExpirationHandler onTokenExpiration) {
    this.accessToken = accessToken;
    this.onTokenExpiration = onTokenExpiration;
    return this;
  }

  SNSMobileSDKBuilder withLocale(Locale locale) {
    this.locale = locale;
    return this;
  }

  SNSMobileSDKBuilder withSupportEmail(String supportEmail) {
    this.supportEmail = supportEmail;
    return this;
  }

  SNSMobileSDKBuilder withSettings(Map<String, dynamic> settings) {
    this.settings = settings;
    return this;
  }

  SNSMobileSDKBuilder withPreferredDocumentDefinitions(Map<String, dynamic> preferredDocumentDefinitions) {
    this.preferredDocumentDefinitions = preferredDocumentDefinitions;
    return this;
  }

  SNSMobileSDKBuilder withApplicantConf(Map<String, String> applicantConf) {
    this.applicantConf = applicantConf;
    return this;
  }

  SNSMobileSDKBuilder withStrings(Map<String, String> strings) {
    this.strings = strings;
    return this;
  }

  SNSMobileSDKBuilder withTheme(Map<String, dynamic> theme) {
    this.theme = theme;
    return this;
  }

  SNSMobileSDKBuilder withHandlers(
      {SNSStatusChangedHandler? onStatusChanged, SNSActionResultHandler? onActionResult, SNSEventHandler? onEvent}) {
    this.onStatusChanged = onStatusChanged;
    this.onActionResult = onActionResult;
    this.onEvent = onEvent;
    return this;
  }

  SNSMobileSDKBuilder withAnalyticsEnabled(bool isAnalyticsEnabled) {
    this.isAnalyticsEnabled = isAnalyticsEnabled;
    return this;
  }

  SNSMobileSDKBuilder withDebug(bool isDebug) {
    this.isDebug = isDebug;
    return this;
  }

  SNSMobileSDKBuilder withBaseUrl(String apiUrl) {
    this.apiUrl = apiUrl;
    return this;
  }

  SNSMobileSDKBuilder withAutoCloseOnApprove(int autoCloseOnApprove) {
    this.autoCloseOnApprove = autoCloseOnApprove;
    return this;
  }

  SNSMobileSDK build() {
    if (this.settings == null) {
      this.settings = new Map();
    }
    this.settings?["appFrameworkName"] = "flutter";

    return SNSMobileSDK._builder(this);
  }
}

class SNSMobileSDKResult {
  final bool success;
  final SNSMobileSDKStatus status;
  final SNSMobileSDKErrorType? errorType;
  final String? errorMsg;
  final SNSMobileSDKActionResult? actionResult;

  SNSMobileSDKResult(this.success, this.status, this.errorType, this.errorMsg, this.actionResult);

  static SNSMobileSDKResult fromMap(Map<dynamic, dynamic> map) {
    return SNSMobileSDKResult(
        map['success'] as bool? ?? false,
        _toStatus(map['status'] as String),
        _toErrorType(map['errorType'] as String),
        map['errorMsg'] as String,
        map['actionResult'] != null ? _toActionResult(map['actionResult'] as Map<dynamic, dynamic>) : null);
  }

  String toString() =>
      'SNSMobileSDKResult(success: $success, status: $status, errorType: $errorType, errorMsg: $errorMsg, actionResult: $actionResult)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SNSMobileSDKResult &&
        o.success == success &&
        o.status == status &&
        o.errorType == errorType &&
        o.errorMsg == errorMsg &&
        o.actionResult == actionResult;
  }

  @override
  int get hashCode {
    return success.hashCode ^ status.hashCode ^ errorType.hashCode ^ errorMsg.hashCode ^ actionResult.hashCode;
  }
}

class SNSMobileSDKActionResult {
  final String actionId;
  final String actionType;
  final SNSMobileSDKAnswerType answer;
  final bool allowContinuing;

  SNSMobileSDKActionResult(this.actionId, this.actionType, this.answer, this.allowContinuing);

  @override
  String toString() =>
      'SNSMobileSDKActionResult(actionId: $actionId, answer: $answer, actionType: $actionType, allowContinuing: $allowContinuing)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SNSMobileSDKActionResult && o.actionId == actionId && o.answer == answer;
  }

  @override
  int get hashCode => actionId.hashCode ^ answer.hashCode;
}

SNSMobileSDKStatus _toStatus(String? value) {
  SNSMobileSDKStatus status;
  switch (value) {
    case 'Ready':
      status = SNSMobileSDKStatus.Ready;
      break;
    case 'Initial':
      status = SNSMobileSDKStatus.Initial;
      break;
    case 'Incomplete':
      status = SNSMobileSDKStatus.Incomplete;
      break;
    case 'Pending':
      status = SNSMobileSDKStatus.Pending;
      break;
    case 'Approved':
      status = SNSMobileSDKStatus.Approved;
      break;
    case 'Failed':
      status = SNSMobileSDKStatus.Failed;
      break;
    case 'FinallyRejected':
      status = SNSMobileSDKStatus.FinallyRejected;
      break;
    case 'TemporarilyDeclined':
      status = SNSMobileSDKStatus.TemporarilyDeclined;
      break;
    case 'ActionCompleted':
      status = SNSMobileSDKStatus.ActionCompleted;
      break;
    default:
      throw new Exception("Unknown Status: $value");
  }

  return status;
}

SNSMobileSDKErrorType? _toErrorType(String? value) {
  if (value == null) {
    return null;
  }

  SNSMobileSDKErrorType errorType;
  switch (value) {
    case 'Unknown':
      errorType = SNSMobileSDKErrorType.Unknown;
      break;
    case 'InvalidParamaters':
      errorType = SNSMobileSDKErrorType.InvalidParameters;
      break;
    case 'Unauthorized':
      errorType = SNSMobileSDKErrorType.Unauthorized;
      break;
    case 'InitialLoadingFailed':
      errorType = SNSMobileSDKErrorType.InitialLoadingFailed;
      break;
    case 'ApplicantNotFound':
      errorType = SNSMobileSDKErrorType.ApplicantNotFound;
      break;
    case 'ApplicantMisconfigured':
      errorType = SNSMobileSDKErrorType.ApplicantMisconfigured;
      break;
    case 'NetworkError':
      errorType = SNSMobileSDKErrorType.NetworkError;
      break;
    case 'UnexpectedError':
      errorType = SNSMobileSDKErrorType.UnexpectedError;
      break;
    case 'InititlizationError':
      errorType = SNSMobileSDKErrorType.InititlizationError;
      break;
    default:
      throw new Exception("Unknown ErrorType: $value");
  }

  return errorType;
}

SNSMobileSDKAnswerType _toAnswerType(String? value) {
  SNSMobileSDKAnswerType type;
  switch (value) {
    case 'IGNORED':
      type = SNSMobileSDKAnswerType.Ignored;
      break;
    case 'RED':
      type = SNSMobileSDKAnswerType.Red;
      break;
    case 'YELLOW':
      type = SNSMobileSDKAnswerType.Yellow;
      break;
    case 'GREEN':
      type = SNSMobileSDKAnswerType.Green;
      break;
    case 'ERROR':
      type = SNSMobileSDKAnswerType.Error;
      break;
    default:
      type = SNSMobileSDKAnswerType.Unknown;
      break;
  }

  return type;
}

SNSMobileSDKActionResult _toActionResult(Map<dynamic, dynamic> value) {
  return SNSMobileSDKActionResult(
    (value['actionId'] as String?) ?? 'Unknown',
    (value['actionType'] as String?) ?? 'Unknown',
    _toAnswerType(value['answer'] as String?),
    (value['allowContinuing'] as bool?) ?? false,
  );
}

String _fromActionResultHandlerReaction(SNSActionResultHandlerReaction reaction) {
  switch (reaction) {
    case SNSActionResultHandlerReaction.Cancel:
      return "cancel";
    default:
      return "continue";
  }
}

// ------
// Events
// ------

class SNSMobileSDKEvent {
  final String eventType;
  final Map<dynamic, dynamic> payload;

  SNSMobileSDKEvent(this.eventType, this.payload);

  String toString() => 'SNSMobileSDKEvent(eventType: $eventType, payload: $payload)';
}

SNSMobileSDKEvent _toEvent(Map<dynamic, dynamic> value) {
  return SNSMobileSDKEvent(
    (value['eventType'] as String?) ?? "Unknown",
    (value['payload'] as Map<dynamic, dynamic>?) ?? {},
  );
}
