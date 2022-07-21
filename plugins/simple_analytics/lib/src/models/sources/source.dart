/// Source screens, used to indicate from what place user navigated
enum Source {
  emptyPorfolioScreen,
  emptyWalletScreen,
  rewards,
  marketBanner,
  accountBanner,
  giftIcon,
  accountScreen,
  assetScreen,
  quickActions,
  earnProgram,
  actionButton,
  walletDetails,
  successScreen,
  marketScreen,
}

extension SourceExtension on Source {
  String get name {
    switch (this) {
      case Source.emptyPorfolioScreen:
        return 'Empty portfolio screen';
      case Source.emptyWalletScreen:
        return 'Empty wallet';
      case Source.rewards:
        return 'Rewards';
      case Source.marketBanner:
        return 'Market banner';
      case Source.giftIcon:
        return 'Gift Icon';
      case Source.accountScreen:
        return 'Account Screen';
      case Source.assetScreen:
        return 'Asset screen';
      case Source.quickActions:
        return 'Quick actions';
      case Source.accountBanner:
        return 'Account banner';
      case Source.earnProgram:
        return 'Earn program';
      case Source.actionButton:
        return 'Action Button';
      case Source.walletDetails:
       return 'Wallet details';
      case Source.successScreen:
        return 'Success screen';
      case Source.marketScreen:
        return 'Market screen';
    }
  }
}
