import 'package:flutter/foundation.dart';
import 'package:softi_common/resource.dart';

class FirestoreResource<T extends IResourceData> extends IResource<T> {
  final Deserializer<T> fromJson;

  FirestoreResource({
    @required this.fromJson,
    String endpoint,
  }) : super(endpoint);

  @override
  T deserializer(Map<String, dynamic> serializedData) {
    return fromJson(serializedData);
  }
}
