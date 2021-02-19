import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  CachedImage(this.path, {this.height, this.fit});

  final String path;
  final BoxFit fit;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      path,
      cache: true,
      clearMemoryCacheIfFailed: true,
      height: height,
      fit: fit,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.failed:
            return Text('Error');
            break;
          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
            );
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
