String validIconUrl([String? iconUrl]) {
  if (iconUrl == null || iconUrl.isEmpty) {
    return 'https://i.imgur.com/cvNa7tH.png';
  } else {
    return iconUrl;
  }
}
