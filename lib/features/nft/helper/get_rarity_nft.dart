String getNFTRarity(int rarityID) {
  switch (rarityID) {
    case 1:
      return 'Common';
    case 2:
      return 'Rare';
    case 3:
      return 'Very Rare';
    case 4:
      return 'Exclusive';
    case 5:
      return 'Unique';
    default:
      return '';
  }
}
