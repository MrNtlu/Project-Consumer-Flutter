class UserToken {
  String? _token;

  UserToken._privateConstructor();

  static final UserToken _instance = UserToken._privateConstructor();

  factory UserToken() {
    return _instance;
  }

  setToken(String? token) {
    _token = token;
  }

  get token => _token!;
  
  Map<String, String> getBearerToken() => {
    "Authorization": 'Bearer $_token'
  };
}