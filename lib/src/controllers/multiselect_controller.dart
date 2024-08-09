part of '../multi_dropdown.dart';

/// Controller for the multiselect dropdown.
class MultiSelectController<T> extends ChangeNotifier {
  List<DropdownItem<T>> _items = [];

  List<DropdownItem<T>> _filteredItems = [];

  List<DropdownItem<T>> _selectedItems = [];

  String _searchQuery = '';

  /// Current page number for lazy loading scroll
  int page = 1;

  /// Gets the list of dropdown items.
  List<DropdownItem<T>> get items =>
      _searchQuery.isEmpty ? _items : _filteredItems;

  /// Gets the list of selected dropdown items.
  List<DropdownItem<T>> get selectedItems => _selectedItems;

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

  ///return true if item is selected
  bool isItemSelected(DropdownItem<T> item) {
    return _selectedItems.contains(item);
  }

  /// sets the list of dropdown items.
  /// It replaces the existing list of dropdown items.
  void setItems(List<DropdownItem<T>> options) {
    _items
      ..clear()
      ..addAll(options);
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

  /// clears all the selected items.
  void clearAll() {
    _selectedItems.clear();
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// selects all the items.
  void selectAll() {
    _selectedItems = items;
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// select the item at the specified index.
  ///
  /// The [index] parameter is the index of the item to select.
  void selectAtIndex(int index) {
    if (index < 0 || index >= _items.length) return;

    final item = _items[index];

    if (item.disabled || _selectedItems.contains(item)) return;

    selectWhere((element) => element == _items[index]);
  }

  /// deselects all the items.
  void toggleWhere(bool Function(DropdownItem<T> item) predicate) {
    for (final item in _items) {
      if (predicate(item)) {
        if (_selectedItems.contains(item)) {
          _selectedItems.remove(item);
        } else {
          _selectedItems.add(item);
        }
      }
    }
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// selects the items that satisfy the predicate.
  ///
  /// The [predicate] parameter is a function that takes a [DropdownItem] and returns a boolean.
  void selectWhere(bool Function(DropdownItem<T> item) predicate) {
    _selectedItems =
        _items.where((currentItem) => predicate(currentItem)).toList();
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  void _toggleOnly(DropdownItem<T> item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
    } else {
      _selectedItems.add(item);
    }
    debugPrint('items: $_items');
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// unselects the items that satisfy the predicate.
  ///
  /// The [predicate] parameter is a function that takes a [DropdownItem] and returns a boolean.
  void unselectWhere(bool Function(DropdownItem<T> item) predicate) {
    for (final item in _items) {
      if (predicate(item)) {
        _selectedItems.remove(item);
      }
    }
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// disables the items that satisfy the predicate.
  ///
  /// The [predicate] parameter is a function that takes a [DropdownItem] and returns a boolean.
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

  /// shows the dropdown, if it is not already open.
  void openDropdown() {
    if (_open) return;

    _open = true;
    notifyListeners();
  }

  /// hides the dropdown, if it is not already closed.
  void closeDropdown() {
    if (!_open) return;

    _open = false;
    notifyListeners();
  }

  // ignore: use_setters_to_change_properties
  void _setOnSelectionChange(OnSelectionChanged<T>? onSelectionChanged) {
    this._onSelectionChanged = onSelectionChanged;
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
    notifyListeners();
  }

  // clears the search query.
  void _clearSearchQuery({bool notify = false}) {
    _searchQuery = '';
    if (notify) notifyListeners();
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
