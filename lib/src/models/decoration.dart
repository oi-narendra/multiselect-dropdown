part of '../multi_dropdown.dart';

/// Represents the decoration for the search field in the dropdown.
class SearchFieldDecoration {
  /// Creates a new instance of [SearchFieldDecoration].
  const SearchFieldDecoration({
    this.hintText = 'Search',
    this.border = const OutlineInputBorder(),
    this.focusedBorder = const OutlineInputBorder(),
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
  const DropdownDecoration({
    this.backgroundColor = Colors.white,
    this.elevation = 1,
    this.height = 300,
    this.marginTop = 0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  /// The background color of the dropdown.
  final Color backgroundColor;

  /// The elevation of the dropdown.
  final double elevation;

  /// The height of the dropdown.
  final double height;

  /// The border radius of the dropdown.
  final BorderRadius borderRadius;

  /// the margin top of the dropdown
  final double marginTop;
}

/// Represents the decoration for the dropdown field.
class FieldDecoration {
  /// Creates a new instance of [FieldDecoration].
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
  final Icon suffixIcon;

  /// The icon to display at the start of dropdown field.
  final Icon? prefixIcon;

  /// The style of the label text.
  final TextStyle? labelStyle;

  /// The style of the hint text.
  final TextStyle? hintStyle;

  /// The border radius of the dropdown field.
  final double borderRadius;

  /// animate the icon or not
  final bool animateSuffixIcon;
}

/// Configuration class for customizing the appearance of chips in the multi-select dropdown.
class ChipDecoration {
  /// Creates a new instance of [ChipDecoration].
  const ChipDecoration({
    this.deleteIcon,
    this.backgroundColor,
    this.padding,
    this.shape,
    this.spacing = 8,
    this.runSpacing = 8,
    this.separator,
    this.labelStyle,
    this.labelPadding = EdgeInsets.zero,
    this.borderSide,
    this.wrap = true,
  });

  /// The icon to display for deleting a chip.
  final Icon? deleteIcon;

  /// The background color of the chip.
  final Color? backgroundColor;

  /// The style of the chip label.
  final TextStyle? labelStyle;

  /// The padding around the chip.
  final EdgeInsets? padding;

  /// The padding for the label of the chip.
  final EdgeInsets labelPadding;

  /// The radius of the chip.
  final OutlinedBorder? shape;

  /// The spacing between chips.
  final double spacing;

  /// The spacing between chip rows (when the chips wrap).
  final double runSpacing;

  /// The widget to display between chips.
  final Widget? separator;

  /// The border side of the chip.
  final BorderSide? borderSide;

  /// Whether to wrap or not
  ///
  /// If true, the chips will wrap to the next line when they reach the end of the row.
  /// If false, the chips will not wrap and will be displayed in a single line, scrolling horizontally if necessary.
  final bool wrap;
}
