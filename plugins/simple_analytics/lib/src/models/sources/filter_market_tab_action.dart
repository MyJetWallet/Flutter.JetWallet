enum FilterMarketTabAction {
  all,
  watchlist,
  cryptoSets,
  gainers,
  losers,
}

extension FilterMarketTabSourceExtension on FilterMarketTabAction {
  String get name {
    switch (this) {
      case FilterMarketTabAction.all:
        return 'All';
      case FilterMarketTabAction.watchlist:
        return 'Watchlist';
      case FilterMarketTabAction.cryptoSets:
        return 'Crypto Sets';
      case FilterMarketTabAction.gainers:
        return 'Gainers';
      case FilterMarketTabAction.losers:
        return 'Losers';
    }
  }
}
