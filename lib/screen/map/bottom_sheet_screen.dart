// it's a stateful widget!
import 'package:buycott/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constants.dart';
import '../../widgets/UnanimatedPageRoute.dart';

class ShopBottomSheet extends StatefulWidget {
  const ShopBottomSheet({super.key});

  @override
  State<ShopBottomSheet> createState() => _ShopBottomSheetState();
}


class _ShopBottomSheetState extends State<ShopBottomSheet> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) {
      _collapse();
    } else if (currentSize >= 0.95) {
      _collapse();
      // Assuming 0.95 as full screen, you can adjust as needed
      // Navigator.push(
      //   context,
      //   UnanimatedPageRoute(builder: (context) => LoginScreen()),
      // );

      context.goNamed(loginRouteName);

    }
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints) {
        return DraggableScrollableSheet(
          key: _sheet,
          initialChildSize: 0.5,
          maxChildSize: 1,
          minChildSize: 0,
          expand: true,
          snap: true,
          snapSizes:  [60 / constraints.maxHeight,0.5], //60 / constraints.maxHeight,
          controller: _controller,
          builder: (BuildContext context, ScrollController scrollController) {
            return DecoratedBox(
              decoration: const BoxDecoration(

                  color: Colors.yellow,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20))),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  const SliverToBoxAdapter(
                    child: Text('Title'),
                  ),
                  SliverList.list(
                    children: const [
                      Text('Content'),
                      Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),

                        ],
                      )

                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }
}