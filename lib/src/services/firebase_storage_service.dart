import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:softi_common/services.dart';

var _eventTypeMap = {
  TaskState.error: UploadState.error,
  TaskState.success: UploadState.success,
  TaskState.paused: UploadState.paused,
  TaskState.canceled: UploadState.canceled,
  TaskState.running: UploadState.running,
};

class FirebaseStorageService extends IRemoteStorageService {
  @override
  Future<UploadEvent> uploadMedia({
    required dynamic imageToUpload,
    required String title,
    bool addTimestamp = false,
  }) {
    print('Start up load');

    var imageFileName = title + (addTimestamp ? DateTime.now().millisecondsSinceEpoch.toString() : '');

    final firebaseStorageRef = FirebaseStorage.instance.ref().child(imageFileName);

    var uploadTask = imageToUpload is File
        ? firebaseStorageRef.putFile(imageToUpload)
        : firebaseStorageRef.putData(imageToUpload as Uint8List);

    return uploadTask.then<UploadEvent>((event) async {
      // print('${event.state} ${event.bytesTransferred} / ${event.totalBytes}');

      // uploadTask.snapshot.ref.getDownloadURL();

      return UploadEvent(
          type: _eventTypeMap[event.state],
          total: event.totalBytes.toDouble(),
          uploaded: event.bytesTransferred.toDouble(),
          // rawrResult: event.state == TaskState.success ? event.metadata. : null,
          result: event.state != TaskState.success
              ? null
              : NetworkMediaAsset(
                  url: await event.ref.getDownloadURL(),
                  title: event.metadata!.fullPath,

                  // url: (await event.snapshot.ref.getDownloadURL()).toString(),
                  // title: event.snapshot.storageMetadata.path,
                ));
    });

    // StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    // var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    // if (uploadTask.isComplete) {
    //   var url = downloadUrl.toString();
    //   return NetworkMediaAsset(
    //     url: url,
    //     title: storageSnapshot.storageMetadata.path,
    //   );
    // }

    // return null;
  }

  @override
  Stream<UploadEvent> uploadMediaStream({
    required dynamic imageToUpload,
    required String title,
    bool addTimestamp = false,
  }) {
    print('Start up load');

    var imageFileName = title + (addTimestamp ? DateTime.now().millisecondsSinceEpoch.toString() : '');

    final firebaseStorageRef = FirebaseStorage.instance.ref().child(imageFileName);

    var uploadTask = imageToUpload is File
        ? firebaseStorageRef.putFile(imageToUpload)
        : firebaseStorageRef.putData(imageToUpload as Uint8List);

    return uploadTask.snapshotEvents.asyncMap<UploadEvent>((event) async {
      // print('${event.state} ${event.bytesTransferred} / ${event.totalBytes}');

      // uploadTask.snapshot.ref.getDownloadURL();

      return UploadEvent(
          type: _eventTypeMap[event.state],
          total: event.totalBytes.toDouble(),
          uploaded: event.bytesTransferred.toDouble(),
          // rawrResult: event.state == TaskState.success ? event.metadata. : null,
          result: event.state != TaskState.success
              ? null
              : NetworkMediaAsset(
                  url: await event.ref.getDownloadURL(),
                  title: event.metadata!.fullPath,

                  // url: (await event.snapshot.ref.getDownloadURL()).toString(),
                  // title: event.snapshot.storageMetadata.path,
                ));
    });

    // StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    // var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    // if (uploadTask.isComplete) {
    //   var url = downloadUrl.toString();
    //   return NetworkMediaAsset(
    //     url: url,
    //     title: storageSnapshot.storageMetadata.path,
    //   );
    // }

    // return null;
  }

  @override
  Future deleteMedia(String imageFileName) async {
    final firebaseStorageRef = FirebaseStorage.instance.ref().child(imageFileName);

    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}
