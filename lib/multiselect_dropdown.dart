library multiselect_dropdown;

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:multiselect_dropdown/enums.dart';

class MultiSelectDropDown extends StatefulWidget {
  // Type of the dropdown
  final DropdownType type;

  // Hint text to be displayed when no option is selected
  final String hint;

  //Hint text color
  final Color? hintTextColor;

  //Font size of hint text
  final double? hintFontSize;

  // List of options to be displayed
  final List<String> options;

  // list of previously selected values
  final List<String> preSelectedItems;

  // list of disabled items values
  final List<String> disabledItems;

  // Function to be called when one or more options are selected
  final Function(List<String>)? onOptionSelected;

  // Icon to be displayed on the right of the dropdown item
  final IconData? selectedOptionIcon;

  // Background color of the selected option in the dropdown
  final Color? selectedOptionBackgroundColor;

  // Background color of the selected option in the dropdown
  final Color? selectedOptionColor;

  // Background color of the options
  final Color? optionsBackgroundColor;

  //FontSize of Options
  final double optionsFontSize;

  //Seperator for options
  final Widget? optionSeperator;

  // Background color of dropdown field
  final Color? backgroundColor;

  //Padding for the dropdown
  final double dropdownHorizontalPadding;
  final double dropdownVerticalPadding;

  //Border radius for the dropdown field
  final double dropdownBorderRadius;

  //Border color of the dropdown
  final Color? dropdownBorderColor;

  //Border width of the dropdown
  final double dropdownBorderWidth;

  // Chip mode
  final bool selectionChipMode;

  // Chip background color
  final Color? chipBackgroundColor;

  // Chip text color
  final Color? chipTextColor;

  // Chip icon
  final bool showChipRemoveIcon;

  // Chip separtion width
  final double chipSeparationWidth;

  //delete icon color in chip
  final Color? chipDeleteIconColor;

  //suffix icon of dropdown
  final IconData? suffixIcon;

  //options height
  final double optionsHeight;

  //show chip in single select mode
  final bool showChipInSingleSelectMode;

  //options wrap type
  final WrapType wrapType;

  static const emptyOption = 'No Options available';

  const MultiSelectDropDown(
      {Key? key,
      this.type = DropdownType.multiSelect,
      this.hint = 'Select',
      this.hintTextColor = Colors.grey,
      this.hintFontSize = 14.0,
      required this.options,
      this.preSelectedItems = const [],
      this.disabledItems = const [],
      this.onOptionSelected,
      this.selectedOptionColor,
      this.optionSeperator,
      this.optionsFontSize = 14.0,
      this.selectedOptionIcon = Icons.check,
      this.selectedOptionBackgroundColor = Colors.grey,
      this.optionsBackgroundColor,
      this.backgroundColor = Colors.white,
      this.dropdownHorizontalPadding = 4.0,
      this.dropdownVerticalPadding = 4.0,
      this.dropdownBorderRadius = 8.0,
      this.dropdownBorderColor,
      this.dropdownBorderWidth = 0.4,
      this.selectionChipMode = true,
      this.showChipRemoveIcon = true,
      this.chipBackgroundColor,
      this.chipTextColor,
      this.chipDeleteIconColor,
      this.chipSeparationWidth = 8.0,
      this.optionsHeight = 200,
      this.showChipInSingleSelectMode = false,
      this.suffixIcon = Icons.arrow_drop_down,
      this.wrapType = WrapType.wrap})
      : super(key: key);

  @override
  State<MultiSelectDropDown> createState() => _MultiSelectDropDownState();
}

class _MultiSelectDropDownState extends State<MultiSelectDropDown> {
  final List<String> _options = [];
  final List<String> _selectedOptions = [];

  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;

  bool _selectionMode = false;
  final FocusNode _focusNode = FocusNode();

  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _options.addAll(
        widget.options.isNotEmpty ? widget.options : ['No options available']);
    _selectedOptions.addAll(widget.preSelectedItems);
    _overlayState ??= Overlay.of(context);

    _focusNode.addListener(() {
      debugPrint('Focus changed: ${_focusNode.hasFocus}');
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)?.insert(_overlayEntry!);
        setState(() {
          _selectionMode = true;
        });
      } else {
        _overlayEntry?.remove();
        setState(() {
          _selectionMode = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant MultiSelectDropDown oldWidget) {
    if (widget.options != oldWidget.options) {
      _options.clear();
      _options.addAll(widget.options);
    }
    super.didUpdateWidget(oldWidget);
  }

  _createOverlayEntry() {
    debugPrint('show options');
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    var size = renderBox?.size ?? Size.zero;
    var offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    final availableHeight = MediaQuery.of(context).size.height - offset.dy;

    if (availableHeight < 200) {
      offset = Offset(offset.dx, offset.dy - (200 - availableHeight + 40));
    }

    return OverlayEntry(builder: (context) {
      List<String> options = _options;
      List<String> selectedOptions = [..._selectedOptions];

      return StatefulBuilder(builder: ((context, myState) {
        return Positioned(
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
                        Size(size.width, widget.optionsHeight)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(options[index],
                              style: const TextStyle(fontSize: 13)),
                          selected: selectedOptions.contains(options[index]),
                          selectedTileColor: Colors.grey.shade200,
                          enabled:
                              options[index] != MultiSelectDropDown.emptyOption,
                          onTap: () {
                            var option = options[index];
                            if (option == MultiSelectDropDown.emptyOption) {
                              return;
                            }
                            if (widget.type == DropdownType.multiSelect) {
                              if (selectedOptions.contains(option)) {
                                myState(() {
                                  selectedOptions.remove(option);
                                });
                              } else {
                                myState(() {
                                  selectedOptions.add(option);
                                });
                              }

                              if (_selectedOptions.contains(option)) {
                                setState(() {
                                  _selectedOptions.remove(option);
                                });
                              } else {
                                setState(() {
                                  _selectedOptions.add(option);
                                });
                              }
                            } else {
                              myState(() {
                                selectedOptions.clear();
                                selectedOptions.add(option);
                              });
                              setState(() {
                                _selectedOptions.clear();
                                _selectedOptions.add(option);
                              });
                              _focusNode.unfocus();
                            }
                          },
                          trailing: selectedOptions.contains(options[index])
                              ? const Icon(Icons.check)
                              : null,
                        );
                      },
                    ),
                  )),
            ));
      }));
    });
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
            if (_focusNode.hasFocus) {
              _focusNode.unfocus();
            } else {
              _focusNode.requestFocus();
            }
          },
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey,
                width: 0.4,
              ),
            ),
            child: Row(children: [
              Expanded(
                child: _selectedOptions.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9.0),
                        child: Text(
                          widget.hint.toUpperCase(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      )
                    : _buildSelectedItems(),
              ),
              AnimatedRotation(
                  turns: _selectionMode ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    widget.suffixIcon,
                  )),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_overlayState != null && _overlayEntry != null) {
      _overlayEntry?.remove();
    }
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildSelectedItems() {
    return widget.wrapType == WrapType.scroll
        ? ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              width: widget.chipSeparationWidth,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: _selectedOptions.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = _selectedOptions[index];
              return Chip(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                label: Text(item),
                deleteIconColor:
                    widget.chipDeleteIconColor ?? Colors.grey.shade400,
                backgroundColor:
                    widget.chipBackgroundColor ?? Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: widget.chipTextColor ?? Colors.black,
                ),
                onDeleted: () {
                  setState(() {
                    _selectedOptions.removeAt(index);
                  });
                  _focusNode.unfocus();
                },
              );
            },
          )
        : Wrap(
            spacing: 20,
            children: _selectedOptions.mapIndexed((index, item) {
              return Chip(
                label: Text(item),
                deleteIconColor:
                    widget.chipDeleteIconColor ?? Colors.grey.shade400,
                backgroundColor:
                    widget.chipBackgroundColor ?? Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: widget.chipTextColor ?? Colors.black,
                ),
                onDeleted: () {
                  setState(() {
                    _selectedOptions.removeAt(index);
                    _focusNode.unfocus();
                  });
                },
              );
            }).toList());
  }
}
