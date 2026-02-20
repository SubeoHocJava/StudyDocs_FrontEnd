// setting_event.dart
abstract class SettingEvent {}

class SettingOpenUpdateInfo extends SettingEvent {}

class SettingShowQR extends SettingEvent {}

class SettingLinkGoogle extends SettingEvent {}

class SettingLogout extends SettingEvent {}