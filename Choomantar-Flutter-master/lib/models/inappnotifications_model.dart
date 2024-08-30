class NotificationModel {
  final String id;
  final String userId;
  final String message;

  NotificationModel(
      {required this.id, required this.userId, required this.message});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? "",
      userId: json['user_id'] ?? "",
      message: json['message'] ?? "",
    );
  }
}
