import 'dart:convert';

import 'package:data_channel/data_channel.dart';
import 'package:simple_networking/api_client/api_client.dart';
import 'package:simple_networking/helpers/handle_api_responses.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/analytic_records/models/analytic_record.dart';
import 'package:simple_networking/modules/analytic_records/models/anchor_record.dart';
import 'package:simple_networking/modules/analytic_records/models/analytic_record_response.dart';

class AnalycticsRecordsApiDataSources {
  final ApiClient _apiClient;

  AnalycticsRecordsApiDataSources(this._apiClient);

  Future<DC<ServerRejectException, AnalyticRecordResponseModel>> postAddAnalyticRecordRequest(
    List<AnalyticRecordModel> listRecords,
  ) async {
    try {
      final listJson = <Map<String, dynamic>>[];

      for (var record in listRecords) {
        final recordJsson = record.toJson();
        recordJsson['eventBody'] = json.encode(recordJsson['eventBody']);
        listJson.add(recordJsson);
      }

      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/analytic-records/add-analytic-record-v2',
        data: listJson,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        final data = handleFullResponse<Map>(
          responseData,
        );

        return DC.data(AnalyticRecordResponseModel.fromJson(data));
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DC<ServerRejectException, void>> postAddAnchorRequest(
    AnchorRecordModel anchorRecord,
  ) async {
    try {
      final recordJson = anchorRecord.toJson();
      recordJson['metadata'] = json.encode(recordJson['metadata']);

      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/analytic-records/add-anchor',
        data: recordJson,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DC<ServerRejectException, void>> postPushNotificationOpenRequest(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(
        '${_apiClient.options.walletApi}/analytic-records/push-notification-open',
        data: data,
      );

      try {
        final responseData = response.data as Map<String, dynamic>;

        handleResultResponse(responseData);

        return DC.data(null);
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }
}
