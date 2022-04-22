

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KettlebellSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          body: Container(
            width: size.width,
            height: size.height,
            child: Column (
              children: [
                Row(
                  children: [

                  ],
                )
              ],
            ),
          ),
        ));
  }
}