bool boolFromString(String boolValue) {
  switch (boolValue?.toLowerCase()) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      return null;
  }
}
