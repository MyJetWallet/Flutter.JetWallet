import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/referral_info_model.dart';

import 'referral_info_spod.dart';

final referralInfoPod = Provider.autoDispose<ReferralInfoModel>((ref) {
  final info = ref.watch(referralInfoSpod);
  var referralInfo = const ReferralInfoModel(
    descriptionLink: '',
    referralLink: '',
    title: '',
    referralTerms: [],
    referralCode: '',
  );

  info.whenData((value) {
    referralInfo = value;
  });

  return referralInfo;
});
