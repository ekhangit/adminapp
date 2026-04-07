class AirlineLibraryModel {
  final int id;
  final String? name;
  final String? picture;
  final List<AirlineLibraryFolderModel> folders;

  AirlineLibraryModel({
    required this.id,
    this.name,
    this.picture,
    required this.folders,
  });

  factory AirlineLibraryModel.fromJson(Map<String, dynamic> json) {
    return AirlineLibraryModel(
      id: json['airline_id'] ?? json['id'] ?? 0,
      name: json['name'],
      picture: json['picture'],
      folders: (json['folders'] as List?)
              ?.map((folder) => AirlineLibraryFolderModel.fromJson(folder))
              .toList() ??
          [],
    );
  }

  bool get hasFolders => folders.isNotEmpty;
}

class AirlineLibraryFolderModel {
  final int id;
  final String name;
  final List<AirlineLibraryFolderModel> subfolders;

  AirlineLibraryFolderModel({
    required this.id,
    required this.name,
    required this.subfolders,
  });

  factory AirlineLibraryFolderModel.fromJson(Map<String, dynamic> json) {
    return AirlineLibraryFolderModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      subfolders: (json['subfolders'] as List?)
              ?.map((subfolder) => AirlineLibraryFolderModel.fromJson(subfolder))
              .toList() ??
          [],
    );
  }

  bool get hasSubfolders => subfolders.isNotEmpty;
}
