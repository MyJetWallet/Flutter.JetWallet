import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../core/di/di.dart';
import '../../core/services/local_storage_service.dart';
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

class _MailOptions extends StatefulObserverWidget {
  const _MailOptions({
    required this.apps,
    required this.defaultAction,
  });

  final List<MailApp> apps;
  final Function() defaultAction;

  @override
  State<_MailOptions> createState() => _MailOptionsBodyState();
}

class _MailOptionsBodyState extends State<_MailOptions> with WidgetsBindingObserver {
  var checked = false;
  late Widget icon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    icon = checked ? const SCheckboxSelectedIcon() : const SCheckboxIcon();

    return Observer(
      builder: (context) {
        return Column(
          children: [
            for (final app in widget.apps)
              MailItem(
                icon: _iconFrom(app.name, colors),
                name: app.name,
                withDivider: true,
                onTap: () async {
                  if (checked) {
                    final storageService = getIt.get<LocalStorageService>();
                    await storageService.setString(
                      lastUsedMail,
                      app.name,
                    );
                  }
                  await OpenMailApp.openSpecificMailApp(app);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            Container(
              padding: const EdgeInsets.all(22),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Observer(
                    builder: (context) {
                      return SIconButton(
                        onTap: () {
                          setState(() {
                            checked = !checked;
                          });
                        },
                        defaultIcon: icon,
                        pressedIcon: icon,
                      );
                    },
                  ),
                  const SpaceW10(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpaceH3(),
                      Text(
                        intl.mailPicker_rememberChosen,
                        style: STStyles.captionMedium.copyWith(
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SpaceH40(),
          ],
        );
      },
    );
  }
}

Widget _iconFrom(String name, SimpleColors colors) {
  switch (name) {
    case 'Gmail':
      return Image.asset(
        gmailAsset,
        height: 40,
        width: 40,
      );
    case 'Yahoo Mail':
      return Image.asset(
        yahooAsset,
        height: 40,
        width: 40,
      );
    case 'Spark':
      return Image.asset(
        sparkAsset,
        height: 40,
        width: 40,
      );
    default:
      return Container(
        decoration: BoxDecoration(
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
    super.key,
    this.withDivider = false,
    required this.icon,
    required this.name,
    required this.onTap,
  });

  final bool withDivider;
  final Widget icon;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
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
                          style: STStyles.subtitle1.copyWith(
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
