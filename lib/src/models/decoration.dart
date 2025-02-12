part of '../multi_dropdown.dart';

/// Represents the decoration for the search field in the dropdown.
class SearchFieldDecoration {
  /// Creates a new instance of [SearchFieldDecoration].
  ///
  /// [hintText] is the hint text to display in the search field. The default value is 'Search'.
  ///
  /// [border] is the border of the search field. The default value is OutlineInputBorder().
  ///
  /// [focusedBorder] is the border of the search field when it is focused. The default value is OutlineInputBorder().
  ///
  /// [searchIcon] is the icon to display in the search field. The default value is Icon(Icons.search).
  const SearchFieldDecoration({
    this.hintText = 'Search',
    this.border = const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.focusedBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.searchIcon = const Icon(Icons.search),
  });

  /// The hint text to display in the search field.
  final String hintText;

  /// The border of the search field.
  final InputBorder? border;

  /// The border of the search field when it is focused.
  final InputBorder? focusedBorder;

  /// The icon to display in the search field.
  final Icon searchIcon;
}

/// Represents the decoration for the dropdown items.
class DropdownItemDecoration {
  /// Creates a new instance of [DropdownItemDecoration].
  ///
  /// [backgroundColor] is the background color of the dropdown item. The default value is white.
  ///
  /// [disabledBackgroundColor] is the background color of the disabled dropdown item. The default value is grey.
  ///
  /// [selectedBackgroundColor] is the background color of the selected dropdown item. The default value is blue.
  ///
  /// [selectedTextColor] is the text color of the selected dropdown item. The default value is white.
  ///
  /// [textColor] is the text color of the dropdown item. The default value is black.
  ///
  /// [disabledTextColor] is the text color of the disabled dropdown item. The default value is black.
  ///
  /// [selectedIcon] is the icon to display for the selected dropdown item. The default value is Icon(Icons.check).
  ///
  /// [disabledIcon] is the icon to display for the disabled dropdown item.
  const DropdownItemDecoration({
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.selectedBackgroundColor,
    this.selectedTextColor,
    this.textColor,
    this.disabledTextColor,
    this.selectedIcon = const Icon(Icons.check),
    this.disabledIcon,
  });

  /// The background color of the dropdown item.
  final Color? backgroundColor;

  /// The background color of the disabled dropdown item.
  final Color? disabledBackgroundColor;

  /// The background color of the selected dropdown item.
  final Color? selectedBackgroundColor;

  /// The text color of the selected dropdown item.
  final Color? selectedTextColor;

  /// The text color of the dropdown item.
  final Color? textColor;

  /// The text color of the disabled dropdown item.
  final Color? disabledTextColor;

  /// The icon to display for the selected dropdown item.
  final Icon? selectedIcon;

  /// The icon to display for the disabled dropdown item.
  final Icon? disabledIcon;
}

/// Represents the decoration for the dropdown.
class DropdownDecoration {
  /// Creates a new instance of [DropdownDecoration].
  ///
  /// [backgroundColor] is the background color of the dropdown. The default value is white.
  ///
  /// [elevation] is the elevation of the dropdown. The default value is 1.
  ///
  /// [maxHeight] is the height of the dropdown. The default value is 300.
  ///
  /// [marginTop] is the margin top of the dropdown. The default value is 0.
  ///
  /// [borderRadius] is the border radius of the dropdown. The default value is 12.
  ///

  const DropdownDecoration({
    this.backgroundColor = Colors.white,
    this.elevation = 1,
    this.maxHeight = 400,
    this.marginTop = 0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.border,
    this.footer,
    this.header,
  });

  /// The background color of the dropdown.
  final Color backgroundColor;

  /// The elevation of the dropdown.
  final double elevation;

  /// The maximum height of the dropdown.
  final double maxHeight;

  /// The border radius of the dropdown.
  final BorderRadius borderRadius;

  /// The border of the dropdown
  final Border? border;

  /// the margin top of the dropdown
  final double marginTop;

  /// The custom footer widget to display at the bottom of the dropdown.
  final Widget? footer;

  /// The custom header widget to display at the top of the dropdown.
  final Widget? header;
}

/// Represents the decoration for the dropdown field.
class FieldDecoration {
  /// Creates a new instance of [FieldDecoration].
  ///
  /// [labelText] is the label text to display above the dropdown field.
  ///
  /// [hintText] is the hint text to display in the dropdown field. The default value is 'Select'.
  ///
  /// [border] is the border of the dropdown field.
  ///
  /// [focusedBorder] is the border of the dropdown field when it is focused.
  ///
  /// [disabledBorder] is the border of the dropdown field when it is disabled.
  ///
  /// [errorBorder] is the border of the dropdown field when there is an error.
  ///
  /// [suffixIcon] is the icon to display at the end of dropdown field. The default value is Icon(Icons.arrow_drop_down).
  ///
  /// [prefixIcon] is the icon to display at the start of dropdown field.
  ///
  /// [labelStyle] is the style of the label text.
  ///
  /// [hintStyle] is the style of the hint text.
  ///
  /// [borderRadius] is the border radius of the dropdown field. The default value is 12.
  ///
  /// [animateSuffixIcon] is whether to animate the suffix icon or not when dropdown is opened/closed. The default value is true.
  ///
  /// [suffixIcon] is the icon to display at the end of dropdown field.
  ///
  /// [prefixIcon] is the icon to display at the start of dropdown field.
  ///
  /// [padding] is the padding around the dropdown field.
  ///
  /// [backgroundColor] is the background color of the dropdown field.
  const FieldDecoration({
    this.labelText,
    this.hintText = 'Select',
    this.border,
    this.focusedBorder,
    this.disabledBorder,
    this.errorBorder,
    this.suffixIcon = const Icon(Icons.arrow_drop_down),
    this.prefixIcon,
    this.labelStyle,
    this.borderRadius = 12,
    this.hintStyle,
    this.animateSuffixIcon = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.backgroundColor,
    this.showClearIcon = true,
  });

  /// The label text to display above the dropdown field.
  final String? labelText;

  /// The hint text to display in the dropdown field.
  final String? hintText;

  /// The border of the dropdown field.
  final InputBorder? border;

  /// The border of the dropdown field when it is focused.
  final InputBorder? focusedBorder;

  /// The border of the dropdown field when it is disabled.
  final InputBorder? disabledBorder;

  /// The border of the dropdown field when there is an error.
  final InputBorder? errorBorder;

  /// The icon to display at the end of dropdown field.
  final Widget? suffixIcon;

  /// The icon to display at the start of dropdown field.
  final Widget? prefixIcon;

  /// The style of the label text.
  final TextStyle? labelStyle;

  /// The style of the hint text.
  final TextStyle? hintStyle;

  /// The border radius of the dropdown field.
  final double borderRadius;

  /// animate the icon or not
  final bool animateSuffixIcon;

  /// padding around the dropdown field
  final EdgeInsets? padding;

  /// background color of the dropdown field
  final Color? backgroundColor;

  /// show clear icon or not in the dropdown field
  final bool showClearIcon;
}

/// Configuration class for customizing the appearance of chips in the multi-select dropdown.
class ChipDecoration {
  /// Creates a new instance of [ChipDecoration].
  ///
  /// [deleteIcon] is the icon to display for deleting a chip.
  ///
  /// [backgroundColor] is the background color of the chip.
  ///
  /// [labelStyle] is the style of the chip label.
  ///
  /// [padding] is the padding around the chip.
  ///
  /// [border] is the border of the chip.
  ///
  /// [spacing] is the spacing between chips.
  ///
  /// [runSpacing] is the spacing between chip rows (when the chips wrap).
  ///
  /// [borderRadius] is the border radius of the chip.
  ///
  /// [wrap] is whether to wrap or not.
  const ChipDecoration({
    this.deleteIcon,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.border = const Border(),
    this.spacing = 8,
    this.runSpacing = 12,
    this.labelStyle,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.wrap = true,
  });

  /// The icon to display for deleting a chip.
  final Icon? deleteIcon;

  /// The background color of the chip.
  final Color? backgroundColor;

  /// The style of the chip label.
  final TextStyle? labelStyle;

  /// The padding around the chip.
  final EdgeInsets padding;

  /// The border of the chip.
  final BoxBorder border;

  /// The spacing between chips.
  final double spacing;

  /// The spacing between chip rows (when the chips wrap).
  final double runSpacing;

  /// The border radius of the chip.
  final BorderRadiusGeometry borderRadius;

  /// Whether to wrap or not
  ///
  /// If true, the chips will wrap to the next line when they reach the end of the row.
  /// If false, the chips will not wrap and will be displayed in a single line, scrolling horizontally if necessary.
  final bool wrap;
}
