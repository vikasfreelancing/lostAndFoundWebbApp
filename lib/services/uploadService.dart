import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class UploadService {
  List<String> imageUrls = List();
  Future<dynamic> uploadFile(File _image) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('lostItemsImages/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    return await storageReference.getDownloadURL();
  }

  Future<List<String>> uploadAllFiles(List<File> images) async {
    List<String> list = List<String>();
    images.forEach((file) async {
      await uploadFile(file).then((fileurl) {
        print(fileurl);
        list.add(fileurl);
      });
    });
  }
}
