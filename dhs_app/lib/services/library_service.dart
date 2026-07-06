import 'dart:developer';

import 'package:dhs_app/models/airline_library_model.dart';
import 'package:dhs_app/models/folder_model.dart';
import 'package:dhs_app/models/library_model.dart';
import 'package:dhs_app/services/base_service.dart';
import 'package:dhs_app/utils/response_class.dart';

import '../utils/api_config.dart';

class LibraryService {
  LibraryService._privateConstructor();
  static final LibraryService _instance = LibraryService._privateConstructor();
  static LibraryService get instance => _instance;

  /// Fetch all folders
  Future<ResponseClass<List<FolderModel>>> getFolders() async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getFolders,
      );

      log("[getFolders] response : ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        final folders = (response.data['body'] as List?)
                ?.map((folder) => FolderModel.fromJson(folder))
                .toList() ??
            [];
        return ResponseClass.success(folders);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Failed to fetch folders',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  /// Fetch documents by folder
  Future<ResponseClass<Map<String, List<LibraryModel>>>>
      getDocumentsByFolder(int folderId) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getDocumentsByFolder,
        data: {'folder_id': folderId},
      );

      log("[getDocumentsByFolder] response : ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        final body = response.data['body'];

        Map<String, List<LibraryModel>> documentsMap = {
          'documents': (body['documents'] as List?)
                  ?.map((l) => LibraryModel.fromJson(l))
                  .toList() ??
              [],
          'read_sign_documents': (body['read_sign_documents'] as List?)
                  ?.map((l) => LibraryModel.fromJson(l))
                  .toList() ??
              [],
        };

        return ResponseClass.success(documentsMap);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Failed to fetch documents',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  /// Fetch all read and sign documents
  Future<ResponseClass<List<LibraryModel>>> getAllReadAndSign() async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getAllReadAndSign,
      );

      log("[getAllReadAndSign] response : ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        final body = response.data['body'];
        final documents = (body['read_sign_documents'] as List?)
                ?.map((doc) => LibraryModel.fromJson(doc))
                .toList() ??
            [];
        return ResponseClass.success(documents);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Failed to fetch read and sign documents',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  /// Fetch read and sign documents by employee
  Future<ResponseClass<List<LibraryModel>>> getReadAndSignByEmp(int employeeId) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getReadAndSignByEmp,
        data: {'employee_id': employeeId},
      );

      log("[getReadAndSignByEmp] response : ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        final body = response.data['body'];

        // Handle if body is a list directly
        if (body is List) {
          final documents = body
              .map((doc) => LibraryModel.fromJson(doc))
              .toList();
          return ResponseClass.success(documents);
        }

        // Handle if body contains read_sign_documents key
        final documents = (body['read_sign_documents'] as List?)
                ?.map((doc) => LibraryModel.fromJson(doc))
                .toList() ??
            [];
        return ResponseClass.success(documents);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Failed to fetch read and sign documents',
        );
      }
    } catch (e) {
      log("[getReadAndSignByEmp] error : $e");
      return ResponseClass.error(e.toString());
    }
  }

  /// Fetch all safety documents
  Future<ResponseClass<Map<String, List<LibraryModel>>>> getSafetyDocument() async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getSafetyDocument,
      );

      log("[getSafetyDocument] response : ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        final body = response.data['body'];

        Map<String, List<LibraryModel>> documentsMap = {
          'documents': (body['documents'] as List?)
                  ?.map((doc) => LibraryModel.fromJson(doc))
                  .toList() ??
              [],
          'read_sign_documents': (body['read_sign_documents'] as List?)
                  ?.map((doc) => LibraryModel.fromJson(doc))
                  .toList() ??
              [],
        };

        return ResponseClass.success(documentsMap);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Failed to fetch safety documents',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  /// Fetch all airline folders
  Future<ResponseClass<List<AirlineLibraryModel>>> getAirlineFolders() async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getAirlineFolders,
      );

      log("[getAirlineFolders] response : ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        final airlines = (response.data['body'] as List?)
                ?.map((airline) => AirlineLibraryModel.fromJson(airline))
                .toList() ??
            [];
        return ResponseClass.success(airlines);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Failed to fetch airline folders',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  /// Fetch documents by airline folder
  Future<ResponseClass<Map<String, List<LibraryModel>>>>
      getDocumentsByAirlineFolder(int folderId, int airlineId) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.getDocumentsByAirlineFolder,
        data: {
          'folder_id': folderId,
          'airline_id': airlineId,
        },
      );

      log("[getDocumentsByAirlineFolder] response : ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        final body = response.data['body'];

        Map<String, List<LibraryModel>> documentsMap = {
          'documents': (body['documents'] as List?)
                  ?.map((l) => LibraryModel.fromJson(l))
                  .toList() ??
              [],
          'read_sign_documents': (body['read_sign_documents'] as List?)
                  ?.map((l) => LibraryModel.fromJson(l))
                  .toList() ??
              [],
        };

        return ResponseClass.success(documentsMap);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Failed to fetch documents',
        );
      }
    } catch (e) {
      return ResponseClass.error(e.toString());
    }
  }

  /// Update last viewed document
  Future<ResponseClass<void>> updateLastViewedDocument(int libraryId) async {
    try {
      final response = await BaseService.instance.dio.post(
        ApiConfig.updateLastViewedDocument,
        data: {'library_id': libraryId},
      );

      log("[updateLastViewedDocument] response : ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        return ResponseClass.success(null);
      } else {
        return ResponseClass.error(
          response.data['message'] ?? 'Failed to update last viewed',
        );
      }
    } catch (e) {
      log("[updateLastViewedDocument] error : $e");
      return ResponseClass.error(e.toString());
    }
  }
}
