import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/padding_size.dart';
import '../../utils/color/basic_color.dart';

BoxDecoration imgBackGround({String? img}) {
  return BoxDecoration(
    image: DecorationImage(
      image: AssetImage(img ?? "assets/imgs/bg.png"),
      fit: BoxFit.fill,
    ),
  );
}

BoxDecoration profileimgBackGround({String? img}) {
  return BoxDecoration(
    image: DecorationImage(
      fit: BoxFit.cover,
        image: CachedNetworkImageProvider(
          img ?? "assets/imgs/bg.png")),
  );
}

BoxDecoration guideBackGround() {
  return BoxDecoration(
    image: DecorationImage(
      image: AssetImage( 'assets/imgs/guide_bg.png'),
      fit: BoxFit.cover,
    ),
  );
}

BoxDecoration accountBackGround() {
  return BoxDecoration(
    image: DecorationImage(
      opacity: 0.4,
      image: AssetImage("assets/imgs/icon_account_list.png"),
      fit: BoxFit.contain,
    ),
  );
}

BoxDecoration imgDecor(Color color){
  return BoxDecoration(
    color: Colors.white,
      shape: BoxShape.rectangle,
      border: Border.all(color: color, width: 1));
}

BoxDecoration profileImgDecor(Color color){
  return BoxDecoration(
      color: BasicColor.linegrey,
      shape: BoxShape.circle,
      border: Border.all(color: color, width: 2));
}

BoxDecoration appBarDecor(Color color){
  return BoxDecoration(
      color: color,
      shape: BoxShape.rectangle,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.7),
          blurRadius: 3.0,
          spreadRadius: 0.0,
        )
      ],
      borderRadius: BorderRadius.circular(15),
      );
}



BoxDecoration grayDecor(double size){
  return BoxDecoration(
      color: BasicColor.lightgrey,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(size))
  );
}

BoxDecoration grayDecor2(){
  return BoxDecoration(
      color: BasicColor.lightgrey3,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(sized_5))
  );
}

BoxDecoration loginDecor(Color color){
  return BoxDecoration(
      color: color,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(sized_12))
  );
}

BoxDecoration categoryDecor(Color color){
  return BoxDecoration(
      color: color,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(sized_20)),
      border: Border.all(color: Colors.white, width: 1.6)
  );
}

BoxDecoration dialogDecor(){
  return BoxDecoration(
      color: BasicColor.primary,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10))
  );
}



Container line({Color? color,double? height}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: sized_10),
    width: 1,
    height: height ?? 12,
    color: color ?? Colors.white,
  );
}

SizedBox heightSizeBox(double size) => SizedBox(height: size,);
SizedBox widthSizeBox(double size) => SizedBox(width: size,);

Divider  divider() => Divider(color: BasicColor.linegrey);
Divider  customDivider(Color color,double height,double thickness) => Divider(color: color,height: height,thickness: thickness,);