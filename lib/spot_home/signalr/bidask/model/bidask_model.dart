class Price {
  String id;
  int dateTime;
  num bid;
  num ask;

  Price({this.id, this.dateTime, this.bid, this.ask});

  String toString() {
    return 'Id: $id, Time: $dateTime, Bid: $bid, Ask: $ask \n';
  }

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      id: json['id'].toString(),
      dateTime: json['dateTime'],
      bid: json['bid'],
      ask: json['ask'],
    );
  }
}

class SpotBidAsk {
  List<Price> prices;
  int now;

  SpotBidAsk({this.prices, this.now});

  String toString() {
    StringBuffer result;
    prices.forEach((e) => result.write(e.toString()));
    result.write(now.toString());
    return result.toString();
  }

  factory SpotBidAsk.fromJson(Map<String, dynamic> json) {
    List<Price> prices = [];
    json['prices'].forEach((e) => prices.add(Price.fromJson(e)));

    return SpotBidAsk(
      prices: prices,
      now: json['now'],
    );
  }
}
