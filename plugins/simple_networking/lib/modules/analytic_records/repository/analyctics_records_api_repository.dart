import 'package:data_channel/data_channel.dart';
import 'package:simple_networking/api_client/api_client.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/analytic_records/data_sources/analyctics_records_api_data_sources.dart';
import 'package:simple_networking/modules/analytic_records/models/analytic_record.dart';
import 'package:simple_networking/modules/analytic_records/models/anchor_record.dart';
import 'package:simple_networking/modules/analytic_records/models/analytic_record_response.dart';
import 'package:simple_networking/modules/analytic_records/models/push_notification_open_request.dart';

class AnalycticsRecordsApiRepository {
  AnalycticsRecordsApiRepository(this._apiClient) {
    _analycticsRecordshApiDataSource = AnalycticsRecordsApiDataSources(_apiClient);
  }

  final ApiClient _apiClient;
  late final AnalycticsRecordsApiDataSources _analycticsRecordshApiDataSource;

  Future<DC<ServerRejectException, AnalyticRecordResponseModel>> postAddAnalyticRecord(
    List<AnalyticRecordModel> listRecords,
  ) async {
    return _analycticsRecordshApiDataSource.postAddAnalyticRecordRequest(
      listRecords,
    );
  }

  Future<DC<ServerRejectException, void>> postAddAnchor(
    AnchorRecordModel anchorRecord,
  ) async {
    return _analycticsRecordshApiDataSource.postAddAnchorRequest(
      anchorRecord,
    );
  }

  Future<DC<ServerRejectException, void>> postPushNotificationOpen(
    PushNotificationOpenRequestModel pushNotificationOpenRequestModel,
  ) async {
    final Map<String, dynamic> data = {
      'messageId': pushNotificationOpenRequestModel.messageId,
      'appVersion': pushNotificationOpenRequestModel.appVersion,
      'device': pushNotificationOpenRequestModel.device,
      'status': pushNotificationOpenRequestModel.status,
    };

    return _analycticsRecordshApiDataSource.postPushNotificationOpenRequest(
      data,
    );
  }
}
