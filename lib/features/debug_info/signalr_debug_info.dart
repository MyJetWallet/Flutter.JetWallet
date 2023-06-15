import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/wallet/helper/format_date_to_hm.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/signalr_log.dart';

@RoutePage(name: 'SignalrDebugInfoRouter')
class SignalrDebugInfo extends StatelessWidget {
  const SignalrDebugInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      header: const SPaddingH24(
        child: SSmallHeader(
          title: 'SignalR Logs',
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SPrimaryButton1(
                  active: true,
                  name: 'Restart Connection',
                  onTap: () {
                    getIt.get<SignalRService>().reCreateSignalR();
                  },
                ),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sSignalRModules.signalRLogs.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    sShowBasicModalBottomSheet(
                      context: context,
                      scrollable: true,
                      horizontalPinnedPadding: 0.0,
                      removePinnedPadding: true,
                      children: [
                        SignalRLogDetail(
                          log: sSignalRModules.signalRLogs[index],
                        )
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
                      color: sKit.colors.grey5,
                    ),
                    child: Row(
                      children: [
                        Text(
                          formatDateToDMonthYHmFromDate(
                            (sSignalRModules.signalRLogs[index].sessionTime ??
                                    DateTime.now())
                                .toString(),
                          ),
                          style: TextStyle(fontWeight: FontWeight.w500),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDateToDMonthYHmFromDate(
              (widget.log.sessionTime ?? DateTime.now()).toString(),
            ),
            style: sSubtitle2Style,
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
                  style: sBodyText1Style.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    filtredLogs = widget.log.logs!
                        .where((element) =>
                            element.type != SLogType.ping &&
                            element.type != SLogType.pong)
                        .toList();
                  });
                },
                child: Text(
                  'Hide Ping/Pong messages',
                  style: sBodyText1Style.copyWith(
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
                    style: sBodyText1Style.copyWith(
                      color: filtredLogs[index].type == SLogType.error
                          ? sKit.colors.red
                          : sKit.colors.black,
                    ),
                  ),
                  Text(
                    'Time: ${formatDateToHms(
                      (filtredLogs[index].date ?? DateTime.now()).toString(),
                    )}',
                    style: sBodyText2Style.copyWith(
                      color: sKit.colors.grey1,
                    ),
                  ),
                  if (filtredLogs[index].type == SLogType.error) ...[
                    Text(
                      filtredLogs[index].error ?? '',
                      style: sBodyText2Style,
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
