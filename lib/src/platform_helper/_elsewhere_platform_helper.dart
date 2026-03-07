import 'dart:io';

///The capability of a Operative System to have shortcuts.
bool get operatingSystemShortcutAvailable {
  return Platform.isMacOS || Platform.isLinux || Platform.isWindows;
}
