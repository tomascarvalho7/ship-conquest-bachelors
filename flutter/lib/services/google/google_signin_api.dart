import 'package:google_sign_in/google_sign_in.dart';

/// A utility class for interacting with Google Sign-In API.
class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn(
    serverClientId: '48002922994-37rvess4o1fgim6mta4tmvefrmf1gu8b.apps.googleusercontent.com'
  );

  /// Initiates the Google Sign-In flow.
  ///
  /// Returns a [Future] that resolves to a [GoogleSignInAccount] or `null`.
  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  /// Retrieves the user information associated with the provided [account].
  ///
  /// Returns a [Future] that resolves to the user's ID token.
  static Future getUserInfo(GoogleSignInAccount account) async {
    final authentication = await account.authentication;
    return authentication.idToken;
  }

  /// Signs out the current user.
  ///
  /// Returns a [Future] that resolves to a [GoogleSignInAccount] or `null`.
  static Future<GoogleSignInAccount?> logout() => _googleSignIn.signOut();
}