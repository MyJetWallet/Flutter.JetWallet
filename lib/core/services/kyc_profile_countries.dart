import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:logger/logger.dart';
import 'package:simple_networking/modules/auth_api/models/country/country_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc_profile/country_list_response_model.dart';

class KycProfileCountries {
  CountryListResponseModel profileCountries = const CountryListResponseModel(countries: []);

  Future<KycProfileCountries> init() async {
    try {
      final response = await sNetwork.getAuthModule().getCountryList();

      response.pick(
        onData: (data) {
          profileCountries = data;
        },
        onError: (error) {},
      );
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'KycProfileCountries init',
            message: e.toString(),
          );
    }

    return this;
  }
}

class ProfileGetUserCountry {
  CountryResponseModel profileUserCountry = const CountryResponseModel(countryCode: '');

  Future<ProfileGetUserCountry> init() async {
    try {
      final response = await sNetwork.getAuthModule().getUserCountry();

      response.pick(
        onData: (data) {
          profileUserCountry = data;
        },
        onError: (error) {},
      );
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'ProfileGetUserCountry init',
            message: e.toString(),
          );
    }

    return this;
  }
}
