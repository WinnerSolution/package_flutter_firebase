import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:softi_common/auth.dart';
import 'package:softi_firebase/src/auth/models/settings.dart';
import 'package:softi_firebase/src/auth/services/firebase_auth_provider.dart';
import 'package:softi_firebase/src/auth/services/providers/firebase_auth_apple.dart';
import 'package:softi_firebase/src/auth/services/providers/firebase_auth_email.dart';
import 'package:softi_firebase/src/auth/services/providers/firebase_auth_email_link.dart';
import 'package:softi_firebase/src/auth/services/providers/firebase_auth_facebook.dart';
import 'package:softi_firebase/src/auth/services/providers/firebase_auth_google.dart';
import 'package:softi_firebase/src/auth/services/providers/firebase_auth_phone.dart';

class FirebaseAuthService extends IAuthService {
  final FirebaseAuth firebaseAuth;
  final FirebaseSettings settings;

  final FirebaseAppleSignin appleSignin;
  final FirebaseGoogleSignin googleSignin;
  final FirebaseAuthFacebookSignIn facebookSignin;
  final FirebaseAuthEmalPassword emailSignin;
  final FirebaseAuthPhone phoneSignin;
  final FirebaseAuthEmailLink emailLinkSignin;

  FirebaseAuthService(this.firebaseAuth, this.settings)
      : appleSignin = FirebaseAppleSignin(
          firebaseAuth,
          appleSignInCallbackUrl: settings.appleSignInCallbackUrl,
          appleSignInClientId: settings.appleSignInClientId,
        ),
        facebookSignin = FirebaseAuthFacebookSignIn(
          firebaseAuth,
          facebookClientId: settings.facebookClientId,
        ),
        emailLinkSignin = FirebaseAuthEmailLink(
          firebaseAuth,
          actionCodeSettings: ActionCodeSettings(
            url: settings.url!,
            //
            androidMinimumVersion: settings.androidMinimumVersion,
            androidInstallApp: settings.androidInstallIfNotAvailable,
            androidPackageName: settings.androidPackageName,
            //
            iOSBundleId: settings.iOSBundleID,
            handleCodeInApp: true,
            // dynamicLinkDomain: null,
          ),
        ),
        googleSignin = FirebaseGoogleSignin(firebaseAuth),
        emailSignin = FirebaseAuthEmalPassword(firebaseAuth),
        phoneSignin = FirebaseAuthPhone(firebaseAuth);

  @override
  Future<AuthUser?> get getCurrentUser => Future.value(FirebaseAuthProvider.authUserFromUser(firebaseAuth.currentUser));

  @override
  Stream<AuthUser?> get authUserStream => firebaseAuth.authStateChanges().map(FirebaseAuthProvider.authUserFromUser);

  @override
  Future<void> init() async {
    // TODO: implement refresh
  }

  @override
  Future<void> dispose() async {
    // TODO: implement refresh
  }

  @override
  void refresh() {
    // TODO: implement refresh
  }

  @override
  Future<AuthUser?> createUserWithEmailAndPassword(String email, String password) {
    return catchError<AuthUser?>(() => emailSignin.createUserWithEmailAndPassword(email, password))!;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return catchError<void>(() => emailSignin.sendPasswordResetEmail(email))!;
  }

  @override
  Future<void> sendSignInWithEmailLink({String? email}) {
    return catchError<void>(() => emailLinkSignin.sendSignInWithEmailLink(email: email!))!;
  }

  @override
  Future<SendCodeResult> sendSignInWithPhoneCode({
    String? phoneNumber,
    resendingId,
    bool? autoRetrive,
    int? autoRetrievalTimeoutSeconds = 30,
  }) {
    return catchError<SendCodeResult>(
      () => phoneSignin.sendSignInWithPhoneCode(
        phoneNumber: phoneNumber,
        resendingId: resendingId,
        autoRetrive: true,
        autoRetrievalTimeoutSeconds: autoRetrievalTimeoutSeconds,
      ),
    )!;
  }

  @override
  Future<AuthUser?> signInAnonymously() {
    return catchError<AuthUser?>(() async {
      final authResult = await firebaseAuth.signInAnonymously();
      return FirebaseAuthProvider.userFromFirebase(authResult);
    })!;
  }

  @override
  Future<AuthUser?> signInWithApple({linkToUser = false}) {
    return catchError<AuthUser?>(() => appleSignin.signInWithApple(linkToUser: linkToUser))!;
  }

  @override
  Future<AuthUser?> signInWithEmailAndLink({String? email, String? link}) {
    return catchError<AuthUser?>(() => emailLinkSignin.signInWithEmailAndLink(email: email!, link: link!))!;
  }

  @override
  Future<AuthUser?> signInWithEmailAndPassword(String email, String password) {
    return catchError<AuthUser?>(() => emailSignin.signInWithEmailAndPassword(email, password))!;
  }

  @override
  Future<AuthUser?> signInWithFacebook(param, {linkToUser = false}) {
    return catchError<AuthUser?>(() => facebookSignin.signInWithFacebook(param, linkToUser: linkToUser))!;
  }

  @override
  Future<AuthUser?> signInWithGoogle({linkToUser = false}) {
    return catchError<AuthUser?>(() => googleSignin.signInWithGoogle(linkToUser: linkToUser))!;
  }

  @override
  Future<AuthUser?> signInWithPhone(verificationId, smsOTP) {
    return catchError<AuthUser?>(() => phoneSignin.signInWithPhone(verificationId, smsOTP))!;
  }

  @override
  Future<bool> isSignInWithEmailLink({String? link}) {
    return catchError<bool>(() => emailLinkSignin.isSignInWithEmailLink(link!))!;
  }

  @override
  Future<void> signOut() {
    return catchError<void>(() => firebaseAuth.signOut())!;
  }
}
