import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:softi_common/core.dart';
import 'package:softi_common/services.dart';
import 'package:softi_firebase/src/auth/models/settings.dart';
import 'package:softi_firebase/src/auth/services/firebase_auth_service.dart';
import 'package:softi_firebase/src/services/firebase_deeplink_service.dart';

export 'package:softi_firebase/src/services/firebase_deeplink_service.dart';
export 'package:softi_firebase/src/services/firebase_remote_config_service.dart';
export 'package:softi_firebase/src/services/firebase_storage_service.dart';
export 'package:softi_firebase/src/services/firebase_presence_service.dart';

Future<void> firebaseServiceSetup(FirebaseSettings firebaseSettings) async {
  /// Third party lib initialization
  await Firebase.initializeApp();

  // Global setings
  FirebaseStorage.instance.setMaxUploadRetryTime(Duration(minutes: 5));

  Get.put<IDynamicLinkService>(FirebaseDeeplinkService(
    firebaseSettings,
  ));
}

Future<void> firebaseServicesInit(ILocalStore store, FirebaseAuthService auth) async {
  /// Handle dynamic links
  Get.find<IDynamicLinkService>().registerhandleDeeplinks(DeepLinkHandler((deepLink) async {
    var _authLink = deepLink.link.toString();
    if (await auth.isSignInWithEmailLink(link: _authLink)) {
      var email = await store.getSecuredKey('UserEmail');
      if (email == null) return;
      await auth.signInWithEmailAndLink(email: email, link: deepLink.link.toString());
    }
  }));

  Get.find<IDynamicLinkService>().handleDeeplinks();
}
