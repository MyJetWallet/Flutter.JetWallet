import 'package:logging/logging.dart';

// [CONVENTION LEVELS] - considered as Exceptions
// 1. The Message arg must take the name of the method inside which log triggers
// 2. An Error must be provided through log's error argument and not the message
const transport = Level('🚚Transport', 1);
const contract = Level('📜Contract', 2);
const state = Level('🎲State', 3);

// [NOTIFIER LEVEL]
// The Message arg must take the name of the method inside which log triggers
const notifier = Level('🔊Notifier', 4);

// [OTHER LEVELS] - considered as Infos or Exceptions
// If you are not interested in the loggerName just pass empty string like that
// * static final _logger = Logger('');
// This practice will be usually applied when you define
// a unique level for the class and have messages like:
// * [🔔SignalR][12:37:19][SignlaR] -> [signalR log]
// with empty loggerName you will have:
// * [🔔SignalR][12:37:19] -> [signalR log]
const signalR = Level('🔔SignalR', 5);
const notification = Level('💬Firebase Notifications', 6);
