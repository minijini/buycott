import 'package:buycott/constants/padding_size.dart';
import 'package:buycott/constants/screen_size.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/widgets/style/container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/basic_text.dart';
import '../../states/user_notifier.dart';

class StoreListTile extends StatefulWidget {
  final String placeName;
  final String addressName;
  final String storeSrno;
   bool likeYn;
   final bool searchYn;
   StoreListTile({super.key, required this.placeName, required this.addressName, required this.likeYn, required this.storeSrno, required this.searchYn});

  @override
  State<StoreListTile> createState() => _StoreListTileState();
}

class _StoreListTileState extends State<StoreListTile> {
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
              GestureDetector(
                onTap: (){
                  if(!widget.searchYn) {
                    favorite();
                  }
                },
                child: Image.asset(widget.likeYn ? "assets/icon/icon_like_on.png" : "assets/icon/icon_like_off.png",width: 20,
                  height: 20,fit: BoxFit.fill,),
              ),
              widthSizeBox(sized_14),
              Column( mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.placeName,style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis),
                  Visibility(
                    visible: widget.addressName != "",
                    child:
                    Column(
                      children: [
                        heightSizeBox(sized_5),
                        SizedBox(
                            width: size!.width - 75,
                            child: Text(widget.addressName,style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BasicColor.lightgrey2),maxLines: 1,overflow: TextOverflow.ellipsis,)),
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


  void favorite() async{
    if(widget.likeYn){
      Provider.of<UserNotifier>(context,listen: false).favoreteDelete(widget.storeSrno, userSrno!).then((value){
        setState(() {
          widget.likeYn = false;
        });
      });
    }else{
      Provider.of<UserNotifier>(context,listen: false).favoreteAdd(widget.storeSrno, userSrno!).then((value){
        setState(() {
          widget.likeYn = true;
        });
      });
    }
  }
}
