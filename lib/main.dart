import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipes_api/screen/pages/home_page.dart';
import 'package:recipes_api/screen/widget/bottom_sheet.dart';

void main(){
  runApp(MyAPP());
}
class MyAPP extends StatefulWidget {
  const MyAPP({super.key});

  @override
  State<MyAPP> createState() => _MyAPPState();
}

class _MyAPPState extends State<MyAPP> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomSheetBar(),
    );
  }
}
