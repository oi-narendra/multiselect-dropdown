part of '../multi_dropdown.dart';

/// Dropdown widget for the multiselect dropdown.
///
class _Dropdown<T> extends StatelessWidget {
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
    required this.scrollController,
    required this.loadingController,
    required this.handleFuture,
    required this.dropdownController,
    Key? key,
    this.onSearchChange,
    this.itemBuilder,
    this.itemSeparator,
    this.singleSelect = false,
    this.searchEditingController,
    this.debounce = const Duration(milliseconds: 250),
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

  /// Menu scroll controller
  final ScrollController scrollController;

  /// Search debounce duration
  final Duration? debounce;

  /// Search controller
  final TextEditingController? searchEditingController;

  /// Dropdown controller for interactions
  final MultiSelectController<T> dropdownController;

  final _FutureController loadingController;

  final void Function() handleFuture;

  static const Map<ShortcutActivator, Intent> _webShortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowDown):
        DirectionalFocusIntent(TraversalDirection.down),
    SingleActivator(LogicalKeyboardKey.arrowUp):
        DirectionalFocusIntent(TraversalDirection.up),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final child = Material(
      elevation: decoration.elevation,
      borderRadius: decoration.borderRadius,
      clipBehavior: Clip.antiAlias,
      color: decoration.backgroundColor,
      surfaceTintColor: decoration.backgroundColor,
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: decoration.borderRadius,
            color: decoration.backgroundColor,
            backgroundBlendMode: BlendMode.dstATop,
          ),
          constraints: BoxConstraints(
            maxWidth: width,
            maxHeight: decoration.maxHeight,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (searchEnabled)
                _SearchField(
                  decoration: searchDecoration,
                  onChanged: _onSearchChange,
                  debounce: debounce,
                  searchEditingController: searchEditingController,
                ),
              if (decoration.header != null)
                Flexible(child: decoration.header!),
              Flexible(
                child: NotificationListener(
                  onNotification: (notif) {
                    if (notif is ScrollEndNotification &&
                        !loadingController.value) {
                      if (scrollController.position.pixels ==
                          scrollController.position.maxScrollExtent) {
                        handleFuture();
                      }
                    }
                    return true;
                  },
                  child: ListView.separated(
                    controller: scrollController,
                    separatorBuilder: (_, __) =>
                        itemSeparator ?? const SizedBox.shrink(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (_, int index) => _buildOption(index, theme),
                  ),
                ),
              ),
              if (items.isEmpty && searchEnabled)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'No items found',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              if (decoration.footer != null)
                Flexible(child: decoration.footer!),
            ],
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
    final option = items[index];

    if (itemBuilder != null) {
      return itemBuilder!(
        option,
        index,
        () => onItemTap(option),
        dropdownController.isItemSelected(option),
      );
    }

    final disabledColor = dropdownItemDecoration.disabledBackgroundColor ??
        dropdownItemDecoration.backgroundColor?.withAlpha(100);

    final tileColor = option.disabled
        ? disabledColor
        : dropdownController.isItemSelected(option)
            ? dropdownItemDecoration.selectedBackgroundColor
            : dropdownItemDecoration.backgroundColor;

    final trailing = option.disabled
        ? dropdownItemDecoration.disabledIcon
        : dropdownController.isItemSelected(option)
            ? dropdownItemDecoration.selectedIcon
            : null;

    return Ink(
      child: ListTile(
        title: Text(option.label),
        trailing: trailing,
        dense: true,
        autofocus: true,
        enabled: !option.disabled,
        selected: dropdownController.isItemSelected(option),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        focusColor: dropdownItemDecoration.backgroundColor?.withAlpha(100),
        selectedColor: dropdownItemDecoration.selectedTextColor ??
            theme.colorScheme.onSurface,
        textColor:
            dropdownItemDecoration.textColor ?? theme.colorScheme.onSurface,
        tileColor: tileColor ?? Colors.transparent,
        selectedTileColor: dropdownItemDecoration.selectedBackgroundColor ??
            Colors.grey.shade200,
        onTap: () {
          if (option.disabled) return;

          if (singleSelect || !_reachedMaxSelection(option)) {
            onItemTap(option);
            return;
          }
        },
      ),
    );
  }

  void _onSearchChange(String value) => onSearchChange?.call(value);

  bool _reachedMaxSelection(DropdownItem<T> option) {
    return !dropdownController.isItemSelected(option) &&
        maxSelections > 0 &&
        dropdownController.selectedItems.length >= maxSelections;
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField({
    required this.decoration,
    required this.onChanged,
    required this.debounce,
    required this.searchEditingController,
  });

  final SearchFieldDecoration decoration;

  final ValueChanged<String> onChanged;

  final Duration? debounce;

  final TextEditingController? searchEditingController;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: widget.searchEditingController,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.decoration.hintText,
          border: widget.decoration.border,
          focusedBorder: widget.decoration.focusedBorder,
          suffixIcon: widget.decoration.searchIcon,
        ),
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce =
              Timer(widget.debounce ?? const Duration(milliseconds: 250), () {
            widget.onChanged(value);
          });
        },
      ),
    );
  }
}
