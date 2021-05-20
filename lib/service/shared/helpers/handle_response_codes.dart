void handleResponseCodes(String result) {
  if (result != 'OK') {
    throw result.toString();
  }
}
