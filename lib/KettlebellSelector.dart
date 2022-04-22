

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KettlebellSelector extends StatelessWidget {
   static const List<String> entries = <String>['Double Clean/ Press', 'Double Swing', 'Double Snatch', 'a', 'b', 's', 'd' 'd','a',
    'Double Clean/ Press', 'Double Swing', 'Double Snatch', 'a', 'b', 's', 'd' 'd',
    'Double Clean/ Press', 'Double Swing', 'Double Snatch', 'a', 'b', 's', 'd' 'd'];

  const KettlebellSelector({Key? key}) : super(key: key);
   randomColor() {
     return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
   }
  final int tracker = 0;
   kettlebellList(int i) {
      if(i < entries.length){
        return entries[i];
      }

   }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
      Scaffold(
          appBar: AppBar(
              title: const Text('Kettlebell Selection')
          ),
          body:
          ListView.builder(
            itemBuilder: (_, index) {
              while (index < entries.length){
                return Text(kettlebellList(index));
              }
              return const Text("");
            },
          ),
      ));

  }
}