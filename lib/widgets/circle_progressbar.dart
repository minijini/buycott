import 'package:flutter/material.dart';

import '../utils/color/basic_color.dart';

class CustomCircularProgress extends StatelessWidget {
  const CustomCircularProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: BasicColor.primary,));
  }
}
