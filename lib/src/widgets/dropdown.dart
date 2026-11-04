part of '../multi_dropdown.dart';

/// Dropdown widget for the multiselect dropdown.
///
class _Dropdown<T> extends StatefulWidget {
  /// Creates a dropdown widget.
  const _Dropdown({
    required this.decoration,
    required this.width,
    required this.searchEnabled,
    required this.dropdownItemDecoration,
    required this.searchDecoration,
    required this.maxSelections,
    required this.items,
    required this.onItemTap,
    this.maxHeight,
    super.key,
    this.onSearchChange,
    this.itemBuilder,
    this.itemSeparator,
    this.singleSelect = false,
    this.groups,
    this.groupHeaderDecoration = const GroupHeaderDecoration(),
    this.showSelectAll = false,
    this.onSelectAll,
    this.onDeselectAll,
  });

  /// The decoration of the dropdown.
  final DropdownDecoration decoration;

  /// Viewport-aware max height override. Falls back to [maxHeight].
  final double? maxHeight;

  /// Whether the search field is enabled.
  final bool searchEnabled;

  /// The width of the dropdown.
  final double width;

  /// The decoration of the dropdown items.
  final DropdownItemDecoration dropdownItemDecoration;

  /// Dropdown item builder, if not provided, the default ListTile will be used.
  final DropdownItemBuilder<T>? itemBuilder;

  /// The separator between the dropdown items.
  final Widget? itemSeparator;

  /// The decoration of the search field.
  final SearchFieldDecoration searchDecoration;

  /// The maximum number of selections allowed.
  final int maxSelections;

  /// The list of dropdown items.
  final List<DropdownItem<T>> items;

  /// The callback when an item is tapped.
  final ValueChanged<DropdownItem<T>> onItemTap;

  /// The callback when the search field value changes.
  final ValueChanged<String>? onSearchChange;

  /// Whether the selection is single.
  final bool singleSelect;

  /// Optional grouped items with section headers.
  final List<DropdownGroup<T>>? groups;

  /// The decoration for group headers.
  final GroupHeaderDecoration groupHeaderDecoration;

  /// Whether to show the select all / deselect all toggle.
  final bool showSelectAll;

  /// Callback invoked when "Select All" is tapped.
  final VoidCallback? onSelectAll;

  /// Callback invoked when "Deselect All" is tapped.
  final VoidCallback? onDeselectAll;

  @override
  State<_Dropdown<T>> createState() => _DropdownState<T>();
}

/// Represents either a group header or a dropdown item in the
/// flattened list used for rendering grouped dropdowns.
class _GroupEntry<T> {
  _GroupEntry.header(this.groupLabel) : item = null, isHeader = true;

  _GroupEntry.item(this.item) : groupLabel = null, isHeader = false;

  final String? groupLabel;
  final DropdownItem<T>? item;
  final bool isHeader;
}

class _DropdownState<T> extends State<_Dropdown<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  int get _selectedCount =>
      widget.items.where((element) => element.selected).length;

  static const Map<ShortcutActivator, Intent> _webShortcuts =
      <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(
          TraversalDirection.down,
        ),
        SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(
          TraversalDirection.up,
        ),
      };

  /// Whether this dropdown is using grouped mode.
  bool get _isGrouped => widget.groups != null && widget.groups!.isNotEmpty;

  /// Builds a flattened list of [_GroupEntry] from the groups,
  /// filtering out groups that have no visible items (e.g., after search).
  List<_GroupEntry<T>> _buildGroupEntries() {
    if (!_isGrouped) return [];

    final visibleItemsByIdentity = {
      for (final item in widget.items) (item.value, item.label): item,
    };
    final entries = <_GroupEntry<T>>[];

    for (final group in widget.groups!) {
      final visibleItems = [
        for (final item in group.items)
          ?visibleItemsByIdentity[(item.value, item.label)],
      ];
      if (visibleItems.isEmpty) continue;

      entries.add(_GroupEntry<T>.header(group.label));
      for (final item in visibleItems) {
        entries.add(_GroupEntry<T>.item(item));
      }
    }

    return entries;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.decoration.animationDuration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: widget.decoration.animationCurve,
    );
    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, -0.05),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: widget.decoration.animationCurve,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedBg =
        widget.decoration.backgroundColor ?? theme.colorScheme.surface;

    final child = SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          elevation: widget.decoration.elevation,
          // Material asserts that shape and borderRadius are not both set, so
          // the radius travels inside the shape whenever a border is given.
          borderRadius: widget.decoration.border == null
              ? widget.decoration.borderRadius
              : null,
          shape: widget.decoration.border == null
              ? null
              : RoundedRectangleBorder(
                  borderRadius: widget.decoration.borderRadius,
                  side: widget.decoration.border!,
                ),
          clipBehavior: Clip.antiAlias,
          color: resolvedBg,
          surfaceTintColor: resolvedBg,
          child: Focus(
            canRequestFocus: false,
            skipTraversal: true,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: widget.decoration.borderRadius,
                color: resolvedBg,
                backgroundBlendMode: BlendMode.dstATop,
              ),
              constraints: BoxConstraints(
                maxWidth: widget.width,
                maxHeight: widget.maxHeight ?? widget.decoration.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.searchEnabled)
                    _SearchField(
                      decoration: widget.searchDecoration,
                      onChanged: _onSearchChange,
                    ),
                  if (widget.decoration.header != null)
                    Flexible(child: widget.decoration.header!),
                  if (widget.showSelectAll &&
                      !widget.singleSelect &&
                      widget.items.isNotEmpty)
                    _buildSelectAllToggle(theme),
                  if (widget.items.isNotEmpty)
                    Flexible(child: _buildItemsList(theme)),
                  if (widget.items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        widget.decoration.noItemsFoundText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  if (widget.decoration.footer != null)
                    Flexible(child: widget.decoration.footer!),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows) {
      return Shortcuts(shortcuts: _webShortcuts, child: child);
    }

    return child;
  }

  /// Builds the items list — either grouped (with headers) or flat.
  Widget _buildItemsList(ThemeData theme) {
    if (_isGrouped) {
      return _buildGroupedList(theme);
    }
    return _buildFlatList(theme);
  }

  /// Builds the Select All / Deselect All toggle row.
  Widget _buildSelectAllToggle(ThemeData theme) {
    final allSelected = widget.items.every((item) => item.selected);
    final label = allSelected
        ? widget.decoration.deselectAllText
        : widget.decoration.selectAllText;

    // Disable select all if maxSelections would be exceeded
    final enabled =
        allSelected ||
        widget.maxSelections == 0 ||
        widget.items.length <= widget.maxSelections;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: enabled
              ? () {
                  if (allSelected) {
                    widget.onDeselectAll?.call();
                  } else {
                    widget.onSelectAll?.call();
                  }
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IgnorePointer(
                  child: Checkbox(
                    value: allSelected,
                    tristate: true,
                    onChanged: enabled ? (_) {} : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: enabled
                          ? theme.colorScheme.onSurface
                          : theme.disabledColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  /// Builds the original flat list of items (no groups).
  Widget _buildFlatList(ThemeData theme) {
    return ListView.separated(
      separatorBuilder: (_, _) =>
          widget.itemSeparator ?? const SizedBox.shrink(),
      shrinkWrap: true,
      padding: widget.decoration.listPadding ?? EdgeInsets.zero,
      itemCount: widget.items.length,
      itemBuilder: (_, index) => _buildOption(widget.items[index], theme),
    );
  }

  /// Builds a grouped list with interleaved section headers and items.
  Widget _buildGroupedList(ThemeData theme) {
    final entries = _buildGroupEntries();

    return ListView.builder(
      shrinkWrap: true,
      padding: widget.decoration.listPadding ?? EdgeInsets.zero,
      itemCount: entries.length,
      itemBuilder: (_, index) {
        final entry = entries[index];

        if (entry.isHeader) {
          return _buildGroupHeader(
            entry.groupLabel!,
            theme,
            isFirst: index == 0,
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOption(entry.item!, theme),
            if (widget.itemSeparator != null &&
                index < entries.length - 1 &&
                !entries[index + 1].isHeader)
              widget.itemSeparator!,
          ],
        );
      },
    );
  }

  /// Builds a group section header row.
  Widget _buildGroupHeader(
    String label,
    ThemeData theme, {
    required bool isFirst,
  }) {
    final decoration = widget.groupHeaderDecoration;
    final textStyle =
        decoration.textStyle ??
        theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isFirst && decoration.showDivider) const Divider(height: 1),
        Container(
          color: decoration.backgroundColor,
          padding: decoration.padding,
          child: Text(label, style: textStyle),
        ),
      ],
    );
  }

  Widget _buildOption(DropdownItem<T> option, ThemeData theme) {
    if (widget.itemBuilder != null) {
      return Material(
        type: MaterialType.transparency,
        child: widget.itemBuilder!(
          option,
          widget.items.indexOf(option),
          () => widget.onItemTap(option),
        ),
      );
    }

    final disabledColor =
        widget.dropdownItemDecoration.disabledBackgroundColor ??
        widget.dropdownItemDecoration.backgroundColor?.withAlpha(100);

    final tileColor = option.disabled
        ? disabledColor
        : option.selected
        ? widget.dropdownItemDecoration.selectedBackgroundColor
        : widget.dropdownItemDecoration.backgroundColor;

    final trailing = option.disabled
        ? widget.dropdownItemDecoration.disabledIcon
        : option.selected
        ? AnimatedScale(
            scale: 1,
            duration: const Duration(milliseconds: 200),
            curve: Curves.elasticOut,
            child: widget.dropdownItemDecoration.selectedIcon,
          )
        : null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: tileColor ?? Colors.transparent,
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          title: Text(
            option.label,
            style: option.selected
                ? widget.dropdownItemDecoration.selectedTextStyle
                : widget.dropdownItemDecoration.textStyle,
          ),
          trailing: trailing,
          dense: true,
          autofocus: true,
          enabled: !option.disabled,
          selected: option.selected,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          focusColor: widget.dropdownItemDecoration.backgroundColor?.withAlpha(
            100,
          ),
          selectedColor:
              widget.dropdownItemDecoration.selectedTextColor ??
              theme.colorScheme.onSurface,
          textColor: option.disabled
              ? widget.dropdownItemDecoration.disabledTextColor ??
                    theme.disabledColor
              : widget.dropdownItemDecoration.textColor ??
                    theme.colorScheme.onSurface,
          tileColor: Colors.transparent,
          selectedTileColor: Colors.transparent,
          onTap: () {
            if (option.disabled) return;

            if (widget.singleSelect || !_reachedMaxSelection(option)) {
              widget.onItemTap(option);
              return;
            }
          },
        ),
      ),
    );
  }

  void _onSearchChange(String value) => widget.onSearchChange?.call(value);

  bool _reachedMaxSelection(DropdownItem<dynamic> option) {
    return !option.selected &&
        widget.maxSelections > 0 &&
        _selectedCount >= widget.maxSelections;
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField({
    required this.decoration,
    required this.onChanged,
    this.focusNode,
  });

  final SearchFieldDecoration decoration;

  final ValueChanged<String> onChanged;

  final FocusNode? focusNode;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _controller = TextEditingController();
  bool _hasText = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final currentHasText = _controller.text.isNotEmpty;
    if (currentHasText != _hasText) {
      setState(() {
        _hasText = currentHasText;
      });
    }
  }

  void _handleSearchChange(String value) {
    final debounceMs = widget.decoration.searchDebounceMs;
    if (debounceMs <= 0) {
      widget.onChanged(value);
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: debounceMs), () {
      widget.onChanged(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller
      ..removeListener(_onTextChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _controller,
        focusNode: widget.focusNode,
        autofocus: widget.decoration.autofocus,
        style: widget.decoration.textStyle,
        cursorColor: widget.decoration.cursorColor,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.decoration.hintText,
          hintStyle: widget.decoration.hintStyle,
          border: widget.decoration.border,
          focusedBorder: widget.decoration.focusedBorder,
          filled: widget.decoration.filled,
          fillColor: widget.decoration.fillColor,
          prefixIcon: widget.decoration.searchIcon,
          suffixIcon: widget.decoration.showClearIcon && _hasText
              ? IconButton(
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _controller.clear();
                    _debounce?.cancel();
                    widget.onChanged('');
                  },
                )
              : null,
        ),
        onChanged: _handleSearchChange,
      ),
    );
  }
}

class _DropdownBottomSheet extends StatefulWidget {
  const _DropdownBottomSheet({required this.builder});

  final Widget Function(BuildContext, ScrollController, FocusNode) builder;

  @override
  State<_DropdownBottomSheet> createState() => _DropdownBottomSheetState();
}

class _DropdownBottomSheetState extends State<_DropdownBottomSheet> {
  final _sheetController = DraggableScrollableController();
  final _searchFocusNode = FocusNode();
  double _keyboardInset = 0;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    if (inset != _keyboardInset) {
      _keyboardInset = inset;
      if (inset > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _expandForSearch();
        });
      }
    }
  }

  void _onSearchFocus() {
    if (_searchFocusNode.hasFocus) _expandForSearch();
  }

  void _expandForSearch() {
    if (!_sheetController.isAttached) return;
    _sheetController.animateTo(
      _keyboardInset > 0 ? 1 : 0.85,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocus);
    _searchFocusNode.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: _keyboardInset),
      child: DraggableScrollableSheet(
        controller: _sheetController,
        maxChildSize: _keyboardInset > 0 ? 1 : 0.85,
        expand: false,
        builder: (context, scrollController) => widget.builder(
          context,
          scrollController,
          _searchFocusNode,
        ),
      ),
    );
  }
}
