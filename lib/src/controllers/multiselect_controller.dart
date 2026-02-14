part of '../multi_dropdown.dart';

/// Controller for programmatically managing the [MultiDropdown] widget.
///
/// Provides methods to set, add, select, deselect, disable, and toggle
/// items as well as open/close the dropdown and manage search state.
///
/// ```dart
/// final controller = MultiSelectController<String>();
///
/// // Select items matching a condition
/// controller.selectWhere((item) => item.value == 'dart');
///
/// // Clear all selections
/// controller.clearAll();
/// ```
class MultiSelectController<T> extends ChangeNotifier {
  /// a flag to indicate whether the controller is initialized.
  bool _initialized = false;

  /// set initialized flag to true.
  void _initialize() {
    _initialized = true;
  }

  List<DropdownItem<T>> _items = [];

  List<DropdownItem<T>> _filteredItems = [];

  String _searchQuery = '';

  /// Gets the list of dropdown items.
  List<DropdownItem<T>> get items =>
      _searchQuery.isEmpty ? _items : _filteredItems;

  /// Gets the list of selected dropdown items.
  List<DropdownItem<T>> get selectedItems =>
      _items.where((element) => element.selected).toList();

  /// Get the list of selected dropdown item values.
  List<T> get _selectedValues => selectedItems.map((e) => e.value).toList();

  /// Gets the list of disabled dropdown items.
  List<DropdownItem<T>> get disabledItems =>
      _items.where((element) => element.disabled).toList();

  bool _open = false;

  /// Gets whether the dropdown is open.
  bool get isOpen => _open;

  bool _isDisposed = false;

  /// Gets whether the controller is disposed.
  bool get isDisposed => _isDisposed;

  /// on selection changed callback invoker.
  OnSelectionChanged<T>? _onSelectionChanged;

  /// on search changed callback invoker.
  OnSearchChanged? _onSearchChanged;

  /// Sets the list of dropdown items, replacing any existing items.
  ///
  /// Also resets the search query and filtered items.
  void setItems(List<DropdownItem<T>> options) {
    _items
      ..clear()
      ..addAll(options);
    // Reset the search query and filtered items when new items are set
    // to prevent stale search results.
    _searchQuery = '';
    _filteredItems = List.from(_items);
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// Adds a dropdown item to the list of dropdown items.
  /// The [index] parameter is optional, and if provided, the item will be inserted at the specified index.
  void addItem(DropdownItem<T> option, {int index = -1}) {
    if (index == -1) {
      _items.add(option);
    } else {
      _items.insert(index, option);
    }
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// Adds a list of dropdown items to the list of dropdown items.
  void addItems(List<DropdownItem<T>> options) {
    _items.addAll(options);
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// Clears all the selected items.
  void clearAll() {
    _items = _items
        .map(
          (element) =>
              element.selected ? element.copyWith(selected: false) : element,
        )
        .toList();
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// Selects all the items.
  void selectAll() {
    _items = _items
        .map(
          (element) =>
              !element.selected ? element.copyWith(selected: true) : element,
        )
        .toList();
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// Selects the item at the specified [index].
  ///
  /// Does nothing if [index] is out of range, or the item is already selected or disabled.
  void selectAtIndex(int index) {
    if (index < 0 || index >= _items.length) return;

    final item = _items[index];

    if (item.disabled || item.selected) return;

    selectWhere((element) => element == _items[index]);
  }

  /// Toggles the selection state of items matching the [predicate].
  ///
  /// Items that match the predicate and are currently selected will be
  /// deselected, and vice versa.
  void toggleWhere(bool Function(DropdownItem<T> item) predicate) {
    _items = _items
        .map(
          (element) => predicate(element)
              ? element.copyWith(selected: !element.selected)
              : element,
        )
        .toList();
    if (_searchQuery.isNotEmpty) {
      _filteredItems = _items
          .where(
            (item) =>
                item.label.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// Selects items matching the [predicate].
  ///
  /// Only items that are not already selected will be updated.
  void selectWhere(bool Function(DropdownItem<T> item) predicate) {
    _items = _items
        .map(
          (element) => predicate(element) && !element.selected
              ? element.copyWith(selected: true)
              : element,
        )
        .toList();
    if (_searchQuery.isNotEmpty) {
      _filteredItems = _items
          .where(
            (item) =>
                item.label.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  void _toggleOnly(DropdownItem<T> item) {
    _items = _items
        .map(
          (element) => element == item
              ? element.copyWith(selected: !element.selected)
              : element.copyWith(selected: false),
        )
        .toList();

    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// Deselects items matching the [predicate].
  ///
  /// Only items that are currently selected will be updated.
  void unselectWhere(bool Function(DropdownItem<T> item) predicate) {
    _items = _items
        .map(
          (element) => predicate(element) && element.selected
              ? element.copyWith(selected: false)
              : element,
        )
        .toList();
    if (_searchQuery.isNotEmpty) {
      _filteredItems = _items
          .where(
            (item) =>
                item.label.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// Disables items matching the [predicate].
  ///
  /// Disabled items cannot be selected or deselected by the user.
  void disableWhere(bool Function(DropdownItem<T> item) predicate) {
    _items = _items
        .map(
          (element) => predicate(element) && !element.disabled
              ? element.copyWith(disabled: true)
              : element,
        )
        .toList();
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// Opens the dropdown overlay, if it is not already open.
  void openDropdown() {
    if (_open) return;

    _open = true;
    notifyListeners();
  }

  /// Closes the dropdown overlay, if it is not already closed.
  void closeDropdown() {
    if (!_open) return;

    _open = false;
    notifyListeners();
  }

  // Using a method instead of a setter to maintain a consistent cascade-style
  // API when called with other methods (e.g., controller.._initialize().._setOnSelectionChange()).
  // ignore: use_setters_to_change_properties
  void _setOnSelectionChange(OnSelectionChanged<T>? onSelectionChanged) {
    _onSelectionChanged = onSelectionChanged;
  }

  // Using a method instead of a setter to maintain a consistent cascade-style
  // API when called with other methods (e.g., controller.._initialize().._setOnSearchChange()).
  // ignore: use_setters_to_change_properties
  void _setOnSearchChange(OnSearchChanged? onSearchChanged) {
    _onSearchChanged = onSearchChanged;
  }

  // sets the search query.
  // The [query] parameter is the search query.
  void _setSearchQuery(String query) {
    _searchQuery = query;
    if (_searchQuery.isEmpty) {
      _filteredItems = List.from(_items);
    } else {
      _filteredItems = _items
          .where(
            (item) =>
                item.label.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    _onSearchChanged?.call(query);
    notifyListeners();
  }

  // clears the search query.
  void _clearSearchQuery({bool notify = false}) {
    _searchQuery = '';
    _filteredItems = List.from(_items);
    if (notify) notifyListeners();
  }

  /// Clears the current search query and resets the filtered items.
  ///
  /// This is useful when you want to programmatically clear the search
  /// field and show all items again.
  void clearSearch() {
    _clearSearchQuery(notify: true);
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    super.dispose();
    _isDisposed = true;
  }

  @override
  String toString() {
    return 'MultiSelectController(options: $_items, open: $_open)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiSelectController<T> &&
        listEquals(other._items, _items) &&
        other._open == _open;
  }

  @override
  int get hashCode => _items.hashCode ^ _open.hashCode;
}
