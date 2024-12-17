import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/wallet/helper/format_date_to_hm.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_networking/modules/signal_r/models/signalr_log.dart';

@RoutePage(name: 'SignalrDebugInfoRouter')
class SignalrDebugInfo extends StatelessWidget {
  const SignalrDebugInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: const GlobalBasicAppBar(
        title: 'SignalR Logs',
        hasRightIcon: false,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SButton.black(
                  text: 'Restart Connection',
                  callback: () {
                    getIt.get<SignalRService>().forceReconnectSignalR();
                  },
                ),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sSignalRModules.signalRLogs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    showBasicBottomSheet(
                      context: context,
                      children: [
                        SignalRLogDetail(
                          log: sSignalRModules.signalRLogs[index],
                        ),
                      ],
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 12, right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: SColorsLight().gray2,
                    ),
                    child: Row(
                      children: [
                        Text(
                          formatDateToDMonthYHmFromDate(
                            (sSignalRModules.signalRLogs[index].sessionTime ?? DateTime.now()).toString(),
                          ),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignalRLogDetail extends StatefulWidget {
  const SignalRLogDetail({
    super.key,
    required this.log,
  });

  final SignalrLog log;

  @override
  State<SignalRLogDetail> createState() => _SignalRLogDetailState();
}

class _SignalRLogDetailState extends State<SignalRLogDetail> {
  var filtredLogs = <SLogData>[];

  @override
  void initState() {
    filtredLogs = widget.log.logs!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDateToDMonthYHmFromDate(
              (widget.log.sessionTime ?? DateTime.now()).toString(),
            ),
            style: STStyles.subtitle1,
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 12,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    filtredLogs = widget.log.logs!;
                  });
                },
                child: Text(
                  'Reset',
                  style: STStyles.body1Semibold.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    filtredLogs = widget.log.logs!
                        .where(
                          (element) => element.type != SLogType.ping && element.type != SLogType.pong,
                        )
                        .toList();
                  });
                },
                child: Text(
                  'Hide Ping/Pong messages',
                  style: STStyles.body1Semibold.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            itemCount: filtredLogs.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Action: ${filtredLogs[index].type}',
                    style: STStyles.body1Medium.copyWith(
                      color: filtredLogs[index].type == SLogType.error ? SColorsLight().red : SColorsLight().black,
                    ),
                  ),
                  Text(
                    'Time: ${formatDateToHms(
                      (filtredLogs[index].date ?? DateTime.now()).toString(),
                    )}',
                    style: STStyles.body2Medium.copyWith(
                      color: SColorsLight().gray10,
                    ),
                  ),
                  if (filtredLogs[index].type == SLogType.error) ...[
                    Text(
                      filtredLogs[index].error ?? '',
                      style: STStyles.body2Medium,
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}
