import 'package:flutter/cupertino.dart';

class TextWidget extends StatefulWidget {
  final String Text;
  final double fontsize;
  final FontWeight fw;
  final Color fontcolour;

  const TextWidget({super.key , required this.Text , required this.fontsize , this.fontcolour = CupertinoColors.black , this.fw = FontWeight.normal});

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.Text, style: TextStyle(color: widget.fontcolour , fontSize: widget.fontsize , fontWeight: widget.fw),);
  }
}
