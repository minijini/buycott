import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final int maxLines;

  ReadMoreText({required this.text, required this.maxLines});

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool readMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Perform the logic here after initState has completed
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          readMore = !readMore;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            maxLines: readMore ? null : widget.maxLines,
              style: Theme.of(context).textTheme.bodyMedium
          ),

            Text(
              !readMore? '... 더보기>' : '^ 접기',
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
