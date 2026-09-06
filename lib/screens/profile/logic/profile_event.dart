abstract class ProfileEvent {
}
class ProfileInitial extends ProfileEvent{
  final String userId;
  ProfileInitial(this.userId);
}
class ProfileReloadSilent extends ProfileEvent{
  final String userId;
  ProfileReloadSilent(this.userId);
}