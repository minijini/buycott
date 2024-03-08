import 'package:buycott/data/KeywordItem.dart';
import 'package:buycott/data/address_result_model.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:provider/provider.dart';

import '../../constants/padding_size.dart';
import '../../data/place_result_model.dart';
import '../../states/place_notifier.dart';
import '../../states/store_notifier.dart';
import '../../utils/color/basic_color.dart';
import '../../utils/log_util.dart';
import '../../widgets/NoGlowScrollBehavior.dart';
import '../../widgets/UnanimatedPageRoute.dart';
import '../../widgets/list/place_list_tile.dart';
import '../../widgets/style/divider.dart';
import '../../widgets/style/input_decor.dart';
import '../login/login_screen.dart';
import '../store/store_add_screen.dart';

class SearchScreen extends StatefulWidget  {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TAG = "SearchScreen";

  FocusNode _focusNode = FocusNode();

  List<Place> placeList = [];
  int page = 1;
  String searchKeyWord = "";
  bool isEndYn = false;
  bool isFirstSearch = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchTextController = TextEditingController();

  List<KeywordItem> _keywordList = [];

  @override
  void initState() {
    _scrollController.addListener(() {
      scrollListener();
    });

    context.read<StoreNotifier>().keywordList.clear();

    getKeywordList();

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void getKeywordList()async{

      final _result = await Provider.of<StoreNotifier>(context,listen: false).getKeywordItems();

      setState(() {
        _keywordList.addAll(_result);
      });


  }

  void getPlaceList(String text,int pageIndex) {
    Provider.of<PlaceNotifier>(context, listen: false)
        .placeSearch(context, text,pageIndex)
        .then((value) {
      setState(() {
        if(value != null){
          for (var data in value) {
            setState(() {
              placeList.add(data);
            });
          }

          setState(() {
            page ++; //페이지증가
            isEndYn = context.read<PlaceNotifier>().endYn;
          });

        }else{
          setState(() {
            placeList.clear();
          });
        }

        Log.logs(TAG, "${placeList.isEmpty}");
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      title: Text(
        "가게 검색",
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
      body:  Column(
            children: [
              heightSizeBox(sized_10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding_side),
                child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _placeSearchBar(),
                        heightSizeBox(sized_20),
                        Visibility(
                          visible: placeList.isEmpty && _searchTextController.text.isEmpty,
                          child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('최근 검색 기록',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),),
                                  heightSizeBox(sized_16),
                                  Visibility(
                                      visible: _keywordList.isEmpty,
                                      child: Text('최근 검색 기록이 없습니다.',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BasicColor.lightgrey2),)),
                                  tag(),
                                ],
                              )

                        ),

                      ],
                    )
              ),

              placeList.isNotEmpty  ? _placeList() : Visibility(
                visible: isFirstSearch && _searchTextController.text.isNotEmpty,
                child: Expanded(child: Padding(
                  padding: EdgeInsets.only(top: sized_100),
                  child: Text('검색 결과가 없습니다.',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BasicColor.lightgrey2) ,),)),
              )
            ],
          ),

    );
  }

  Widget tag(){

    return Tags(

      key:_tagStateKey,
      alignment:WrapAlignment.start,
      itemCount: _keywordList.length, // required
      itemBuilder: (int index){
        final item = _keywordList[index];
        return ItemTags(
            elevation: 0,
          color: Colors.white,
          key: Key(index.toString()),
          index: index, // required
          title: item.title ?? "",
          active: item.active ?? false,
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BasicColor.lightgrey2),
          textColor: BasicColor.lightgrey2,
          activeColor: BasicColor.primary2,
          border: Border.all(color: BasicColor.primary, width: 1),
          borderRadius:BorderRadius.all(Radius.circular(sized_25)) ,
          combine: ItemTagsCombine.withTextBefore,
          removeButton: ItemTagsRemoveButton(
            color: BasicColor.lightgrey2,
            backgroundColor: Colors.transparent,
            onRemoved: () {
              setState(() {
                _keywordList.removeAt(index);
              });

              Provider.of<StoreNotifier>(context,listen: false).saveKeywordItems(_keywordList);

              return true;
            },
          ),
          onPressed: (item) => print(item),
        );

      },
    );
  }



  Widget _placeSearchBar() {
    return SizedBox(
      height:40 ,
      child: TextField(
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
        cursorColor: BasicColor.primary,
        controller: _searchTextController,
        focusNode: _focusNode,
        autofocus: true,
        maxLines: 1,
        keyboardType: TextInputType.text,
        onChanged: (text) {

          setState(() {
            isFirstSearch = true;
            searchKeyWord = text;
            _placeReset();
          });

          if(_searchTextController.text.isNotEmpty) {
            getPlaceList(searchKeyWord, page);
          }

        },
        decoration: textInputDecor_none(
            context,
            hint: "가게 이름을 입력해주세요",
           ).copyWith(
          suffixIcon: _searchTextController.text.isNotEmpty
            ? IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
          onPressed: () {
            setState(() {
              _searchTextController.clear();

              _placeReset();
            });
          },
          icon: Icon(Icons.clear,color: Colors.black,),
        )
            : null,),
      ),
    );
  }

  void _placeReset() {
    if(placeList != null || _searchTextController.text.isEmpty) {
      page = 1;
      placeList!.clear();
    }
  }

  Widget _placeList() {

    return  Expanded(
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ListView.separated(
            controller: _scrollController,
            itemBuilder: (context, index) {
              Place placeModel = placeList[index];

              return GestureDetector(
                  onTap: () {
                    Log.logs(
                        TAG, "list tile click :: ${placeModel.placeName!}");

                    setState(() {
                      _keywordList.add(KeywordItem(title: placeModel.placeName!, active: false, index: 1));
                    });
                    Provider.of<StoreNotifier>(context,listen: false).saveKeywordItems(_keywordList);
                  },
                  child: PlaceListTile(
                      placeName:  placeModel.placeName!,
                      addressName: placeModel.roadAddressName!));
            },
            separatorBuilder: (context, index) {
              return list_divider();
            },
            itemCount: placeList.length),
      ),
    );
  }

  scrollListener() async {
    if (_scrollController.offset  == _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {

      if(!isEndYn) {
        getPlaceList(searchKeyWord, page);
      }
    }
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();


}


