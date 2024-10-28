import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/auth/register/ui/widgets/referral_code/referral_code.dart';
import 'package:jetwallet/features/auth/user_data/store/user_data_store.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/birth_date/show_birrth_date_picker.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/country_field.dart';
import 'package:jetwallet/widgets/show_verification_modal.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/headers/simple_auth_header.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../../core/di/di.dart';
import '../../../../core/services/user_info/user_info_service.dart';
import 'widgets/birth_date/store/selected_date_store.dart';

@RoutePage(name: 'UserDataScreenRouter')
class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  @override
  void initState() {
    super.initState();
    sNetwork.getWalletModule().getSessionInfo().then((value) {
      final techAcc = value.data?.isTechClient ?? false;
      sAnalytics.updateisTechAcc(techAcc: techAcc);
      sAnalytics.signInFlowPersonalDetailsView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider<SelectedDateStore>(
      create: (context) => SelectedDateStore(),
      builder: (context, child) => Provider<UserDataStore>(
        create: (_) => UserDataStore(
          SelectedDateStore.of(context),
        ),
        dispose: (context, store) => store.dispose(),
        builder: (context, child) {
          return const _UserDataScreenBody();
        },
      ),
    );
  }
}

class _UserDataScreenBody extends StatelessObserverWidget {
  const _UserDataScreenBody();

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final birthDateInfo = SelectedDateStore.of(context);
    final birthDateController = TextEditingController();

    birthDateController.text = birthDateInfo.selectedDate;

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      loading: birthDateInfo.loader,
      color: colors.grey5,
      header: SLargeHeader(
        //customIconButton: const SpaceH24(),
        progressValue: 60,
        title: intl.user_data_whats_your_name,
        customIconButton: SIconButton(
          onTap: () {
            showModalVerification(context);
          },
          defaultIcon: const SCloseIcon(),
          pressedIcon: const SClosePressedIcon(),
        ),
      ),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ColoredBox(
                              color: colors.white,
                              child: SPaddingH24(
                                child: SStandardField(
                                  controller: UserDataStore.of(context).firstNameController,
                                  labelText: intl.user_data_first_name,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                      RegExp('[ ]'),
                                    ),
                                  ],
                                  isError: UserDataStore.of(context).firstNameError,
                                  textCapitalization: TextCapitalization.words,
                                  onErase: () {
                                    UserDataStore.of(context).clearNameError();
                                  },
                                  onChanged: (val) {
                                    UserDataStore.of(context).updateFirstName(val.trim());
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SpaceW1(),
                          Expanded(
                            child: ColoredBox(
                              color: colors.white,
                              child: SPaddingH24(
                                child: SStandardField(
                                  controller: UserDataStore.of(context).lastNameController,
                                  labelText: intl.user_data_last_name,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                      RegExp('[ ]'),
                                    ),
                                  ],
                                  isError: UserDataStore.of(context).lastNameError,
                                  textCapitalization: TextCapitalization.words,
                                  onChanged: (val) {
                                    UserDataStore.of(context).updateLastName(val.trim());
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SpaceH1(),
                  ColoredBox(
                    color: colors.white,
                    child: SPaddingH24(
                      child: SStandardField(
                        labelText: intl.user_data_date_of_birth,
                        readOnly: true,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          showBirthDatePicker(
                            context,
                            birthDateInfo,
                            UserDataStore.of(context),
                          );
                        },
                        controller: birthDateController,
                      ),
                    ),
                  ),
                  const SpaceH1(),
                  const CountryProfileField(),
                  const ReferralCode(),
                  const Spacer(),
                  const SpaceH8(),
                  SPaddingH24(
                    child: SButton.blue(
                      text: intl.register_continue,
                      callback: UserDataStore.of(context).activeButton
                          ? () {
                              sAnalytics.signInFlowPersonalContinue();
                              getIt.get<UserInfoService>().updateIsJustRegistered(value: true);

                              UserDataStore.of(context).saveUserData(
                                birthDateInfo.loader,
                                birthDateInfo,
                              );
                            }
                          : null,
                    ),
                  ),
                  const SpaceH42(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
