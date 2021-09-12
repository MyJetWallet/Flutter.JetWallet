String apiTitleFromUrl(String url) {
  final lowerCaseUrl = url.toLowerCase();

  if (lowerCaseUrl.contains('test')) {
    return 'TEST';
  } else if (lowerCaseUrl.contains('uat')) {
    return 'UAT';
  } else {
    return 'UNKNOWN';
  }
}
