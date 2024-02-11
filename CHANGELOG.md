# 1.0.0

- Initial release.

# 1.0.1

- Updated screenshots.

# 1.0.2

- Added example.

# 1.0.3

- Added new constructor that supports fetching the data from a URL.

# 1.0.4

- Added support for dropdown field padding, border color, border width, and border radius.
- Fixed onOptionsSelected callback not being called.
- Added toString/JsonSerialization/Equality/Hash methods to ValueItem class.

# 1.0.5

- Fixed onOptionsSelected callback not being called when deleting the chip item.
- Fixed issue causing overlay exception.

# 1.0.6

- Fixed selected option text color not being applied.

# 1.0.7

- Added custom border radius in dropdown.

# 1.0.8

- Updated dropdown to detect available space and show the dropdown above or below the field.

# 1.0.9

- Added clear button to dropdown field.
- Added support focus on dropdown field.

# 2.0.0-dev.1

- Added support for controller.
- Use controller to get/set selected options, disabled options, options, and enabled options.
- Use controller to clear selected options, show/hide dropdown.
- Added support for focusnode, use focusnode to focus/unfocus the dropdown field programmatically.

# 2.0.0-dev.2

- Fixed issue where chips were not being cleared when controller not set.

# 2.0.0-dev.3

- Fixed issue where selecting an option after passing initial options would not work.

# 2.0.0

- Stable release.

# 2.0.1

- Added maxItems property to dropdown field. If max items is set, the dropdown field will not allow more than the specified number of items to be selected.
- Upgraded http dependency to 1.0.0.

# 2.0.2

- Added support for custom suffix icon in dropdown field.
- Added support for custom clear icon in dropdown field.
- Fixed the issue where the dropdown would not follow the dropdown field when the dropdown field is scrolled.
- Updated http dependency to 1.1.0.

# 2.1.0

- Added support for search in dropdown options.

# 2.1.1

- Added dropdown margin property. Use this property to set the margin between the dropdown field and the dropdown.
- Added dropdownborderradius property. Use this property to set the border radius of the dropdown.
- Fixed controller being used after being disposed.

# 2.1.2
- Fixed dropdown dismiss issue when search is enabled and option is/are selected on web.
- Fixed the issue where the selected options were ignored when the widget is rebuilt.

# 2.1.3
- Added dropdown background color property, search field background color property, and search field label property.
- Added onDelete callback to dropdown field. This callback is called when option is deleted from the dropdown field using 
the delete icon/button in chips.

# 2.1.4

- Removed ```showClearIcon``` property from dropdown field. Use clearIcon property to set the clear icon. If clearIcon is null, the clear icon will not be shown.
- Added ```singleSelectItemStyle``` property to dropdown field. Use this property to set the style of the selected item in single select dropdown.
- Fixed suffixIcon animation issue in dropdown field, also added ```animateSuffixIcon``` property to enable/disable suffix icon animation.
- Added ```optionBuilder``` property to dropdown field. Use this property to build custom dropdown options.