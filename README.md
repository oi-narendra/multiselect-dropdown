[![Pub Version](https://img.shields.io/pub/v/multi_dropdown)](https://pub.dev/packages/multi_dropdown)
[![License](https://img.shields.io/github/license/oi-narendra/anydrawer)](https://github.com/oi-narendra/anydrawer/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/oi-narendra/multiselect-dropdown)]()
[![Very Good Analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)

The MultiSelect Dropdown for Flutter is a powerful and customizable widget that empowers you to effortlessly manage and search through multiple items in a dropdown list. Whether you're selecting multiple options for filtering data or picking various preferences, this package provides a seamless user experience. It also supports fetching the data from a URL.

## Links

[Preview](#preview) | [Features](#features) | [Getting started](#getting-started) | [Example](#example) | [Controller](#controller) | [Parameters](#parameters) | [Usage With Form Validation](#usage-with-form-validation) | [License](#license)

## Preview

`Selection mode: single`

```dart
 MultiSelectDropDown<int>(
              onOptionSelected: (List<ValueItem> selectedOptions) {},
              options: const <ValueItem>[
                ValueItem(label: 'Option 1', value: 1),
                ValueItem(label: 'Option 2', value: 2),
                ValueItem(label: 'Option 3', value: 3),
                ValueItem(label: 'Option 4', value: 4),
                ValueItem(label: 'Option 5', value: 5),
                ValueItem(label: 'Option 6', value: 6),
              ],
              selectionType: SelectionType.single,
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              dropdownHeight: 300,
              optionTextStyle: const TextStyle(fontSize: 16),
              selectedOptionIcon: const Icon(Icons.check_circle),
            ),
```

[<img src="https://raw.githubusercontent.com/oi-narendra/multiselect-dropdown/main/screenshots/sample1.png" width="300"/>](sample1.png)

`Selection mode: multiple`

```dart
 MultiSelectDropDown(
              showClearIcon: true,
              controller: _controller,
              onOptionSelected: (options) {
                debugPrint(options.toString());
              },
              options: const <ValueItem>[
                ValueItem(label: 'Option 1', value: '1'),
                ValueItem(label: 'Option 2', value: '2'),
                ValueItem(label: 'Option 3', value: '3'),
                ValueItem(label: 'Option 4', value: '4'),
                ValueItem(label: 'Option 5', value: '5'),
                ValueItem(label: 'Option 6', value: '6'),
              ],
              maxItems: 2,
              disabledOptions: const [ValueItem(label: 'Option 1', value: '1')],
              selectionType: SelectionType.multi,
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              dropdownHeight: 300,
              optionTextStyle: const TextStyle(fontSize: 16),
              selectedOptionIcon: const Icon(Icons.check_circle),
            ),
```

[<img src="https://raw.githubusercontent.com/oi-narendra/multiselect-dropdown/main/screenshots/sample1.gif" width="300"/>](sample1.gif)
[<img src="https://raw.githubusercontent.com/oi-narendra/multiselect-dropdown/main/screenshots/sample2.gif" width="300"/>](sample2.gif)
[<img src="https://raw.githubusercontent.com/oi-narendra/multiselect-dropdown/main/screenshots/sample3.gif" width="300"/>](sample3.gif)

`Search`

[<img src="https://raw.githubusercontent.com/oi-narendra/multiselect-dropdown/main/screenshots/sample6.gif" width="300"/>](sample6.gif)

`Network Request`

```dart
MultiSelectDropDown.network(
              onOptionSelected: (options) {},
              networkConfig: NetworkConfig(
                url: 'https://jsonplaceholder.typicode.com/users',
                method: RequestMethod.get,
                headers: {
                  'Content-Type': 'application/json',
                },
              ),
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              responseParser: (response) {

                final list = (response as List<dynamic>).map((e) {
                  final item = e as Map<String, dynamic>;
                  return ValueItem(
                    label: item['name'],
                    value: item['id'].toString(),
                  );
                }).toList();

                return Future.value(list);
              },
              responseErrorBuilder: ((context, body) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Error fetching the data'),
                );
              }),
            )
```

[<img src="https://raw.githubusercontent.com/oi-narendra/multiselect-dropdown/main/screenshots/sample4.png" width="300"/>](sample4.png)
[<img src="https://raw.githubusercontent.com/oi-narendra/multiselect-dropdown/main/screenshots/sample5.png" width="300"/>](sample5.png)

## Features

- Allows you to select multiple/single items from a list.
- Allows to fetch the data from a URL.
- Shows the selected items as chips. You can customize the chip style.
- Disable the dropdown items.
- Preselect the dropdown items.
- Customize dropdown list items.
- Customize selected item builder.
- Customize dropdown field style.
- Callback when dropdown items are selected/unselected.
- Use controller to programmatically select/unselect items, clear the selection, and get the selected items, set disabled items, show/hide the dropdown.

## Getting started

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  multi_dropdown: ^latest_version
```

Run `flutter packages get`

## Example

```dart
import 'package:flutter/material.dart';
import 'package:multiselect_dropdown/multiselect_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
   MyHomePage({Key? key}) : super(key: key);

  final MultiSelectController _controller = MultiSelectController();

   @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('WRAP', style: _headerStyle),
            const SizedBox(
              height: 4,
            ),
            MultiSelectDropDown(
              controller: _controller,
              onOptionSelected: (List<ValueItem> selectedOptions) {},
              options: const <ValueItem>[
                ValueItem(label: 'Option 1', value: '1'),
                ValueItem(label: 'Option 2', value: '2'),
                ValueItem(label: 'Option 3', value: '3'),
                ValueItem(label: 'Option 4', value: '4'),
                ValueItem(label: 'Option 5', value: '5'),
                ValueItem(label: 'Option 6', value: '6'),
              ],
              selectionType: SelectionType.multi,
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              dropdownHeight: 300,
              optionTextStyle: const TextStyle(fontSize: 16),
              selectedOptionIcon: const Icon(Icons.check_circle),
            ),
             const SizedBox(
              height: 50,
            ),
            Wrap(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller.clearAllSelection();
                  },
                  child: const Text('CLEAR'),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    debugPrint(_controller.getSelectedOptions.toString());
                  },
                  child: const Text('Get Selected Options'),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.isDropdownOpen) {
                      _controller.hideDropdown();
                    } else {
                      _controller.showDropdown();
                    }
                  },
                  child: const Text('SHOW/HIDE DROPDOWN'),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const Text('SCROLL', style: _headerStyle),
            const SizedBox(
              height: 4,
            ),
            MultiSelectDropDown(
              onOptionSelected: (List<ValueItem> selectedOptions) {},
              options: const <ValueItem>[
                ValueItem(label: 'Option 1', value: '1'),
                ValueItem(label: 'Option 2', value: '2'),
                ValueItem(label: 'Option 3', value: '3'),
                ValueItem(label: 'Option 4', value: '4'),
                ValueItem(label: 'Option 5', value: '5'),
                ValueItem(label: 'Option 6', value: '6'),
              ],
              selectionType: SelectionType.multi,
              chipConfig: const ChipConfig(wrapType: WrapType.scroll),
              dropdownHeight: 300,
              optionTextStyle: const TextStyle(fontSize: 16),
              selectedOptionIcon: const Icon(Icons.check_circle),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text('FROM NETWORK', style: _headerStyle),
            const SizedBox(
              height: 4,
            ),
            MultiSelectDropDown.network(
              onOptionSelected: (options) {},
              networkConfig: NetworkConfig(
                url: 'https://jsonplaceholder.typicode.com/users',
                method: RequestMethod.get,
                headers: {
                  'Content-Type': 'application/json',
                },
              ),
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              responseParser: (response) {
                final list = (response as List<dynamic>).map((e) {
                  final item = e as Map<String, dynamic>;
                  return ValueItem(
                    label: item['name'],
                    value: item['id'].toString(),
                  );
                }).toList();

                return Future.value(list);
              },
              responseErrorBuilder: ((context, body) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Error fetching the data'),
                );
              }),
            ),
          ],
        ),
      ),
    ));
    }
}
```

## Usage with form Validation

See example [here](https://github.com/oi-narendra/multiselect-dropdown/blob/main/example/lib/usage_with_form.dart)

## Controller

You can use the controller to programmatically select/unselect items, clear the selection, and get the selected items, set disabled items, show/hide the dropdown. It is still in beta, will be stable in the next release.

```dart
final MultiSelectController _controller = MultiSelectController();

_controller.clearAllSelection(); /// Clear all selected items

_controller.clearSelection(ValueItem item); /// Clear a selected item

_controller.setSelectedOptions(List<ValueItem> options); /// Set selected items

_controller.addSelectedOption(ValueItem option); /// Add a selected item

_controller.setDisabledOptions(List<ValueItem> options); /// Set disabled items

_controller.addDisabledOption(ValueItem option); /// Add a disabled item

_controller.setOptions(List<ValueItem> options); /// Set options

_controller.options; /// Get options

_controller.selectedOptions; /// Get selected options

_controller.disabledOptions; /// Get disabled options

_controller.enabledOptions; /// Get enabled options

_controller.showDropdown(); /// Show the dropdown

_controller.hideDropdown(); /// Hide the dropdown if it is open

```

## Parameters

| Name                          | Type                                       | Description                      |
| ----------------------------- | ------------------------------------------ | -------------------------------- |
| selectionType                 | SelectionType                              | selection type of the dropdown   |
| controller                    | MultiSelectController?                     | Controller                       |
| hint                          | String                                     | Hint                             |
| hintColor                     | Color?                                     | Hint color                       |
| hintFontSize                  | double?                                    | Hint font size                   |
| hintStyle                     | TextStyle?                                 | Hint style                       |
| options                       | List<ValueItem>                            | Options                          |
| selectedOptions               | List<ValueItem>                            | Selected options                 |
| disabledOptions               | List<ValueItem>                            | Disabled options                 |
| onOptionRemoved               | Function(int index, ValueItem<T> option)?  | On option removed                |
| onOptionSelected              | Function(List<ValueItem>)?                 | On option selected               |
| selectedOptionIcon            | Icon?                                      | Selected option icon             |
| selectedOptionTextColor       | Color?                                     | Selected option text color       |
| selectedOptionBackgroundColor | Color?                                     | Selected option background color |
| selectedItemBuilder           | Widget Function(BuildContext, ValueItem)?  | Selected item builder            |
| showChipInSingleSelectMode    | bool                                       | Show chip in single select mode  |
| chipConfig                    | ChipConfig                                 | Chip configuration               |
| fieldBackgroundColor          | Color?                                     | Dropdown field background color  |
| optionTextStyle               | TextStyle?                                 | Option text style                |
| optionSeparator               | Widget?                                    | Option seperator                 |
| dropdownHeight                | double                                     | Dropdown height                  |
| optionSeparator               | Widget?                                    | Option separator                 |
| alwaysShowOptionIcon          | bool                                       | Always show option icon          |
| backgroundColor               | Color?                                     | Background color                 |
| suffixIcon                    | Icon?                                      | Suffix icon                      |
| clearIcon                     | Icon?                                      | Clear icon                       |
| inputDecoration               | Decoration?                                | Input decoration                 |
| borderRadius                  | double?                                    | Border radius                    |
| borderColor                   | Color?                                     | Border color                     |
| borderWidth                   | double?                                    | Border width                     |
| padding                       | EdgeInsets?                                | Padding                          |
| networkConfig                 | NetworkConfig?                             | Network configuration            |
| responseParser                | Future<List<ValueItem>> Function(dynamic)? | Response parser                  |
| responseErrorBuilder          | Widget Function(BuildContext, dynamic)?    | Response error builder           |
| focusNode                     | FocusNode?                                 | Focus node                       |
| radiusGeometry                | RadiusGeometry?                            | Radius geometry                  |
| focusBorderWidth              | double?                                    | Focus border width               |
| maxItems                      | int?                                       | Max items                        |
| searchEnabled                 | bool                                       | Allow dropdown search            |
| dropdownBorderRadius          | double?                                    | Dropdown border radius           |
| dropdownMargin                | double?                                    | Dropdown vertical margin         |
| searchBackgroundColor         | Color?                                     | Search field background color    |
| dropdownBackgroundColor       | Color?                                     | Dropdown background color        |
| searchLabel                   | String?                                    | Search label                     |
| animateSuffixIcon             | bool                                       | Animate Suffix Icon              |
| singleSelectItemStyle         | TextStyle?                                 | Single select item style         |
| optionBuilder                 | Widget Function(ctx, ValueItem<T>, bool)?  | Option builder                   |
