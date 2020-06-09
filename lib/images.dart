import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:math';

class Images extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImagesPage();
  }
}

class _ImagesPage extends State<Images> {
  ImageCache _imageCache = ImageCache();
  List<_ImageData> _data = List();
  static const _channel = const MethodChannel("app.android.gallery/media");

  _ImagesPage() {
    getImages().then((value) => updateData(value));
  }

  void updateData(List<_ImageData> data) {
    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    var size = mediaQueryData.size;
    var pixelRatio = mediaQueryData.devicePixelRatio;

    double spacing = 4;
    int count = size.width ~/ 120;
    var width = (size.width - (count - 1) * spacing) ~/ count;

    return GridView.builder(
      itemCount: _data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        var image = Image.file(
          File(_data[index].path),
          fit: BoxFit.cover,
          cacheWidth: width * pixelRatio.toInt(),
        );
        return Stack(
          children: <Widget>[
            image,
            InkWell(
              onTap: () {
                debugPrint(_data[index].path);
              },
            ),
          ],
        );
//        return GridTile(
//            child: GestureDetector(
//          child: image,
//          onTap: () {
//            debugPrint(_data[index].path);
//          },
//        ));
      },
    );
  }

  Future<List<_ImageData>> getImages() async {
    List<_ImageData> list = List();

    List<String> data = await _channel.invokeListMethod("loadMedias",
        {"uri": "content://media/external/images/media", "type": "image/*"});

    for (String item in data) {
      _ImageData data = _ImageData();
      var map = jsonDecode(item);
      data.id = map["id"];
      data.path = map["path"];
      list.add(data);
    }
    return list;
  }
}

class _ImageData {
  int id;
  String path;

  String name;
}
