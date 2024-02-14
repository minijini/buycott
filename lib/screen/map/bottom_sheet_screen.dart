// it's a stateful widget!
import 'package:buycott/screen/login/login_screen.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/widgets/list/my_shop_register_list_tile.dart';
import 'package:buycott/widgets/start_widget.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constants.dart';
import '../../constants/padding_size.dart';
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

      context.goNamed(storeDetailRouteName);
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
    return LayoutBuilder(builder: (context, constraints) {
      return DraggableScrollableSheet(
        key: _sheet,
        initialChildSize: 0.5,
        maxChildSize: 1,
        minChildSize: 0,
        expand: true,
        snap: true,
        snapSizes: [85 / constraints.maxHeight, 0.5],
        //60 / constraints.maxHeight,
        controller: _controller,
        builder: (BuildContext context, ScrollController scrollController) {
          return DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 0,
                    blurRadius: 20,
                  ),
                ],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: _sliverTitle(context),
                ),
                SliverList.list(
                  children: [
                    _sliverContent(context),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Column _sliverTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: sized_10),
          child: Center(
              child: SizedBox(
                  width: sized_35,
                  child: customDivider(BasicColor.linegrey, sized_4, sized_5))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: sized_18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              heightSizeBox(sized_5),
              Text(
                '영업시간 11:00~12:00',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding _sliverContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: sized_18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightSizeBox(sized_10),
          Row(
            children: [
              Text('댓글 97', style: Theme.of(context).textTheme.titleSmall),
              widthSizeBox(sized_6),
              buildStarRating(5, sized_10)
            ],
          ),
          heightSizeBox(sized_10),
          Text('주소', style: Theme.of(context).textTheme.displaySmall),
          heightSizeBox(sized_10),
          Text('설명', style: Theme.of(context).textTheme.displaySmall),
        ],
      ),
    );
  }
}
