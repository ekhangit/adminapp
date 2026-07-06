class LibraryModel {
  final int id;
  final String name;
  String? editionNumber;
  String? issueDate;
  final String docUrl;
  final String status;
  String? station;
  bool docView;
  bool isNew;
  String? userName;
  bool isReadAndSign;
  String? createdAt;

  LibraryModel({
    required this.id,
    required this.name,
    this.editionNumber,
    required this.issueDate,
    required this.status,
    required this.docUrl,
    this.station,
    this.docView = false,
    this.isNew = false,
    this.userName,
    this.isReadAndSign = false,
    this.createdAt,
  });

  factory LibraryModel.fromJson(Map<String, dynamic> json) {
    // Check if this is a Read & Sign document (has 'list' field instead of 'document')
    bool isReadAndSign = json['list'] != null && json['document'] == null;

    return LibraryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      editionNumber: json['edition_no']?.toString(),
      docUrl: json['document'] ?? json['list'] ?? '',
      issueDate: json['issue_date'],
      status: json['status'] ?? '',
      station: json['station'],
      docView: json['doc_view'] == true || json['doc_view'] == 'true',
      isNew: json['is_new'] ?? false,
      userName: json['user_name'],
      isReadAndSign: isReadAndSign,
      createdAt: json['created_at'],
    );
  }
}
