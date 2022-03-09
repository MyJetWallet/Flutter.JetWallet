enum MarketBannerAction {
  open,
  close,
}

extension MarketBannerActionExtension on MarketBannerAction {
  String get name {
    switch (this) {
      case MarketBannerAction.close:
        return 'Close';
      case MarketBannerAction.open:
        return 'Open';
    }
  }
}

enum MarketBannerSource {
  inviteFriend,
  earn,
}

extension MarketBannerSourceExtension on MarketBannerSource {
  String get name {
    switch (this) {
      case MarketBannerSource.inviteFriend:
        return 'Invite Friend';
      case MarketBannerSource.earn:
        return 'Earn';
    }
  }
}
