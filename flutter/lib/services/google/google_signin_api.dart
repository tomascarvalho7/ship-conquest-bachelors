import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn(
    serverClientId: '48002922994-37rvess4o1fgim6mta4tmvefrmf1gu8b.apps.googleusercontent.com'
  );

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future getUserInfo(GoogleSignInAccount account) async {
    final authentication = await account.authentication;
    return authentication.idToken;
  }

  static Future<GoogleSignInAccount?> logout() => _googleSignIn.signOut();
}