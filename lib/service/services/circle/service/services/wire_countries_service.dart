import 'package:dio/dio.dart';

import '../../model/wire_countries/wire_countries_response_model.dart';

Future<WireCountriesResponseModel> wireCountriesService(Dio dio) async {
  final response = await dio.post(
    'url',
  );

  final responseData = response.data as Map<String, dynamic>;

  return WireCountriesResponseModel.fromJson(responseData);
}
