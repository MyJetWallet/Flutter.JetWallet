import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/iban/widgets/iban_item.dart';
import 'package:jetwallet/features/iban/widgets/iban_terms_container.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:simple_kit/simple_kit.dart';

class IbanReceive extends StatefulWidget {
  const IbanReceive({
    super.key,
    required this.name,
    required this.iban,
    required this.bic,
    required this.address,
  });

  final String name;
  final String iban;
  final String bic;
  final String address;

  @override
  State<IbanReceive> createState() => _IbanReceiveState();
}

class _IbanReceiveState extends State<IbanReceive> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    getIt<EventBus>().on<ResetScrollAccount>().listen((event) {
      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SingleChildScrollView(
      controller: controller,
      child: Column(
        children: [
          const SpaceH12(),
          const IbanTermsContainer(),
          const SpaceH24(),
          SPaddingH24(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.grey5,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      ibanEuroAsset,
                      width: 80,
                    ),
                    const SpaceW20(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          intl.iban_euro,
                          style: sTextH5Style,
                        ),
                        const SpaceH10(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 188,
                          child: Text(
                            intl.iban_euro_desc,
                            maxLines: 5,
                            style: sBodyText2Style.copyWith(
                              color: colors.grey1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SpaceH16(),
          IBanItem(
            name: intl.iban_benificiary,
            text: widget.name,
          ),
          IBanItem(
            name: intl.iban_iban,
            text: widget.iban,
          ),
          IBanItem(
            name: intl.iban_bic,
            text: widget.bic,
          ),
          IBanItem(
            name: intl.iban_address,
            text: simpleCompanyAddress,
          ),
          const SpaceH42(),
        ],
      ),
    );
  }
}
