import 'package:buycott/data/address_result_model.dart';
import 'package:buycott/screen/shop/address_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/place_result_model.dart';
import '../../states/place_notifier.dart';
import '../../utils/log_util.dart';
import '../../widgets/UnanimatedPageRoute.dart';
import '../../widgets/place_list_tile.dart';
import '../../widgets/style/divider.dart';
import '../login/login_screen.dart';

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
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            _placeSearchBar(),
            _placeList()
          ],
        ),
      ),

    );
  }

  TextField _placeSearchBar() {
    return TextField(
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
      cursorColor: Colors.blueGrey,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.yellow,
          contentPadding:
          const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
          hintText: "장소를 입력해주세요",
          border: InputBorder.none,

          prefixIcon: Padding(
              padding: EdgeInsets.only(left: 13),
              child: Icon(Icons.search,color: Colors.blueGrey,))),
    );
  }

  Widget _placeList() {
    return (placeList.isNotEmpty )
        ? Expanded(
      child: ListView.separated(
          controller: _scrollController,
          itemBuilder: (context, index) {
            Place placeModel = placeList[index];

            return GestureDetector(
                onTap: () {
                  Log.logs(
                      TAG, "list tile click :: ${placeModel.placeName!}");
                },
                child: PlaceListTile(
                    placeName:  placeModel.placeName!,
                    addressName: placeModel.roadAddressName!));
          },
          separatorBuilder: (context, index) {
            return list_divider();
          },
          itemCount: placeList.length),
    )
        : _emptyList();
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
