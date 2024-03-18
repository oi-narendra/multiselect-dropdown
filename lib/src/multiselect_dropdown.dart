import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../multiselect_dropdown.dart';

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
  final OnOptionSelected<T>? onChanged;

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

  final Widget Function(BuildContext ctx, ValueItem<T> item, bool selected)?
      optionBuilder;

  // dropdownfield configuration
  final Color? fieldBackgroundColor;
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

  final Widget Function(BuildContext context, Object error)?
      responseErrorBuilder;

  //Async configuration
  final Future<List<ValueItem<T>>> Function(String search)? asyncOptions;

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
      this.onOptionSelected,
      this.options = const [],
      this.onOptionRemoved,
      this.onChanged,
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
      : responseErrorBuilder = null,
        asyncOptions = null,
        super(key: key);

  const MultiSelectDropDown.async(
      {Key? key,
      required this.onOptionSelected,
      required this.asyncOptions,
      this.onOptionRemoved,
      this.onChanged,
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
  /// Search controller
  final searchController = TextEditingController();

  /// The controller for the dropdown.
  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;
  bool _selectionMode = false;

  late final FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();

  /// value notifier that is used for controller.
  late MultiSelectController<T> _c;

  /// search field focus node
  FocusNode? _searchFocusNode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
    _focusNode = widget.focusNode ?? FocusNode();
    _c = widget.controller ??
        MultiSelectController<T>(
          options: widget.options,
          disabledOptions: widget.disabledOptions,
          selectedOptions: widget.selectedOptions,
        );
  }

  /// Initializes the options, selected options and disabled options.
  /// If the options are fetched from the network, then the network call is made.
  /// If the options are passed as a parameter, then the options are initialized.
  void _initialize() async {
    if (!mounted) return;
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

  /// Handles the focus change to show/hide the dropdown.
  void _handleFocusChange() {
    if (_focusNode.hasFocus && mounted) {
      _overlayEntry = _buildOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      _updateSelection();
      return;
    }

    if ((_searchFocusNode == null || _searchFocusNode?.hasFocus == false) &&
        _overlayEntry != null) {
      _overlayEntry?.remove();
    }

    if (mounted) _updateSelection();

    _c.isDropdownOpen =
        _focusNode.hasFocus || _searchFocusNode?.hasFocus == true;
  }

  void _updateSelection() {
    setState(() {
      _selectionMode =
          _focusNode.hasFocus || _searchFocusNode?.hasFocus == true;
    });
  }

  /// Calculate offset size for dropdown.
  List _calculateOffsetSize() {
    final renderBox = context.findRenderObject() as RenderBox?;

    final size = renderBox?.size ?? Size.zero;
    final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    final availableHeight = MediaQuery.of(context).size.height - offset.dy;

    return [size, availableHeight < widget.dropdownHeight];
  }

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<MultiSelectController<T>>.value(
        value: _c,
        builder: (context, child) => Consumer<MultiSelectController<T>>(
          builder: (context, value, child) => Semantics(
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
                    height:
                        widget.chipConfig.wrapType == WrapType.wrap ? null : 52,
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      minHeight: 52,
                    ),
                    padding: _getContainerPadding(),
                    decoration: _getContainerDecoration(),
                    child: Row(
                      children: [
                        Expanded(
                          child: _getContainerContent(),
                        ),
                        if (widget.clearIcon != null && _c.anyItemSelected) ...[
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
          ),
        ),
      );

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
    if (_c.selectedOptions.isEmpty) {
      return HintText(
        hintText: widget.hint,
        hintColor: widget.hintColor,
        hintStyle: widget.hintStyle,
        hintPadding: widget.hintPadding,
      );
    }

    if (widget.selectionType == SelectionType.single &&
        !widget.showChipInSingleSelectMode) {
      return SingleSelectedItem(
          label: _c.selectedOptions.first.label,
          style: widget.singleSelectItemStyle);
    }

    return _buildSelectedItems();
  }

  /// Container decoration for the dropdown.
  Decoration _getContainerDecoration() =>
      widget.inputDecoration ??
      BoxDecoration(
        color: widget.fieldBackgroundColor ?? Colors.white,
        borderRadius: widget.radiusGeometry ??
            BorderRadius.circular(widget.fieldBorderRadius ?? 12.0),
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

    if (widget.controller == null || widget.controller?.isDisposed == true) {
      _c.dispose();
    }

    super.dispose();
  }

  /// Build the selected items for the dropdown.
  Widget _buildSelectedItems() {
    if (widget.chipConfig.wrapType == WrapType.scroll) {
      return ListView.separated(
        separatorBuilder: (context, index) =>
            _getChipSeparator(widget.chipConfig),
        scrollDirection: Axis.horizontal,
        itemCount: _c.selectedOptions.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final option = _c.selectedOptions[index];
          if (widget.selectedItemBuilder != null) {
            return widget.selectedItemBuilder!(context, option);
          }
          return _buildChip(
            option,
            widget.chipConfig,
            !_c.disabledOptions.contains(_c.selectedOptions[index]),
          );
        },
      );
    }
    return Wrap(
        spacing: widget.chipConfig.spacing,
        runSpacing: widget.chipConfig.runSpacing,
        children: mapIndexed(_c.selectedOptions, (index, item) {
          if (widget.selectedItemBuilder != null) {
            return widget.selectedItemBuilder!(
                context, _c.selectedOptions[index]);
          }
          return _buildChip(
            _c.selectedOptions[index],
            widget.chipConfig,
            !_c.disabledOptions.contains(_c.selectedOptions[index]),
          );
        }).toList());
  }

  /// Util method to map with index.
  Iterable<E> mapIndexed<E, F>(
      Iterable<F> items, E Function(int index, F item) f) sync* {
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

  /// Build the selected item chip.
  Widget _buildChip(ValueItem<T> item, ChipConfig chipConfig, isEnabled) =>
      SelectionChip<T>(
        item: item,
        chipConfig: chipConfig,
        onItemDelete: isEnabled
            ? (removedItem) {
                widget.onOptionRemoved?.call(
                    _c.options.indexOf(removedItem),
                    _c.selectedOptions[
                        _c.selectedOptions.indexOf(removedItem)]);
                _c.clearSelection(removedItem);
                widget.onChanged?.call(_c.selectedOptions);
                if (_focusNode.hasFocus) _focusNode.unfocus();
              }
            : null,
      );

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

    final icon = widget.selectedOptionIcon ??
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

    var options = _c.options;
    var future = widget.asyncOptions?.call('');

    return OverlayEntry(
      builder: (ctx) => ChangeNotifierProvider<MultiSelectController<T>>.value(
        value: _c,
        builder: (context, child) => StatefulBuilder(
          builder: (context, dropdownState) => Stack(
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
                targetAnchor:
                    showOnTop ? Alignment.topLeft : Alignment.bottomLeft,
                followerAnchor:
                    showOnTop ? Alignment.bottomLeft : Alignment.topLeft,
                offset: widget.dropdownMargin != null
                    ? Offset(
                        0,
                        showOnTop
                            ? -widget.dropdownMargin!
                            : widget.dropdownMargin!)
                    : Offset.zero,
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
                      borderRadius: widget.dropdownBorderRadius != null
                          ? BorderRadius.circular(widget.dropdownBorderRadius!)
                          : null,
                    ),
                    constraints: widget.searchEnabled
                        ? BoxConstraints.loose(
                            Size(size.width, widget.dropdownHeight + 50))
                        : BoxConstraints.loose(
                            Size(size.width, widget.dropdownHeight)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.searchEnabled) ...[
                          ColoredBox(
                            color:
                                widget.dropdownBackgroundColor ?? Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: searchController,
                                onTapOutside: (_) {},
                                scrollPadding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                focusNode: _searchFocusNode,
                                decoration: InputDecoration(
                                  fillColor: widget.searchBackgroundColor ??
                                      Colors.grey.shade200,
                                  isDense: true,
                                  filled: true,
                                  hintText: widget.searchLabel,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        widget.fieldBorderRadius ?? 12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 0.8,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        widget.fieldBorderRadius ?? 12),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 0.8,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      searchController.clear();
                                      if (widget.asyncOptions != null) {
                                        future = widget.asyncOptions!('');
                                      } else {
                                        dropdownState(() {
                                          options = _c.options;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                onChanged: (value) {
                                  if (widget.asyncOptions != null) {
                                    future = widget.asyncOptions!(value);
                                  } else {
                                    dropdownState(() {
                                      options = _c.options
                                          .where((element) => element.label
                                              .toLowerCase()
                                              .contains(value.toLowerCase()))
                                          .toList();
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                        ],
                        if (widget.asyncOptions == null)
                          Expanded(
                            child: _getList(context, options),
                          ),
                        if (widget.asyncOptions != null)
                          Expanded(
                            child: FutureBuilder<List<ValueItem<T>>>(
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.error != null) {
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      widget.responseErrorBuilder != null
                                          ? widget.responseErrorBuilder!(
                                              context, snapshot.error!)
                                          : const Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Text(
                                                'Error fetching data',
                                              ),
                                            ),
                                    ],
                                  );
                                }
                                _c.options.clear();
                                _c.options.addAll(snapshot.data ?? []);
                                return _getList(context, _c.options);
                              },
                              future: future,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getList(BuildContext context, List<ValueItem<T>> options) =>
      ListView.separated(
        separatorBuilder: (_, __) =>
            widget.optionSeparator ?? const SizedBox(height: 0),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = context.watch<MultiSelectController<T>>().selectedOptions.contains(option);
          void onTap() {
            if (widget.selectionType == SelectionType.multi) {
              if (isSelected) {
                _c.removeSelectedOption(option);
              } else {
                final hasReachMax = widget.maxItems == null
                    ? false
                    : (_c.selectedOptions.length + 1) > widget.maxItems!;
                if (hasReachMax) return;
                _c.addSelectedOption(option);
              }
            } else {
              _c.setSelectedOptions([option]);
              _focusNode.unfocus();
            }
            widget.onOptionSelected?.call(_c.selectedOptions);
            widget.onChanged?.call(_c.selectedOptions);
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
            onTap: onTap,
            selectedOptions: _c.selectedOptions,
          );
        },
      );

  ListTile _buildOption(
          {required ValueItem<T> option,
          required Color primaryColor,
          required bool isSelected,
          required void Function() onTap,
          required List<ValueItem<T>> selectedOptions}) =>
      ListTile(
        title: Text(
          option.label,
          style: widget.optionTextStyle ??
              TextStyle(
                fontSize: widget.hintFontSize,
              ),
        ),
        selectedColor: widget.selectedOptionTextColor ?? primaryColor,
        selected: isSelected,
        autofocus: true,
        dense: true,
        tileColor: widget.optionsBackgroundColor ?? Colors.white,
        selectedTileColor:
            widget.selectedOptionBackgroundColor ?? Colors.grey.shade200,
        enabled: !_c.disabledOptions.contains(option),
        onTap: onTap,
        trailing: _getSelectedIcon(isSelected, primaryColor),
      );

  /// Clear the selected options.
  /// [MultiSelectController] is used to clear the selected options.
  void clear() {
    if (!_c.isDisposed) {
      _c.clearAllSelection();
      widget.onOptionSelected?.call(_c.selectedOptions);
      widget.onChanged?.call(_c.selectedOptions);
    }
    if (_focusNode.hasFocus) _focusNode.unfocus();
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
