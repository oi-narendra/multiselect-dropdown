import 'package:flutter/material.dart';

/// MultiSelect Controller class.
/// This class is used to control the state of the MultiSelectDropdown widget.
/// This is just base class. The implementation of this class is in the MultiSelectController class.
/// The implementation of this class is hidden from the user.

/// implementation of the MultiSelectController class.
class MultiSelectController<T> extends ChangeNotifier {
  MultiSelectController({
    List<T> disabledOptions = const [],
    List<T> options = const [],
    List<T> selectedOptions = const [],
  }) {
    _disabledOptions.addAll(disabledOptions);
    _options.addAll(options);
    _selectedOptions.addAll(selectedOptions);
  }

  final List<T> _disabledOptions = [];
  final List<T> _options = [];
  final List<T> _selectedOptions = [];

  /// return true if any item is selected.
  bool get anyItemSelected => selectedOptions.isNotEmpty;

  bool _isDropdownOpen = false;

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  /// set the dispose method.
  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }

  /// Clear the selected options.
  /// [MultiSelectController] is used to clear the selected options.
  void clearAllSelection() {
    _selectedOptions.clear();
    notifyListeners();
  }

  /// clear specific selected option
  /// [MultiSelectController] is used to clear specific selected option.
  void clearSelection(T option) {
    if (!_selectedOptions.contains(option)) return;

    if (_disabledOptions.contains(option)) {
      throw Exception('Cannot clear selection of a disabled option');
    }

    if (!_options.contains(option)) {
      throw Exception(
          'Cannot clear selection of an option that is not in the options list');
    }

    _selectedOptions.remove(option);
    notifyListeners();
  }

  /// select the options
  /// [MultiSelectController] is used to select the options.
  void setSelectedOptions(List<T> options) {
    if (options.any((element) => _disabledOptions.contains(element))) {
      throw Exception('Cannot select disabled options');
    }

    if (options.any((element) => !_options.contains(element))) {
      throw Exception('Cannot select options that are not in the options list');
    }

    _selectedOptions.clear();
    _selectedOptions.addAll(options);
    notifyListeners();
  }

  /// add selected option
  /// [MultiSelectController] is used to add selected option.
  void addSelectedOption(T option) {
    if (_disabledOptions.contains(option)) {
      throw Exception('Cannot select disabled option');
    }

    if (!_options.contains(option)) {
      throw Exception('Cannot select option that is not in the options list');
    }

    _selectedOptions.add(option);
    notifyListeners();
  }

  /// remove selected option
  /// [MultiSelectController] is used to remove selected option.
  void removeSelectedOption(T option) {
    if (!_selectedOptions.contains(option)) {
      throw Exception(
          'Cannot remove option that is not in the selected options list');
    }
    _selectedOptions.remove(option);
    notifyListeners();
  }

  /// set disabled options
  /// [MultiSelectController] is used to set disabled options.
  void setDisabledOptions(List<T> disabledOptions) {
    if (disabledOptions.any((element) => !_options.contains(element))) {
      throw Exception(
          'Cannot disable options that are not in the options list');
    }

    _disabledOptions.clear();
    _disabledOptions.addAll(disabledOptions);
    notifyListeners();
  }

  /// setDisabledOption method
  /// [MultiSelectController] is used to set disabled option.
  void setDisabledOption(T disabledOption) {
    if (!_options.contains(disabledOption)) {
      throw Exception('Cannot disable option that is not in the options list');
    }

    _disabledOptions.add(disabledOption);
    notifyListeners();
  }

  /// set options
  /// [MultiSelectController] is used to set options.
  void setOptions(List<T> options) {
    _options.clear();
    _options.addAll(options);
    notifyListeners();
  }

  /// get disabled options
  List<T> get disabledOptions => _disabledOptions;

  /// get enabled options
  List<T> get enabledOptions =>
      _options.where((element) => !_disabledOptions.contains(element)).toList();

  /// get options
  List<T> get options => _options;

  /// get selected options
  List<T> get selectedOptions => _selectedOptions;

  /// get is dropdown open
  bool get isDropdownOpen => _isDropdownOpen;
  set isDropdownOpen(bool value) {
    _isDropdownOpen = value;
    notifyListeners();
  }

  /// show dropdown
  /// [MultiSelectController] is used to show dropdown.
  void showDropdown() {
    if (_isDropdownOpen) return;
    _isDropdownOpen = true;
    notifyListeners();
  }

  /// hide dropdown
  /// [MultiSelectController] is used to hide dropdown.
  void hideDropdown() {
    if (!_isDropdownOpen) return;
    _isDropdownOpen = false;
    notifyListeners();
  }
}
