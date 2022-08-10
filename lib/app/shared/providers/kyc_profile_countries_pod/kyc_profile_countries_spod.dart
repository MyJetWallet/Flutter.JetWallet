import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/kyc_profile/model/country_list_response_model.dart';

import '../../../../shared/providers/service_providers.dart';

final kycProfileCountriesFpod =
    FutureProvider.autoDispose<CountryListResponseModel>((ref) {
  final service = ref.watch(kycProfileServicePod);
  final intl = ref.read(intlPod);
  return service.getCountryList(intl.localeName);
});
