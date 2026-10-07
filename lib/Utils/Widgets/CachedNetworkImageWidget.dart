import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_music_app/Utils/Constants/AppAssets.dart';
import 'package:new_music_app/Utils/Styling/AppColors.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final Widget? fallback;

  const CachedNetworkImageWidget(
      {super.key,
      required this.image,
      this.height,
      this.width,
      this.fit,
      this.fallback});

  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (image == null || image == '' || image == 'null') {
      return fallback ?? _logoPlaceholder();
    }
    return CachedNetworkImage(
      imageUrl: image!,
      height: height,
      width: width,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator.adaptive()),
      errorWidget: (context, url, error) => fallback ?? _logoPlaceholder(),
      fit: fit ?? BoxFit.cover,
    );
  }

  /// DJ Sisko logo shown when an image is missing or fails to load.
  Widget _logoPlaceholder() {
    return Container(
      height: height,
      width: width,
      color: AppColors.textFormFieldColor,
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        heightFactor: 0.7,
        child: Image.asset(AppAssets.alajazaLogo, fit: BoxFit.contain),
      ),
    );
  }
}
