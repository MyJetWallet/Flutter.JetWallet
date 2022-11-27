enum KycDocumentSource {
  governmentId,
  internationalPassport,
  driverLicense,
}

extension KycDocumentSourceExtension on KycDocumentSource {
  String get name {
    switch (this) {
      case KycDocumentSource.governmentId:
        return 'ID';
      case KycDocumentSource.internationalPassport:
        return 'International Passport';
      case KycDocumentSource.driverLicense:
        return 'Driver License';
    }
  }
}
