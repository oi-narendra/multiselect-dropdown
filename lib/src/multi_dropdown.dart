import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'controllers/future_controller.dart';
part 'controllers/multiselect_controller.dart';
part 'enum/enums.dart';
part 'models/decoration.dart';
part 'models/dropdown_item.dart';
// part 'models/network_request.dart';
part 'widgets/dropdown.dart';

/// typedef for the dropdown item builder.
typedef DropdownItemBuilder<T> = Widget Function(
  DropdownItem<T> item,
  int index,
);

/// typedef for the callback when the item is selected/de-selected/disabled.
typedef OnSelectionChanged<T> = void Function(List<T> selectedItems);

/// typedef for the selected item builder.
typedef SelectedItemBuilder<T> = Widget Function(DropdownItem<T> item);

/// typedef for the future request.
typedef FutureRequest<T> = Future<List<DropdownItem<T>>> Function();

/// A multiselect dropdown widget.
///
class MultiDropdown<T extends Object> extends StatefulWidget {
  /// Creates a multiselect dropdown widget.
  const MultiDropdown({
    required this.items,
    this.fieldDecoration = const FieldDecoration(),
    this.dropdownDecoration = const DropdownDecoration(),
    this.searchDecoration = const SearchFieldDecoration(),
    this.dropdownItemDecoration = const DropdownItemDecoration(),
    this.autovalidateMode = AutovalidateMode.disabled,
    this.singleSelect = false,
    this.itemSeparator,
    this.controller,
    this.validator,
    this.itemBuilder,
    this.enabled = true,
    this.chipDecoration = const ChipDecoration(),
    this.searchEnabled = false,
    this.maxSelections = 0,
    this.selectedItemBuilder,
    this.focusNode,
    this.onSelectionChange,
    Key? key,
  })  : future = null,
        super(key: key);

  /// Creates a multiselect dropdown widget with future request.
  const MultiDropdown.future({
    required this.future,
    this.fieldDecoration = const FieldDecoration(),
    this.dropdownDecoration = const DropdownDecoration(),
    this.searchDecoration = const SearchFieldDecoration(),
    this.dropdownItemDecoration = const DropdownItemDecoration(),
    this.autovalidateMode = AutovalidateMode.disabled,
    this.singleSelect = false,
    this.itemSeparator,
    this.controller,
    this.validator,
    this.itemBuilder,
    this.enabled = true,
    this.chipDecoration = const ChipDecoration(),
    this.searchEnabled = false,
    this.maxSelections = 0,
    this.selectedItemBuilder,
    this.focusNode,
    this.onSelectionChange,
    Key? key,
  })  : items = const [],
        super(key: key);

  /// The list of dropdown items.
  final List<DropdownItem<T>> items;

  /// The selection type of the dropdown.
  final bool singleSelect;

  /// The configuration for the chips.
  final ChipDecoration chipDecoration;

  /// The decoration of the field.
  final FieldDecoration fieldDecoration;

  /// The decoration of the dropdown.
  final DropdownDecoration dropdownDecoration;

  /// The decoration of the search field.
  final SearchFieldDecoration searchDecoration;

  /// The decoration of the dropdown items.
  final DropdownItemDecoration dropdownItemDecoration;

  /// The builder for the dropdown items.
  final DropdownItemBuilder<T>? itemBuilder;

  /// The builder for the selected items.
  final SelectedItemBuilder<T>? selectedItemBuilder;

  /// The separator between the dropdown items.
  final Widget? itemSeparator;

  /// The validator for the dropdown.
  final String? Function(List<DropdownItem<T>>? selectedOptions)? validator;

  /// The autovalidate mode for the dropdown.
  final AutovalidateMode autovalidateMode;

  /// The controller for the dropdown.
  final MultiSelectController<T>? controller;

  /// The maximum number of selections allowed.
  final int maxSelections;

  /// Whether the dropdown is enabled.
  final bool enabled;

  /// Whether the search field is enabled.
  final bool searchEnabled;

  /// The focus node for the dropdown.
  final FocusNode? focusNode;

  /// The future request for the dropdown items.
  final FutureRequest<T>? future;

  /// The callback when the item is changed.
  ///
  /// This callback is called when any item is selected or unselected.
  final OnSelectionChanged<T>? onSelectionChange;

  @override
  State<MultiDropdown<T>> createState() => _MultiDropdownState<T>();
}

class _MultiDropdownState<T extends Object> extends State<MultiDropdown<T>> {
  final LayerLink _layerLink = LayerLink();

  final OverlayPortalController _portalController = OverlayPortalController();

  late final MultiSelectController<T> _dropdownController =
      widget.controller ?? MultiSelectController<T>();
  final _FutureController _loadingController = _FutureController();

  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  late final Listenable _listenable = Listenable.merge([
    _dropdownController,
    _loadingController,
  ]);

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    if (_dropdownController.isDisposed) {
      throw StateError('DropdownController is disposed');
    }

    if (widget.future != null) {
      unawaited(_handleFuture());
    }
    _dropdownController
      ..setItems(widget.items)
      ..addListener(_controllerListener);
  }

  Future<void> _handleFuture() async {
    // we need to wait for the future to complete
    // before we can set the items to the dropdown controller.

    try {
      _loadingController.start();
      final items = await widget.future!();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadingController.stop();
        _dropdownController.setItems(items);
      });
    } catch (e) {
      _loadingController.stop();
      rethrow;
    }
  }

  void _controllerListener() {
    if (_dropdownController.isOpen) {
      _portalController.show();
    } else {
      _portalController.hide();
    }
  }

  @override
  void didUpdateWidget(covariant MultiDropdown<T> oldWidget) {
    // if the controller is changed, then dispose the old controller
    // and initialize the new controller.
    if (oldWidget.controller != widget.controller) {
      _dropdownController
        ..removeListener(_controllerListener)
        ..dispose();

      _initializeController();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _dropdownController.dispose();
    }

    _loadingController.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<DropdownItem<T>>?>(
      validator: widget.validator ?? (_) => null,
      autovalidateMode: widget.autovalidateMode,
      initialValue: _dropdownController.selectedItems,
      enabled: widget.enabled,
      builder: (FormFieldState<dynamic> state) {
        return OverlayPortal(
          controller: _portalController,
          overlayChildBuilder: (_) {
            final renderBox = context.findRenderObject()! as RenderBox;
            final renderBoxSize = renderBox.size;
            final renderBoxOffset = renderBox.localToGlobal(Offset.zero);

            final availableHeight = MediaQuery.of(context).size.height -
                renderBoxOffset.dy -
                renderBoxSize.height;

            final showOnTop =
                availableHeight < widget.dropdownDecoration.height;

            final stack = Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _handleOutsideTap,
                    child: const ColoredBox(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  targetAnchor:
                      showOnTop ? Alignment.topLeft : Alignment.bottomLeft,
                  followerAnchor:
                      showOnTop ? Alignment.bottomLeft : Alignment.topLeft,
                  offset: widget.dropdownDecoration.marginTop == 0
                      ? Offset.zero
                      : Offset(0, widget.dropdownDecoration.marginTop),
                  child: _Dropdown<T>(
                    decoration: widget.dropdownDecoration,
                    onItemTap: (item) => _handleDropdownItemTap(item, state),
                    width: renderBoxSize.width,
                    items: _dropdownController.items,
                    searchEnabled: widget.searchEnabled,
                    dropdownItemDecoration: widget.dropdownItemDecoration,
                    itemBuilder: widget.itemBuilder,
                    itemSeparator: widget.itemSeparator,
                    searchDecoration: widget.searchDecoration,
                    maxSelections: widget.maxSelections,
                    singleSelect: widget.singleSelect,
                  ),
                ),
              ],
            );
            return stack;
          },
          child: CompositedTransformTarget(
            link: _layerLink,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 52,
              ),
              child: ListenableBuilder(
                listenable: _listenable,
                builder: (_, __) {
                  return InkWell(
                    onTap: _handleTap,
                    focusNode: _focusNode,
                    canRequestFocus: widget.enabled,
                    borderRadius: _getFieldBorderRadius(),
                    child: InputDecorator(
                      isEmpty: _dropdownController.selectedItems.isEmpty,
                      isFocused: _dropdownController.isOpen,
                      decoration: _buildDecoration(state),
                      child: _buildField(),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleDropdownItemTap(
    DropdownItem<T> item,
    FormFieldState<dynamic> state,
  ) {
    if (widget.singleSelect) {
      _dropdownController._toggleOnly(item);
    } else {
      _dropdownController.toggleWhere(
        (element) => element.label == item.label,
      );
    }
    state.didChange(_dropdownController.selectedItems);
    widget.onSelectionChange?.call(
      _dropdownController.selectedItems.map((e) => e.value).toList(),
    );
  }

  InputDecoration _buildDecoration(FormFieldState<dynamic> state) {
    final theme = Theme.of(context);

    final border = widget.fieldDecoration.border ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.fieldDecoration.borderRadius,
          ),
          borderSide: theme.inputDecorationTheme.border?.borderSide ??
              const BorderSide(),
        );

    final fieldDecoration = widget.fieldDecoration;

    return InputDecoration(
      enabled: widget.enabled,
      labelText: fieldDecoration.labelText,
      labelStyle: fieldDecoration.labelStyle,
      hintText: fieldDecoration.hintText,
      hintStyle: fieldDecoration.hintStyle,
      errorText: state.errorText,
      border: fieldDecoration.border ?? border,
      enabledBorder: fieldDecoration.border ?? border,
      disabledBorder: fieldDecoration.disabledBorder,
      prefixIcon: fieldDecoration.prefixIcon,
      focusedBorder: fieldDecoration.focusedBorder ?? border,
      errorBorder: fieldDecoration.errorBorder,
      suffixIcon: _buildSuffixIcon(state),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }

  Widget _buildSuffixIcon(FormFieldState<dynamic> state) {
    if (_loadingController.value) {
      return const CircularProgressIndicator.adaptive();
    }

    if (_dropdownController.selectedItems.isNotEmpty) {
      return GestureDetector(
        child: const Icon(Icons.clear),
        onTap: () {
          _dropdownController.clearAll();
          state.didChange(_dropdownController.selectedItems);
        },
      );
    }

    if (!widget.fieldDecoration.animateSuffixIcon) {
      return widget.fieldDecoration.suffixIcon;
    }

    return AnimatedRotation(
      turns: _dropdownController.isOpen ? 0.5 : 0,
      duration: const Duration(milliseconds: 200),
      child: widget.fieldDecoration.suffixIcon,
    );
  }

  Widget _buildField() {
    if (_dropdownController.selectedItems.isEmpty) {
      return const SizedBox();
    }

    final selectedOptions = _dropdownController.selectedItems;

    if (widget.singleSelect) {
      return Text(selectedOptions.first.label);
    }

    return _buildSelectedItems(selectedOptions);
  }

  /// Build the selected items for the dropdown.
  Widget _buildSelectedItems(List<DropdownItem<T>> selectedOptions) {
    final chipDecoration = widget.chipDecoration;

    return Wrap(
      spacing: chipDecoration.spacing,
      runSpacing: chipDecoration.runSpacing,
      children: selectedOptions
          .map(
            (option) => Chip(
              label: Text(option.label),
              onDeleted: () => _dropdownController
                  .deselectWhere((element) => element.label == option.label),
              deleteIcon: chipDecoration.deleteIcon,
              shape: chipDecoration.shape,
              backgroundColor: widget.enabled
                  ? chipDecoration.backgroundColor
                  : Colors.grey.shade100,
              labelStyle: widget.enabled ? chipDecoration.labelStyle : null,
              labelPadding: chipDecoration.labelPadding,
              padding: chipDecoration.padding ??
                  const EdgeInsets.symmetric(horizontal: 8),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              elevation: 0,
              side: chipDecoration.borderSide,
            ),
          )
          .toList(),
    );
  }

  BorderRadius? _getFieldBorderRadius() {
    if (widget.fieldDecoration.border is OutlineInputBorder) {
      return (widget.fieldDecoration.border! as OutlineInputBorder)
          .borderRadius;
    }

    return BorderRadius.circular(widget.fieldDecoration.borderRadius);
  }

  void _handleTap() {
    if (!widget.enabled || _loadingController.value) {
      return;
    }

    if (_portalController.isShowing && _dropdownController.isOpen) return;

    _dropdownController.show();
  }

  void _handleOutsideTap() {
    if (!_dropdownController.isOpen) return;

    _dropdownController.hide();
  }
}
