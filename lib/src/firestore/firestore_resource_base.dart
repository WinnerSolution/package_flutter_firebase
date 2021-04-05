import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:softi_common/resource.dart';
import 'package:softi_firebase/src/firestore/firestore_resource_adapter.dart';

class FirestoreResourceBase extends IResourceBase {
  final IResource<T> Function<T extends IResourceData>() _resourceResolver;
  final FirebaseFirestore _firebaseFirestore;
  FirestoreResourceBase(
    this._resourceResolver,
    this._firebaseFirestore,
  );

  @override
  IResourceAdapter<T> adapter<T extends IResourceData>(IResource<IResourceData> res) {
    return FirestoreResourceAdapter<T>(_firebaseFirestore)..setResource(res);
  }

  @override
  IResource<T> resourceResolver<T extends IResourceData>() => _resourceResolver<T>();
}
