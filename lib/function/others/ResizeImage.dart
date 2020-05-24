import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ResizeImage {
  ///resize image required [image] file , you can pass image [quality] 0-100
  ///default is 60 and image [type] default is webp this will return a resized Image
  Future<File> resize({@required File image, int quality = 60}) async {
    var dir = await getTemporaryDirectory();
    String type = Platform.isAndroid ? 'webp' : 'jpeg';
    String path = "${dir.path}/resizeImage.$type";

    File newImage = await FlutterImageCompress.compressAndGetFile(
        image.path, path,
        format: type == 'webp' ? CompressFormat.webp : CompressFormat.jpeg,
        quality: quality);
    return newImage;
  }

  Future<String> uploadImg(
      {@required File img,
      @required String imageName,
      String path = 'profile'}) async {
    String type = Platform.isAndroid ? 'webp' : 'jpeg';
    var meta = StorageMetadata(contentType: 'image/$type');
    final StorageReference ref =
        FirebaseStorage.instance.ref().child(path + '/' + imageName);
    final StorageUploadTask task = ref.putFile(img, meta);
    var picUrl = await (await task.onComplete).ref.getDownloadURL();
    return picUrl;
  }
}

final resize = ResizeImage();
