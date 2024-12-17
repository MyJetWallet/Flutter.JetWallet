import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/iban/store/get_personal_iban_store.dart';
import 'package:provider/provider.dart';

@RoutePage(name: 'GetPersonalIbanRouter')
class GetPersonalIbanScreen extends StatelessWidget {
  const GetPersonalIbanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => GetPersonalIbanStore(),
      child: GetPersonalIbanBody(),
    );
  }
}

class GetPersonalIbanBody extends StatelessObserverWidget {
  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      loading: GetPersonalIbanStore.of(context).loading,
      color: SColorsLight().white,
      header: GlobalBasicAppBar(
        title: '',
        hasLeftIcon: false,
        onRightIconTap: () {
          context.maybePop();
        },
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE0EBFA),
                    Color(0xFFECE7FB),
                  ],
                ),
              ),
              child: Assets.images.bank.simpleImg(
                height: 160.0,
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Text(
              intl.get_personal_iban_title,
              softWrap: true,
              style: STStyles.header4.copyWith(
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            _buildHintWidget(
              title: intl.get_personal_iban_hint1_title,
              body: intl.get_personal_iban_hint1_body,
              icon: Assets.svg.medium.userSend.simpleSvg(
                height: 20.0,
                width: 20.0,
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            _buildHintWidget(
              title: intl.get_personal_iban_hint2_title,
              body: intl.get_personal_iban_hint2_body,
              icon: Assets.svg.medium.cash.simpleSvg(
                height: 20.0,
                width: 20.0,
              ),
            ),
            const Spacer(),
            SButton.black(
              text: intl.get_personal_iban_button,
              callback: () {
                GetPersonalIbanStore.of(context).openAnAccount(context);
              },
            ),
            SizedBox(
              height: 16.0 + MediaQuery.of(context).padding.bottom,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHintWidget({required String title, required String body, required Widget icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40.0,
          width: 40.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: SColorsLight().gray2,
          ),
          child: Center(
            child: icon,
          ),
        ),
        const SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: STStyles.subtitle2,
              ),
              Text(
                body,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: STStyles.subtitle2.copyWith(
                  color: SColorsLight().gray10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
