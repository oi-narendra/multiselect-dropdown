# MultiSelect Dropdown

[![Pub Version](https://img.shields.io/pub/v/multi_dropdown)](https://pub.dev/packages/multi_dropdown)
[![License](https://img.shields.io/github/license/oi-narendra/multiselect-dropdown)](https://github.com/oi-narendra/multiselect-dropdown/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/oi-narendra/multiselect-dropdown)](https://img.shields.io/github/issues/oi-narendra/multiselect-dropdown)
[![Very Good Analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)

A powerful and highly customizable multi-select dropdown widget for Flutter. Supports single & multi-select, search, form validation, programmatic control, and extensive visual customization.

## Preview

[<img src="https://raw.githubusercontent.com/oi-narendra/multiselect-dropdown/develop/screenshots/screenshot_1.png" width="250" alt=""/>](screenshot_1.png)
[<img src="https://raw.githubusercontent.com/oi-narendra/multiselect-dropdown/develop/screenshots/screenshot_2.png" width="250" alt=""/>](screenshot_2.png)
[<img src="https://raw.githubusercontent.com/oi-narendra/multiselect-dropdown/develop/screenshots/screenshot_3.png" width="250" alt="">](screenshot_3.png)
[<img src="https://raw.githubusercontent.com/oi-narendra/multiselect-dropdown/develop/screenshots/screenshot_4.png" width="250" alt=""/>](screenshot_4.png)

## Features

- ✅ Multi-select & single-select modes
- ✅ Searchable dropdown with customizable search field
- ✅ Form validation support with `autovalidateMode`
- ✅ Programmatic control via `MultiSelectController`
- ✅ Async data loading with `MultiDropdown.future()`
- ✅ Extensive decoration classes (chips, field, dropdown, items, search)
- ✅ Pre-selected & disabled items
- ✅ Max selection limit with `maxSelections`
- ✅ Chip overflow control with `maxDisplayCount`
- ✅ Custom item builders & selected item builders
- ✅ Header & footer widgets in the dropdown
- ✅ Expand direction control (`auto`, `up`, `down`)
- ✅ Close on back button support
- ✅ Full `InputDecoration` override for form consistency

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  multi_dropdown: ^3.1.0
```

## Quick Start

### Basic Multi-Select

```dart
MultiDropdown<String>(
  items: [
    DropdownItem(label: 'Australia', value: 'AU'),
    DropdownItem(label: 'Canada', value: 'CA'),
    DropdownItem(label: 'India', value: 'IN'),
    DropdownItem(label: 'United States', value: 'US'),
  ],
  onSelectionChange: (selectedItems) {
    debugPrint('Selected: $selectedItems');
  },
);
```

### Single Select

```dart
MultiDropdown<String>(
  items: items,
  singleSelect: true,
  fieldDecoration: FieldDecoration(
    hintText: 'Choose a role',
    suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
  ),
  onSelectionChange: (values) {
    debugPrint('Selected: ${values.first}');
  },
);
```

### Searchable Dropdown

```dart
MultiDropdown<String>(
  items: items,
  searchEnabled: true,
  searchDecoration: SearchFieldDecoration(
    hintText: 'Type to search...',
  ),
);
```

### With Form Validation

```dart
MultiDropdown<String>(
  items: items,
  maxSelections: 4,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  validator: (selectedItems) {
    if (selectedItems == null || selectedItems.isEmpty) {
      return 'Please select at least one item';
    }
    return null;
  },
);
```

### Async Data Loading

```dart
MultiDropdown<int>.future(
  future: () async {
    final response = await http.get(Uri.parse('https://api.example.com/users'));
    final data = jsonDecode(response.body) as List;
    return data.map((e) => DropdownItem(
      label: e['name'] as String,
      value: e['id'] as int,
    )).toList();
  },
);
```

## Controller

Use `MultiSelectController` to programmatically control the dropdown:

```dart
final controller = MultiSelectController<String>();

controller.setItems(items);       // Set/replace items
controller.addItem(item);         // Add a single item
controller.addItems(items);       // Add multiple items

controller.selectAll();           // Select all items
controller.clearAll();            // Deselect all items
controller.selectAtIndex(0);      // Select item at index
controller.selectWhere((i) => i.value == 'dart');   // Select by predicate
controller.unselectWhere((i) => i.value == 'dart'); // Deselect by predicate
controller.toggleWhere((i) => i.value == 'dart');   // Toggle by predicate
controller.disableWhere((i) => i.value == 'admin'); // Disable by predicate

controller.openDropdown();        // Open the dropdown
controller.closeDropdown();       // Close the dropdown
controller.clearSearch();         // Clear search query

controller.items;                 // All items
controller.selectedItems;         // Selected items
controller.disabledItems;         // Disabled items
controller.isOpen;                // Dropdown open state
```

## Examples

The [example app](example/) contains **8 dedicated examples**, each in its own file:

| Example                   | File                                                                                | Description                                          |
| ------------------------- | ----------------------------------------------------------------------------------- | ---------------------------------------------------- |
| 🌍 **Country Picker**     | [`basic_example.dart`](example/lib/examples/basic_example.dart)                     | Multi-select with flag emojis and chip wrapping      |
| 🎯 **Task Priority**      | [`single_select_example.dart`](example/lib/examples/single_select_example.dart)     | Single-select with color-coded result card           |
| 👥 **Team Members**       | [`searchable_example.dart`](example/lib/examples/searchable_example.dart)           | Search with custom `itemBuilder` (avatars)           |
| 🏷️ **Issue Labels**       | [`custom_style_example.dart`](example/lib/examples/custom_style_example.dart)       | Color-coded chips, `maxDisplayCount`, disabled items |
| 🍳 **Recipe Ingredients** | [`controller_example.dart`](example/lib/examples/controller_example.dart)           | All `MultiSelectController` methods                  |
| 💼 **Job Application**    | [`form_validation_example.dart`](example/lib/examples/form_validation_example.dart) | Form validation, `maxSelections`, submit flow        |
| 🌐 **Async Loading**      | [`future_example.dart`](example/lib/examples/future_example.dart)                   | `MultiDropdown.future()` with loading spinner        |
| ♿ **Accessibility**      | [`accessibility_example.dart`](example/lib/examples/accessibility_example.dart)     | Font scaling slider, high contrast, `Semantics`      |

Run the example:

```bash
cd example
flutter run
```

## API Reference

### MultiDropdown

| Parameter              | Type                        | Description                          | Default                    |
| ---------------------- | --------------------------- | ------------------------------------ | -------------------------- |
| items                  | `List<DropdownItem<T>>`     | The list of dropdown items           | Required                   |
| singleSelect           | `bool`                      | Single-select mode                   | `false`                    |
| chipDecoration         | `ChipDecoration`            | Chip styling configuration           | `ChipDecoration()`         |
| fieldDecoration        | `FieldDecoration`           | Field styling configuration          | `FieldDecoration()`        |
| dropdownDecoration     | `DropdownDecoration`        | Dropdown panel configuration         | `DropdownDecoration()`     |
| searchDecoration       | `SearchFieldDecoration`     | Search field configuration           | `SearchFieldDecoration()`  |
| dropdownItemDecoration | `DropdownItemDecoration`    | Item styling configuration           | `DropdownItemDecoration()` |
| itemBuilder            | `DropdownItemBuilder<T>?`   | Custom item widget builder           | `null`                     |
| selectedItemBuilder    | `SelectedItemBuilder<T>?`   | Custom selected item builder         | `null`                     |
| itemSeparator          | `Widget?`                   | Separator between items              | `null`                     |
| validator              | `String? Function(...)`     | Form validation callback             | `null`                     |
| autovalidateMode       | `AutovalidateMode`          | When to auto-validate                | `.disabled`                |
| controller             | `MultiSelectController<T>?` | Programmatic controller              | `null`                     |
| maxSelections          | `int`                       | Max selectable items (0 = unlimited) | `0`                        |
| enabled                | `bool`                      | Whether the dropdown is enabled      | `true`                     |
| searchEnabled          | `bool`                      | Whether search is enabled            | `false`                    |
| focusNode              | `FocusNode?`                | Custom focus node                    | `null`                     |
| future                 | `FutureRequest<T>?`         | Async item loading                   | `null`                     |
| onSelectionChange      | `OnSelectionChanged<T>?`    | Selection change callback            | `null`                     |
| onSearchChange         | `ValueChanged<String>?`     | Search text change callback          | `null`                     |
| closeOnBackButton      | `bool`                      | Close on back button press           | `false`                    |

### DropdownItem

| Parameter | Type     | Description                  | Default  |
| --------- | -------- | ---------------------------- | -------- |
| label     | `String` | Display label                | Required |
| value     | `T`      | Associated value             | Required |
| disabled  | `bool`   | Whether item is disabled     | `false`  |
| selected  | `bool`   | Whether item is pre-selected | `false`  |

### ChipDecoration

| Parameter       | Type                   | Description                         | Default                                             |
| --------------- | ---------------------- | ----------------------------------- | --------------------------------------------------- |
| deleteIcon      | `Widget?`              | Chip delete icon                    | `Icon(Icons.close)`                                 |
| backgroundColor | `Color?`               | Chip background color               | `Color(0xFFE0E0E0)`                                 |
| labelStyle      | `TextStyle?`           | Chip label text style               | `null`                                              |
| padding         | `EdgeInsets`           | Chip padding                        | `EdgeInsets.symmetric(horizontal: 12, vertical: 4)` |
| border          | `BoxBorder`            | Chip border                         | `Border()`                                          |
| spacing         | `double`               | Spacing between chips               | `8.0`                                               |
| runSpacing      | `double`               | Spacing between chip rows           | `12.0`                                              |
| borderRadius    | `BorderRadiusGeometry` | Chip border radius                  | `BorderRadius.circular(12)`                         |
| wrap            | `bool`                 | Wrap chips or scroll horizontally   | `true`                                              |
| maxDisplayCount | `int?`                 | Max visible chips (shows "+N more") | `null`                                              |

### FieldDecoration

| Parameter             | Type               | Description                              | Default                                             |
| --------------------- | ------------------ | ---------------------------------------- | --------------------------------------------------- |
| labelText             | `String?`          | Label text above the field               | `null`                                              |
| hintText              | `String?`          | Hint text in the field                   | `'Select'`                                          |
| border                | `InputBorder?`     | Field border                             | `null`                                              |
| focusedBorder         | `InputBorder?`     | Border when focused                      | `null`                                              |
| disabledBorder        | `InputBorder?`     | Border when disabled                     | `null`                                              |
| errorBorder           | `InputBorder?`     | Border on validation error               | `null`                                              |
| suffixIcon            | `Widget?`          | Trailing icon                            | `Icon(Icons.arrow_drop_down)`                       |
| prefixIcon            | `Widget?`          | Leading icon                             | `null`                                              |
| labelStyle            | `TextStyle?`       | Label text style                         | `null`                                              |
| hintStyle             | `TextStyle?`       | Hint text style                          | `null`                                              |
| borderRadius          | `double`           | Border radius                            | `12.0`                                              |
| animateSuffixIcon     | `bool`             | Animate suffix icon rotation             | `true`                                              |
| padding               | `EdgeInsets?`      | Content padding                          | `EdgeInsets.symmetric(horizontal: 12, vertical: 8)` |
| backgroundColor       | `Color?`           | Background fill color                    | `null`                                              |
| showClearIcon         | `bool`             | Show clear/deselect icon                 | `true`                                              |
| selectedItemTextStyle | `TextStyle?`       | Selected item text style (single-select) | `null`                                              |
| inputDecoration       | `InputDecoration?` | Full InputDecoration override            | `null`                                              |

### DropdownDecoration

| Parameter        | Type              | Description                     | Default                     |
| ---------------- | ----------------- | ------------------------------- | --------------------------- |
| backgroundColor  | `Color`           | Dropdown background color       | `Colors.white`              |
| elevation        | `double`          | Dropdown elevation              | `1.0`                       |
| maxHeight        | `double`          | Maximum dropdown height         | `400.0`                     |
| borderRadius     | `BorderRadius`    | Dropdown border radius          | `BorderRadius.circular(12)` |
| marginTop        | `double`          | Gap between field and dropdown  | `0.0`                       |
| header           | `Widget?`         | Header widget inside dropdown   | `null`                      |
| footer           | `Widget?`         | Footer widget inside dropdown   | `null`                      |
| noItemsFoundText | `String`          | Text when no items match search | `'No items found'`          |
| expandDirection  | `ExpandDirection` | Dropdown expand direction       | `ExpandDirection.auto`      |

### SearchFieldDecoration

| Parameter     | Type           | Description                    | Default                   |
| ------------- | -------------- | ------------------------------ | ------------------------- |
| hintText      | `String`       | Search hint text               | `'Search'`                |
| border        | `InputBorder?` | Search field border            | `OutlineInputBorder(...)` |
| focusedBorder | `InputBorder?` | Border when focused            | `OutlineInputBorder(...)` |
| searchIcon    | `Icon`         | Search icon                    | `Icon(Icons.search)`      |
| textStyle     | `TextStyle?`   | Search input text style        | `null`                    |
| hintStyle     | `TextStyle?`   | Search hint text style         | `null`                    |
| fillColor     | `Color?`       | Search field fill color        | `null`                    |
| filled        | `bool?`        | Whether search field is filled | `null`                    |
| cursorColor   | `Color?`       | Cursor color                   | `null`                    |
| showClearIcon | `bool`         | Show clear button in search    | `true`                    |
| autofocus     | `bool`         | Auto-focus search on open      | `false`                   |

### DropdownItemDecoration

| Parameter               | Type         | Description                    | Default             |
| ----------------------- | ------------ | ------------------------------ | ------------------- |
| backgroundColor         | `Color?`     | Item background color          | `null`              |
| disabledBackgroundColor | `Color?`     | Disabled item background color | `null`              |
| selectedBackgroundColor | `Color?`     | Selected item background color | `null`              |
| selectedTextColor       | `Color?`     | Selected item text color       | `null`              |
| textColor               | `Color?`     | Item text color                | `null`              |
| disabledTextColor       | `Color?`     | Disabled item text color       | `null`              |
| selectedIcon            | `Widget?`    | Selected item trailing icon    | `Icon(Icons.check)` |
| disabledIcon            | `Widget?`    | Disabled item trailing icon    | `null`              |
| textStyle               | `TextStyle?` | Item label text style          | `null`              |
| selectedTextStyle       | `TextStyle?` | Selected item label text style | `null`              |

## Migration from v2.x

See the [CHANGELOG](CHANGELOG.md) for details on breaking changes in v3.0.0.

Key changes:

- `MultiSelectDropDown` → `MultiDropdown`
- `ValueItem` → `DropdownItem`
- `.network()` → `.future()`
- `onOptionsSelected` → `onSelectionChange`

## License

[MIT License](LICENSE)
