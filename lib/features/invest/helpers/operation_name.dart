import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';

import '../../../core/l10n/i10n.dart';

String operationPositionName(PositionAuditEvent event, InvestPositionModel position, PositionCloseReason closeReason) {
  switch (closeReason) {
    case PositionCloseReason.undefined: break;
    case PositionCloseReason.liquidation: return intl.invest_close;
    case PositionCloseReason.marketClose: return intl.invest_liquidation;
    case PositionCloseReason.stopLoss: return intl.invest_limits_stop_loss;
    case PositionCloseReason.takeProfit: return intl.invest_limits_take_profit;
    default: break;
  }

  switch (event) {
    case PositionAuditEvent.rollOverReCalc: return '-';
    case PositionAuditEvent.closeByStopLoss: return '-';
    case PositionAuditEvent.closeByTakeProfit: return '-';
    case PositionAuditEvent.closeByLiquidation: return '-';
    case PositionAuditEvent.setTpSl: return intl.invest_modify;
    case PositionAuditEvent.closingToClose: return intl.invest_close;
    case PositionAuditEvent.openedToClosing: return intl.invest_closing;
    case PositionAuditEvent.marketOpeningToOpened: return '${intl.invest_invest} '
        '${position.direction == Direction.buy ? intl.invest_buy : intl.invest_sell}';
    case PositionAuditEvent.createMarketOpening: return '${intl.invest_opening} '
        '${position.direction == Direction.buy ? intl.invest_buy : intl.invest_sell}';
    case PositionAuditEvent.pendingToCancel: return '${intl.invest_delete} '
        '${position.direction == Direction.buy ? intl.invest_buy : intl.invest_sell}';
    case PositionAuditEvent.pendingToOpened: return '${intl.invest_invest} '
        '${position.direction == Direction.buy ? intl.invest_buy : intl.invest_sell}';
    case PositionAuditEvent.createPending: return '${intl.invest_pending} '
        '${position.direction == Direction.buy ? intl.invest_buy : intl.invest_sell}';
    case PositionAuditEvent.undefined: return '-';
    default: return '-';
  }
}
