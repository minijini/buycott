import 'package:banner_carousel/banner_carousel.dart';
import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/constants/screen_size.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/widgets/list/main_shop_list_tile.dart';
import 'package:flutter/material.dart';

import '../../utils/log_util.dart';
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
      padding: EdgeInsets.symmetric(horizontal: sized_18,vertical: sized_18),
      child: ListView(
        children: [
          _placeSearchBar(),
          _heightSizeBox(sized_30),
          _banner(),
          _heightSizeBox(sized_30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('오늘의 돈쭐',style: Theme.of(context).textTheme.displayLarge,),
              Icon(Icons.chevron_right)
            ],
          ),
          _heightSizeBox(sized_10),
          _todayBuyCott()


        ],
      ),
    );
  }

  Container _todayBuyCott() {
    return Container(
          constraints: BoxConstraints(
            maxHeight: sized_100, // Set a maximum height as needed
          ),
          child: ListView.separated(
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
              separatorBuilder: (context, index) {
                return list_divider();
              },
              itemCount: BannerImages.listBanners.length),
        );
  }

  SizedBox _heightSizeBox(double size) => SizedBox(height: size,);

  Widget _placeSearchBar() {
    return TextField(
      controller: _searchTextController,
      autofocus: true,
      keyboardType: TextInputType.text,
      cursorColor: Colors.blueGrey,
      decoration: InputDecoration(
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
  ];
}
