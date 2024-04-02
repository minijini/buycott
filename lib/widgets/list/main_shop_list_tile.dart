import 'package:auto_size_text/auto_size_text.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constants.dart';
import '../../constants/padding_size.dart';
import '../../data/store_model.dart';
import '../square_image.dart';

class MainShopListTile extends StatelessWidget {
  final StoreModel storeModel;
   MainShopListTile({super.key, required this.storeModel});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.goNamed(storeDetailRouteName,pathParameters: {
          'storeSrno' : storeModel.storeSrno.toString()
        });
      },
      child: Container(
        padding: EdgeInsets.only(right: sized_6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                width:sized_104,height: sized_50,
                    color: BasicColor.linegrey,
                    child:Image.asset("assets/icon/map.png",fit: BoxFit.fill,)),
                Container(padding:EdgeInsets.symmetric(vertical: sized_8),
                width:sized_104,height: sized_50,child: Center(child: _iconImg()))
              ],
            ),
            // SquareImage(img: 'https://cdn.mos.cms.futurecdn.net/Nxz3xSGwyGMaziCwiAC5WW-1024-80.jpg',width:sized_104,height: sized_50,),
            SizedBox(height: sized_10,),
            SizedBox(
                width: sized_104,
                child: AutoSizeText(storeModel.storeName ?? "",style: Theme.of(context).textTheme.displaySmall,maxLines: 1, // Restrict to a single line
                  overflow: TextOverflow.ellipsis,)),
            SizedBox(height: sized_6,),
            SizedBox(
                width: sized_104,
                child: AutoSizeText(storeModel.storeAddress  ?? "",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: sized_10),maxLines: 1, // Restrict to a single line
                  overflow: TextOverflow.ellipsis,)),

          ],
        ),
      ),
    );
  }

  Image _iconImg() {
    if(storeModel.storeType == "CE7" || storeModel.storeType == "FD6") {
      return Image.asset(
        'assets/icon/icon_marker_${storeModel.storeType}.png', scale: 12,);
    }else{
      return Image.asset("assets/icon/icon_marker_etc.png", scale: 12);
    }

  }
}


