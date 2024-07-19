library multiselect_dropdown;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:multi_dropdown/models/network_config.dart';
import 'package:multi_dropdown/widgets/hint_text.dart';
import 'package:multi_dropdown/widgets/selection_chip.dart';
import 'package:multi_dropdown/widgets/single_selected_item.dart';

import 'enum/app_enums.dart';
import 'models/chip_config.dart';
import 'models/value_item.dart';

export 'enum/app_enums.dart';
export 'models/chip_config.dart';
export 'models/network_config.dart';
export 'models/value_item.dart';

typedef OnOptionSelected<T> = void Function(List<ValueItem<T>> selectedOptions);

class MultiSelectDropDown<T> extends StatefulWidget {
  // selection type of the dropdown
  final SelectionType selectionType;

  // Hint
  final String hint;
  final Color? hintColor;
  final double? hintFontSize;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? hintPadding;

  // Options
  final List<ValueItem<T>> options;
  final List<ValueItem<T>> selectedOptions;
  final List<ValueItem<T>> disabledOptions;
  final OnOptionSelected<T>? onOptionSelected;

  /// [onOptionRemoved] is the callback that is called when an option is removed.The callback takes two arguments, the index of the removed option and the removed option.
  /// This will be called only when the delete icon is clicked on the option chip.
  ///
  /// This will not be called when the option is removed programmatically.
  ///
  /// ```index``` is the index of the removed option.
  ///
  /// ```option``` is the removed option.
  final void Function(int index, ValueItem<T> option)? onOptionRemoved;

  // selected option
  final Icon? selectedOptionIcon;
  final Color? selectedOptionTextColor;
  final Color? selectedOptionBackgroundColor;
  final Widget Function(BuildContext, ValueItem<T>)? selectedItemBuilder;

  // chip configuration
  final bool showChipInSingleSelectMode;
  final ChipConfig chipConfig;

  // options configuration
  final Color? optionsBackgroundColor;
  final TextStyle? optionTextStyle;
  final double dropdownHeight;
  final Widget? optionSeparator;
  final bool alwaysShowOptionIcon;

  /// option builder
  /// [optionBuilder] is the builder that is used to build the option item.
  /// The builder takes three arguments, the context, the option and the selected status of the option.
  /// The builder returns a widget.
  ///

  final Widget Function(BuildContext ctx, ValueItem<T> item, bool selected)? optionBuilder;

  // dropdownfield configuration
  final Color? fieldBackgroundColor;
  final Widget? prefixIcon;
  final Icon suffixIcon;
  final bool animateSuffixIcon;
  final Icon? clearIcon;
  final Decoration? inputDecoration;
  final double? fieldBorderRadius;
  final BorderRadiusGeometry? radiusGeometry;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? borderWidth;
  final double? focusedBorderWidth;
  final EdgeInsets? padding;

  final TextStyle? singleSelectItemStyle;

  final int? maxItems;

  final Color? dropdownBackgroundColor;
  final Color? searchBackgroundColor;

  // dropdown border radius
  final double? dropdownBorderRadius;
  final double? dropdownMargin;

  // network configuration
  final NetworkConfig? networkConfig;
  final Future<List<ValueItem<T>>> Function(dynamic)? responseParser;
  final Widget Function(BuildContext, dynamic)? responseErrorBuilder;

  /// focus node
  final FocusNode? focusNode;

  /// Controller for the dropdown
  /// [controller] is the controller for the dropdown. It can be used to programmatically open and close the dropdown.
  final MultiSelectController<T>? controller;

  /// Enable search
  /// [searchEnabled] is the flag to enable search in dropdown. It is used to show search bar in dropdown.
  final bool searchEnabled;

  /// Search label
  /// [searchLabel] is the label for search bar in dropdown.
  final String? searchLabel;

  /// MultiSelectDropDown is a widget that allows the user to select multiple options from a list of options. It is a dropdown that allows the user to select multiple options.
  ///
  ///  **Selection Type**
  ///
  ///   [selectionType] is the type of selection that the user can make. The default is [SelectionType.single].
  /// * [SelectionType.single] - allows the user to select only one option.
  /// * [SelectionType.multi] - allows the user to select multiple options.
  ///
  ///  **Options**
  ///
  /// [options] is the list of options that the user can select from. The options need to be of type [ValueItem].
  ///
  /// [selectedOptions] is the list of options that are pre-selected when the widget is first displayed. The options need to be of type [ValueItem].
  ///
  /// [disabledOptions] is the list of options that the user cannot select. The options need to be of type [ValueItem]. If the items in this list are not available in options, will be ignored.
  ///
  /// [onOptionSelected] is the callback that is called when an option is selected or unselected. The callback takes one argument of type `List<ValueItem>`.
  ///
  /// **Selected Option**
  ///
  /// [selectedOptionIcon] is the icon that is used to indicate the selected option.
  ///
  /// [selectedOptionTextColor] is the color of the selected option.
  ///
  /// [selectedOptionBackgroundColor] is the background color of the selected option.
  ///
  /// [selectedItemBuilder] is the builder that is used to build the selected option. If this is not provided, the default builder is used.
  ///
  /// **Chip Configuration**
  ///
  /// [showChipInSingleSelectMode] is used to show the chip in single select mode. The default is false.
  ///
  /// [chipConfig] is the configuration for the chip.
  ///
  /// **Options Configuration**
  ///
  /// [optionsBackgroundColor] is the background color of the options. The default is [Colors.white].
  ///
  /// [optionTextStyle] is the text style of the options.
  ///
  /// [optionSeparator] is the seperator between the options.
  ///
  /// [dropdownHeight] is the height of the dropdown options. The default is 200.
  ///
  ///  **Dropdown Configuration**
  ///
  /// [fieldBackgroundColor] is the background color of the dropdown. The default is [Colors.white].
  ///
  /// [prefixIcon] is the icon used on the left of the dropdown.
  ///
  /// [suffixIcon] is the icon that is used to indicate the dropdown. The default is [Icons.arrow_drop_down].
  ///
  /// [inputDecoration] is the decoration of the dropdown.
  ///
  /// [dropdownHeight] is the height of the dropdown. The default is 200.
  ///
  ///  **Hint**
  ///
  /// [hint] is the hint text to be displayed when no option is selected.
  ///
  /// [hintColor] is the color of the hint text. The default is [Colors.grey.shade300].
  ///
  /// [hintFontSize] is the font size of the hint text. The default is 14.0.
  ///
  /// [hintStyle] is the style of the hint text.
  ///
  /// [animateSuffixIcon] is the flag to enable animation for the suffix icon. The default is true.
  ///
  ///  **Example**
  ///
  /// ```dart
  ///  final List<ValueItem> options = [
  ///     ValueItem(label: 'Option 1', value: '1'),
  ///     ValueItem(label: 'Option 2', value: '2'),
  ///     ValueItem(label: 'Option 3', value: '3'),
  ///   ];
  ///
  ///   final List<ValueItem> selectedOptions = [
  ///     ValueItem(label: 'Option 1', value: '1'),
  ///   ];
  ///
  ///   final List<ValueItem> disabledOptions = [
  ///     ValueItem(label: 'Option 2', value: '2'),
  ///   ];
  ///
  ///  MultiSelectDropDown(
  ///    onOptionSelected: (option) {},
  ///    options: const <ValueItem>[
  ///       ValueItem(label: 'Option 1', value: '1'),
  ///       ValueItem(label: 'Option 2', value: '2'),
  ///       ValueItem(label: 'Option 3', value: '3'),
  ///       ValueItem(label: 'Option 4', value: '4'),
  ///       ValueItem(label: 'Option 5', value: '5'),
  ///       ValueItem(label: 'Option 6', value: '6'),
  ///    ],
  ///    selectionType: SelectionType.multi,
  ///    selectedOptions: selectedOptions,
  ///    disabledOptions: disabledOptions,
  ///    onOptionSelected: (List<ValueItem> selectedOptions) {
  ///      debugPrint('onOptionSelected: $option');
  ///    },
  ///    chipConfig: const ChipConfig(wrapType: WrapType.scroll),
  ///    );
  /// ```

  const MultiSelectDropDown(
      {Key? key,
      required this.onOptionSelected,
      required this.options,
      this.onOptionRemoved,
      this.selectedOptionTextColor,
      this.chipConfig = const ChipConfig(),
      this.selectionType = SelectionType.multi,
      this.hint = 'Select',
      this.hintColor = Colors.grey,
      this.hintFontSize = 14.0,
      this.hintPadding = HintText.hintPaddingDefault,
      this.selectedOptions = const [],
      this.disabledOptions = const [],
      this.alwaysShowOptionIcon = false,
      this.optionTextStyle,
      this.selectedOptionIcon = const Icon(Icons.check),
      this.selectedOptionBackgroundColor,
      this.optionsBackgroundColor,
      this.fieldBackgroundColor = Colors.white,
      this.dropdownHeight = 200,
      this.showChipInSingleSelectMode = false,
      this.prefixIcon,
      this.suffixIcon = const Icon(Icons.arrow_drop_down),
      this.clearIcon = const Icon(Icons.close_outlined, size: 20),
      this.selectedItemBuilder,
      this.optionSeparator,
      this.inputDecoration,
      this.hintStyle,
      this.padding,
      this.focusedBorderColor = Colors.black54,
      this.borderColor = Colors.grey,
      this.borderWidth = 0.4,
      this.focusedBorderWidth = 0.4,
      this.fieldBorderRadius = 12.0,
      this.radiusGeometry,
      this.maxItems,
      this.focusNode,
      this.controller,
      this.searchEnabled = false,
      this.dropdownBorderRadius,
      this.dropdownMargin,
      this.dropdownBackgroundColor,
      this.searchBackgroundColor,
      this.animateSuffixIcon = true,
      this.singleSelectItemStyle,
      this.optionBuilder,
      this.searchLabel = 'Search'})
      : networkConfig = null,
        responseParser = null,
        responseErrorBuilder = null,
        super(key: key);

  /// Constructor for MultiSelectDropDown that fetches the options from a network call.
  /// [networkConfig] is the configuration for the network call.
  /// [responseParser] is the parser that is used to parse the response from the network call.
  /// [responseErrorBuilder] is the builder that is used to build the error widget when the network call fails.

  const MultiSelectDropDown.network(
      {Key? key,
      required this.onOptionSelected,
      required this.networkConfig,
      required this.responseParser,
      this.onOptionRemoved,
      this.responseErrorBuilder,
      this.selectedOptionTextColor,
      this.chipConfig = const ChipConfig(),
      this.selectionType = SelectionType.multi,
      this.hint = 'Select',
      this.hintColor = Colors.grey,
      this.hintFontSize = 14.0,
      this.selectedOptions = const [],
      this.disabledOptions = const [],
      this.alwaysShowOptionIcon = false,
      this.optionTextStyle,
      this.selectedOptionIcon = const Icon(Icons.check),
      this.selectedOptionBackgroundColor,
      this.optionsBackgroundColor,
      this.fieldBackgroundColor = Colors.white,
      this.dropdownHeight = 200,
      this.showChipInSingleSelectMode = false,
      this.prefixIcon,
      this.suffixIcon = const Icon(Icons.arrow_drop_down),
      this.clearIcon = const Icon(Icons.close_outlined, size: 14),
      this.selectedItemBuilder,
      this.optionSeparator,
      this.inputDecoration,
      this.hintStyle,
      this.hintPadding = HintText.hintPaddingDefault,
      this.padding,
      this.borderColor = Colors.grey,
      this.focusedBorderColor = Colors.black54,
      this.borderWidth = 0.4,
      this.focusedBorderWidth = 0.4,
      this.fieldBorderRadius = 12.0,
      this.radiusGeometry,
      this.maxItems,
      this.focusNode,
      this.controller,
      this.searchEnabled = false,
      this.dropdownBorderRadius,
      this.dropdownMargin,
      this.dropdownBackgroundColor,
      this.searchBackgroundColor,
      this.animateSuffixIcon = true,
      this.singleSelectItemStyle,
      this.optionBuilder,
      this.searchLabel = 'Search'})
      : options = const [],
        super(key: key);

  @override
  State<MultiSelectDropDown<T>> createState() => _MultiSelectDropDownState<T>();
}

class _MultiSelectDropDownState<T> extends State<MultiSelectDropDown<T>> {
  /// Options list that is used to display the options.
  final List<ValueItem<T>> _options = [];

  /// Selected options list that is used to display the selected options.
  final List<ValueItem<T>> _selectedOptions = [];

  /// Disabled options list that is used to display the disabled options.
  final List<ValueItem<T>> _disabledOptions = [];

  /// The controller for the dropdown.
  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;
  bool _selectionMode = false;

  late final FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();

  /// Response from the network call.
  dynamic _reponseBody;

  /// value notifier that is used for controller.
  late MultiSelectController<T> _controller;

  /// search field focus node
  FocusNode? _searchFocusNode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? MultiSelectController<T>();
  }

  /// Initializes the options, selected options and disabled options.
  /// If the options are fetched from the network, then the network call is made.
  /// If the options are passed as a parameter, then the options are initialized.
  void _initialize() async {
    if (!mounted) return;
    if (widget.networkConfig?.url != null) {
      await _fetchNetwork();
    } else {
      _options.addAll(_controller.options.isNotEmpty == true ? _controller.options : widget.options);
    }
    _addOptions();
    if (mounted) {
      _initializeOverlay();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _initializeOverlay();
      });
    }
  }

  void _initializeOverlay() {
    _overlayState ??= Overlay.of(context);

    _focusNode.addListener(_handleFocusChange);

    if (widget.searchEnabled) {
      _searchFocusNode = FocusNode();
      _searchFocusNode!.addListener(_handleFocusChange);
    }
  }

  /// Adds the selected options and disabled options to the options list.
  void _addOptions() {
    setState(() {
      _selectedOptions.addAll(_controller.selectedOptions.isNotEmpty == true ? _controller.selectedOptions : widget.selectedOptions);
      _disabledOptions.addAll(_controller.disabledOptions.isNotEmpty == true ? _controller.disabledOptions : widget.disabledOptions);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller._isDisposed == false) {
        _controller.setOptions(_options);
        _controller.setSelectedOptions(_selectedOptions);
        _controller.setDisabledOptions(_disabledOptions);

        _controller.addListener(_handleControllerChange);
      }
    });
  }

  /// Handles the focus change to show/hide the dropdown.
  void _handleFocusChange() {
    if (_focusNode.hasFocus && mounted) {
      _overlayEntry = _reponseBody != null && widget.networkConfig != null ? _buildNetworkErrorOverlayEntry() : _buildOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      _updateSelection();
      return;
    }

    if ((_searchFocusNode == null || _searchFocusNode?.hasFocus == false) && _overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

    if (mounted) _updateSelection();

    _controller.value._isDropdownOpen = _focusNode.hasFocus || _searchFocusNode?.hasFocus == true;
  }

  void _updateSelection() {
    setState(() {
      _selectionMode = _focusNode.hasFocus || _searchFocusNode?.hasFocus == true;
    });
  }

  /// Calculate offset size for dropdown.
  List _calculateOffsetSize() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    var size = renderBox?.size ?? Size.zero;
    var offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    final availableHeight = MediaQuery.of(context).size.height - (offset.dy + size.height + (widget.searchEnabled ? 60 : 0));

    return [size, availableHeight < widget.dropdownHeight];
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Focus(
          canRequestFocus: true,
          skipTraversal: true,
          focusNode: _focusNode,
          child: InkWell(
            splashColor: null,
            splashFactory: null,
            onTap: _toggleFocus,
            child: Container(
              height: widget.chipConfig.wrapType == WrapType.wrap
                  ? null
                  : widget.selectionType == SelectionType.single
                      ? 52
                      : 57,
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: 52,
              ),
              padding: _getContainerPadding(),
              decoration: _getContainerDecoration(),
              child: Row(
                children: [
                  if (widget.prefixIcon != null) ...[
                    const SizedBox(width: 10),
                    widget.prefixIcon ?? const SizedBox(height: 0),
                    const SizedBox(width: 10),
                  ],
                  Expanded(child: _getContainerContent()),
                  if (widget.clearIcon != null && _anyItemSelected) ...[
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => clear(),
                      child: widget.clearIcon,
                    ),
                    const SizedBox(width: 4)
                  ],
                  _buildSuffixIcon(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuffixIcon() {
    if (widget.animateSuffixIcon) {
      return AnimatedRotation(
        turns: _selectionMode ? 0.5 : 0,
        duration: const Duration(milliseconds: 300),
        child: widget.suffixIcon,
      );
    }
    return widget.suffixIcon;
  }

  /// Container Content for the dropdown.
  Widget _getContainerContent() {
    if (_selectedOptions.isEmpty) {
      return Text(
        widget.hint,
        style: widget.hintStyle,
      );
    }

    if (widget.selectionType == SelectionType.single && !widget.showChipInSingleSelectMode) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              widget.hint,
              style: TextStyle(color: widget.hintColor, fontSize: 13),
            )),
        Flexible(
            child: Text(
          _selectedOptions.first.label,
          style: widget.singleSelectItemStyle,
          overflow: TextOverflow.ellipsis,
        ))
      ]);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            widget.hint,
            style: TextStyle(color: widget.hintColor, fontSize: 13),
          )),
      SizedBox(height: 30, child: _buildSelectedItems())
    ]);
  }

  /// return true if any item is selected.
  bool get _anyItemSelected => _selectedOptions.isNotEmpty;

  /// Container decoration for the dropdown.
  Decoration _getContainerDecoration() {
    return widget.inputDecoration ??
        BoxDecoration(
          color: widget.fieldBackgroundColor ?? Colors.white,
          borderRadius: widget.radiusGeometry ?? BorderRadius.circular(widget.fieldBorderRadius ?? 12.0),
          border: _selectionMode
              ? Border.all(
                  color: widget.focusedBorderColor ?? Colors.grey,
                  width: widget.focusedBorderWidth ?? 0.4,
                )
              : Border.all(
                  color: widget.borderColor ?? Colors.grey,
                  width: widget.borderWidth ?? 0.4,
                ),
        );
  }

  /// Dispose the focus node and overlay entry.
  @override
  void dispose() {
    if (_overlayEntry?.mounted == true) {
      if (_overlayState != null && _overlayEntry != null) {
        _overlayEntry?.remove();
      }
      _overlayEntry = null;
      _overlayState?.dispose();
    }
    _focusNode.removeListener(_handleFocusChange);
    _searchFocusNode?.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _searchFocusNode?.dispose();
    _controller.removeListener(_handleControllerChange);

    if (widget.controller == null || widget.controller?.isDisposed == true) {
      _controller.dispose();
    }

    super.dispose();
  }

  /// Build the selected items for the dropdown.
  Widget _buildSelectedItems() {
    if (widget.chipConfig.wrapType == WrapType.scroll) {
      return ListView.separated(
        separatorBuilder: (context, index) => _getChipSeparator(widget.chipConfig),
        scrollDirection: Axis.horizontal,
        itemCount: _selectedOptions.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final option = _selectedOptions[index];
          if (widget.selectedItemBuilder != null) {
            return widget.selectedItemBuilder!(context, option);
          }
          return _buildChip(
            option,
            widget.chipConfig,
            !_disabledOptions.contains(_selectedOptions[index]),
          );
        },
      );
    }
    return Wrap(
        spacing: widget.chipConfig.spacing,
        runSpacing: widget.chipConfig.runSpacing,
        children: mapIndexed(_selectedOptions, (index, item) {
          if (widget.selectedItemBuilder != null) {
            return widget.selectedItemBuilder!(context, _selectedOptions[index]);
          }
          return _buildChip(
            _selectedOptions[index],
            widget.chipConfig,
            !_disabledOptions.contains(_selectedOptions[index]),
          );
        }).toList());
  }

  /// Util method to map with index.
  Iterable<E> mapIndexed<E, F>(Iterable<F> items, E Function(int index, F item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }

  /// Get the chip separator.
  Widget _getChipSeparator(ChipConfig chipConfig) {
    if (chipConfig.separator != null) {
      return chipConfig.separator!;
    }

    return SizedBox(
      width: chipConfig.spacing,
    );
  }

  /// Handle the focus change on tap outside of the dropdown.
  void _onOutSideTap() {
    if (_searchFocusNode != null) {
      _searchFocusNode!.unfocus();
    }
    _focusNode.unfocus();
  }

  /// Buid the selected item chip.
  Widget _buildChip(ValueItem<T> item, ChipConfig chipConfig, isEnabled) {
    return SelectionChip<T>(
      item: item,
      chipConfig: chipConfig,
      onItemDelete: isEnabled
          ? (removedItem) {
              widget.onOptionRemoved?.call(_options.indexOf(removedItem), _selectedOptions[_selectedOptions.indexOf(removedItem)]);

              _controller.clearSelection(removedItem);
              if (_focusNode.hasFocus) _focusNode.unfocus();
            }
          : null,
    );
  }

  /// Method to toggle the focus of the dropdown.
  void _toggleFocus() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  /// Get the selectedItem icon for the dropdown
  Widget? _getSelectedIcon(bool isSelected, Color primaryColor) {
    if (isSelected) {
      return widget.selectedOptionIcon ??
          Icon(
            Icons.check,
            color: primaryColor,
          );
    }
    if (!widget.alwaysShowOptionIcon) {
      return null;
    }

    final Icon icon = widget.selectedOptionIcon ??
        Icon(
          Icons.check,
          color: widget.optionTextStyle?.color ?? Colors.grey,
        );

    return icon;
  }

  /// Create the overlay entry for the dropdown.
  OverlayEntry _buildOverlayEntry() {
    // Calculate the offset and the size of the dropdown button
    final values = _calculateOffsetSize();
    // Get the size from the first item in the values list
    final size = values[0] as Size;
    // Get the showOnTop value from the second item in the values list
    final showOnTop = values[1] as bool;

    return OverlayEntry(builder: (context) {
      List<ValueItem<T>> options = _options;
      List<ValueItem<T>> selectedOptions = [..._selectedOptions];
      final searchController = TextEditingController();

      return StatefulBuilder(builder: ((context, dropdownState) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _onOutSideTap,
                child: const ColoredBox(
                  color: Colors.transparent,
                ),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: true,
              targetAnchor: showOnTop ? Alignment.topLeft : Alignment.bottomLeft,
              followerAnchor: showOnTop ? Alignment.bottomLeft : Alignment.topLeft,
              offset: widget.dropdownMargin != null ? Offset(0, showOnTop ? -widget.dropdownMargin! : widget.dropdownMargin!) : Offset.zero,
              child: Material(
                  color: widget.dropdownBackgroundColor ?? Colors.white,
                  elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(widget.dropdownBorderRadius ?? 0),
                    ),
                  ),
                  shadowColor: Colors.black,
                  child: Container(
                    decoration: BoxDecoration(
                      backgroundBlendMode: BlendMode.dstATop,
                      color: widget.dropdownBackgroundColor ?? Colors.white,
                      borderRadius: widget.dropdownBorderRadius != null ? BorderRadius.circular(widget.dropdownBorderRadius!) : null,
                    ),
                    constraints: widget.searchEnabled
                        ? BoxConstraints.loose(Size(size.width, widget.dropdownHeight + 60))
                        : BoxConstraints.loose(Size(size.width, widget.dropdownHeight)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.searchEnabled) ...[
                          ColoredBox(
                            color: widget.dropdownBackgroundColor ?? Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: widget.hintStyle,
                                controller: searchController,
                                onTapOutside: (_) {},
                                scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                focusNode: _searchFocusNode,
                                decoration: InputDecoration(
                                  fillColor: widget.searchBackgroundColor ?? Colors.grey.shade200,
                                  isDense: true,
                                  filled: true,
                                  hintText: widget.searchLabel,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(widget.fieldBorderRadius ?? 12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 0.8,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(widget.fieldBorderRadius ?? 12),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 0.8,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      searchController.clear();
                                      dropdownState(() {
                                        options = _options;
                                      });
                                    },
                                  ),
                                ),
                                onChanged: (value) {
                                  dropdownState(() {
                                    options =
                                        _options.where((element) => element.label.toLowerCase().contains(value.toLowerCase())).toList();
                                  });
                                },
                              ),
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                        ],
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder: (_, __) => widget.optionSeparator ?? const SizedBox(height: 0),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final option = options[index];
                              final isSelected = selectedOptions.contains(option);

                              onTap() {
                                if (widget.selectionType == SelectionType.multi) {
                                  if (isSelected) {
                                    dropdownState(() {
                                      selectedOptions.remove(option);
                                    });
                                    setState(() {
                                      _selectedOptions.remove(option);
                                    });
                                    widget.onOptionRemoved?.call(index, option);
                                    _controller.clearSelection(option);
                                  } else {
                                    final bool hasReachMax =
                                        widget.maxItems == null ? false : (_selectedOptions.length + 1) > widget.maxItems!;
                                    if (hasReachMax) return;

                                    dropdownState(() {
                                      selectedOptions.add(option);
                                    });
                                    setState(() {
                                      _selectedOptions.add(option);
                                    });
                                  }
                                } else {
                                  dropdownState(() {
                                    selectedOptions.clear();
                                    selectedOptions.add(option);
                                  });
                                  setState(() {
                                    _selectedOptions.clear();
                                    _selectedOptions.add(option);
                                  });
                                  _focusNode.unfocus();
                                }

                                _controller.value._selectedOptions.clear();
                                _controller.value._selectedOptions.addAll(_selectedOptions);

                                widget.onOptionSelected?.call(_selectedOptions);
                              }

                              if (widget.optionBuilder != null) {
                                return InkWell(
                                  onTap: onTap,
                                  child: widget.optionBuilder!(context, option, isSelected),
                                );
                              }

                              final primaryColor = Theme.of(context).primaryColor;

                              return _buildOption(
                                option: option,
                                primaryColor: primaryColor,
                                isSelected: isSelected,
                                dropdownState: dropdownState,
                                onTap: onTap,
                                selectedOptions: selectedOptions,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        );
      }));
    });
  }

  ListTile _buildOption(
          {required ValueItem<T> option,
          required Color primaryColor,
          required bool isSelected,
          required StateSetter dropdownState,
          required void Function() onTap,
          required List<ValueItem<T>> selectedOptions}) =>
      ListTile(
          title: Text(option.label,
              style: widget.optionTextStyle ??
                  TextStyle(
                    fontSize: widget.hintFontSize,
                  )),
          selectedColor: widget.selectedOptionTextColor ?? primaryColor,
          selected: isSelected,
          autofocus: true,
          dense: true,
          tileColor: widget.optionsBackgroundColor ?? Colors.white,
          selectedTileColor: widget.selectedOptionBackgroundColor ?? Colors.grey.shade200,
          enabled: !_disabledOptions.contains(option),
          onTap: onTap,
          trailing: _getSelectedIcon(isSelected, primaryColor));

  /// Make a request to the provided url.
  /// The response then is parsed to a list of ValueItem objects.
  Future<void> _fetchNetwork() async {
    final result = await _performNetworkRequest();
    if (result.statusCode == 200) {
      final data = json.decode(result.body);
      final List<ValueItem<T>> parsedOptions = await widget.responseParser!(data);
      _reponseBody = null;
      _options.addAll(parsedOptions);
    } else {
      _reponseBody = result.body;
    }
  }

  /// Perform the network request according to the provided configuration.
  Future<Response> _performNetworkRequest() async {
    switch (widget.networkConfig!.method) {
      case RequestMethod.get:
        return await http.get(
          Uri.parse(widget.networkConfig!.url),
          headers: widget.networkConfig!.headers,
        );
      case RequestMethod.post:
        return await http.post(
          Uri.parse(widget.networkConfig!.url),
          body: widget.networkConfig!.body,
          headers: widget.networkConfig!.headers,
        );
      case RequestMethod.put:
        return await http.put(
          Uri.parse(widget.networkConfig!.url),
          body: widget.networkConfig!.body,
          headers: widget.networkConfig!.headers,
        );
      case RequestMethod.patch:
        return await http.patch(
          Uri.parse(widget.networkConfig!.url),
          body: widget.networkConfig!.body,
          headers: widget.networkConfig!.headers,
        );
      case RequestMethod.delete:
        return await http.delete(
          Uri.parse(widget.networkConfig!.url),
          headers: widget.networkConfig!.headers,
        );
      default:
        return await http.get(
          Uri.parse(widget.networkConfig!.url),
          headers: widget.networkConfig!.headers,
        );
    }
  }

  /// Builds overlay entry for showing error when fetching data from network fails.
  OverlayEntry _buildNetworkErrorOverlayEntry() {
    final values = _calculateOffsetSize();
    final size = values[0] as Size;
    final showOnTop = values[1] as bool;

    // final offsetY = showOnTop ? -(size.height + 5) : size.height + 5;

    return OverlayEntry(builder: (context) {
      return StatefulBuilder(builder: ((context, dropdownState) {
        return Stack(
          children: [
            Positioned.fill(
                child: GestureDetector(
              onTap: _onOutSideTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.transparent,
              ),
            )),
            CompositedTransformFollower(
                link: _layerLink,
                targetAnchor: showOnTop ? Alignment.topLeft : Alignment.bottomLeft,
                followerAnchor: showOnTop ? Alignment.bottomLeft : Alignment.topLeft,
                offset:
                    widget.dropdownMargin != null ? Offset(0, showOnTop ? -widget.dropdownMargin! : widget.dropdownMargin!) : Offset.zero,
                child: Material(
                    borderRadius: widget.dropdownBorderRadius != null ? BorderRadius.circular(widget.dropdownBorderRadius!) : null,
                    elevation: 4,
                    child: Container(
                        width: size.width,
                        constraints: BoxConstraints.loose(Size(size.width, widget.dropdownHeight)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widget.responseErrorBuilder != null
                                ? widget.responseErrorBuilder!(context, _reponseBody)
                                : Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text('Error fetching data: $_reponseBody'),
                                  ),
                          ],
                        ))))
          ],
        );
      }));
    });
  }

  /// Clear the selected options.
  /// [MultiSelectController] is used to clear the selected options.
  void clear() {
    if (!_controller._isDisposed) {
      _controller.clearAllSelection();
    } else {
      setState(() {
        _selectedOptions.clear();
      });
      widget.onOptionSelected?.call(_selectedOptions);
    }
    if (_focusNode.hasFocus) _focusNode.unfocus();
  }

  /// handle the controller change.
  void _handleControllerChange() {
    // if the controller is null, return.
    if (_controller.isDisposed == true) return;

    // if current disabled options are not equal to the controller's disabled options, update the state.
    if (_disabledOptions != _controller.value._disabledOptions) {
      setState(() {
        _disabledOptions.clear();
        _disabledOptions.addAll(_controller.value._disabledOptions);
      });
    }

    // if current options are not equal to the controller's options, update the state.
    if (_options != _controller.value._options) {
      setState(() {
        _options.clear();
        _options.addAll(_controller.value._options);
      });
    }

    // if current selected options are not equal to the controller's selected options, update the state.
    if (_selectedOptions != _controller.value._selectedOptions) {
      setState(() {
        _selectedOptions.clear();
        _selectedOptions.addAll(_controller.value._selectedOptions);
      });
      widget.onOptionSelected?.call(_selectedOptions);
    }

    if (_selectionMode != _controller.value._isDropdownOpen) {
      if (_controller.value._isDropdownOpen) {
        _focusNode.requestFocus();
      } else {
        _focusNode.unfocus();
      }
    }
  }

  // get the container padding.
  EdgeInsetsGeometry _getContainerPadding() {
    if (widget.padding != null) {
      return widget.padding!;
    }
    return widget.selectionType == SelectionType.single
        ? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)
        : const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0);
  }
}

/// MultiSelect Controller class.
/// This class is used to control the state of the MultiSelectDropdown widget.
/// This is just base class. The implementation of this class is in the MultiSelectController class.
/// The implementation of this class is hidden from the user.
class _MultiSelectController<T> {
  final List<ValueItem<T>> _disabledOptions = [];
  final List<ValueItem<T>> _options = [];
  final List<ValueItem<T>> _selectedOptions = [];
  bool _isDropdownOpen = false;
}

/// implementation of the MultiSelectController class.
class MultiSelectController<T> extends ValueNotifier<_MultiSelectController<T>> {
  MultiSelectController() : super(_MultiSelectController());

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  /// set the dispose method.
  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }

  /// Clear the selected options.
  /// [MultiSelectController] is used to clear the selected options.
  void clearAllSelection() {
    value._selectedOptions.clear();
    notifyListeners();
  }

  /// clear specific selected option
  /// [MultiSelectController] is used to clear specific selected option.
  void clearSelection(ValueItem<T> option) {
    if (!value._selectedOptions.contains(option)) return;

    if (value._disabledOptions.contains(option)) {
      throw Exception('Cannot clear selection of a disabled option');
    }

    if (!value._options.contains(option)) {
      throw Exception('Cannot clear selection of an option that is not in the options list');
    }

    value._selectedOptions.remove(option);
    notifyListeners();
  }

  /// select the options
  /// [MultiSelectController] is used to select the options.
  void setSelectedOptions(List<ValueItem<T>> options) {
    if (options.any((element) => value._disabledOptions.contains(element))) {
      throw Exception('Cannot select disabled options');
    }

    if (options.any((element) => !value._options.contains(element))) {
      throw Exception('Cannot select options that are not in the options list');
    }

    value._selectedOptions.clear();
    value._selectedOptions.addAll(options);
    notifyListeners();
  }

  /// add selected option
  /// [MultiSelectController] is used to add selected option.
  void addSelectedOption(ValueItem<T> option) {
    if (value._disabledOptions.contains(option)) {
      throw Exception('Cannot select disabled option');
    }

    if (!value._options.contains(option)) {
      throw Exception('Cannot select option that is not in the options list');
    }

    value._selectedOptions.add(option);
    notifyListeners();
  }

  /// set disabled options
  /// [MultiSelectController] is used to set disabled options.
  void setDisabledOptions(List<ValueItem<T>> disabledOptions) {
    if (disabledOptions.any((element) => !value._options.contains(element))) {
      throw Exception('Cannot disable options that are not in the options list');
    }

    value._disabledOptions.clear();
    value._disabledOptions.addAll(disabledOptions);
    notifyListeners();
  }

  /// setDisabledOption method
  /// [MultiSelectController] is used to set disabled option.
  void setDisabledOption(ValueItem<T> disabledOption) {
    if (!value._options.contains(disabledOption)) {
      throw Exception('Cannot disable option that is not in the options list');
    }

    value._disabledOptions.add(disabledOption);
    notifyListeners();
  }

  /// set options
  /// [MultiSelectController] is used to set options.
  void setOptions(List<ValueItem<T>> options) {
    value._options.clear();
    value._options.addAll(options);
    notifyListeners();
  }

  /// get disabled options
  List<ValueItem<T>> get disabledOptions => value._disabledOptions;

  /// get enabled options
  List<ValueItem<T>> get enabledOptions => value._options.where((element) => !value._disabledOptions.contains(element)).toList();

  /// get options
  List<ValueItem<T>> get options => value._options;

  /// get selected options
  List<ValueItem<T>> get selectedOptions => value._selectedOptions;

  /// get is dropdown open
  bool get isDropdownOpen => value._isDropdownOpen;

  /// show dropdown
  /// [MultiSelectController] is used to show dropdown.
  void showDropdown() {
    if (value._isDropdownOpen) return;
    value._isDropdownOpen = true;
    notifyListeners();
  }

  /// hide dropdown
  /// [MultiSelectController] is used to hide dropdown.
  void hideDropdown() {
    if (!value._isDropdownOpen) return;
    value._isDropdownOpen = false;
    notifyListeners();
  }
}
