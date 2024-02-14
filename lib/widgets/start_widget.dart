import 'package:flutter/material.dart';

Widget buildStarRating(int star,double size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      star,
          (index) => Icon(
        Icons.star,
        color: Colors.yellow,
        size: size,
      ),
    ),
  );
}

List<Widget> buildStarRatingWithHalf(double star,double size) {
  int fullStars = star.toInt(); // Extract the integer part
  double fractionalPart = star - fullStars; // Extract the fractional part

  List<Widget> starIcons = List.generate(
    fullStars,
        (index) => Icon(
      Icons.star,
      color: Colors.yellow,
      size: size,
    ),
  );

  if (fractionalPart > 0.0) {
    starIcons.add(
      Icon(
        Icons.star_half,
        color: Colors.yellow,
        size: size,
      ),
    );
  }
  return starIcons;
}

