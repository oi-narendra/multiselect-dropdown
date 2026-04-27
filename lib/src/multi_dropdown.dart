import 'dart:async';
import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'controllers/future_controller.dart';
part 'controllers/multiselect_controller.dart';
part 'enum/enums.dart';
part 'models/decoration.dart';
part 'models/dropdown_group.dart';
part 'models/dropdown_item.dart';
part 'widgets/dropdown.dart';

/// typedef for the dropdown item builder.
typedef DropdownItemBuilder<T> = Widget Function(
  DropdownItem<T> item,
  int index,
  VoidCallback onTap,
);

/// typedef for the callback when the item is selected/de-selected/disabled.
typedef OnSelectionChanged<T> = void Function(List<T> selectedItems);

/// typedef for the callback when the search field value changes.
typedef OnSearchChanged = ValueChanged<String>;

/// Typedef for a custom search filter function.
///
/// Takes the search [query] and the full list of [items], and returns
/// the filtered list that should be displayed.
///
/// ```dart
/// MultiDropdown<String>(
///   searchEnabled: true,
///   searchFilter: (query, items) {
///     return items.where((i) => i.label.toLowerCase().startsWith(query)).toList();
///   },
/// )
/// ```
typedef SearchFilter<T> = List<DropdownItem<T>> Function(
  String query,
  List<DropdownItem<T>> items,
);

/// typedef for the selected item builder.
typedef SelectedItemBuilder<T> = Widget Function(DropdownItem<T> item);

/// typedef for the future request.
typedef FutureRequest<T> = Future<List<DropdownItem<T>>> Function();

/// A multiselect dropdown widget.
///
/// Supports multi-select and single-select modes, search, form validation,
/// async data loading via [MultiDropdown.future], programmatic control via
/// [MultiSelectController], and extensive visual customization through
/// [ChipDecoration], [FieldDecoration], [DropdownDecoration],
/// [DropdownItemDecoration], and [SearchFieldDecoration].
class MultiDropdown<T extends Object> extends StatefulWidget {
  /// Creates a multiselect dropdown widget.
  ///
  /// The [items] are the list of dropdown items. It is required.
  ///
  /// The [fieldDecoration] is the decoration of the field. The default value is FieldDecoration().
  /// It can be used to customize the field decoration.
  ///
  /// The [dropdownDecoration] is the decoration of the dropdown. The default value is DropdownDecoration().
  /// It can be used to customize the dropdown decoration.
  ///
  /// The [searchDecoration] is the decoration of the search field. The default value is SearchFieldDecoration().
  /// It can be used to customize the search field decoration.
  /// If [searchEnabled] is true, then the search field will be displayed.
  ///
  /// The [dropdownItemDecoration] is the decoration of the dropdown items. The default value is DropdownItemDecoration().
  /// It can be used to customize the dropdown item decoration.
  ///
  /// The [autovalidateMode] is the autovalidate mode for the dropdown. The default value is AutovalidateMode.disabled.
  ///
  /// The [singleSelect] is the selection type of the dropdown. The default value is false.
  /// If true, only one item can be selected at a time.
  ///
  /// The [itemSeparator] is the separator between the dropdown items.
  ///
  /// The [controller] is the controller for the dropdown. It can be used to control the dropdown programmatically.
  ///
  /// The [validator] is the validator for the dropdown. It can be used to validate the dropdown.
  ///
  /// The [itemBuilder] is the builder for the dropdown items. If not provided, the default ListTile will be used.
  ///
  /// The [enabled] is whether the dropdown is enabled. The default value is true.
  ///
  /// The [chipDecoration] is the configuration for the chips. The default value is ChipDecoration().
  /// It can be used to customize the chip decoration. The chips are displayed when an item is selected.
  ///
  /// The [searchEnabled] is whether the search field is enabled. The default value is false.
  ///
  /// The [maxSelections] is the maximum number of selections allowed. The default value is 0.
  ///
  /// The [selectedItemBuilder] is the builder for the selected items. If not provided, the default Chip will be used.
  ///
  /// The [focusNode] is the focus node for the dropdown.
  ///
  /// The [onSelectionChange] is the callback when the item is changed.
  ///
  /// The [closeOnBackButton] is whether to close the dropdown when the back button is pressed. The default value is false.
  /// Note: This option requires the app to have a router, such as MaterialApp.router, in order to work properly.
  ///
  ///
  const MultiDropdown({
    required this.items,
    this.groups,
    this.groupHeaderDecoration = const GroupHeaderDecoration(),
    this.fieldDecoration = const FieldDecoration(),
    this.dropdownDecoration = const DropdownDecoration(),
    this.searchDecoration = const SearchFieldDecoration(),
    this.dropdownItemDecoration = const DropdownItemDecoration(),
    this.autovalidateMode = AutovalidateMode.disabled,
    this.singleSelect = false,
    this.showSelectAll = false,
    this.dropdownMode = DropdownMode.overlay,
    this.itemSeparator,
    this.controller,
    this.validator,
    this.itemBuilder,
    this.enabled = true,
    this.chipDecoration = const ChipDecoration(),
    this.searchEnabled = false,
    this.searchFilter,
    this.maxSelections = 0,
    this.selectedItemBuilder,
    this.focusNode,
    this.onSelectionChange,
    this.onSearchChange,
    this.closeOnBackButton = false,
    Key? key,
  })  : future = null,
        super(key: key);

  /// Creates a multiselect dropdown widget with future request.
  ///
  /// The [future] is the future request for the dropdown items.
  /// You can use this to fetch the dropdown items asynchronously.
  ///
  /// A loading indicator will be displayed while the future is in progress at the suffix icon.
  /// The dropdown will be disabled until the future is completed.
  ///
  /// Example:
  ///
  /// ```dart
  /// MultiDropdown<User>.future(
  ///  future: () async {
  ///   final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
  ///  final data = jsonDecode(response.body) as List;
  /// return data.map((e) => DropdownItem(
  ///  label: e['name'] as String,
  /// value: e['id'] as int,
  /// )).toList();
  /// },
  /// );
  ///
  /// ```
  const MultiDropdown.future({
    required this.future,
    this.groups,
    this.groupHeaderDecoration = const GroupHeaderDecoration(),
    this.fieldDecoration = const FieldDecoration(),
    this.dropdownDecoration = const DropdownDecoration(),
    this.searchDecoration = const SearchFieldDecoration(),
    this.dropdownItemDecoration = const DropdownItemDecoration(),
    this.autovalidateMode = AutovalidateMode.disabled,
    this.singleSelect = false,
    this.showSelectAll = false,
    this.dropdownMode = DropdownMode.overlay,
    this.itemSeparator,
    this.controller,
    this.validator,
    this.itemBuilder,
    this.enabled = true,
    this.chipDecoration = const ChipDecoration(),
    this.searchEnabled = false,
    this.searchFilter,
    this.maxSelections = 0,
    this.selectedItemBuilder,
    this.focusNode,
    this.onSelectionChange,
    this.onSearchChange,
    this.closeOnBackButton = false,
    Key? key,
  })  : items = const [],
        super(key: key);

  /// The list of dropdown items.
  ///
  /// When [groups] is provided, items from the groups are used instead.
  final List<DropdownItem<T>> items;

  /// Optional grouped items with section headers.
  ///
  /// When provided, the dropdown renders items organized under
  /// labeled section headers. The [items] parameter is ignored when
  /// groups are provided.
  ///
  /// ```dart
  /// MultiDropdown<String>(
  ///   items: [], // ignored when groups is set
  ///   groups: [
  ///     DropdownGroup(label: 'Fruits', items: [apple, banana]),
  ///     DropdownGroup(label: 'Vegetables', items: [carrot]),
  ///   ],
  /// )
  /// ```
  final List<DropdownGroup<T>>? groups;

  /// The decoration for the group section headers.
  ///
  /// Only used when [groups] is provided.
  final GroupHeaderDecoration groupHeaderDecoration;

  /// Whether to show a "Select All / Deselect All" toggle at the top
  /// of the dropdown items list.
  ///
  /// When true, a checkbox row appears above the items that allows
  /// selecting or deselecting all visible items at once.
  ///
  /// Ignored when [singleSelect] is true.
  ///
  /// The labels can be customized via [DropdownDecoration.selectAllText]
  /// and [DropdownDecoration.deselectAllText].
  ///
  /// Defaults to false.
  final bool showSelectAll;

  /// An optional custom search filter function.
  ///
  /// When provided, this function is used instead of the default
  /// label-contains-query filter. Receives the search query and the
  /// full list of items, and must return the filtered subset.
  ///
  /// Useful for fuzzy matching, multi-field search, or any custom logic.
  final SearchFilter<T>? searchFilter;

  /// Controls how the dropdown items are presented.
  ///
  /// Use [DropdownMode.overlay] (default) for a classic inline dropdown.
  /// Use [DropdownMode.bottomSheet] for a mobile-friendly modal bottom sheet.
  final DropdownMode dropdownMode;

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

  /// The callback when the search field value changes.
  final OnSearchChanged? onSearchChange;

  /// Whether to close the dropdown when the back button is pressed.
  ///
  /// Note: This option requires the app to have a router, such as MaterialApp.router, in order to work properly.
  final bool closeOnBackButton;

  @override
  State<MultiDropdown<T>> createState() => _MultiDropdownState<T>();
}

class _MultiDropdownState<T extends Object> extends State<MultiDropdown<T>> {
  final LayerLink _layerLink = LayerLink();

  final OverlayPortalController _portalController = OverlayPortalController();

  /// Returns the flat list of items — either from groups (flattened)
  /// or from `widget.items` directly.
  List<DropdownItem<T>> get _effectiveItems {
    if (widget.groups != null && widget.groups!.isNotEmpty) {
      return widget.groups!.expand((g) => g.items).toList();
    }
    return widget.items;
  }

  late MultiSelectController<T> _dropdownController =
      widget.controller ?? MultiSelectController<T>();
  final _FutureController _loadingController = _FutureController();

  late FocusNode _focusNode = widget.focusNode ?? FocusNode();

  late final Listenable _listenable = Listenable.merge([
    _dropdownController,
    _loadingController,
  ]);

  // the global key for the form field state to update the form field state when the controller changes
  final GlobalKey<FormFieldState<List<DropdownItem<T>>?>> _formFieldKey =
      GlobalKey();

  @override
  void initState() {
    super.initState();
    unawaited(_initializeController());
  }

  Future<void> _initializeController() async {
    if (_dropdownController.isDisposed) {
      throw StateError('DropdownController is disposed');
    }

    if (widget.future != null) {
      unawaited(_handleFuture());
    }

    if (!_dropdownController._initialized) {
      _dropdownController
        .._initialize()
        ..setItems(_effectiveItems);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dropdownController
        ..addListener(_controllerListener)
        .._setOnSelectionChange(widget.onSelectionChange)
        .._setOnSearchChange(widget.onSearchChange)
        .._setSearchFilter(widget.searchFilter);

      // if close on back button is enabled, then add the listener
      _listenBackButton();
    });
  }

  void _listenBackButton() {
    if (!widget.closeOnBackButton) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _registerBackButtonDispatcherCallback();
      } on Exception catch (e) {
        debugPrint('Error: $e');
      }
    });
  }

  void _registerBackButtonDispatcherCallback() {
    final rootBackDispatcher = Router.of(context).backButtonDispatcher;

    if (rootBackDispatcher != null) {
      rootBackDispatcher.createChildBackButtonDispatcher()
        ..addCallback(() {
          if (_dropdownController.isOpen) {
            _dropdownController.closeDropdown();
          }

          return Future.value(true);
        })
        ..takePriority();
    }
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
    // update the form field state when the controller changes
    _formFieldKey.currentState?.didChange(_dropdownController.selectedItems);

    // Only manage the overlay portal in overlay mode.
    // Bottom sheet mode manages its own presentation.
    if (widget.dropdownMode == DropdownMode.overlay) {
      if (_dropdownController.isOpen) {
        _portalController.show();
      } else {
        _dropdownController._clearSearchQuery();
        _portalController.hide();
      }
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

      _dropdownController = widget.controller ?? MultiSelectController<T>();

      unawaited(_initializeController());
    }

    // if the focus node is changed, then dispose the old focus node
    // and initialize the new focus node.
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _dropdownController.removeListener(_controllerListener);

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
      key: _formFieldKey,
      validator: widget.validator ?? (_) => null,
      autovalidateMode: widget.autovalidateMode,
      initialValue: _dropdownController.selectedItems,
      enabled: widget.enabled,
      builder: (_) {
        return OverlayPortal(
          controller: _portalController,
          overlayChildBuilder: (_) {
            final renderBox = context.findRenderObject() as RenderBox?;

            if (renderBox == null || !renderBox.attached) {
              _showError('Failed to build the dropdown\nCode: 08');
              return const SizedBox();
            }

            final renderBoxSize = renderBox.size;
            final renderBoxOffset = renderBox.localToGlobal(Offset.zero);

            final screenHeight = MediaQuery.of(context).size.height;
            final spaceBelow =
                screenHeight - renderBoxOffset.dy - renderBoxSize.height;
            final spaceAbove = renderBoxOffset.dy;

            final bool showOnTop;
            switch (widget.dropdownDecoration.expandDirection) {
              case ExpandDirection.down:
                showOnTop = false;
                break;
              case ExpandDirection.up:
                showOnTop = true;
                break;
              case ExpandDirection.auto:
                showOnTop = spaceBelow < widget.dropdownDecoration.maxHeight &&
                    spaceAbove > spaceBelow;
                break;
            }

            final marginOffset = widget.dropdownDecoration.marginTop == 0
                ? Offset.zero
                : Offset(
                    0,
                    showOnTop
                        ? -widget.dropdownDecoration.marginTop
                        : widget.dropdownDecoration.marginTop,
                  );

            final stack = Stack(
              children: [
                Positioned.fill(
                  child: Listener(
                    behavior: HitTestBehavior.translucent,
                    onPointerDown: _handleOutsideTap,
                  ),
                ),
                CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  targetAnchor:
                      showOnTop ? Alignment.topLeft : Alignment.bottomLeft,
                  followerAnchor:
                      showOnTop ? Alignment.bottomLeft : Alignment.topLeft,
                  offset: marginOffset,
                  child: RepaintBoundary(
                    child: _Dropdown<T>(
                      decoration: widget.dropdownDecoration,
                      onItemTap: _handleDropdownItemTap,
                      width: renderBoxSize.width,
                      items: _dropdownController.items,
                      searchEnabled: widget.searchEnabled,
                      dropdownItemDecoration: widget.dropdownItemDecoration,
                      itemBuilder: widget.itemBuilder,
                      itemSeparator: widget.itemSeparator,
                      searchDecoration: widget.searchDecoration,
                      maxSelections: widget.maxSelections,
                      singleSelect: widget.singleSelect,
                      showSelectAll: widget.showSelectAll,
                      onSearchChange: _dropdownController._setSearchQuery,
                      groups: widget.groups,
                      groupHeaderDecoration: widget.groupHeaderDecoration,
                      onSelectAll: _dropdownController.selectAll,
                      onDeselectAll: _dropdownController.clearAll,
                    ),
                  ),
                ),
              ],
            );
            return stack;
          },
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: CompositedTransformTarget(
              link: _layerLink,
              child: ListenableBuilder(
                listenable: _listenable,
                builder: (_, __) {
                  return Semantics(
                    label: widget.fieldDecoration.labelText ?? 'Dropdown field',
                    button: true,
                    enabled: widget.enabled,
                    child: InkWell(
                      mouseCursor: widget.enabled
                          ? SystemMouseCursors.click
                          : SystemMouseCursors.forbidden,
                      onTap: widget.enabled ? _handleTap : null,
                      focusNode: _focusNode,
                      canRequestFocus: widget.enabled,
                      borderRadius: _getFieldBorderRadius(),
                      child: InputDecorator(
                        isEmpty: _dropdownController.selectedItems.isEmpty,
                        isFocused: _dropdownController.isOpen,
                        decoration: _buildDecoration(),
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        child: _buildField(),
                      ),
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

  void _handleDropdownItemTap(DropdownItem<T> item) {
    if (widget.singleSelect) {
      _dropdownController._toggleOnly(item);
    } else {
      _dropdownController.toggleWhere((element) => element == item);
    }
    _formFieldKey.currentState?.didChange(_dropdownController.selectedItems);

    if (widget.singleSelect) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _dropdownController.closeDropdown();
      });
    }
  }

  InputDecoration _buildDecoration() {
    final theme = Theme.of(context);
    final fieldDecoration = widget.fieldDecoration;

    // If a custom InputDecoration is provided, use it as the base
    // and only override the internally-managed properties.
    if (fieldDecoration.inputDecoration != null) {
      return fieldDecoration.inputDecoration!.copyWith(
        enabled: widget.enabled,
        suffixIcon: _buildSuffixIcon(),
        errorText: _formFieldKey.currentState?.errorText,
      );
    }

    final border = fieldDecoration.border ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            fieldDecoration.borderRadius,
          ),
          borderSide: theme.inputDecorationTheme.border?.borderSide ??
              const BorderSide(),
        );

    final prefixIcon = fieldDecoration.prefixIcon != null
        ? IconTheme.merge(
            data: IconThemeData(
              color: widget.enabled ? null : theme.disabledColor,
            ),
            child: fieldDecoration.prefixIcon!,
          )
        : null;

    return InputDecoration(
      enabled: widget.enabled,
      labelText: fieldDecoration.labelText,
      labelStyle: fieldDecoration.labelStyle,
      hintText: fieldDecoration.hintText,
      hintStyle: fieldDecoration.hintStyle,
      errorText: _formFieldKey.currentState?.errorText,
      filled: fieldDecoration.backgroundColor != null,
      fillColor: fieldDecoration.backgroundColor,
      border: fieldDecoration.border ?? border,
      enabledBorder: fieldDecoration.border ?? border,
      disabledBorder: fieldDecoration.disabledBorder,
      prefixIcon: prefixIcon,
      focusedBorder: fieldDecoration.focusedBorder ?? border,
      errorBorder: fieldDecoration.errorBorder,
      suffixIcon: _buildSuffixIcon(),
      contentPadding: fieldDecoration.padding,
    );
  }

  Widget? _buildSuffixIcon() {
    if (_loadingController.value) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator.adaptive(strokeWidth: 2),
      );
    }

    if (widget.fieldDecoration.showClearIcon &&
        widget.enabled &&
        _dropdownController.selectedItems.isNotEmpty) {
      return Tooltip(
        message: 'Clear selection',
        child: Semantics(
          label: 'Clear all selections',
          button: true,
          child: GestureDetector(
            child: const Icon(Icons.clear),
            onTap: () {
              _dropdownController.clearAll();
              _formFieldKey.currentState
                  ?.didChange(_dropdownController.selectedItems);
            },
          ),
        ),
      );
    }

    if (widget.fieldDecoration.suffixIcon == null) {
      return null;
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
      if (widget.selectedItemBuilder != null) {
        return widget.selectedItemBuilder!(selectedOptions.first);
      }
      return Text(
        selectedOptions.first.label,
        style: widget.fieldDecoration.selectedItemTextStyle,
        overflow: TextOverflow.ellipsis,
      );
    }

    return _buildSelectedItems(selectedOptions);
  }

  /// Build the selected items for the dropdown.
  Widget _buildSelectedItems(List<DropdownItem<T>> selectedOptions) {
    final chipDecoration = widget.chipDecoration;

    if (widget.selectedItemBuilder != null) {
      final children = selectedOptions
          .map((option) => widget.selectedItemBuilder!(option))
          .toList();

      if (chipDecoration.wrap) {
        return Wrap(
          spacing: chipDecoration.spacing,
          runSpacing: chipDecoration.runSpacing,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: children,
        );
      }

      return ConstrainedBox(
        constraints: BoxConstraints.loose(const Size(double.infinity, 32)),
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          scrollDirection: Axis.horizontal,
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        ),
      );
    }

    final maxCount = chipDecoration.maxDisplayCount;
    final displayOptions = maxCount != null && selectedOptions.length > maxCount
        ? selectedOptions.take(maxCount).toList()
        : selectedOptions;
    final remainingCount = selectedOptions.length - displayOptions.length;

    final chips = displayOptions
        .map((option) => _buildChip(option, chipDecoration))
        .toList();

    if (remainingCount > 0) {
      final overflowLabel = chipDecoration.overflowLabelBuilder != null
          ? chipDecoration.overflowLabelBuilder!(remainingCount)
          : '+$remainingCount more';
      chips.add(
        Container(
          padding: chipDecoration.padding,
          child: Text(
            overflowLabel,
            style: chipDecoration.labelStyle ??
                TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      );
    }

    if (chipDecoration.wrap) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: Alignment.topLeft,
            children: [
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        child: Wrap(
          key: ValueKey(selectedOptions.length),
          spacing: chipDecoration.spacing,
          runSpacing: chipDecoration.runSpacing,
          children: chips,
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints.loose(const Size(double.infinity, 32)),
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        itemBuilder: (context, index) => chips[index],
      ),
    );
  }

  Widget _buildChip(
    DropdownItem<dynamic> option,
    ChipDecoration chipDecoration,
  ) {
    final theme = Theme.of(context);
    final resolvedChipBg =
        chipDecoration.backgroundColor ?? theme.colorScheme.surface;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: chipDecoration.borderRadius,
        color:
            widget.enabled ? resolvedChipBg : theme.disabledColor.withAlpha(30),
        border: chipDecoration.border,
      ),
      padding: chipDecoration.padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              option.label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: chipDecoration.labelStyle?.copyWith(
                    color: widget.enabled
                        ? chipDecoration.labelStyle?.color
                        : theme.disabledColor,
                  ) ??
                  TextStyle(
                    color: widget.enabled ? null : theme.disabledColor,
                  ),
            ),
          ),
          if (widget.enabled) ...[
            const SizedBox(width: 4),
            Semantics(
              label: 'Remove ${option.label}',
              button: true,
              child: Tooltip(
                message: 'Remove ${option.label}',
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    _dropdownController.unselectWhere(
                      (element) => element.value == option.value,
                    );
                  },
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: chipDecoration.deleteIcon ??
                        Icon(
                          Icons.close,
                          size: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
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

    if (_dropdownController.isOpen) {
      _dropdownController.closeDropdown();
      return;
    }

    // Dismiss the keyboard and unfocus any currently focused widget
    // (e.g., TextFormField) before opening the dropdown.
    FocusManager.instance.primaryFocus?.unfocus();

    if (widget.dropdownMode == DropdownMode.bottomSheet) {
      _showBottomSheet();
    } else {
      _dropdownController.openDropdown();
    }
  }

  void _showBottomSheet() {
    _dropdownController.openDropdown();

    unawaited(showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          maxChildSize: 0.85,
          expand: false,
          builder: (_, scrollController) {
            return ListenableBuilder(
              listenable: _dropdownController,
              builder: (ctx, __) {
                final theme = Theme.of(ctx);
                return Column(
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Title
                    if (widget.fieldDecoration.labelText != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 8,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.fieldDecoration.labelText!,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    // Search
                    if (widget.searchEnabled)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: _SearchField(
                          decoration: widget.searchDecoration,
                          onChanged: _dropdownController._setSearchQuery,
                        ),
                      ),
                    // Items list
                    Expanded(
                      child: _dropdownController.items.isEmpty
                          ? Center(
                              child: Text(
                                widget.dropdownDecoration.noItemsFoundText,
                                style: theme.textTheme.bodyMedium,
                              ),
                            )
                          : ListView.separated(
                              controller: scrollController,
                              padding: widget.dropdownDecoration.listPadding ??
                                  EdgeInsets.zero,
                              itemCount: _dropdownController.items.length,
                              separatorBuilder: (_, __) =>
                                  widget.itemSeparator ??
                                  const SizedBox.shrink(),
                              itemBuilder: (_, index) {
                                final item = _dropdownController.items[index];
                                if (widget.itemBuilder != null) {
                                  return widget.itemBuilder!(
                                    item,
                                    index,
                                    () => _handleDropdownItemTap(item),
                                  );
                                }
                                return _buildBottomSheetItem(
                                  item,
                                  theme,
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    ).whenComplete(() {
      _dropdownController._clearSearchQuery(notify: true);
      _dropdownController.closeDropdown();
    }),);
  }

  Widget _buildBottomSheetItem(DropdownItem<T> item, ThemeData theme) {
    final selected = item.selected;
    final disabled = item.disabled;

    return ListTile(
      title: Text(
        item.label,
        style: TextStyle(
          color: disabled ? theme.disabledColor : null,
        ),
      ),
      trailing: selected
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
          : null,
      enabled: !disabled,
      onTap: () => _handleDropdownItemTap(item),
    );
  }

  void _handleOutsideTap(PointerDownEvent event) {
    if (!_dropdownController.isOpen) return;

    // Check if the tap landed on the field itself. If so, let the
    // field's InkWell handle the toggle — don't treat it as "outside".
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.attached) {
      final localPosition = renderBox.globalToLocal(event.position);
      if (renderBox.paintBounds.contains(localPosition)) {
        return;
      }
    }

    _dropdownController.closeDropdown();
  }

  void _showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    });
  }
}
