import 'package:buycott/data/address_result_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/place_result_model.dart';
import '../../states/place_notifier.dart';
import '../../utils/log_util.dart';
import '../../widgets/list/place_list_tile.dart';
import '../../widgets/style/divider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TAG = "AddressScreen";

  FocusNode _focusNode = FocusNode();

  List<Documents> addressList = [];
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


  void getAddressList(String text,int pageIndex) {
    Provider.of<PlaceNotifier>(context, listen: false)
        .addressSearch(context, text,pageIndex)
        .then((value) {
      setState(() {
        if(value != null){
          for (var data in value) {
            addressList.add(data);
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

          if(addressList != null) {
            page = 1;
            addressList!.clear();
          }
        });

        getAddressList(searchKeyWord,page);

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
          hintText: "주소를 입력해주세요",
          border: InputBorder.none,

          prefixIcon: Padding(
              padding: EdgeInsets.only(left: 13),
              child: Icon(Icons.search,color: Colors.blueGrey,))),
    );
  }

  Widget _placeList() {
    return ( addressList.isNotEmpty)
        ? Expanded(
      child: ListView.separated(
          controller: _scrollController,
          itemBuilder: (context, index) {
            Documents addressModel = addressList[index];

            return GestureDetector(
                onTap: () {
                  Log.logs(
                      TAG, "list tile click :: ${addressModel.roadAddress!.roadName!}");
                },
                child: addressModel.roadAddress != null ? PlaceListTile(
                    placeName:  addressModel.roadAddress!.roadName! ,
                    addressName: addressModel.roadAddress!.addressName!,
                ) : Container());
          },
          separatorBuilder: (context, index) {
            return list_divider();
          },
          itemCount: addressList.length),
    )
        : _emptyList();
  }

  Container _emptyList() {
    return Container(
    color: Colors.amber,

  );
  }

  scrollListener() async {
    if (_scrollController.offset  == _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {

      if(!isEndYn) {
        getAddressList(searchKeyWord, page);
      }
    }
  }
}
