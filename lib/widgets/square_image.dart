import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../api/api_url.dart';
import '../utils/color/basic_color.dart';

class SquareImage extends StatelessWidget {
  const SquareImage({
    super.key,
    required this.img, this.size,
  });

  final String? img;
  final double? size;

  @override
  Widget build(BuildContext context) {

    return CachedNetworkImage(
      // imageUrl: img!=null ?'${Api.baseUrl}$img':'',
      imageUrl: img!=null ?'$img':'',
      width: size,
      height: size,
      fit: BoxFit.contain,
      placeholder: (context, url) => const CircularProgressIndicator(color: BasicColor.primary,),
      errorWidget: (context, url, error) =>  ExtendedImage.asset(
        'assets/login/kakao_login.png',
        fit: BoxFit.contain,
        width: size,
        height: size,
        shape: BoxShape.rectangle,
      ),
    );
  }
}