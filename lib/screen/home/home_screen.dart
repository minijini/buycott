import 'package:banner_carousel/banner_carousel.dart';
import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/constants/screen_size.dart';
import 'package:buycott/data/store_model.dart';
import 'package:buycott/states/user_notifier.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/widgets/list/main_shop_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/file_model.dart';
import '../../states/store_notifier.dart';
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
  void initState() {
    _mainStoresNotifier();

    super.initState();
  }

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
    return Consumer<StoreNotifier>(
        builder: (context,notifier,child){
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
                // _title(context,"오늘의 돈쭐"),
                // heightSizeBox(sized_10),
                // _todayBuyCott(),
                // _buildHeightSizeBox(),
                _title(context,"인기 돈쭐"),
                heightSizeBox(sized_10),
                _todayBuyCott(notifier,1),
                _buildHeightSizeBox(),
                _title(context,"새로운 돈쭐"),
                heightSizeBox(sized_10),
                _todayBuyCott(notifier,2),
                _buildHeightSizeBox(),
                // _title(context,"돈쭐 뉴스"),
                // heightSizeBox(sized_10),
                // _todayBuyCott(),
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

  Widget _todayBuyCott(StoreNotifier storeNotifier, int code) {

    List<StoreModel> _storeList = storeNotifier.mainStoreList
        .where((store) => store.code == code)
        .toList();

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:  BoxConstraints(
          minHeight: 50.0,
          maxHeight:  130.0,
        ),
        child: ListView.builder(
            shrinkWrap: true,
          scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              StoreModel storeModel = _storeList[index];

              return GestureDetector(
                  onTap: () {

                  },
                  child: MainShopListTile(storeModel: storeModel,));
            },
            itemCount: _storeList.length),
      ),
    );
  }

  // Widget _today(){
  //   return Container(
  //     height: 150,
  //     child: LayoutBuilder(
  //       builder: (context, constraints) {
  //         final textPainter = TextPainter(
  //           text: TextSpan(
  //             text: '세상의 이런일이세상의 이런일이세상의 이런일이세상의 이런일이 ',
  //             style: Theme.of(context).textTheme.displaySmall
  //           ),
  //
  //           textDirection: TextDirection.ltr,
  //         );
  //
  //         textPainter.layout(maxWidth: 104);
  //
  //         final int lines = (textPainter.size.height / textPainter.preferredLineHeight).ceil();
  //
  //         Log.logs(TAG, "lines :: $lines");
  //         return Container(
  //           height: constraints.maxHeight,
  //           child: ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: BannerImages.listBanners.length,
  //             scrollDirection: Axis.horizontal,
  //             itemBuilder: (context, index) {
  //
  //               return MainShopListTile();
  //             },
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }


  Widget _placeSearchBar() {
    return TextField(
      style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w500,color: BasicColor.lightgrey2),
      controller: _searchTextController,
      keyboardType: TextInputType.text,
      cursorColor: BasicColor.primary,
      decoration: InputDecoration(
          hintText: "검색어를 입력하세요",
          suffixIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: sized_8,horizontal: sized_12),
              child: Icon(Icons.search,size: sized_30,))),
    );
  }

  Widget _banner(){
    return Consumer<UserNotifier>(
      builder: (context, notifier,widget) {
        return BannerCarousel(
          banners: notifier.bannerList,
          // customizedIndicators: IndicatorModel.animation(
          //     width: 10, height: 5, spaceBetween: 2, widthAnimation: 15),
          height: 140,
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
    );
  }

  void _mainStoresNotifier() {
    Provider.of<StoreNotifier>(context, listen: false).getMainStores();
  }


}




