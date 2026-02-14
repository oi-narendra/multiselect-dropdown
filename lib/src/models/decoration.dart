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
  ///
  /// [textStyle] is the text style of the search field input.
  ///
  /// [hintStyle] is the text style of the hint text.
  ///
  /// [fillColor] is the fill color of the search field.
  ///
  /// [filled] is whether the search field is filled with [fillColor].
  ///
  /// [cursorColor] is the cursor color of the search field.
  ///
  /// [showClearIcon] is whether to show a clear icon in the search field. The default value is true.
  ///
  /// [autofocus] is whether the search field should be focused when the dropdown is opened. The default value is false.
  ///
  /// [searchDebounceMs] is the debounce duration in milliseconds for search input. The default value is 0 (no debounce).
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
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.filled,
    this.cursorColor,
    this.showClearIcon = true,
    this.autofocus = false,
    this.searchDebounceMs = 0,
  });

  /// The hint text to display in the search field.
  final String hintText;

  /// The border of the search field.
  final InputBorder? border;

  /// The border of the search field when it is focused.
  final InputBorder? focusedBorder;

  /// The icon to display in the search field.
  final Icon searchIcon;

  /// The text style of the search field input.
  final TextStyle? textStyle;

  /// The text style of the hint text.
  final TextStyle? hintStyle;

  /// The fill color of the search field.
  final Color? fillColor;

  /// Whether the search field is filled with [fillColor].
  final bool? filled;

  /// The cursor color of the search field.
  final Color? cursorColor;

  /// Whether to show a clear icon in the search field when text is entered.
  final bool showClearIcon;

  /// Whether the search field should be automatically focused when the dropdown is opened.
  final bool autofocus;

  /// The debounce duration in milliseconds for search input.
  ///
  /// When set to a value greater than 0, search callbacks will
  /// only fire after the user stops typing for this duration.
  /// Defaults to 0 (no debounce).
  final int searchDebounceMs;
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
    this.textStyle,
    this.selectedTextStyle,
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
  final Widget? selectedIcon;

  /// The icon to display for the disabled dropdown item.
  final Widget? disabledIcon;

  /// The text style of the dropdown item label.
  final TextStyle? textStyle;

  /// The text style of the selected dropdown item label.
  final TextStyle? selectedTextStyle;
}

/// Represents the decoration for the dropdown.
class DropdownDecoration {
  /// Creates a new instance of [DropdownDecoration].
  ///
  /// [backgroundColor] is the background color of the dropdown.
  /// Defaults to null, which resolves to [ColorScheme.surfaceContainerHighest] from the theme.
  ///
  /// [elevation] is the elevation of the dropdown. The default value is 1.
  ///
  /// [maxHeight] is the height of the dropdown. The default value is 400.
  ///
  /// [marginTop] is the margin top of the dropdown. The default value is 0.
  ///
  /// [borderRadius] is the border radius of the dropdown. The default value is 12.
  ///
  /// [animationDuration] is the duration of the open/close animation. Defaults to 200ms.
  ///
  /// [animationCurve] is the curve of the open/close animation. Defaults to [Curves.easeOutCubic].

  const DropdownDecoration({
    this.backgroundColor,
    this.elevation = 1,
    this.maxHeight = 400,
    this.marginTop = 0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.footer,
    this.header,
    this.noItemsFoundText = 'No items found',
    this.expandDirection = ExpandDirection.auto,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOutCubic,
  });

  /// The background color of the dropdown.
  ///
  /// When null, resolves to [ColorScheme.surfaceContainerHighest] from the theme.
  final Color? backgroundColor;

  /// The elevation of the dropdown.
  final double elevation;

  /// The maximum height of the dropdown.
  final double maxHeight;

  /// The border radius of the dropdown.
  final BorderRadius borderRadius;

  /// the margin top of the dropdown
  final double marginTop;

  /// The custom footer widget to display at the bottom of the dropdown.
  final Widget? footer;

  /// The custom header widget to display at the top of the dropdown.
  final Widget? header;

  /// The text to display when no items are found in the dropdown.
  /// Defaults to 'No items found'.
  final String noItemsFoundText;

  /// The direction in which the dropdown expands.
  ///
  /// Defaults to [ExpandDirection.auto], which automatically determines
  /// the direction based on available screen space.
  final ExpandDirection expandDirection;

  /// The duration of the dropdown open/close animation.
  ///
  /// Defaults to 200 milliseconds. Set to [Duration.zero] to disable animation.
  final Duration animationDuration;

  /// The curve used for the dropdown open/close animation.
  ///
  /// Defaults to [Curves.easeOutCubic].
  final Curve animationCurve;
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
    this.selectedItemTextStyle,
    this.inputDecoration,
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

  /// Whether to animate the suffix icon rotation when the dropdown opens/closes.
  final bool animateSuffixIcon;

  /// The padding around the dropdown field content.
  final EdgeInsets? padding;

  /// The background fill color of the dropdown field.
  final Color? backgroundColor;

  /// Whether to show a clear/deselect icon when items are selected.
  final bool showClearIcon;

  /// The text style of the selected item in single-select mode.
  ///
  /// This style is applied to the selected item text displayed in the field
  /// when [MultiDropdown.singleSelect] is true. If not provided, the default
  /// text style is used.
  final TextStyle? selectedItemTextStyle;

  /// A custom [InputDecoration] for the dropdown field.
  ///
  /// When provided, this replaces the auto-built InputDecoration entirely,
  /// giving full control over the field's appearance. Only `suffixIcon` and
  /// `errorText` from the validator will still be managed internally.
  ///
  /// Useful for making the dropdown visually consistent with other
  /// `TextFormField` widgets in the same form.
  final InputDecoration? inputDecoration;
}

/// Configuration class for customizing the appearance of chips in the multi-select dropdown.
class ChipDecoration {
  /// Creates a new instance of [ChipDecoration].
  ///
  /// [deleteIcon] is the icon to display for deleting a chip.
  ///
  /// [backgroundColor] is the background color of the chip.
  /// Defaults to null, which resolves to [ColorScheme.surfaceContainerHighest] from the theme.
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
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.border = const Border(),
    this.spacing = 8,
    this.runSpacing = 12,
    this.labelStyle,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.wrap = true,
    this.maxDisplayCount,
  });

  /// The icon to display for deleting a chip.
  final Widget? deleteIcon;

  /// The background color of the chip.
  ///
  /// When null, resolves to [ColorScheme.surfaceContainerHighest] from the theme.
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

  /// The maximum number of chips to display.
  ///
  /// If the number of selected items exceeds this value, a "+N" label will be
  /// shown after the visible chips indicating the remaining count.
  /// If null, all chips are displayed.
  final int? maxDisplayCount;
}
