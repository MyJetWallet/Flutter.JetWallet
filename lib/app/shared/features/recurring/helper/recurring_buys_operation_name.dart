import 'package:simple_networking/services/swap/model/get_quote/get_quote_request_model.dart';

String recurringBuysOperationName(RecurringBuysType type) {
  switch (type) {
    case RecurringBuysType.oneTimePurchase:
      return 'One-time purchase';
    case RecurringBuysType.daily:
      return 'Daily';
    case RecurringBuysType.weekly:
      return 'Weekly';
    case RecurringBuysType.biWeekly:
      return 'Bi-weekly';
    case RecurringBuysType.monthly:
      return 'Monthly';
  }
}
