A dropddown package for flutter that allows you to select multiple items from a list.
You can customize the dropdown list items, the dropdown list style, and the dropdown field style.
You can also get the options from a network request.

## Preview

`Selection mode: single`

```dart
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

`Network Request`

``` dart
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
-  Allows you to select multiple/single items from a list.
-  Allows to fetch the data from a URL.
-  Shows the selected items as chips. You can customize the chip style.
-  Disable the dropdown items.
-  Preselect the dropdown items.
-  Customize dropdown list items.
-  Customize selected item builder.
-  Customize dropdown field style.
-  Callback when dropdown items are selected/unselected.
-  Use controller to programmatically select/unselect items, clear the selection, and get the selected items, set disabled items, show/hide the dropdown.

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
| onOptionSelected              | Function(List<ValueItem>)?                 | On option selected               |
| selectedOptionIcon            | Icon?                                      | Selected option icon             |
| selectedOptionTextColor       | Color?                                     | Selected option text color       |
| selectedOptionBackgroundColor | Color?                                     | Selected option background color |
| selectedItemBuilder           | Widget Function(BuildContext, ValueItem)?  | Selected item builder            |
| showChipInSingleSelectMode    | bool                                       | Show chip in single select mode  |
| chipConfig                    | ChipConfig                                 | Chip configuration               |
| optionsBackgroundColor        | Color?                                     | Options background color         |
| optionTextStyle               | TextStyle?                                 | Option text style                |
| optionSeperator               | Widget?                                    | Option seperator                 |
| dropdownHeight                | double                                     | Dropdown height                  |
| optionSeparator               | Widget?                                    | Option separator                 |
| alwaysShowOptionIcon          | bool                                       | Always show option icon          |
| backgroundColor               | Color?                                     | Background color                 |
| suffixIcon                    | IconData?                                  | Suffix icon                      |
| inputDecoration               | Decoration?                                | Input decoration                 |
| borderRadius                  | double?                                    | Border radius                    |
| borderColor                   | Color?                                     | Border color                     |
| borderWidth                   | double?                                    | Border width                     |
| padding                       | EdgeInsets?                                | Padding                          |
| networkConfig                 | NetworkConfig?                             | Network configuration            |
| responseParser                | Future<List<ValueItem>> Function(dynamic)? | Response parser                  |
| responseErrorBuilder          | Widget Function(BuildContext, dynamic)?    | Response error builder           |
| showClearIcon                 | bool                                       | Show clear icon                  |
| focusNode                     | FocusNode?                                 | Focus node                       |
| radiusGeometry                | RadiusGeometry?                            | Radius geometry                  |
| focusBorderWidth              | double?                                    | Focus border width               |
| maxItems                      | int?                                       | Max items                        |





