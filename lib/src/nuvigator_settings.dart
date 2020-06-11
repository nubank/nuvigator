class NuvigatorSettings {
  factory NuvigatorSettings() {
    return _instance;
  }

  NuvigatorSettings._internal();

  static final NuvigatorSettings _instance = NuvigatorSettings._internal();

  static void setAppScheme(String scheme) {
    _instance._appScheme = scheme;
  }

  static String get appScheme => _instance._appScheme;

  String _appScheme;
}
