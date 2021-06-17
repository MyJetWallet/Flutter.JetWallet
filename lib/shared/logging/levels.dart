import 'package:logging/logging.dart';

// [CONVENTION LEVELS] - considered as Exceptions
// 1. [message] must take the name of the method inside which log triggers
// 2. [error] must be provided through log's error argument and not the message
const transport = Level('🚚Transport', 1);
const contract = Level('📜Contract', 2);
const stateFlow = Level('🎲State', 3);

// [NOTIFIER LEVEL] - considered as Info
/// [message]  must take the name of the method inside which log triggers
const notifier = Level('🔊Notifier', 4);

// [PROVIDER LEVEL] - considered as Info
const providerLevel = Level('Provider', 5);

// [OTHER LEVELS] - considered as Infos or Exceptions
// If you are not interested in the loggerName just pass empty string like that
// * static final _logger = Logger('');
// This practice will be usually applied when you define
// a unique level for the class and have messages like:
// * [🔔SignalR][12:37:19][SignlaR] -> [signalR log]
// with empty loggerName you will have:
// * [🔔SignalR][12:37:19] -> [signalR log]
//
// It's also possible to provide only error without message like:
// * _logger.log(signalR, '', e);
// The custom parser will omit message line and will show only error in the log
const signalR = Level('🔔SignalR', 6);
const pushNotifications = Level('💬Push Notifications', 7);
