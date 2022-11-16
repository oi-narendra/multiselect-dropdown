/// [SelectionType]
/// SelectionType enum for the selection type of the dropdown items.
/// * [single]: single selection
/// * [multi]: multi selection
enum SelectionType {
  single,
  multi,
}

/// [WrapType]
/// WrapType enum for the wrap type of the selected items.
/// * [WrapType.scroll]: scroll the selected items horizontally
/// * [WrapType.wrap]: wrap the selected items in both directions
enum WrapType { scroll, wrap }

/// [RequestMethod]
/// RequestMethod enum for the request method of the dropdown items.
/// * [RequestMethod.get]: get request
/// * [RequestMethod.post]: post request
/// * [RequestMethod.put]: put request
/// * [RequestMethod.delete]: delete request
/// * [RequestMethod.patch]: patch request
enum RequestMethod { get, post, put, patch, delete }
