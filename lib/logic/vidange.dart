import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/constants/constants.dart';
import 'package:notes/models/vidange.dart';
import 'package:notes/screens/add_or_edit/vidangee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VidangeLogic extends ChangeNotifier {
  Map<String, dynamic> decodedelement;
  SharedPreferences sharedPreferences;
  List<TextEditingController> controllers;
  List<bool> yesOrNo;
  var formKey = GlobalKey<FormState>();
  String date;
  Color color = Colors.black;
  int dateViewIndex;
  VidangeLogic({@required this.sharedPreferences, int dateViewIndex}) {
    controllers = List.generate(6, (_) => TextEditingController());
    yesOrNo = List.filled(6, false);

    this.dateViewIndex = dateViewIndex;
    if (dateViewIndex != null) initFetchElement();
  }
  void initFetchElement() {
    decodedelement = jsonDecode(
        sharedPreferences.getStringList(Constants.vidangePref)[dateViewIndex]);
    print(decodedelement);
    date = decodedelement['date'];
    controllers[0].text = decodedelement['km'].toString();
    controllers[1].text = decodedelement['nextOil'].toString();
    controllers[2].text = decodedelement['oil']['price'] == null
        ? ''
        : decodedelement['oil']['price'].toString();
    controllers[3].text = decodedelement['air']['price'] == null
        ? ''
        : decodedelement['air']['price'].toString();
    controllers[4].text = decodedelement['fuel']['price'] == null
        ? ''
        : decodedelement['fuel']['price'].toString();
    controllers[5].text = decodedelement['clim']['price'] == null
        ? ''
        : decodedelement['clim']['price'].toString();
    yesOrNo[0] = decodedelement['oil']['yesOrNo'];
    yesOrNo[1] = decodedelement['air']['yesOrNo'];
    yesOrNo[2] = decodedelement['fuel']['yesOrNo'];
    yesOrNo[3] = decodedelement['clim']['yesOrNo'];
  }

  void save(BuildContext context) {
    bool validate = formKey.currentState.validate();
    if (date == null) {
      color = Colors.red;
    }

    if (validate && date != null) {
      var key = Constants.vidangePref;
      var list = sharedPreferences.getStringList(key);
      VidangeModel vidangeModel = VidangeModel(
          date: date,
          km: double.parse(controllers[0].text),
          nextOil: double.parse(controllers[1].text),
          oil: VidangeFilterModel(
              yesOrNo: yesOrNo[0],
              price: controllers[2].text.isEmpty
                  ? null
                  : double.parse(controllers[2].text)),
          air: VidangeFilterModel(
            yesOrNo: yesOrNo[1],
            price: controllers[3].text.isEmpty
                ? null
                : double.parse(controllers[3].text),
          ),
          fuel: VidangeFilterModel(
              yesOrNo: yesOrNo[2],
              price: controllers[4].text.isEmpty
                  ? null
                  : double.parse(controllers[4].text)),
          clim: VidangeFilterModel(
              yesOrNo: yesOrNo[3],
              price: controllers[5].text.isEmpty
                  ? null
                  : double.parse(controllers[5].text)));
      String encodedElement = jsonEncode(vidangeModel.toJson());
      if (dateViewIndex == null) {
        list.add(encodedElement);
      } else {
        list[dateViewIndex] = jsonEncode(vidangeModel.toJson());
      }
      sharedPreferences.setStringList(Constants.vidangePref, list).then((x) {
        Navigator.pop(context, jsonEncode(vidangeModel.toJson()));
      });
    }

    notifyListeners();
  }

  void showDatePick(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1500, 1, 1),
            lastDate: DateTime(2500, 1, 1))
        .then((dateTime) {
      date = DateFormat.yMd().format(dateTime);
    });
  }
}
