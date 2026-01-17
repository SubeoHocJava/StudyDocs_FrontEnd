abstract class AdminState {
  const AdminState();
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminStatsLoaded extends AdminState {
  final int totalDocuments;

  const AdminStatsLoaded({required this.totalDocuments});
}

class AdminError extends AdminState {
  final String message;

  const AdminError(this.message);
}
