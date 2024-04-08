import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  final _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

  Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  Future<GoogleSignInAccount?> signOut() => _googleSignIn.disconnect();

  Future<GoogleSignInAccount?> signInSilently() => _googleSignIn.signInSilently();

  GoogleSignInApi._privateConstructor();

  static final GoogleSignInApi _instance =
      GoogleSignInApi._privateConstructor();

  factory GoogleSignInApi() {
    return _instance;
  }
}