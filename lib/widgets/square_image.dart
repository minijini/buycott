import 'package:buycott/constants/padding_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../api/api_url.dart';
import '../utils/color/basic_color.dart';

class SquareImage extends StatelessWidget {
  const SquareImage({
    super.key,
    required this.img,
    this.width,
    this.height,
  });

  final String? img;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      // imageUrl: img!=null ?'${Api.baseUrl}$img':'',
      imageUrl: img != null ? '$img' : '',
      width: width,
      height: height,
      fit: BoxFit.cover,
      // placeholder: (context, url) =>  Transform.scale(
      //   scale: 0.6,
      //   child:  CircularProgressIndicator(
      //     color: BasicColor.primary,
      //   ),
      //
      // ),
      errorWidget: (context, url, error) => ExtendedImage.asset(
        'assets/icon/icon_error.png',
        fit: BoxFit.contain,
        width: width,
        height: height,
        shape: BoxShape.rectangle,
      ),
    );
  }
}
