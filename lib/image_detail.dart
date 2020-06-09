import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageDetail extends StatelessWidget {
  String path;

  ImageDetail(this.path);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: _Photo(path),
    );
  }
}

// ignore: must_be_immutable
class _Photo extends StatefulWidget {
  String path;

  _Photo(this.path);

  @override
  State<StatefulWidget> createState() {
    return _PhotoState(path);
  }
}

class _PhotoState extends State<_Photo> with SingleTickerProviderStateMixin {
  String path;

  Offset _offset = Offset.zero;
  double _scale = 1.0;
  double _previousScale;
  Offset _normalizedOffset;

  _PhotoState(this.path);

  void _onScaleStart(ScaleStartDetails details) {
    debugPrint(details.toString());
    _previousScale = _scale;
    _normalizedOffset = (details.focalPoint - _offset) / _scale;
  }

  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    // widget的屏幕宽度
    final Offset minOffset = Offset(size.width, size.height) * (1.0 - _scale);
    // 限制他的最小尺寸
    return Offset(
        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    debugPrint(details.toString());

    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 3.0);
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    debugPrint(details.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: ClipRect(
        child: Transform(
          transform: Matrix4.identity()
            ..translate(_offset.dx, _offset.dy)
            ..scale(_scale),
          child: Image.file(File(path)),
        ),
      ),
    );
  }
}
