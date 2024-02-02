import 'package:flutter/material.dart';

import 'bottom_sheet_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin{
  bool isVisible = false;
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, -0.0), // Move up when becoming visible
      end: Offset(0.0,1.0),   // Move down when becoming invisible
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          TextButton(onPressed: (){

            setState(() {
              isVisible = !isVisible;
              if (isVisible) {
                _animationController.reverse();
              } else {
                _animationController.forward();
              }

            });
          }, child: Text('click')),

          SlideTransition(
            position: _offsetAnimation,
            child: Visibility(
              visible: isVisible,
              child: ShopBottomSheet(),
            ),
          ),
        ],
      ),
    );
  }
}
