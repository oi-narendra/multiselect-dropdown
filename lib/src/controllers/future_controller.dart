part of '../multi_dropdown.dart';

/// Controller for the future.
///
/// This controller is used to control the future state of the dropdown.
/// It can be used to start, stop, or toggle the future state of the dropdown.
class _FutureController extends ValueNotifier<bool> {
  _FutureController() : super(false);

  /// Sets the controller to true.
  void start() {
    value = true;
  }

  /// Sets the controller to false.
  void stop() {
    value = false;
  }

  /// Toggles the controller.
  void toggle() {
    value = !value;
  }
}
