import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:simple_networking/modules/auth_api/models/country/country_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc_profile/country_list_response_model.dart';

class KycProfileCountries {
  late CountryListResponseModel profileCountries;

  Future<KycProfileCountries> init() async {
    final response = await sNetwork.getAuthModule().getCountryList();

    response.pick(
      onData: (data) {
        profileCountries = data;
      },
      onError: (error) {},
    );

    return this;
  }
}

class ProfileGetUserCountry {
  late CountryResponseModel profileUserCountry;

  Future<ProfileGetUserCountry> init() async {
    final response = await sNetwork.getAuthModule().getUserCountry();

    response.pick(
      onData: (data) {
        profileUserCountry = data;
      },
      onError: (error) {},
    );

    return this;
  }
}
