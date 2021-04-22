class Price {
  Price(
      {required this.id,
      required this.dateTime,
      required this.bid,
      required this.ask});

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      id: json['id'].toString(),
      dateTime: int.parse(json['dateTime'].toString()),
      bid: num.parse(json['bid'].toString()),
      ask: num.parse(json['ask'].toString()),
    );
  }

  String id;
  int dateTime;
  num bid;
  num ask;
}

class SpotBidAsk {
  SpotBidAsk({required this.prices, required this.now});

  factory SpotBidAsk.fromJson(Map<String, dynamic> json) {
    final prices = <Price>[];
    json['prices'].forEach(
        (Map<String, dynamic> price) => prices.add(Price.fromJson(price)));

    return SpotBidAsk(
      prices: prices,
      now: int.parse(json['now'].toString()),
    );
  }

  List<Price> prices;
  int now;
}
