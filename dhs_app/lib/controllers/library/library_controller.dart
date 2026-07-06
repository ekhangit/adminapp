// controllers/library_controller.dart
import 'dart:developer';

import 'package:dhs_app/services/library_service.dart';
import 'package:get/get.dart';

import '../../models/airline_library_model.dart';
import '../../models/folder_model.dart';
import '../../models/library_model.dart';
import '../storage/data_storage_controller.dart';

class LibraryController extends GetxController {
  RxList<LibraryModel> documents = <LibraryModel>[].obs;
  RxList<LibraryModel> readAndSign = <LibraryModel>[].obs;
  RxList<LibraryModel> safetyDocuments = <LibraryModel>[].obs;
  RxBool isLoading = false.obs;

  // Folder management
  RxList<FolderModel> folders = <FolderModel>[].obs;
  RxBool isFoldersLoading = false.obs;
  Rx<FolderModel?> selectedFolder = Rx<FolderModel?>(null);
  RxMap<int, bool> expandedFolders = <int, bool>{}.obs;

  // Airline Library management
  RxList<AirlineLibraryModel> airlines = <AirlineLibraryModel>[].obs;
  RxBool isAirlinesLoading = false.obs;
  RxMap<int, bool> expandedAirlineFolders = <int, bool>{}.obs;

  // Tab management for document screens
  RxInt selectedDocumentTab = 0.obs; // 0: All, 1: Documents, 2: Read & Sign

  void selectDocumentTab(int index) {
    selectedDocumentTab.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    loadFolders(); // Load folders on init
  }

  /// Fetch all folders
  Future<void> loadFolders() async {
    isFoldersLoading.value = true;

    try {
      final response = await LibraryService.instance.getFolders();

      if (response.isSuccess && response.data != null) {
        folders.assignAll(response.data!);
      } else {
        log('[loadFolders] error : ${response.errorMessage}');
        Get.snackbar(
          'Error',
          response.errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log('[loadFolders] catch : $e');
      Get.snackbar(
        'Error',
        'Failed to load folders',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isFoldersLoading.value = false;
    }
  }

  /// Select a folder
  void selectFolder(FolderModel? folder) {
    selectedFolder.value = folder;
    if (folder != null) {
      loadDocumentsByFolder(folder.id);
    }
  }

  /// Fetch documents by folder
  Future<void> loadDocumentsByFolder(int folderId) async {
    isLoading.value = true;

    try {
      final response =
          await LibraryService.instance.getDocumentsByFolder(folderId);

      if (response.isSuccess && response.data != null) {
        final map = response.data!;
        documents.assignAll(map['documents'] ?? []);
        readAndSign.assignAll(map['read_sign_documents'] ?? []);
      } else {
        log('[loadDocumentsByFolder] error : ${response.errorMessage}');
        Get.snackbar(
          'Error',
          response.errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log('[loadDocumentsByFolder] catch : $e');
      Get.snackbar(
        'Error',
        'Failed to load documents',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch documents by airline folder
  Future<void> loadDocumentsByAirlineFolder(int folderId, int airlineId) async {
    isLoading.value = true;

    try {
      final response = await LibraryService.instance
          .getDocumentsByAirlineFolder(folderId, airlineId);

      if (response.isSuccess && response.data != null) {
        final map = response.data!;
        documents.assignAll(map['documents'] ?? []);
        readAndSign.assignAll(map['read_sign_documents'] ?? []);
      } else {
        log('[loadDocumentsByAirlineFolder] error : ${response.errorMessage}');
        Get.snackbar(
          'Error',
          response.errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log('[loadDocumentsByAirlineFolder] catch : $e');
      Get.snackbar(
        'Error',
        'Failed to load documents',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle folder expansion
  void toggleFolderExpansion(int folderId) {
    expandedFolders[folderId] = !(expandedFolders[folderId] ?? false);
  }

  /// Close all sibling folders at the same level
  void closeSiblingFolders(List<int> siblingIds, int currentFolderId) {
    for (final id in siblingIds) {
      if (id != currentFolderId) {
        expandedFolders[id] = false;
      }
    }
  }

  /// Check if folder is expanded
  bool isFolderExpanded(int folderId) {
    return expandedFolders[folderId] ?? false;
  }

  /// Fetch all read and sign documents
  Future<void> loadReadAndSignDocuments() async {
    isLoading.value = true;

    try {
      final response = await LibraryService.instance.getAllReadAndSign();

      if (response.isSuccess && response.data != null) {
        readAndSign.assignAll(response.data!);
      } else {
        log('[loadReadAndSignDocuments] error : ${response.errorMessage}');
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to load read and sign documents',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log('[loadReadAndSignDocuments] catch : $e');
      Get.snackbar(
        'Error',
        'Failed to load read and sign documents',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Alias for loadReadAndSignDocuments
  Future<void> loadAllReadAndSign() async {
    return loadReadAndSignDocuments();
  }

  /// Fetch read and sign documents by employee
  Future<void> loadReadAndSignByEmployee() async {
    isLoading.value = true;

    try {
      // Get employee ID from storage
      final storageController = Get.find<DataStorageController>();
      final employeeId = storageController.session.value?['id'];

      if (employeeId == null) {
        Get.snackbar(
          'Error',
          'Employee ID not found. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return;
      }

      final response = await LibraryService.instance.getReadAndSignByEmp(employeeId);

      if (response.isSuccess && response.data != null) {
        readAndSign.assignAll(response.data!);
      } else {
        log('[loadReadAndSignByEmployee] error : ${response.errorMessage}');
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to load read and sign documents',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log('[loadReadAndSignByEmployee] catch : $e');
      Get.snackbar(
        'Error',
        'Failed to load read and sign documents',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch all safety documents
  Future<void> loadSafetyDocuments() async {
    isLoading.value = true;

    try {
      final response = await LibraryService.instance.getSafetyDocument();

      if (response.isSuccess && response.data != null) {
        final map = response.data!;
        safetyDocuments.assignAll(map['documents'] ?? []);
        readAndSign.assignAll(map['read_sign_documents'] ?? []);
      } else {
        log('[loadSafetyDocuments] error : ${response.errorMessage}');
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to load safety documents',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log('[loadSafetyDocuments] catch : $e');
      Get.snackbar(
        'Error',
        'Failed to load safety documents',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch all airline folders
  Future<void> loadAirlineFolders() async {
    isAirlinesLoading.value = true;

    try {
      final response = await LibraryService.instance.getAirlineFolders();

      if (response.isSuccess && response.data != null) {
        airlines.assignAll(response.data!);
      } else {
        log('[loadAirlineFolders] error : ${response.errorMessage}');
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to load airline folders',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log('[loadAirlineFolders] catch : $e');
      Get.snackbar(
        'Error',
        'Failed to load airline folders',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isAirlinesLoading.value = false;
    }
  }

  /// Toggle airline folder expansion
  void toggleAirlineFolderExpansion(int folderId) {
    final isCurrentlyExpanded = expandedAirlineFolders[folderId] ?? false;

    // Close all expanded folders
    expandedAirlineFolders.clear();

    // If the clicked folder was not expanded, expand it
    if (!isCurrentlyExpanded) {
      expandedAirlineFolders[folderId] = true;
    }
  }

  /// Check if airline folder is expanded
  bool isAirlineFolderExpanded(int folderId) {
    return expandedAirlineFolders[folderId] ?? false;
  }
}
