enum EventCategory {
  onboarding(1),
  pushPermission(2),
  signUpSignIn(3),
  signUp(4),
  signIn(5),
  kyc(6),
  market(7),
  receiveFlow(8),
  sendFlow(9),
  receiveGift(10),
  rewards(11),
  walletWithFavourites(12),
  buyFlow(13),
  sellFlow(14),
  convertFlow(15),
  withdrawal(16),
  cardFlow(17),
  transferFlow(18),
  earn(19),
  prepaidCard(20),
  banners(21),
  withdrawSimpleCoin(22),
  jar(23);

  const EventCategory(this.id);
  final int id;
}
