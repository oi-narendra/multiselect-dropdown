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
    Key? key,
    this.onSearchChange,
    this.itemBuilder,
    this.itemSeparator,
    this.singleSelect = false,
  }) : super(key: key);

  /// The decoration of the dropdown.
  final DropdownDecoration decoration;

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

  @override
  State<_Dropdown<T>> createState() => _DropdownState<T>();
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
    SingleActivator(LogicalKeyboardKey.arrowDown):
        DirectionalFocusIntent(TraversalDirection.down),
    SingleActivator(LogicalKeyboardKey.arrowUp):
        DirectionalFocusIntent(TraversalDirection.up),
  };

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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.decoration.animationCurve,
      ),
    );
    unawaited(_animationController.forward());
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
          borderRadius: widget.decoration.borderRadius,
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
                maxHeight: widget.decoration.maxHeight,
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
                  if (widget.items.isNotEmpty)
                    Flexible(
                      child: ListView.separated(
                        separatorBuilder: (_, __) =>
                            widget.itemSeparator ?? const SizedBox.shrink(),
                        shrinkWrap: true,
                        padding: widget.decoration.listPadding ??
                            EdgeInsets.zero,
                        itemCount: widget.items.length,
                        itemBuilder: (_, index) => _buildOption(index, theme),
                      ),
                    ),
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

    if (kIsWeb || Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      return Shortcuts(shortcuts: _webShortcuts, child: child);
    }

    return child;
  }

  Widget _buildOption(int index, ThemeData theme) {
    final option = widget.items[index];

    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(option, index, () => widget.onItemTap(option));
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
        focusColor:
            widget.dropdownItemDecoration.backgroundColor?.withAlpha(100),
        selectedColor: widget.dropdownItemDecoration.selectedTextColor ??
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
  });

  final SearchFieldDecoration decoration;

  final ValueChanged<String> onChanged;

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
              ? Tooltip(
                  message: 'Clear search',
                  child: IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _controller.clear();
                      _debounce?.cancel();
                      widget.onChanged('');
                    },
                  ),
                )
              : null,
        ),
        onChanged: _handleSearchChange,
      ),
    );
  }
}
