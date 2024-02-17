
import 'package:device_screen_size/device_screen_size.dart';
import 'package:flutter/material.dart';

import '../../constants/basic_text.dart';
import '../../constants/padding_size.dart';
import '../../utils/color/basic_color.dart';


class CustomDialog {
  final Function(BuildContext context)? funcAction;
  final Function(BuildContext context, String pkChat,String pkMember)? chatfuncAction;

  CustomDialog({this.funcAction,this.chatfuncAction});

  Future<void> normalDialog(
      BuildContext context, String message , String clickmsg ) async {
    showDialog(
      context: context,
      barrierDismissible: false, // 바깐 영역 터치시 창닫기 x
      builder: (context) => dialog(context,message,clickmsg),
    );
  }

  Widget dialog(BuildContext context,String message, String clickmsg) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: WillPopScope(
        onWillPop: ()async{
          if(appUpdateYn == true) {
            return false;
          }else{
            return true;
          }
        },
        child: Container(
          margin: EdgeInsets.only(top: sized_35),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(sized_10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: sized_15,
              ),
              SizedBox(
                width: 50,
                height: 70,
                child: Image.asset("assets/icon/icon_marker.png"),
              ),
              SizedBox(
                height: sized_15,
              ),
              Container(
                  padding: EdgeInsets.all(sized_20),
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                height: sized_10,
              ),
              Align(
                alignment: Alignment.center,
                child: Center(
                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: BasicColor.primary,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)

                            )
                        ),
                        minimumSize: Size(DeviceScreenSize.screenWidthInPercentage(context, percentage: 1), 50),
                      ),
                      onPressed:   () => funcAction!(context),
                      child: Text(
                        clickmsg,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }


Future<void> actionDialog(
    BuildContext context,
    String message,
    String negativeMsg,
    String positiveMsg,
    String icon,
  {String? pkChat,String? pkMember}
    ) async {
  showDialog(
    context: context,
    barrierDismissible: false, // 바깐 영역 터치시 창닫기 x
    builder: (context) => actiondialog(context,message,negativeMsg,positiveMsg,icon, pkChat ?? '',pkMember ?? ''),
  );
}

  Widget actiondialog(BuildContext context,String message, String negativeMsg,String positiveMsg,String icon,String pkChat,String pkMember) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(top: sized_35),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(sized_10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: sized_15,
            ),
            SizedBox(
              width: 121,
              height: 70,
              child: Image.asset(icon),
            ),
            SizedBox(
              height: sized_15,
            ),
            Container(
                padding: EdgeInsets.all(sized_20),
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: sized_10,
            ),
            Align(
              alignment: Alignment.center,
              child: Center(
                  child: Row(
                    children: [
                      Flexible(
                        flex:1,
                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                              side: const BorderSide(
                                width: 0.7,
                                color: BasicColor.primary,
                              ),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                )
                            ),
                            minimumSize: Size(DeviceScreenSize.screenWidthInPercentage(context, percentage: 1), 50),
                          ),
                          onPressed:   () {
                                appUpdateYn = false;
                                Navigator.pop(context);
                          },
                          child: Text(
                            negativeMsg,
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(color: BasicColor.primary),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(
                            backgroundColor: BasicColor.primary,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(

                                    bottomRight: Radius.circular(10)

                                )
                            ),
                            minimumSize: Size(DeviceScreenSize.screenWidthInPercentage(context, percentage: 1), 50),
                          ),
                          onPressed:   () =>  funcAction!(context),
                          child: Text(
                            positiveMsg,
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
