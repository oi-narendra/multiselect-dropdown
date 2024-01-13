import 'package:flutter/material.dart';

/// [HintText] is a hint text builder.
/// It is used to build the hint text.
class HintText extends StatelessWidget {
  final TextStyle? hintStyle;
  final String hintText;
  final Color? hintColor;
  final EdgeInsetsGeometry? hintPadding;

  const HintText({
    Key? key,
    this.hintStyle,
    required this.hintText,
    this.hintColor,
    this.hintPadding,
  }) : super(key: key);

  static const EdgeInsetsGeometry hintPaddingDefault =
      EdgeInsets.symmetric(horizontal: 10.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: hintPadding ?? hintPaddingDefault,
      child: Text(
        hintText,
        style: hintStyle ??
            TextStyle(
              fontSize: 13,
              color: hintColor ?? Colors.grey.shade300,
            ),
      ),
    );
  }
}
