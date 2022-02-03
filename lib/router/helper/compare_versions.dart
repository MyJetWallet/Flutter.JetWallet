enum VersionStatus { greater, smaller, equal }

// returns VersionStatus.greater if version1 > version2
// returns VersionStatus.smaller if version1 < version2
// returns VersionStatus.equal if version1 == version2
VersionStatus compareVersions(String version1, String version2) {
  final decomposed1 = _decompose(version1);
  final decomposed2 = _decompose(version2);

  for (var i = 0; i < decomposed1.length; i++) {
    if (decomposed1[i] > decomposed2[i]) {
      return VersionStatus.greater;
    } else if (decomposed1[i] < decomposed2[i]) {
      return VersionStatus.smaller;
    } else {
      if (i == 2) {
        return VersionStatus.equal;
      }
    }
  }

  return VersionStatus.equal; // never will be called
}

List<int> _decompose(String version) {
  final array = version.split('');

  var num1 = '';
  var num2 = '';
  var num3 = '';

  var counter = 0;

  for (final element in array) {
    if (element != '.') {
      if (counter == 0) {
        num1 = num1 + element;
      } else if (counter == 1) {
        num2 = num2 + element;
      } else {
        num3 = num3 + element;
      }
    } else {
      counter++;
    }
  }

  return [int.parse(num1), int.parse(num2), int.parse(num3)];
}
