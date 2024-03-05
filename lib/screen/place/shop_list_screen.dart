import 'package:buycott/data/address_result_model.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/padding_size.dart';
import '../../data/place_result_model.dart';
import '../../states/place_notifier.dart';
import '../../utils/color/basic_color.dart';
import '../../utils/log_util.dart';
import '../../widgets/UnanimatedPageRoute.dart';
import '../../widgets/list/place_list_tile.dart';
import '../../widgets/style/divider.dart';
import '../login/login_screen.dart';
import '../store/store_add_screen.dart';
import 'address_list_screen.dart';

class ShopListScreen extends StatefulWidget {
  const ShopListScreen({super.key});

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  final TAG = "ShopListScreen";

  FocusNode _focusNode = FocusNode();

  List<Place> placeList = [];
  int page = 1;
  String searchKeyWord = "";
  bool isEndYn = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchTextController = TextEditingController();


  @override
  void initState() {
    _scrollController.addListener(() {
      scrollListener();
    });

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void getPlaceList(String text,int pageIndex) {
    Provider.of<PlaceNotifier>(context, listen: false)
        .placeSearch(context, text,pageIndex)
        .then((value) {
      setState(() {
        if(value != null){
          for (var data in value) {
            placeList.add(data);
          }

          setState(() {
            page ++; //페이지증가
            isEndYn = context.read<PlaceNotifier>().endYn;
          });
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text(
        "가게 검색",
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: padding_side),
        child: Column(
          children: [
            _placeSearchBar(),
            heightSizeBox(sized_10),
            _placeList()
          ],
        ),
      ),

    );
  }



  TextField _placeSearchBar() {
    return TextField(
      style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w500,color: BasicColor.lightgrey2),
      cursorColor: BasicColor.primary,
      controller: _searchTextController,
      focusNode: _focusNode,
      autofocus: true,
      keyboardType: TextInputType.text,
      onChanged: (text) {

        setState(() {
          searchKeyWord = text;

          if(placeList != null) {
            page = 1;
            placeList!.clear();
          }
        });

        getPlaceList(searchKeyWord,page);

      },
      decoration: InputDecoration(
          hintText: "가게 이름을 입력해주세요",
          suffixIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: sized_8,horizontal: sized_12),
              child: Icon(Icons.search,size: sized_30,))),
    );
  }

  Widget _placeList() {
    return  Expanded(
      child: ListView.separated(
          controller: _scrollController,
          itemBuilder: (context, index) {
            Place placeModel = placeList[index];

            return GestureDetector(
                onTap: () {
                  Log.logs(
                      TAG, "list tile click :: ${placeModel.placeName!}");

                  Navigator.of(context).pop(Arguments(place: placeModel));
                },
                child: PlaceListTile(
                    placeName:  placeModel.placeName!,
                    addressName: placeModel.roadAddressName!));
          },
          separatorBuilder: (context, index) {
            return list_divider();
          },
          itemCount: placeList.length),
    );
  }

  Container _emptyList() {
    return Container(
    color: Colors.amber,
      child: TextButton(
        onPressed: () {
          Navigator.push(
                context,
                UnanimatedPageRoute(builder: (context) => AddressScreen()),
              );
        },
        child: Text('주소검색'),
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
}
