import 'package:flutter/foundation.dart';
import 'package:softi_common/resource.dart';

class FirestoreResource<T> extends IResource<T> {
  String _endpoint;
  final Deserializer<T> fromJson;

  FirestoreResource<T> setEndpoint(String newEndPoint) {
    _endpoint = newEndPoint;
    return this;
  }

  FirestoreResource({
    @required this.fromJson,
    String endpoint,
  }) : _endpoint = endpoint;

  @override
  String endpointResolver({
    ResourceRequestType requestType,
    QueryParameters queryParams,
    QueryPagination querypagination,
    String dataId,
    String dataPath,
    T dataObject,
  }) {
    return _endpoint;
  }

  @override
  T deserializer(Map<String, dynamic> serializedData) {
    return fromJson(serializedData);
  }
}
