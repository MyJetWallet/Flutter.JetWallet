enum KycSource {
  assetScreen,
  quickActions,
  accountBanner,
  emptyPortfolioScreen,
  earnProgram,
}

extension KycSourceExtension on KycSource {
  String get name {
    switch (this) {
      case KycSource.assetScreen:
        return 'Asset screen';
      case KycSource.quickActions:
        return 'Quick actions';
      case KycSource.accountBanner:
        return 'Account banner';
      case KycSource.emptyPortfolioScreen:
        return 'Empty portfolio screen';
      case KycSource.earnProgram:
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
