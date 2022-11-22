import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:simple_kit/simple_kit.dart';

import '../constants.dart';

void showMailAppsOptions(
    BuildContext context,
    List<MailApp> apps,
    Function() defaultAction,
) {

  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.mailPicker_chooseMail,
    ),
    children: [
      _MailOptions(
        apps: apps,
        defaultAction: defaultAction,
      ),
    ],
  );
}

class _MailOptions extends StatelessObserverWidget {
  const _MailOptions({
    Key? key,
    required this.apps,
    required this.defaultAction,
  }) : super(key: key);

  final List<MailApp> apps;
  final Function() defaultAction;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Column(
      children: [
        MailItem(
          icon: _iconFrom('Mail', colors),
          name: 'Mail',
          withDivider: apps.isNotEmpty,
          onTap: () {
            defaultAction.call();
            Navigator.pop(context);
          },
        ),
        for (final app in apps)
          MailItem(
            icon: _iconFrom(app.name, colors),
            name: app.name,
            withDivider: app != apps.last,
            onTap: () {
              OpenMailApp.openSpecificMailApp(app);

              Navigator.pop(context);
            },
          ),
        const SpaceH40(),
      ],
    );
  }
}

Widget _iconFrom(String name, SimpleColors colors) {
  print(name);
  switch (name) {
    case 'googlegmail':
      return Image.asset(
        gmailAsset,
        height: 40,
        width: 40,
      );
    case 'ymail':
      return Image.asset(
        yahooAsset,
        height: 40,
        width: 40,
      );
    case 'readdle-spark':
      return Image.asset(
        sparkAsset,
        height: 40,
        width: 40,
      );
    default:
      print('here');
      return Container(
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: colors.grey5,
        ),
        width: 40,
        height: 40,
        child: const SMailIcon(),
      );
  }
}

class MailItem extends StatelessWidget {
  const MailItem({
    Key? key,
    this.withDivider = false,
    required this.icon,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final bool withDivider;
  final Widget icon;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    print(icon);
    final colors = sKit.colors;
    final mainColor = colors.black;

    return InkWell(
      highlightColor: colors.grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 80.0,
          child: Column(
            children: [
              const SpaceH20(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SpaceW20(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SpaceH3(),
                        Text(
                          name,
                          style: sSubtitle2Style.copyWith(
                            color: mainColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (withDivider) const SDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
