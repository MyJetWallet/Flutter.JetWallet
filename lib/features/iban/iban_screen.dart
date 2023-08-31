import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:jetwallet/features/iban/widgets/iban_body.dart';
import 'package:jetwallet/features/iban/widgets/iban_empty.dart';
import 'package:jetwallet/features/iban/widgets/iban_header.dart';
import 'package:jetwallet/features/iban/widgets/iban_skeleton.dart';
import 'package:simple_kit/modules/shared/page_frames/simple_page_frame.dart';
import 'package:simple_kit/modules/shared/simple_show_alert_popup.dart';
import 'package:simple_kit/utils/constants.dart';
import 'package:simple_networking/modules/wallet_api/models/iban_info/iban_info_response_model.dart';

import '../../core/di/di.dart';
import '../../core/l10n/i10n.dart';
import '../../core/router/app_router.dart';
import '../../core/services/kyc_profile_countries.dart';
import '../../utils/helpers/check_kyc_status.dart';
import '../kyc/helper/kyc_alert_handler.dart';
import '../kyc/kyc_service.dart';
import '../kyc/models/kyc_operation_status_model.dart';

@RoutePage(name: 'IBanRouter')
class IBanScreen extends StatefulObserverWidget {
  const IBanScreen({
    super.key,
    this.initIndex = 0,
  });

  final int initIndex;

  @override
  State<IBanScreen> createState() => _IBanScreenBodyState();
}

class _IBanScreenBodyState extends State<IBanScreen> {
  late Timer updateTimer;

  @override
  void initState() {
    super.initState();
    final store = getIt.get<IbanStore>();
    final kycState = getIt.get<KycService>();
    final countriesList = getIt.get<KycProfileCountries>().profileCountries;

    getIt.get<IbanStore>().initState();
    getIt.get<IbanStore>().getAddressBook();
    getIt.get<IbanStore>().initCountryState(countriesList);
    final kycPassed = checkKycPassed(
      kycState.depositStatus,
      kycState.sellStatus,
      kycState.withdrawalStatus,
    );

    updateTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (getIt<AppRouter>().topRoute.name == 'IBanRouter' &&
            ((store.ibanBic.isEmpty && kycPassed && !store.toSetupAddress) ||
                store.status == IbanInfoStatusDto.inProcess)) {
          store.initState();
        }
      },
    );
  }

  @override
  void dispose() {
    updateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    final store = getIt.get<IbanStore>();

    final kycPassed = checkKycPassed(
      kycState.depositStatus,
      kycState.sellStatus,
      kycState.withdrawalStatus,
    );
    final kycBlocked = checkKycBlocked(
      kycState.depositStatus,
      kycState.sellStatus,
      kycState.withdrawalStatus,
    );
    final verificationInProgress = kycState.inVerificationProgress;

    final isAddress = store.toSetupAddress;
    final isKyc = !kycPassed && !kycBlocked && !verificationInProgress;
    final isLoading = kycBlocked ||
        verificationInProgress ||
        (store.status != IbanInfoStatusDto.allow &&
            store.status != IbanInfoStatusDto.notExist);

    final showEmptyScreen = store.ibanAddress.isEmpty;

    final textForShare = '${intl.iban_share_text}: \n \n'
        '${intl.iban_benificiary}: ${store.ibanName} \n'
        '${intl.iban_iban}: ${store.ibanAddress} \n'
        '${intl.iban_bic}: ${store.ibanBic} \n'
        '${intl.iban_address}: $simpleCompanyAddress \n \n'
        '${intl.iban_terms}';

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: IBanHeader(
        isShareActive:
            store.isReceive ? !showEmptyScreen && !store.isLoading : false,
        textForShare: textForShare,
        isKyc: !showEmptyScreen,
      ),
      child: (store.isLoading && !store.wasFirstLoad)
          ? const IBanSkeleton()
          : showEmptyScreen
              ? IBanEmpty(
                  isLoading: isLoading,
                  isAddress: isAddress,
                  isKyc: isKyc,
                  onButtonTap: () {
                    sShowAlertPopup(
                      context,
                      primaryText: intl.iban_hold_on,
                      secondaryText: isKyc
                          ? intl.iban_please_verify
                          : intl.iban_please_provide,
                      primaryButtonName: isKyc
                          ? intl.iban_start_verification
                          : intl.iban_provide,
                      image: Image.asset(
                        phoneChangeAsset,
                        width: 80,
                        height: 80,
                        package: 'simple_kit',
                      ),
                      onPrimaryButtonTap: () {
                        if (isKyc) {
                          Navigator.pop(context);
                          final isDepositAllow = kycState.depositStatus !=
                              kycOperationStatus(KycStatus.allowed);
                          final isWithdrawalAllow = kycState.withdrawalStatus !=
                              kycOperationStatus(KycStatus.allowed);

                          kycAlertHandler.handle(
                            status: isDepositAllow
                                ? kycState.depositStatus
                                : isWithdrawalAllow
                                    ? kycState.withdrawalStatus
                                    : kycState.sellStatus,
                            isProgress: kycState.verificationInProgress,
                            currentNavigate: () {},
                            requiredDocuments: kycState.requiredDocuments,
                            requiredVerifications:
                                kycState.requiredVerifications,
                          );
                        } else {
                          Navigator.pop(context);
                          sRouter.push(
                            const IbanAddressRouter(),
                          );
                        }
                      },
                      secondaryButtonName: intl.iban_cancel,
                      onSecondaryButtonTap: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                )
              : IBanBody(
                  name: store.ibanName,
                  iban: store.ibanAddress,
                  bic: store.ibanBic,
                  address: store.ibanAddress,
                  initIndex: widget.initIndex,
                  isKyc: !showEmptyScreen,
                ),
    );
  }
}
