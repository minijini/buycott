import 'package:banner_carousel/banner_carousel.dart';
import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/constants/screen_size.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/widgets/list/main_shop_list_tile.dart';
import 'package:flutter/material.dart';

import '../../utils/log_util.dart';
import '../../widgets/style/container.dart';
import '../../widgets/style/divider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TAG = "HomeScreen";
  final TextEditingController _searchTextController = TextEditingController();

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left:sized_18,right: sized_18,top: sized_18),
      child: _sliver(),
    );
  }

  Widget _sliver(){
    return CustomScrollView(
      slivers: [
          SliverToBoxAdapter(child: Column(children: [
            _placeSearchBar(),
            heightSizeBox(sized_30),
            _banner(),
            heightSizeBox(sized_30),
          ],)),
        SliverList.list(
          children: [
            _title(context,"오늘의 돈쭐"),
            heightSizeBox(sized_10),
            _todayBuyCott(),
            _buildHeightSizeBox(),
            _title(context,"인기 돈쭐"),
            heightSizeBox(sized_10),
            _todayBuyCott(),
            _buildHeightSizeBox(),
            _title(context,"새로운 돈쭐"),
            heightSizeBox(sized_10),
            _todayBuyCott(),
            _buildHeightSizeBox(),
            _title(context,"돈쭐 뉴스"),
            heightSizeBox(sized_10),
            _todayBuyCott(),
            _buildHeightSizeBox(),
          ],
        )
          // SliverList(
          //   delegate: SliverChildBuilderDelegate(((context, replyIndex) {
          //     debugPrint("Reply $replyIndex in Comment $commentIndex is generated!!");
          //     return Text("Reply: $replyIndex");
          //   }),
          //     childCount: BannerImages.listBanners.length,),
          // ),

      ],
    );
  }


  SizedBox _buildHeightSizeBox() => heightSizeBox(sized_30);

  Row _title(BuildContext context,String title) {
    return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,style: Theme.of(context).textTheme.displayLarge,),
            Icon(Icons.chevron_right)
          ],
        );
  }

  Widget _todayBuyCott() {
    var content = '세상의 이런일이이세상의 이 이런일이세상의 이 이런일이';
    var len = content.length;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:  BoxConstraints(
          minHeight: 50.0,
          maxHeight: len < 10 ? 105.0 : 130.0,
        ),
        child: ListView.builder(
            shrinkWrap: true,
          scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              BannerModel placeModel = BannerImages.listBanners[index];

              return GestureDetector(
                  onTap: () {
                    Log.logs(
                        TAG, "list tile click :: ${placeModel.id}");

                  },
                  child: MainShopListTile());
            },
            itemCount: BannerImages.listBanners.length),
      ),
    );
  }

  Widget _today(){
    return Container(
      height: 150,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: '세상의 이런일이세상의 이런일이세상의 이런일이세상의 이런일이 ',
              style: Theme.of(context).textTheme.displaySmall
            ),

            textDirection: TextDirection.ltr,
          );

          textPainter.layout(maxWidth: 104);

          final int lines = (textPainter.size.height / textPainter.preferredLineHeight).ceil();

          Log.logs(TAG, "lines :: $lines");
          return Container(
            height: constraints.maxHeight,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: BannerImages.listBanners.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {

                return MainShopListTile();
              },
            ),
          );
        },
      ),
    );
  }


  Widget _placeSearchBar() {
    return TextField(
      style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w500,color: BasicColor.lightgrey2),
      controller: _searchTextController,
      keyboardType: TextInputType.text,
      cursorColor: BasicColor.primary,
      decoration: InputDecoration(
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BasicColor.lightgrey2),
          hintText: "검색어를 입력하세요",
          suffixIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: sized_8,horizontal: sized_12),
              child: Icon(Icons.search,size: sized_30,))),
    );
  }

  Widget _banner(){
    return BannerCarousel(
      banners: BannerImages.listBanners,
      customizedIndicators: IndicatorModel.animation(
          width: 10, height: 5, spaceBetween: 2, widthAnimation: 15),
      height: sized_120,
      activeColor: BasicColor.primary,
      disableColor: Colors.white,
      animation: true,
      borderRadius: 10,
      width: size!.width,
      onTap: (id) => print(id),
      indicatorBottom: false,
      margin: EdgeInsets.zero,
    );
  }
}


class BannerImages {
  static const String banner1 =
      "https://picjumbo.com/wp-content/uploads/the-golden-gate-bridge-sunset-1080x720.jpg";
  static const String banner2 =
      "https://cdn.mos.cms.futurecdn.net/Nxz3xSGwyGMaziCwiAC5WW-1024-80.jpg";
  static const String banner3 = "https://wallpaperaccess.com/full/19921.jpg";
  static const String banner4 =
      "https://images.pexels.com/photos/2635817/pexels-photo-2635817.jpeg?auto=compress&crop=focalpoint&cs=tinysrgb&fit=crop&fp-y=0.6&h=500&sharp=20&w=1400";

  static List<BannerModel> listBanners = [
    BannerModel(imagePath: banner1, id: "1"),
    BannerModel(imagePath: banner2, id: "2"),
    BannerModel(imagePath: banner3, id: "3"),
    BannerModel(imagePath: banner4, id: "4"),
    BannerModel(imagePath: banner4, id: "5"),
  ];
}
