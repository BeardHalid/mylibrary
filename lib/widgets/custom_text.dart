import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? textSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color? textColor;
  const CustomText({
    super.key,
    required this.text,
    this.textSize,
    this.fontStyle,
    this.fontWeight,
    this.textAlign,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      style: TextStyle(
        fontSize: textSize ?? 13.0,
        fontStyle: fontStyle ?? FontStyle.normal,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: textColor ?? Colors.black,
      ),
    );
  }
}
