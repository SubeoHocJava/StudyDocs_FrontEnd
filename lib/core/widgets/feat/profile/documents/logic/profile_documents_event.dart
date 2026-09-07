abstract class ProfileDocumentsEvent {}

class FetchProfileDocumentsEvent extends ProfileDocumentsEvent {
  final String userId;

  FetchProfileDocumentsEvent(this.userId);
}
