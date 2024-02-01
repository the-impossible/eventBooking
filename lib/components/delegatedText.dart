import 'package:event/utils/constant.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DelegatedText extends StatelessWidget {
  final String text;
  final double fontSize;
  String? fontName = 'InterBold';
  Color? color = Constants.tertiaryColor;
  TextAlign? align;
  bool? truncate;

  DelegatedText({
    required this.text,
    required this.fontSize,
    this.fontName,
    this.color,
    this.align,
    this.truncate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      (truncate == true) ? truncateString(text, 13) : text,
      softWrap: true,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        letterSpacing: 1,
        fontFamily: fontName,
      ),
      textAlign: align,
      overflow: TextOverflow.ellipsis,
    );
  }

  String truncateString(String input, int maxLength) {
    if (input.length <= maxLength) {
      return input;
    } else {
      return "${input.substring(0, maxLength)}...";
    }
  }
}
