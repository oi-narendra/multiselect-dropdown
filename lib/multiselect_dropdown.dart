library multiselect_dropdown;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:multi_dropdown/models/network_config.dart';
import 'package:multi_dropdown/widgets/hint_text.dart';
import 'package:multi_dropdown/widgets/selection_chip.dart';
import 'package:multi_dropdown/widgets/single_selected_item.dart';
import 'package:http/http.dart' as http;

import 'models/chip_config.dart';
import 'models/value_item.dart';
import 'enum/app_enums.dart';

export 'enum/app_enums.dart';
export 'models/chip_config.dart';
export 'models/value_item.dart';
export 'models/network_config.dart';

typedef OnOptionSelected = void Function(List<ValueItem> selectedOptions);

class MultiSelectDropDown extends StatefulWidget {
  // selection type of the dropdown
  final SelectionType selectionType;

  // Hint
  final String hint;
  final Color? hintColor;
  final double? hintFontSize;
  final TextStyle? hintStyle;

  // Options
  final List<ValueItem> options;
  final List<ValueItem> selectedOptions;
  final List<ValueItem> disabledOptions;

  final OnOptionSelected? onOptionSelected;

  // selected option
  final Icon? selectedOptionIcon;
  final Color? selectedOptionTextColor;
  final Color? selectedOptionBackgroundColor;
  final Widget Function(BuildContext, ValueItem)? selectedItemBuilder;

  // chip configuration
  final bool showChipInSingleSelectMode;
  final ChipConfig chipConfig;

  // options configuration
  final Color? optionsBackgroundColor;
  final TextStyle? optionTextStyle;
  final Widget? optionSeperator;
  final double dropdownHeight;
  final Widget? optionSeparator;
  final bool alwaysShowOptionIcon;

  // dropdownfield configuration
  final Color? backgroundColor;
  final IconData? suffixIcon;
  final Decoration? inputDecoration;
  final double? borderRadius;
  final BorderRadiusGeometry? radiusGeometry;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsets? padding;

  // network configuration
  final NetworkConfig? networkConfig;
  final Future<List<ValueItem>> Function(dynamic)? responseParser;
  final Widget Function(BuildContext, dynamic)? responseErrorBuilder;

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
  /// [optionSeperator] is the seperator between the options.
  ///
  /// [dropdownHeight] is the height of the dropdown options. The default is 200.
  ///
  ///  **Dropdown Configuration**
  ///
  /// [backgroundColor] is the background color of the dropdown. The default is [Colors.white].
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

  const MultiSelectDropDown({
    Key? key,
    required this.onOptionSelected,
    required this.options,
    this.selectedOptionTextColor,
    this.optionSeperator,
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
    this.backgroundColor = Colors.white,
    this.dropdownHeight = 200,
    this.showChipInSingleSelectMode = false,
    this.suffixIcon = Icons.arrow_drop_down,
    this.selectedItemBuilder,
    this.optionSeparator,
    this.inputDecoration,
    this.hintStyle,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 8,
    ),
    this.borderColor = Colors.grey,
    this.borderWidth = 0.4,
    this.borderRadius = 12.0,
    this.radiusGeometry,
  })  : networkConfig = null,
        responseParser = null,
        responseErrorBuilder = null,
        super(key: key);

  /// Constructor for MultiSelectDropDown that fetches the options from a network call.
  /// [networkConfig] is the configuration for the network call.
  /// [responseParser] is the parser that is used to parse the response from the network call.
  /// [responseErrorBuilder] is the builder that is used to build the error widget when the network call fails.

  const MultiSelectDropDown.network({
    Key? key,
    required this.networkConfig,
    required this.responseParser,
    this.responseErrorBuilder,
    required this.onOptionSelected,
    this.selectedOptionTextColor,
    this.optionSeperator,
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
    this.backgroundColor = Colors.white,
    this.dropdownHeight = 200,
    this.showChipInSingleSelectMode = false,
    this.suffixIcon = Icons.arrow_drop_down,
    this.selectedItemBuilder,
    this.optionSeparator,
    this.inputDecoration,
    this.hintStyle,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 8,
    ),
    this.borderColor = Colors.grey,
    this.borderWidth = 0.4,
    this.borderRadius = 12.0,
    this.radiusGeometry,
  })  : options = const [],
        super(key: key);

  @override
  State<MultiSelectDropDown> createState() => _MultiSelectDropDownState();
}

class _MultiSelectDropDownState extends State<MultiSelectDropDown> {
  /// Options list that is used to display the options.
  final List<ValueItem> _options = [];

  /// Selected options list that is used to display the selected options.
  final List<ValueItem> _selectedOptions = [];

  /// Disabled options list that is used to display the disabled options.
  final List<ValueItem> _disabledOptions = [];

  /// The controller for the dropdown.
  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;
  bool _selectionMode = false;

  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  /// Response from the network call.
  dynamic _reponseBody;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// Initializes the options, selected options and disabled options.
  /// If the options are fetched from the network, then the network call is made.
  /// If the options are passed as a parameter, then the options are initialized.
  void _initialize() async {
    if (widget.networkConfig?.url != null) {
      await _fetchNetwork();
    } else {
      _options.addAll(widget.options);
    }
    _addOptions();
    _overlayState ??= Overlay.of(context);
    _focusNode.addListener(_handleFocusChange);
  }

  /// Adds the selected options and disabled options to the options list.
  void _addOptions() {
    _selectedOptions.addAll(widget.selectedOptions);
    _disabledOptions.addAll(widget.disabledOptions);
  }

  /// Handles the focus change to show/hide the dropdown.
  _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _overlayEntry = _reponseBody != null && widget.networkConfig != null
          ? _buildNetworkErrorOverlayEntry()
          : _buildOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      return;
    }
    _overlayEntry?.remove();
    setState(() {
      _selectionMode = _focusNode.hasFocus;
    });
  }

  /// Handles the widget rebuild when the options are changed externally.
  @override
  void didUpdateWidget(covariant MultiSelectDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.options != oldWidget.options) {
      _options.clear();
      _options.addAll(widget.options);
    }

    if (widget.selectedOptions != oldWidget.selectedOptions) {
      _selectedOptions.clear();
      _selectedOptions.addAll(widget.selectedOptions);
    }

    if (widget.disabledOptions != oldWidget.disabledOptions) {
      _disabledOptions.clear();
      _disabledOptions.addAll(widget.disabledOptions);
    }
  }

  /// Calculate offset size for dropdown.
  List _calculateOffsetSize() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    var size = renderBox?.size ?? Size.zero;
    var offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    final availableHeight = MediaQuery.of(context).size.height - offset.dy;

    if (availableHeight < widget.dropdownHeight) {
      offset = Offset(offset.dx,
          offset.dy - (widget.dropdownHeight - availableHeight + 40));
    }
    return [size, offset];
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        canRequestFocus: true,
        skipTraversal: true,
        focusNode: _focusNode,
        child: GestureDetector(
          onTap: () {
            _toggleFocus();
          },
          child: Container(
            height: widget.chipConfig.wrapType == WrapType.wrap ? null : 52,
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: 52,
            ),
            padding: widget.padding,
            decoration: _getContainerDecoration(),
            child: Row(
              children: [
                Expanded(
                  child: _getContainerContent(),
                ),
                AnimatedRotation(
                    turns: _selectionMode ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      widget.suffixIcon,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Container Content for the dropdown.
  Widget _getContainerContent() {
    if (_selectedOptions.isEmpty) {
      return HintText(
        hintText: widget.hint,
        hintColor: widget.hintColor,
        hintStyle: widget.hintStyle,
      );
    }

    if (widget.selectionType == SelectionType.single &&
        !widget.showChipInSingleSelectMode) {
      return SingleSelectedItem(label: _selectedOptions.first.label);
    }

    return _buildSelectedItems();
  }

  /// Container decoration for the dropdown.
  Decoration _getContainerDecoration() {
    return widget.inputDecoration ??
        BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: widget.radiusGeometry ??
              BorderRadius.circular(widget.borderRadius ?? 12.0),
          border: Border.all(
            color: widget.borderColor ?? Colors.grey,
            width: widget.borderWidth ?? 0.4,
          ),
        );
  }

  /// Dispose the focus node and overlay entry.
  @override
  void dispose() {
    if (_overlayEntry?.mounted == true) {
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
      _overlayState?.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  /// Build the selected items for the dropdown.
  Widget _buildSelectedItems() {
    if (widget.chipConfig.wrapType == WrapType.scroll) {
      return ListView.separated(
        separatorBuilder: (context, index) =>
            _getChipSeparator(widget.chipConfig),
        scrollDirection: Axis.horizontal,
        itemCount: _selectedOptions.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final option = _selectedOptions[index];
          if (widget.selectedItemBuilder != null) {
            return widget.selectedItemBuilder!(context, option);
          }
          return _buildChip(option, widget.chipConfig);
        },
      );
    }
    return Wrap(
        spacing: widget.chipConfig.spacing,
        runSpacing: widget.chipConfig.runSpacing,
        children: mapIndexed(_selectedOptions, (index, item) {
          if (widget.selectedItemBuilder != null) {
            return widget.selectedItemBuilder!(
                context, _selectedOptions[index]);
          }
          return _buildChip(_selectedOptions[index], widget.chipConfig);
        }).toList());
  }

  /// Util method to map with index.
  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
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
    _focusNode.unfocus();
  }

  /// Buid the selected item chip.
  Widget _buildChip(ValueItem item, ChipConfig chipConfig) {
    return SelectionChip(
      item: item,
      chipConfig: chipConfig,
      onItemDelete: (removedItem) {
        setState(() {
          _selectedOptions.remove(removedItem);
        });
        widget.onOptionSelected?.call(_selectedOptions);
        if (_focusNode.hasFocus) _focusNode.unfocus();
      },
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
    final values = _calculateOffsetSize();
    final size = values[0] as Size;
    final offset = values[1] as Offset;

    return OverlayEntry(builder: (context) {
      List<ValueItem> options = _options;
      List<ValueItem> selectedOptions = [..._selectedOptions];

      return StatefulBuilder(builder: ((context, dropdownState) {
        return Stack(
          children: [
            Positioned.fill(
                child: GestureDetector(
              onTap: _onOutSideTap,
              child: Container(
                color: Colors.transparent,
              ),
            )),
            Positioned(
                left: offset.dx,
                top: offset.dy + size.height + 5.0,
                width: size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0.0, size.height + 5.0),
                  child: Material(
                      elevation: 4,
                      child: Container(
                        constraints: BoxConstraints.loose(
                            Size(size.width, widget.dropdownHeight)),
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return widget.optionSeparator ??
                                const SizedBox(height: 0);
                          },
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options[index];
                            final isSelected = selectedOptions.contains(option);
                            final primaryColor = Theme.of(context).primaryColor;

                            return ListTile(
                                title: Text(option.label,
                                    style: widget.optionTextStyle ??
                                        TextStyle(
                                          fontSize: widget.hintFontSize,
                                        )),
                                textColor: Colors.black,
                                selectedColor: widget.selectedOptionTextColor ??
                                    primaryColor,
                                selected: isSelected,
                                tileColor: widget.optionsBackgroundColor ??
                                    Colors.white,
                                selectedTileColor:
                                    widget.selectedOptionBackgroundColor ??
                                        Colors.grey.shade200,
                                enabled: !_disabledOptions.contains(option),
                                onTap: () {
                                  if (widget.selectionType ==
                                      SelectionType.multi) {
                                    if (isSelected) {
                                      dropdownState(() {
                                        selectedOptions.remove(option);
                                      });
                                      setState(() {
                                        _selectedOptions.remove(option);
                                      });
                                    } else {
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

                                  widget.onOptionSelected
                                      ?.call(_selectedOptions);
                                },
                                trailing:
                                    _getSelectedIcon(isSelected, primaryColor));
                          },
                        ),
                      )),
                )),
          ],
        );
      }));
    });
  }

  /// Make a request to the provided url.
  /// The response then is parsed to a list of ValueItem objects.
  Future<void> _fetchNetwork() async {
    final result = await _performNetworkRequest();
    http.get(Uri.parse(widget.networkConfig!.url));
    if (result.statusCode == 200) {
      final data = json.decode(result.body);
      final List<ValueItem> parsedOptions = await widget.responseParser!(data);
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
    final offset = values[1] as Offset;

    return OverlayEntry(builder: (context) {
      return StatefulBuilder(builder: ((context, dropdownState) {
        return Stack(
          children: [
            Positioned.fill(
                child: GestureDetector(
              onTap: _onOutSideTap,
              child: Container(
                color: Colors.transparent,
              ),
            )),
            Positioned(
                left: offset.dx,
                top: offset.dy + size.height + 5.0,
                width: size.width,
                child: CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(0.0, size.height + 5.0),
                    child: Material(
                        elevation: 4,
                        child: Container(
                            constraints: BoxConstraints.loose(
                                Size(size.width, widget.dropdownHeight)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                widget.responseErrorBuilder != null
                                    ? widget.responseErrorBuilder!(
                                        context, _reponseBody)
                                    : Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                            'Error fetching data: $_reponseBody'),
                                      ),
                              ],
                            )))))
          ],
        );
      }));
    });
  }
}
