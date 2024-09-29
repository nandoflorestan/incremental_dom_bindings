library incremental_dom;

import "dart:js_interop" as js;
import "dart:js_interop_unsafe" as u;
import "package:web/web.dart" as web;

final js.JSObject _incDom = web.window["IncrementalDOM"] as js.JSObject;
final js.JSObject _notifications = _incDom["notifications"] as js.JSObject;
final js.JSObject _attributes = _incDom["attributes"] as js.JSObject;

js.JSAny? _toJS(dynamic arg) {
  if (arg == null) {
    return null;
  }
  if (arg is String || arg is int || arg is double || arg is bool) {
    return arg.toJS;
  }
  if (arg is List || arg is Map) {
    return arg.jsify()!; // bang because we know it's not null
  }
  throw Exception("_toJS() cannot handle $arg");
}

/// Maps a list of arguments to be valid for Javascript
/// function call.
List<js.JSAny?> _mapArgs(List<Object>? args) {
  // TODO Test the library then decide whether to delete this function.
  if (args == null) {
    return [];
  }
  return args.map(_toJS).toList();
}

/// Declares an Element with zero or more
/// attributes/properties that should be present at the
/// current location in the document tree.
///
/// [tagname] is the name of the element, e.g. "div" or "span".
/// This could also be the tag of a custom element.
///
/// A [key] identifies Element for reuse. See 'Keys and
/// Arrays' in the IncrementalDOM documentation.
///
/// [staticPropertyValuePairs] is a list of pairs of
/// property names and values. Depending on the type of the
/// value, these will be set as either attributes or
/// properties on the Element. These are only set on the
/// Element once during creation. These will not be updated
/// during subsequent passes. See 'Statics Array' in the
/// IncrementalDOM documentation.
///
/// [propertyValuePairs] is a list of pairs of property
/// names and values. Depending on the type of the value,
/// these will be set as either attributes or properties
/// on the Element.
///
/// Returns the corresponding DOM Element.
web.Element elementOpen(
  String tagname, [
  String? key,
  List<Object>? staticPropertyValuePairs,
  List<Object>? propertyValuePairs,
]) {
  return _incDom.callMethodVarArgs("elementOpen".toJS, [
    tagname.toJS,
    key?.toJS,
    staticPropertyValuePairs.jsify(),
    ..._mapArgs(propertyValuePairs),
  ]) as web.Element;
}

/// Used with [attr] and [elementOpenEnd] to declare an
/// element.
///
/// [tagname] is the name of the element, e.g. "div" or "span".
/// This could also be the tag of a custom element.
///
/// A [key] identifies Element for reuse. See 'Keys and
/// Arrays' in the IncrementalDOM documentation.
///
/// [staticPropertyValuePairs] is a list of pairs of
/// property names and values. Depending on the type of the
/// value, these will be set as either attributes or
/// properties on the Element. These are only set on the
/// Element once during creation. These will not be updated
/// during subsequent passes. See 'Statics Array' in the
/// IncrementalDOM documentation.
void elementOpenStart(
  String tagname, [
  String? key,
  List<Object>? staticPropertyValuePairs,
]) {
  _incDom.callMethod("elementOpenStart".toJS, tagname.toJS, key?.toJS,
      staticPropertyValuePairs.jsify());
}

/// Used with [elementOpenStart] and [elementOpenEnd] to declare an element.
///
/// Sets a dynamic (I mean, not static) attribute with [name] and [value].
void attr(String name, Object value) =>
    _incDom.callMethod("attr".toJS, [name, value].jsify());

/// Used with [elementOpenStart] and [attr] to declare an element.
///
/// Returns the corresponding DOM Element.
web.Element elementOpenEnd() => _incDom.callMethod("elementOpenEnd".toJS);

/// Signifies the end of the element opened with
/// [elementOpen], corresponding to a closing tag (e.g.
/// </div> in HTML). Any childNodes of the currently open
/// Element that are in the DOM that have not been
/// encountered in the current render pass are removed by
/// the call to [elementClose].
///
/// [tagname] is the name of the element, e.g. "div" or "span".
/// This could also be the tag of a custom element.
///
/// Returns the corresponding DOM Element.
web.Element elementClose(String tagname) =>
    _incDom.callMethod("elementClose".toJS, tagname.toJS);

/// A combination of [elementOpen], followed by
/// [elementClose].
///
/// [tagname] is the name of the element, e.g. "div" or "span".
/// This could also be the tag of a custom element.
///
/// A [key] identifies the Element for reuse. See 'Keys and
/// Arrays' in the IncrementalDOM documentation.
///
/// [staticPropertyValuePairs] is a list of pairs of
/// property names and values. Depending on the type of the
/// value, these will be set as either attributes or
/// properties on the Element. These are only set on the
/// Element once during creation. These will not be updated
/// during subsequent passes. See 'Statics Array' in the
/// IncrementalDOM documentation.
///
/// [propertyValuePairs] is a list of pairs of property
/// names and values. Depending on the type of the value,
/// these will be set as either attributes or properties
/// on the Element.
///
/// Returns the corresponding DOM Element.
web.Element elementVoid(
  String tagname, [
  String? key,
  List<Object>? staticPropertyValuePairs,
  List<Object>? propertyValuePairs,
]) {
  return _incDom.callMethodVarArgs("elementVoid".toJS, [
    tagname.toJS,
    key?.toJS,
    staticPropertyValuePairs.jsify(),
    ..._mapArgs(propertyValuePairs)
  ]);
}

/// Declares a Text node, with the specified [value], which should
/// appear at the current location in the document tree.
///
/// The [formatters] are optional functions that format the
/// value when it changes. The formatters are applied in the
/// order they appear in the list of formatters. The second
/// formatter will receive the result of the first formatter
/// and so on.
///
/// Returns the corresponding DOM Text Node.
web.Text text(Object value, {List<String Function(Object)>? formatters}) {
  final jsFormatters =
      formatters == null ? null : [for (final f in formatters) f.toJS];
  return _incDom
      .callMethodVarArgs("text".toJS, [_toJS(value)!, ...?jsFormatters]);
}

/// Updates the provided node with a function containing
/// zero or more calls to [elementOpen], [text] and
/// [elementClose]. The provided callback function may call
/// other such functions. The [patch] function may be
/// called with a new Node while a call to [patch] is
/// already executing.
///
/// This function patches the [node]. Typically, this
/// will be an HTMLElement or DocumentFragment.
///
/// [description] is the callback to build the DOM tree
/// underneath [node].
void patch(web.Element node, void Function(Object?) description,
    [Object? data]) {
  _incDom.callMethod("patch".toJS, node, description.jsify(), data.jsify());
}

/// Provides a way to get the currently open element.
///
/// Returns the currently open element.
web.Element currentElement() => _incDom.callMethod("currentElement".toJS);

/// The current location in the DOM that Incremental DOM is
/// looking at. This will be the next Node that will be
/// compared against for the next [elementOpen] or text
/// call.
///
/// Returns the next node that will be compared.
web.Element currentPointer() => _incDom.callMethod("currentPointer".toJS);

/// Moves the current pointer to the end of the currently
/// open element. This prevents Incremental DOM from
/// removing any children of the currently open element.
/// When calling skip, there should be no calls to
/// [elementOpen] (or similar) prior to the [elementClose]
/// call for the currently open element.
void skip() => _incDom.callMethod("skip".toJS);

/// Moves the current patch pointer forward by one node.
/// This can be used to skip over elements declared outside
/// of Incremental DOM.
void skipNode() => _incDom.callMethod("skipNode".toJS);

/// A function to set a value as a property
/// or attribute for an element.
typedef ValueSetter = void Function(
    web.Element element, String name, Object? value);

/// A predefined function, that applies a value as a
/// property.
ValueSetter get applyProp {
  return (web.Element element, String name, Object? value) =>
      _incDom["applyProp"].apply([element, name, value]);
}

/// A predefined function, that applies a value as an
/// attribute.
ValueSetter get applyAttr {
  return (web.Element element, String name, Object? value) =>
      _incDom["applyAttr"].apply([element, name, value]);
}

/// See [attributes].
class Attributes {
  Attributes._();

  /// If no function is specified for a given name, a
  /// default function is used that applies values as
  /// described in Attributes and Properties. This can
  /// be changed by specifying the default function.
  ///
  /// FIXME: not yet working
  void setDefault(ValueSetter? setter) {
    this['__default'] = setter;
  }

  /// Sets a [ValueSetter] for a property/attribute
  /// identified by a [name].
  void operator []=(String name, ValueSetter? setter) {
    _attributes[name] = setter;
  }
}

/// The [attributes] object allows you to provide a
/// function to decide what to do when an attribute
/// passed to elementOpen or similar functions changes.
/// The following example makes IncrementalDOM always
/// set value as a property.
///
/// ```
/// attributes['value'] = applyProp;
/// ```
final attributes = Attributes._();

/// A listener for node events.
typedef NodeListener = void Function(List<web.Element> nodes);

/// See [notifications].
class Notifications {
  /// Sets the listener for the event of added nodes.
  set nodesCreated(NodeListener listener) => _notifications["nodesCreated"] =
      (js.JSArray nodes) => listener(nodes.cast<web.Element>().toList());

  /// Sets the listener for the event of deleted nodes.
  set nodesDeleted(NodeListener listener) => _notifications["nodesDeleted"] =
      (js.JSArray nodes) => listener(nodes.cast<web.Element>().toList());
}

/// You can be notified when Nodes are added or removed by
/// IncrementalDOM by specifying functions for
/// [notifications.nodesCreated] and
/// [notifications.nodesDeleted]. If there are added or
/// removed nodes during a patch operation, the appropriate
/// function will be called at the end of the patch with
/// the added or removed nodes.
final notifications = Notifications();
