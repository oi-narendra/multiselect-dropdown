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

  static const Map<ShortcutActivator, Intent> _webShortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowDown): _ArrowDownIntent(),
    SingleActivator(LogicalKeyboardKey.arrowUp): _ArrowUpdIntent(),
  };

  @override
  State<_Dropdown<T>> createState() => _DropdownState<T>();
}

class _DropdownState<T> extends State<_Dropdown<T>> {
  int get _selectedCount =>
      widget.items.where((element) => element.selected).length;

  int _currentHighlight = 0;

  final ScrollController _scrollController = ScrollController();
  final key = GlobalKey();

  final _focusNodes = <FocusNode>[];

  @override
  void initState() {
    super.initState();
    _focusNodes.addAll(
      List.generate(
        widget.items.length,
        (_) => FocusNode(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final child = Material(
      elevation: widget.decoration.elevation,
      borderRadius: widget.decoration.borderRadius,
      clipBehavior: Clip.antiAlias,
      color: widget.decoration.backgroundColor,
      surfaceTintColor: widget.decoration.backgroundColor,
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: widget.decoration.borderRadius,
            color: widget.decoration.backgroundColor,
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
              Flexible(
                child: ListView.separated(
                  controller: _scrollController,
                  separatorBuilder: (_, __) =>
                      widget.itemSeparator ?? const SizedBox.shrink(),
                  shrinkWrap: true,
                  itemCount: widget.items.length,
                  itemBuilder: (_, int index) => _buildOption(index, theme),
                ),
              ),
              if (widget.items.isEmpty && widget.searchEnabled)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'No items found',
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
    );

    if (kIsWeb || Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      return Actions(
        actions: {
          _ArrowUpdIntent: CallbackAction<_ArrowUpdIntent>(
            onInvoke: (_ArrowUpdIntent _) {
              _currentHighlight = (_currentHighlight - 1) % widget.items.length;
              debugPrint('$_currentHighlight');
              while (widget.items[_currentHighlight].disabled) {
                _currentHighlight =
                    (_currentHighlight - 1) % widget.items.length;
              }
              _scrollToHighlightedItem();
              setState(() {});
              return null;
            },
          ),
          _ArrowDownIntent: CallbackAction<_ArrowDownIntent>(
            onInvoke: (_ArrowDownIntent _) {
              _currentHighlight = (_currentHighlight + 1) % widget.items.length;
              debugPrint('$_currentHighlight');
              while (widget.items[_currentHighlight].disabled) {
                _currentHighlight =
                    (_currentHighlight + 1) % widget.items.length;
              }
              _scrollToHighlightedItem();
              setState(() {});
              return null;
            },
          ),
        },
        child: Shortcuts(
          shortcuts: _Dropdown._webShortcuts,
          child: child,
        ),
      );
    }

    return child;
  }

  void _scrollToHighlightedItem() {
    // Scroll to the highlighted item
    _scrollController.animateTo(
      _currentHighlight * 40.0, // Hight of ink
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _focusNodes[_currentHighlight].requestFocus();
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
            ? widget.dropdownItemDecoration.selectedIcon
            : null;

    return Ink(
      key: index == 0 ? key : null,
      child: ListTile(
        focusNode: _focusNodes[index],
        title: Text(option.label),
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
        textColor: widget.dropdownItemDecoration.textColor ??
            theme.colorScheme.onSurface,
        tileColor: tileColor ?? Colors.transparent,
        selectedTileColor:
            widget.dropdownItemDecoration.selectedBackgroundColor ??
                Colors.grey.shade200,
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

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.decoration,
    required this.onChanged,
  });

  final SearchFieldDecoration decoration;

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: InputDecoration(
          isDense: true,
          hintText: decoration.hintText,
          border: decoration.border,
          focusedBorder: decoration.focusedBorder,
          suffixIcon: decoration.searchIcon,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _ArrowUpdIntent extends Intent {
  const _ArrowUpdIntent();
}

class _ArrowDownIntent extends Intent {
  const _ArrowDownIntent();
}
