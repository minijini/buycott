import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../api/api_url.dart';
import '../utils/color/basic_color.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({
    super.key,
    required this.img, this.size,
  });

  final String? img;
  final double? size;

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius:BorderRadius.circular(10000.0),
      child: CachedNetworkImage(
        imageUrl: img!=null ?'$img':'',
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => Transform.scale(
          scale: 0.6,
          child:  CircularProgressIndicator(
            color: BasicColor.primary,
          ),

        ),
        errorWidget: (context, url, error) =>  ExtendedImage.asset(
          'assets/icon/icon_error.png',
          fit: BoxFit.contain,
          width: size,
          height: size,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}