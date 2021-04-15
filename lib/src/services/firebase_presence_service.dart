import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:pedantic/pedantic.dart';
import 'package:softi_common/auth.dart';
import 'package:softi_common/services.dart';

class FirebasePresenceService extends IPresenceService {
  final IAuthService authService;
  FirebasePresenceService([IAuthService? authService]) : authService = authService ?? Get.find();

  @override
  void setOnline() => _changeUserPresence({
        'state': 'online',
        'lastChanged': FieldValue.serverTimestamp(),
      });

  @override
  void setOffline() => _changeUserPresence({
        'state': 'offline',
        'lastChanged': FieldValue.serverTimestamp(),
      });

  @override
  void setAway() => _changeUserPresence({
        'state': 'away',
        'lastChanged': FieldValue.serverTimestamp(),
      });

  @override
  Future<void> init() => _init();

  @override
  Future<void> dispose() async => _cancel();

  StreamSubscription<Event>? _sub;
  late DatabaseReference _userStatusDatabaseRef;

  void _cancel() {
    _sub?.cancel();
  }

  void _changeUserPresence(Map<String, dynamic> presence) async {
    var uid = (await authService.getCurrentUser)?.uid;

    if (uid != null) {
      await FirebaseFirestore.instance //
          .doc('civi_users_stats/$uid')
          .update({'presenceState': presence});
    }
  }

  Future<void> _init() async {
    authService.authUserStream.listen((authUser) async {
      _cancel();

      if (authUser?.uid == null) return;

      await FirebaseDatabase.instance.setPersistenceEnabled(false);

      _userStatusDatabaseRef = FirebaseDatabase.instance
          .reference() //
          .child('status/' + authUser!.uid!);

      _sub = FirebaseDatabase.instance.reference().child('.info/connected').onValue.listen((Event event) async {
        if (event.snapshot.value == false) {
          setOffline();
        } else {
          setOnline();
        }
      });

      unawaited(_userStatusDatabaseRef.onDisconnect().update({
        'state': 'offline',
        'lastChanged': ServerValue.timestamp,
      }));
    });
  }
}
