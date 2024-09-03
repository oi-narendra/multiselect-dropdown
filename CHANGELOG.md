# ChangeLOG

## 3.0.1

- Fixed overlay exception error.
- Fixed Text Direction issue.
- Exposed `OnSearchChange` callback to get the search query.
- Fixed dropdown reset issue when used inside a `ListView`.
- Close dropdown when single select item is selected.

## 3.0.0

### Breaking Changes

- Multiple breaking changes have been made to the library to make it more flexible and customizable.
- The library has been completely rewritten to make it more flexible and customizable.
- `MultiSelectDropDown` is now `MultiDropdown`.
- `ValueItem` is now `DropdownItem`. It now supports `disabled` & `selected` properties.
- Added `.future` constructor to `MultiDropdown` to support future options. It now shows a loading indicator when the future is being resolved.
- `.custom` constructor is now removed. You need to handle custom network requests manually by using the `.future` constructor.
- Dropdown now supports `Form Validation`, `Prefix Icon` and some other properties.
- Dropdown now somewhat takes decoration from theme, to make the UI more consistent across the app.
- Refer to the parameters of the `MultiDropdown` widget for more information.

## 3.0.0-dev.5

- `height` property in `DropdownDecoration` is renamed to `maxHeight`.

## 3.0.0-dev.4

- Fixed `search` feature not working issue.
- Fixed `itemBuilder` not working properly.

## 3.0.0-dev.3

- Fixed issue causing `onSelectionChange` callback to not work properly.

## 3.0.0-beta.1

- Added `closeOnBackButton` property to `MultiDropdown` to close the dropdown when the back button is pressed.
- Added `footer` and `header` properties to `DropdownDecoration` to add a custom footer and header to the dropdown.
- When dropdown is opened, now it supports gesture in the background as well. Example: You can now scroll the list behind the dropdown, when the dropdown is open.
- `prefixIcon` in `FieldDecoration` is now a `Widget` instead of an `Icon`.
- Fixed dropdown not opening on web.
- Fixed an issue causing validation to not work properly when using controller to update the dropdown.
- Renamed controller's `.open` method to `.showDropdown` and `.hide` method to `.closeDropdown`.

## 3.0.0-dev.2

- Added `backgroundColor` property to `FieldDecoration` to set the background color of the dropdown field.
- Fixed issue with `onSelectionChange` callback.

## 3.0.0-dev.1

- Multiple breaking changes have been made to the library to make it more flexible and customizable.
- The library has been completely rewritten to make it more flexible and customizable.

## Features

- `MultiSelectDropDown` is now `MultiDropdown`.
- `ValueItem` is now `DropdownItem`. It now supports `disabled` & `selected` properties.
- Added `.future` constructor to `MultiDropdown` to support future options. It now shows a loading indicator when the future is being resolved.
- `.custom` constructor is now removed. You need to handle custom network requests manually by using the `.future` constructor.
- Dropdown now supports `Form Validation`, `Prefix Icon` and some other properties.
- Dropdown now somewhat takes decoration from theme, to make the UI more consistent across the app.

## 2.1.5

- Renamed `NetworkConfig` class to `NetworkRequest`.
- responseParser and responseErrorBuilder are now moved inside the `NetworkRequest` class.
- `NetworkRequest.custom` is now added to support custom network requests.
- Fixed an issue where unnecessary network call was being made when used with networkRequest.
- Updated chip style to support `disabled background color`, `disabled label color`, and `border side`.
- Fixed issue which caused the border-radius of the dropdown to be clipped by options
- Rename `borderRadius` parameter to `fieldBorderRadius`
- DropdwnField now shows a `loading indicator` when the options are being fetched from the network.

## 2.1.4

- Removed `showClearIcon` property from dropdown field. Use clearIcon property to set the clear icon. If clearIcon is null, the clear icon will not be shown.
- Added `singleSelectItemStyle` property to dropdown field. Use this property to set the style of the selected item in single select dropdown.
- Fixed suffixIcon animation issue in dropdown field, also added `animateSuffixIcon` property to enable/disable suffix icon animation.
- Added `optionBuilder` property to dropdown field. Use this property to build custom dropdown options.

## 2.1.3

- Added dropdown background color property, search field background color property, and search field label property.
- Added onDelete callback to dropdown field. This callback is called when option is deleted from the dropdown field using
  the delete icon/button in chips.

## 2.1.2

- Fixed dropdown dismiss issue when search is enabled and option is/are selected on web.
- Fixed the issue where the selected options were ignored when the widget is rebuilt.

## 2.1.1

- Added dropdown margin property. Use this property to set the margin between the dropdown field and the dropdown.
- Added dropdownborderradius property. Use this property to set the border radius of the dropdown.
- Fixed controller being used after being disposed.

## 2.1.0

- Added support for search in dropdown options.

## 2.0.2

- Added support for custom suffix icon in dropdown field.
- Added support for custom clear icon in dropdown field.
- Fixed the issue where the dropdown would not follow the dropdown field when the dropdown field is scrolled.
- Updated http dependency to 1.1.0.

## 2.0.1

- Added maxItems property to dropdown field. If max items is set, the dropdown field will not allow more than the specified number of items to be selected.
- Upgraded http dependency to 1.0.0.

## 2.0.0

- Stable release.

## 2.0.0-dev.3

- Fixed issue where selecting an option after passing initial options would not work.

## 2.0.0-dev.2

- Fixed issue where chips were not being cleared when controller not set.

## 2.0.0-dev.1

- Added support for controller.
- Use controller to get/set selected options, disabled options, options, and enabled options.
- Use controller to clear selected options, show/hide dropdown.
- Added support for focusnode, use focusnode to focus/unfocus the dropdown field programmatically.

## 1.0.9

- Added clear button to dropdown field.
- Added support focus on dropdown field.

## 1.0.8

- Updated dropdown to detect available space and show the dropdown above or below the field.

## 1.0.7

- Added custom border radius in dropdown.

## 1.0.6

- Fixed selected option text color not being applied.

## 1.0.5

- Fixed onOptionsSelected callback not being called when deleting the chip item.
- Fixed issue causing overlay exception.

## 1.0.4

- Added support for dropdown field padding, border color, border width, and border radius.
- Fixed onOptionsSelected callback not being called.
- Added toString/JsonSerialization/Equality/Hash methods to ValueItem class.

## 1.0.3

- Added new constructor that supports fetching the data from a URL.

## 1.0.2

- Added example.

## 1.0.1

- Updated screenshots.

## 1.0.0

- Initial release.
