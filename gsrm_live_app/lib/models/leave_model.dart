class LeaveTypeModel {
  final int id;
  final String title;

  LeaveTypeModel({required this.id, required this.title});

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(id: json['id'] ?? 0, title: json['title'] ?? '');
  }
}
