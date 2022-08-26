import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/authentication/model/country/country_response_model.dart';

import '../../../../shared/providers/service_providers.dart';

final profileUserCountryFpod =
    FutureProvider.autoDispose<CountryResponseModel>((ref) {
  final service = ref.watch(authServicePod);
  final intl = ref.read(intlPod);
  return service.getUserCountry(intl.localeName);
});
