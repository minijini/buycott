import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/dialog/custom_dialog.dart';

class CodeDialog {
  void result_error_code(int? result_code,BuildContext context,{String? dialog_text}) {
    if (result_code == 214) {
      CustomDialog(funcAction: dialogPop)
          .normalDialog(context, "member_no_id", '확인');
    } else{
        CustomDialog(funcAction: dialogPop).normalDialog(
          context,dialog_text ?? "", '확인');
    }
  }

  void response_error(BuildContext context) {
    CustomDialog(funcAction: dialogPop).normalDialog(
          context,api_error, '확인');
  }

  void response_403_error(BuildContext context) {
    CustomDialog(funcAction: dialogPop).normalDialog(
        context,api_403_error, '확인');
  }

  void dialogPop(BuildContext context) async {
    Navigator.pop(context);
  }
}
