class NotificationModel {
  const NotificationModel({
    this.id,
    required this.show,
  });

  final int? id;
  final Future Function() show;
}
