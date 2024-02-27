import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/data/place_result_model.dart';
import 'package:buycott/screen/place/shop_list_screen.dart';
import 'package:buycott/states/store_notifier.dart';
import 'package:buycott/utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/UnanimatedPageRoute.dart';
import '../place/address_list_screen.dart';

class Arguments {
  Place place; //반환때 사용할 클래스
  Arguments({required this.place});
}

class StoreAddScreen extends StatefulWidget {
  const StoreAddScreen({super.key});

  @override
  State<StoreAddScreen> createState() => _StoreAddScreenState();
}

class _StoreAddScreenState extends State<StoreAddScreen> {
  final TAG = "StoreAddScreen";
  TextEditingController _storeDescController = TextEditingController();
  Place? storeModel;

  @override
  void dispose() {
    _storeDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '가게 제안',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: ()async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShopListScreen()),
            );

            if(result != null){
              setState(() {
                storeModel = result.place;
              });

              if(storeModel != null) {
                registerStore(storeModel!);
              }

            }
          }, child: Text('가게등록')),
          SizedBox(
            height: sized_10,
          ),
          Text(storeModel?.placeName ?? "" ),
          Text(storeModel?.phone ?? "" ),
        ],
      ),
    );
  }

  void registerStore(Place storeModel) {
    Provider.of<StoreNotifier>(context, listen: false).registerStore(
        context,
        storeModel.id!,
        1,
        storeModel.categoryGroupCode!,
        storeModel.categoryGroupName!,
        storeModel.roadAddressName! + storeModel.placeName!,
        storeModel.placeName!,
        storeModel.phone!,
        _storeDescController.text,
        storeModel.x!,
        storeModel.y!);
  }
}
