import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/constants/screen_size.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';

class StoreListTile extends StatelessWidget {
  final String placeName;
  final String addressName;
  final bool likeYn;
  const StoreListTile({super.key, required this.placeName, required this.addressName, required this.likeYn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding_side,vertical: sized_17),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(likeYn ? "assets/icon/icon_like_on.png" : "assets/icon/icon_like_off.png",width: 16,
                height: 16,fit: BoxFit.fill,),
              widthSizeBox(sized_14),
              Column( mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(placeName,style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16),),
                  Visibility(
                    visible: addressName != "",
                    child:
                    Column(
                      children: [
                        heightSizeBox(sized_5),
                        SizedBox(
                            width: size!.width - 75,
                            child: Text(addressName,style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BasicColor.lightgrey2),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                      ],
                    ),

                  ),
                ],
              ),

            ],
          ),



        ],
      ),
    );
  }
}
