enum ScreenSource {
  assetScreen,
  quickActions,
  accountBanner,
  emptyPortfolioScreen,
  earnProgram,
}

extension KycSourceExtension on ScreenSource {
  String get name {
    switch (this) {
      case ScreenSource.assetScreen:
        return 'Asset screen';
      case ScreenSource.quickActions:
        return 'Quick actions';
      case ScreenSource.accountBanner:
        return 'Account banner';
      case ScreenSource.emptyPortfolioScreen:
        return 'Empty portfolio screen';
      case ScreenSource.earnProgram:
        return 'Earn program';
    }
  }
}

enum KycScope {
  phone,
  identity,
  phoneIdentity,
}

extension KycScopeExtension on KycScope {
  String get name {
    switch (this) {
      case KycScope.phone:
        return 'Phone';
      case KycScope.identity:
        return 'Identity';
      case KycScope.phoneIdentity:
        return 'Phone + Identity';
    }
  }
}
