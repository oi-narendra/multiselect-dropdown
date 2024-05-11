part of '../multi_dropdown.dart';

/// Controller for the multiselect dropdown.
class MultiSelectController<T> extends ChangeNotifier {
  List<DropdownItem<T>> _items = [];

  /// Gets the list of dropdown items.
  List<DropdownItem<T>> get items => _items;

  /// Gets the list of selected dropdown items.
  List<DropdownItem<T>> get selectedItems =>
      _items.where((element) => element.selected).toList();

  /// Get the list of selected dropdown item values.
  List<T> _selectedValues() => selectedItems.map((e) => e.value).toList();

  /// Gets the list of disabled dropdown items.
  List<DropdownItem<T>> get disabledItems =>
      _items.where((element) => element.disabled).toList();

  bool _open = false;

  /// Gets whether the dropdown is open.
  bool get isOpen => _open;

  bool _isDisposed = false;

  /// Gets whether the controller is disposed.
  bool get isDisposed => _isDisposed;

  /// sets the list of dropdown items.
  /// It replaces the existing list of dropdown items.
  void setItems(List<DropdownItem<T>> options) {
    _items
      ..clear()
      ..addAll(options);
    notifyListeners();
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
  }

  /// Adds a list of dropdown items to the list of dropdown items.
  void addItems(List<DropdownItem<T>> options) {
    _items.addAll(options);
    notifyListeners();
  }

  /// clears all the selected items.
  void clearAll() {
    _items = _items
        .map(
          (element) =>
              element.selected ? element.copyWith(selected: false) : element,
        )
        .toList();
    notifyListeners();
  }

  /// selects all the items.
  void selectAll() {
    _items = _items
        .map(
          (element) =>
              !element.selected ? element.copyWith(selected: true) : element,
        )
        .toList();
    notifyListeners();
  }

  /// select the item at the specified index.
  ///
  /// The [index] parameter is the index of the item to select.
  void selectAtIndex(int index) {
    if (index < 0 || index >= _items.length) return;

    final item = _items[index];

    if (item.disabled || item.selected) return;

    selectWhere((element) => element == _items[index]);
  }

  /// deselects all the items.
  void toggleWhere(bool Function(DropdownItem<T> item) predicate) {
    _items = _items
        .map(
          (element) => predicate(element)
              ? element.copyWith(selected: !element.selected)
              : element,
        )
        .toList();
    notifyListeners();
  }

  /// selects the items that satisfy the predicate.
  ///
  /// The [predicate] parameter is a function that takes a [DropdownItem] and returns a boolean.
  void selectWhere(bool Function(DropdownItem<T> item) predicate) {
    _items = _items
        .map(
          (element) => predicate(element) && !element.selected
              ? element.copyWith(selected: true)
              : element,
        )
        .toList();
    notifyListeners();
  }

  void _toggleOnly(DropdownItem<T> item) {
    _items = _items
        .map(
          (element) => element == item
              ? element.copyWith(selected: !element.selected)
              : element.copyWith(selected: false),
        )
        .toList();

    debugPrint('items: $_items');
    notifyListeners();
  }

  /// deselects the items that satisfy the predicate.
  ///
  /// The [predicate] parameter is a function that takes a [DropdownItem] and returns a boolean.
  void deselectWhere(bool Function(DropdownItem<T> item) predicate) {
    _items = _items
        .map(
          (element) => predicate(element) && element.selected
              ? element.copyWith(selected: false)
              : element,
        )
        .toList();
    notifyListeners();
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
  }

  /// shows the dropdown, if it is not already open.
  void show() {
    if (_open) return;

    _open = true;
    notifyListeners();
  }

  /// hides the dropdown, if it is not already closed.
  void hide() {
    if (!_open) return;

    _open = false;
    notifyListeners();
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
