// extension on DateTime {
//   DateTime roundDown({Duration delta = const Duration(seconds: 1)}) {
//     return DateTime.fromMillisecondsSinceEpoch(
//      millisecondsSinceEpoch - millisecondsSinceEpoch % delta.inMilliseconds,
//         isUtc: true);
//   }
// }

class HttpService {
  // Future<String> getCandles(String? authToken, DateTime fromDate,
  //     DateTime toDate, String resolution, String instrumentId) async {
  //   final queryParameters = {
//     'candleType': DataFeedUtil.parseCandleType(resolution).index.toString(),
  //     'bidOrAsk': '0',
  //     'fromDate': fromDate.roundDown().millisecondsSinceEpoch.toString(),
  //     'toDate': toDate.roundDown().millisecondsSinceEpoch.toString(),
  //     'instrumentId': instrumentId
  //   };
  //   log('${toDate.roundDown()} ${fromDate.roundDown()}');
  //
  //   final newUri = Uri.https('trading-api-test.mnftx.biz',
  //       '/api/v1/PriceHistory/Candles', queryParameters);
  //   String result;
  //   final response = await http.get(newUri, headers: {
  //     HttpHeaders.authorizationHeader: authToken!
  //   }).timeout(const Duration(seconds: 7));
  //   if (response.statusCode == 200) {
  //     result = response.body;
  //   } else {
  //     return Future.error('Error');
  //   }
  //   return result;
  // }
}
