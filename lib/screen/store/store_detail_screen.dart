import 'package:auto_size_text/auto_size_text.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:buycott/constants/basic_text.dart';
import 'package:buycott/data/review_model.dart';
import 'package:buycott/data/store_model.dart';
import 'package:buycott/firebase/firebaseservice.dart';
import 'package:buycott/screen/store/review_sliver_header.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/utils/log_util.dart';
import 'package:buycott/utils/utility.dart';
import 'package:buycott/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../constants/padding_size.dart';
import '../../constants/screen_size.dart';
import '../../states/store_notifier.dart';
import '../../widgets/NoGlowScrollBehavior.dart';
import '../../widgets/circle_progressbar.dart';
import '../../widgets/list/review_list_tile.dart';
import '../../widgets/star_widget.dart';
import '../../widgets/style/container.dart';
import '../../widgets/style/divider.dart';
import '../home/home_screen.dart';

class StoreDetailScreen extends StatefulWidget {
  final String storeSrno;
  const StoreDetailScreen({super.key, required this.storeSrno});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  final TAG = "StoreDetailScreen";

  StoreModel? storeModel;

  int pageNum = 1;
  int limit = 10;
  bool lastList = false;

  bool getReviewsList = false;


  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {

    _getStoreDetail();

    _scrollController.addListener(() {
      scrollListener();
    });

    context.read<StoreNotifier>().reviewList.clear();

    getReviews();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _getStoreDetail() {
    Provider.of<StoreNotifier>(context, listen: false).storeDetail(int.parse(widget.storeSrno),userSrno).then((value){
      setState(() {
        storeModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(

        title: Text(
          storeModel?.storeName ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
          centerTitle: false,
          titleSpacing: -10,
          leading:  IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: BasicColor.back_black,
              icon: Image.asset('assets/icon/icon_arrow_left.png',scale: 16,)),
        actions: [
          Visibility(
            visible: userSrno != null,
            child: Transform.scale(
                scale: 0.5,
                child: Image.asset("assets/icon/icon_like_off.png",fit: BoxFit.fill,)),
          )
        ],
      ),

      body: storeModel != null ?
      Consumer<StoreNotifier>(
        builder: (context, notifier, widget) {
          return Column(
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                         color: Colors.white,
                          child: Column(
                            children: [
                              _storeInfo(context),
                              Padding(
                                padding: const EdgeInsets.only(top:sized_30 ),
                                child: customDivider(BasicColor.lightgrey3, sized_8, sized_8),
                              )
                            ],
                          ),
                        ),
                      ),
                       SliverPersistentHeader(
                          pinned: true, delegate: ReviewSliverHeader(storeModel?.storeSrno)),
                      notifier.reviewList.isNotEmpty ?  SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            Review review = notifier.reviewList[index];

                            return   ReviewListTile(review: review,storeSrno: storeModel!.storeSrno.toString(),index: index,) ;
                          },
                          childCount:  notifier.reviewList.length ,
                        ),
                      ) : getReviewsList ?  _empty() : _emptyReviews(),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      )

          : Container(color:Colors.white,child: CustomCircularProgress()),
    );
  }

  Widget _empty(){
    return SliverToBoxAdapter(
      child: Expanded(
        child: Column(
          children: [
            heightSizeBox(sized_90),
            Image.asset('assets/icon/icon_review.png',width: sized_75,height: sized_75,),
            heightSizeBox(sized_10),
            Text('작성된 리뷰가 없습니다.',style: Theme.of(context).textTheme.displayMedium!.copyWith(color: BasicColor.lightgrey4),)
          ],
        ),
      ),
    );
  }


  SliverList _emptyReviews() {
    return SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return   EmptyScreen(
                              widget: Padding(
                                padding: const EdgeInsets.symmetric(vertical: sized_20,horizontal: padding_side),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: sized_100,
                                          height: sized_100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(sized_10),
                                          ),
                                        ),
                                        widthSizeBox(sized_10),
                                        Container(
                                          width: sized_100,
                                          height: sized_100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(sized_10),
                                          ),
                                        ),
                                      ],
                                    ),
                                    heightSizeBox(sized_20),
                                    Row(
                                      children: [
                                        Container(
                                          width: sized_24,
                                          height: sized_24,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        widthSizeBox(sized_5),
                                        Container(
                                          height: 16,
                                          width: 50,
                                          color: Colors.white,
                                        ),
                                        widthSizeBox(sized_5),
                                        Container(
                                          height: 16,
                                          width: sized_80,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    heightSizeBox(sized_20),
                                    Container(
                                      height: sized_50,
                                      width: size!.width-36,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),

                            );
                          },
                          childCount:  3 ,
                        ),
                      );
  }

  Padding _storeInfo(BuildContext context) {
    Widget starIcons = buildStarRating(storeModel?.score ?? 0, sized_12);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding_side),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Row(
            //   children: [
            //     Text(
            //       storeModel?.storeName ?? "",
            //       style: Theme.of(context).textTheme.titleLarge,
            //     ),
            //     Expanded(
            //         child: Align(
            //             alignment: Alignment.topRight,
            //             child: IconButton(
            //               padding: EdgeInsets.zero,
            //               constraints: BoxConstraints(),
            //               icon: Icon(Icons.close),
            //               color: BasicColor.primary2,
            //               iconSize: sized_30,
            //               onPressed: () {
            //                 Navigator.pop(context);
            //               },
            //             )))
            //   ],
            // ),
            // heightSizeBox(sized_24),
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: storeModel?.businessHours != null ? Utility().getOpenClose(storeModel!.businessHours!.split("~")[0], storeModel!.businessHours!.split("~")[1]): "",
                style: Theme.of(context).textTheme.displayMedium,
                children: <TextSpan>[
                  TextSpan(text: " "),
                  TextSpan(
                      text: storeModel?.businessHours ?? "", style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            heightSizeBox(sized_10),
            Row(
              children: [
                Text('댓글 97', style: Theme.of(context).textTheme.displayMedium),
                widthSizeBox(sized_6),
                starIcons
              ],
            ),
            heightSizeBox(sized_10),
            Text(storeModel?.storeAddress ?? "", style: Theme.of(context).textTheme.bodyMedium),
            heightSizeBox(sized_10),
            SizedBox(
              width: size!.width -36,
                child: AutoSizeText(storeModel?.storeDesc ?? "",minFontSize: 8, style: Theme.of(context).textTheme.bodyMedium,)),
          ],
        ),
      ),
    );
  }

  void getReviews() async {

   await  Provider.of<StoreNotifier>(context,listen: false).getReviews(widget.storeSrno,pageNum,limit).then((_reviewResult){
      setState(() {
          getReviewsList = true;

        if(_reviewResult.isNotEmpty) {
          setState(() {
            pageNum ++; //페이지증가
          });
        }else{
          setState(() {
            lastList = true;
          });
        }
      });
    });
  }

  scrollListener() async {
    if (_scrollController.offset  == _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      Log.logs(TAG, "scroll bottom ===");
      if(!lastList) {
        getReviews();
      }
    }
  }
}

