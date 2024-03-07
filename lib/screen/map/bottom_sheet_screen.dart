import 'package:buycott/constants/screen_size.dart';
import 'package:buycott/data/store_model.dart';
import 'package:buycott/screen/login/login_screen.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/widgets/list/my_shop_register_list_tile.dart';
import 'package:buycott/widgets/star_widget.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constants.dart';
import '../../constants/padding_size.dart';
import '../../utils/utility.dart';
import '../../widgets/UnanimatedPageRoute.dart';

class ShopBottomSheet extends StatefulWidget {
  final StoreModel? storeModel;
  const ShopBottomSheet({super.key, required this.storeModel});

  @override
  State<ShopBottomSheet> createState() => _ShopBottomSheetState();
}

class _ShopBottomSheetState extends State<ShopBottomSheet> {
  // final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

   final GlobalKey<_ShopBottomSheetState> _sheet = GlobalKey<_ShopBottomSheetState>();


  @override
  void initState() {
    _controller.addListener(_onChanged);

    super.initState();

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

      if(widget.storeModel?.storeName != null) {
        context.goNamed(storeDetailRouteName,pathParameters: {
          'storeSrno' : widget.storeModel!.storeSrno.toString()
        });
      }
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
     DraggableScrollableSheet(
      key: _sheet,
      initialChildSize: widget.storeModel?.storeName != null ? 0.5: 85 / size!.height,
      maxChildSize: 1,
      minChildSize: 0,
      expand: true,
      snap: true,
      snapSizes:  [ 85 / size!.height, 40 / size!.height,1],
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
            slivers: widget.storeModel?.storeName != null ? _dataSlivers(context) : _emptySlivers(context),
          ),
        );
      },
    );
    return LayoutBuilder(builder: (context, constraints) {
      return DraggableScrollableSheet(
        // 화면 비율로 높이 조정
        key: _sheet,
        initialChildSize: widget.storeModel?.storeName != null ? 0.3: 85 / constraints.maxHeight,
        maxChildSize: 1,
        minChildSize:  85 / constraints.maxHeight,
        snap: true,
        expand: true,
        snapSizes: const [
          0.3,
          1,
        ],
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
              slivers: widget.storeModel?.storeName != null ? _dataSlivers(context) : _emptySlivers(context),
            ),
          );
        },
      );
    });
  }

  List<Widget> _dataSlivers(BuildContext context) {
    return [
      SliverToBoxAdapter(
          child:  _sliverTitle(context)
      ),
      SliverList.list(
        children: [
          _sliverContent(context)
        ],
      ),
    ];
  }

  List<Widget> _emptySlivers(BuildContext context) {
    return [
      SliverToBoxAdapter(
          child:  _sliverTitle(context)
      ),
      SliverList.list(
        children: [
        ],
      ),
    ];
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
        widget.storeModel?.storeName != null ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding_side),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.storeModel!.storeName! ,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: sized_18),
              ),
              heightSizeBox(sized_10),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text:  widget.storeModel?.businessHours != null ? Utility().getOpenClose(widget.storeModel!.businessHours!.split("~")[0], widget.storeModel!.businessHours!.split("~")[1]): "",
                  style: Theme.of(context).textTheme.displayMedium,
                  children: <TextSpan>[
                    TextSpan(text: "  "),
                    TextSpan(
                        text: widget.storeModel?.businessHours ?? "", style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              )
            ],
          ),
        ) : Container(),
      ],
    );
  }

  Padding _sliverContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: padding_side),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightSizeBox(sized_10),
          Row(
            children: [
              Text('댓글 97', style: Theme.of(context).textTheme.displayMedium),
              widthSizeBox(sized_6),
              buildStarRating(widget.storeModel?.score ?? 0, sized_10)
            ],
          ),
          heightSizeBox(sized_10),
          Text(widget.storeModel?.storeAddress ?? "", style: Theme.of(context).textTheme.bodyMedium),
          heightSizeBox(sized_10),
          Text(widget.storeModel?.storeDesc ?? "", style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
