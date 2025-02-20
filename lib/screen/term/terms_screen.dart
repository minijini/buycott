import 'package:flutter/material.dart';

import '../../constants/padding_size.dart';
import '../../utils/color/basic_color.dart';

class TermsScreen extends StatefulWidget {
  final String title;
  const TermsScreen({super.key, required this.title});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
          centerTitle: false,
          titleSpacing: -10,
          leading:  IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: BasicColor.back_black,
              icon: Image.asset('assets/icon/icon_arrow_left.png',scale: 16,))
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: sized_18),
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility : true,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: padding_side, vertical: sized_16),
                          child: Text('widget.content')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
