class NotificationKeywordGroup {
  final String name;
  final List<NotificationKeyword> keywords;

  const NotificationKeywordGroup({
    required this.name,
    required this.keywords,
  });
}

class NotificationKeyword {
  final String label;
  final String key;

  const NotificationKeyword({
    required this.label,
    required this.key,
  });
}
