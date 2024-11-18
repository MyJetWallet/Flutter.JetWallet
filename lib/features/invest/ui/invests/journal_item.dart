import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/features/invest/ui/invests/data_line.dart';
import 'package:jetwallet/features/invest/ui/invests/rollover_line.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';

import '../../../../core/l10n/i10n.dart';
import '../../../../utils/helpers/icon_url_from.dart';
import '../../helpers/operation_name.dart';
import 'instrument_data_line.dart';

class JournalItem extends StatelessObserverWidget {
  const JournalItem({
    super.key,
    required this.item,
    required this.instrument,
    required this.position,
  });

  final NewInvestJournalModel item;
  final InvestInstrumentModel instrument;
  final InvestPositionModel position;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Column(
      children: [
        RolloverLine(
          mainText: normalizeAndFormatDateTime(
            item.timestamp.toString(),
            'dd.MM.yyyy / HH:mm:ss',
          ),
          secondaryText: '',
        ),
        const SpaceH8(),
        InstrumentDataLine(
          icon: SvgPicture.network(
            iconUrlFrom(assetSymbol: instrument.name ?? ''),
            width: 16.0,
            height: 16.0,
            placeholderBuilder: (_) {
              return const SAssetPlaceholderIcon();
            },
          ),
          mainText: instrument.name!,
          secondaryText: operationPositionName(
            item.auditEvent,
            position,
            item.closeReason,
          ),
        ),
        const SpaceH8(),
        if (item.closeReason != PositionCloseReason.undefined) ...[
          DataLine(
            mainText: intl.invest_close_price,
            secondaryText: item.closePrice.toFormatSum(accuracy: instrument.priceAccuracy ?? 2),
          ),
        ],
        if (item.auditEvent == PositionAuditEvent.marketOpeningToOpened ||
            item.auditEvent == PositionAuditEvent.pendingToOpened) ...[
          DataLine(
            mainText: intl.invest_open_price,
            secondaryText: item.openPrice.toFormatSum(accuracy: instrument.priceAccuracy ?? 2),
          ),
          const SpaceH8(),
        ],
        if (item.auditEvent == PositionAuditEvent.setTpSl ||
            item.auditEvent == PositionAuditEvent.marketOpeningToOpened ||
            item.auditEvent == PositionAuditEvent.pendingToOpened) ...[
          if (item.stopLossType != TPSLType.undefined || item.takeProfitType != TPSLType.undefined) ...[
            if (item.takeProfitType != TPSLType.undefined) ...[
              DataLine(
                withDot: true,
                dotColor: colors.green,
                mainText: intl.invest_limits_take_profit,
                secondaryText: item.takeProfitType == TPSLType.amount
                    ? item.takeProfitAmount.toFormatCount(
                        accuracy: 2,
                        symbol: 'USDT',
                      )
                    : item.takeProfitPrice.toFormatCount(
                        accuracy: instrument.priceAccuracy ?? 2,
                      ),
              ),
              const SpaceH8(),
            ],
            if (item.stopLossType != TPSLType.undefined) ...[
              DataLine(
                withDot: true,
                dotColor: colors.red,
                mainText: intl.invest_limits_stop_loss,
                secondaryText: item.stopLossType == TPSLType.amount
                    ? (item.stopLossAmount * Decimal.fromInt(-1)).toFormatCount(
                        accuracy: 2,
                        symbol: 'USDT',
                      )
                    : (item.stopLossPrice * Decimal.fromInt(-1)).toFormatCount(
                        accuracy: instrument.priceAccuracy ?? 2,
                      ),
              ),
              const SpaceH8(),
            ],
          ],
        ],
        const SpaceH8(),
      ],
    );
  }

  String normalizeAndFormatDateTime(String timestamp, String dateFormat) {
    var normalizedTimestamp = timestamp;

    if (!normalizedTimestamp.endsWith('Z') && !RegExp(r'[+-]\d{2}:\d{2}$').hasMatch(normalizedTimestamp)) {
      normalizedTimestamp = '${normalizedTimestamp}Z';
    }

    final dateTimeUtc = DateTime.parse(normalizedTimestamp).toUtc();
    final dateTimeLocal = dateTimeUtc.toLocal();

    return DateFormat(dateFormat).format(dateTimeLocal);
  }
}
