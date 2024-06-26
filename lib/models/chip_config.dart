import 'package:flutter/material.dart';
import '../enum/app_enums.dart';

/// Configuration for the chip.
/// [backgroundColor] is the background color of the chip. Defaults to [Colors.white].
/// [padding] is the padding of the chip.
/// [radius] is the radius of the chip. Defaults to [BorderRadius.circular(18)].
///
/// [labelStyle] is the style of the label.
/// [labelPadding] is the padding of the label.
///
/// [deleteIcon] is the icon that is used to delete the chip.
/// [deleteIconColor] is the color of the delete icon.
///
/// [separator] is the separator between the chips. Default is a sized box with width of 8.
/// [spacing] is the width of the separator. If separator is provided, this value is ignored.
///
/// [wrapType] is the type of the chip. Default is [WrapType.scroll]. [WrapType.wrap] will wrap the chips to next line if there is not enough space. [WrapType.scroll] will scroll the chips.
///  * [WrapType.scroll] is used to scroll the chips.
///  * [WrapType.wrap] is used to wrap the chips in a row.
///
///
///
///
/// An example of a [ChipConfig] is:
/// ```dart
/// const ChipConfig(
///   deleteIcon: Icon(Icons.delete, color: Colors.red),
///   wrapType: WrapType.scroll,
///   separator: const Divider(),
///   padding: const EdgeInsets.all(8),
///   labelStyle: TextStyle(fontSize: 16),
///   labelPadding: const EdgeInsets.symmetric(horizontal: 8),
///   radius: BorderRadius.circular(18),
///   backgroundColor: Colors.white,
///   )
/// ```

class ChipConfig {
  final Icon? deleteIcon;

  final Color deleteIconColor;
  final Color labelColor;
  final Color labelDisabledColor;
  final Color? backgroundColor;
  final Color? backgroundDisabledColor;

  final TextStyle? labelStyle;
  final EdgeInsets padding;
  final EdgeInsets labelPadding;

  final double radius;
  final double spacing;
  final double runSpacing;

  final Widget? separator;
  final BorderSide? borderSide;

  final WrapType wrapType;

  final bool autoScroll;

  const ChipConfig({
    this.deleteIcon,
    this.deleteIconColor = Colors.white,
    this.backgroundColor,
    this.backgroundDisabledColor,
    this.padding = const EdgeInsets.only(left: 12, top: 0, right: 4, bottom: 0),
    this.radius = 18,
    this.spacing = 8,
    this.runSpacing = 8,
    this.separator,
    this.labelColor = Colors.white,
    this.labelDisabledColor = Colors.white,
    this.labelStyle,
    this.wrapType = WrapType.scroll,
    this.labelPadding = EdgeInsets.zero,
    this.autoScroll = false,
    this.borderSide,
  });
}