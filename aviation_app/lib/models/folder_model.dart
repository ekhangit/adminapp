class FolderModel {
  final int id;
  final String name;
  final List<FolderModel> subfolders;

  FolderModel({
    required this.id,
    required this.name,
    required this.subfolders,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      subfolders: (json['subfolders'] as List?)
              ?.map((subfolder) => FolderModel.fromJson(subfolder))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subfolders': subfolders.map((e) => e.toJson()).toList(),
    };
  }

  bool get hasSubfolders => subfolders.isNotEmpty;
}
