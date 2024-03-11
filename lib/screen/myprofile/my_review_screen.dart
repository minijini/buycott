import 'package:buycott/constants/basic_text.dart';
import 'package:buycott/constants/screen_size.dart';
import 'package:buycott/widgets/list/my_review_list_tile.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/padding_size.dart';
import '../../data/review_model.dart';
import '../../states/store_notifier.dart';
import '../../utils/color/basic_color.dart';
import '../../widgets/NoGlowScrollBehavior.dart';
import '../../widgets/circle_progressbar.dart';
import '../../widgets/style/divider.dart';

class MyReviewScreen extends StatefulWidget {
  const MyReviewScreen({super.key});

  @override
  State<MyReviewScreen> createState() => _MyReviewScreenState();
}

class _MyReviewScreenState extends State<MyReviewScreen> {
  int pageNum = 1;
  int limit = 10;
  bool lastList = false;

  bool getReviewsList = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {


    _scrollController.addListener(() {
      scrollListener();
    });

    context.read<StoreNotifier>().myReviewList.clear();

    getMyReviews();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내가 쓴 리뷰',
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
      body: Container(
        color: Colors.white,
        child: _myReviewList(),
      ),
    );
  }

  Widget _myReviewList() {
    return  Expanded(
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: Consumer<StoreNotifier>(
            builder: (context, notifier, widget) {
            return notifier.myReviewList.isNotEmpty ? ListView.separated(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  Review review = notifier.myReviewList[index];

                  return MyReviewListTile(
                      review: review,index: index,);
                },
                separatorBuilder: (context, index) {
                  return divider();
                },
                itemCount: notifier.myReviewList.length) : getReviewsList ?  _empty() : CustomCircularProgress();
          }
        ),
      ),
    );
  }

  Widget _empty(){
    return SizedBox(
      width: size!.width,
      child: Column(
        children: [
          heightSizeBox(sized_180),
          Text('내가 쓴 리뷰가 없습니다.',style: Theme.of(context).textTheme.displayMedium!.copyWith(color: BasicColor.lightgrey4),)
        ],
      ),
    );
  }


  void getMyReviews() async {

    List<Review> _myReviewResult = await  Provider.of<StoreNotifier>(context,listen: false).myReviews(userSrno.toString(),pageNum,limit);

    setState(() {
      getReviewsList = true;

      if(_myReviewResult.isNotEmpty) {

        setState(() {
          pageNum ++; //페이지증가
        });
      }else{
        setState(() {
          lastList = true;
        });
      }
    });
  }

  scrollListener() async {
    if (_scrollController.offset  == _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      if(!lastList) {
        getMyReviews();
      }
    }
  }
}
