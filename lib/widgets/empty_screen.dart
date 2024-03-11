
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EmptyScreen extends StatelessWidget {
  final Widget widget;
  const EmptyScreen({
    super.key, required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      enabled: true,
      child: widget,
    );
  }
}