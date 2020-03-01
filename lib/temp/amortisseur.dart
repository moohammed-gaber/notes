import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:notes/constants/constants.dart';
import 'package:notes/models/amortisseur.dart';
import 'package:notes/models/batterie.dart';
import 'package:notes/models/courroie.dart';
import 'package:notes/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Armortisseurr extends StatefulWidget {
  static const String route = '/armortisseur';
  int index;
  Armortisseurr({this.index});

  @override
  _ArmortisseurrState createState() => _ArmortisseurrState();
}

class _ArmortisseurrState extends State<Armortisseurr> {
  String date;
  List<TextEditingController> controllers;
  bool front = false;
  bool rear = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllers = List.generate(2, (_) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      label: Text(
                        'Date',
                      ),
                    ),
                  ),
                  Text(
                    date == null ? '' : date,
                  ),
                  IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1500, 1, 1),
                                lastDate: DateTime(2500, 1, 1))
                            .then((dateTime) {
                          this.date = DateFormat.yMd().format(dateTime);

                          setState(() {});
                        });
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      label: Text(
                        'KM',
                      ),
                    ),
                  ),
                  Flexible(
                      flex: 2,
                      child: MyTextField(
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        textEditingController: controllers[0],
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('Front/Av'),
                      Checkbox(
                          value: front,
                          onChanged: (front) {
                            this.front = front;
                            setState(() {});
                          })
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text('Rear/Av'),
                      Checkbox(
                          value: rear,
                          onChanged: (rear) {
                            this.rear = rear;
                            setState(() {});
                          })
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                        label: Text(
                      'Note',
                    )),
                  ),
                  Flexible(
                      flex: 2,
                      child: MyTextField(
                        textInputType: TextInputType.text,
                        textEditingController: controllers[1],
                      )),
                ],
              ),
              RaisedButton(
                  color: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {},
                  child: Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
