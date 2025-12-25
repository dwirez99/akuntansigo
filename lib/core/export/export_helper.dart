import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class ExportHelper {
  /// Check if share is supported on current platform
  static bool isShareSupported() {
    // Share is supported on Android, iOS, and partially on Web
    // Not supported on Linux, Windows, macOS desktop
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Share exported file
  static Future<void> shareFile(
    File file, {
    String? subject,
    String? text,
  }) async {
    // Check if platform supports sharing
    if (!isShareSupported()) {
      throw UnsupportedError(
        'Sharing tidak didukung di platform ini. File sudah tersimpan di: ${file.path}',
      );
    }

    try {
      final xFile = XFile(file.path);
      await Share.shareXFiles(
        [xFile],
        subject: subject ?? 'Export Data AkuntansiGo',
        text: text ?? 'Berikut data keuangan dari AkuntansiGo',
      );
    } catch (e) {
      throw Exception('Gagal membagikan file: $e');
    }
  }

  /// Open file location in system file manager (for desktop platforms)
  static Future<void> openFileLocation(File file) async {
    if (Platform.isLinux) {
      // Open file manager at the directory
      final directory = file.parent.path;
      await Process.run('xdg-open', [directory]);
    } else if (Platform.isWindows) {
      final directory = file.parent.path;
      await Process.run('explorer', [directory]);
    } else if (Platform.isMacOS) {
      await Process.run('open', ['-R', file.path]);
    }
  }

  /// Generate unique filename with timestamp
  static String generateFileName({
    required String prefix,
    required String extension,
  }) {
    final now = DateTime.now();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(now);
    return '${prefix}_$timestamp.$extension';
  }

  /// Request storage permission (Android only)
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), we don't need storage permission for app-specific directory
      // But if you want to save to public directory, you need this
      final androidInfo = await _getAndroidVersion();

      if (androidInfo >= 33) {
        // Android 13+: No permission needed for app-specific storage
        return true;
      } else if (androidInfo >= 30) {
        // Android 11-12: Use MANAGE_EXTERNAL_STORAGE for broader access
        var status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          status = await Permission.manageExternalStorage.request();
        }
        return status.isGranted;
      } else {
        // Android 10 and below
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        return status.isGranted;
      }
    }

    // iOS and other platforms don't need permission for app directory
    return true;
  }

  /// Get Android version (SDK level)
  static Future<int> _getAndroidVersion() async {
    if (!Platform.isAndroid) return 0;

    // This is a simplified version. In production, you might want to use
    // device_info_plus package for more accurate version detection
    return 30; // Default to Android 11 for safety
  }

  /// Delete file
  static Future<bool> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get file size in readable format
  static String getFileSize(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  /// Check if file exists
  static Future<bool> fileExists(String path) async {
    final file = File(path);
    return await file.exists();
  }

  /// Format date range for export filename
  static String formatDateRangeForFilename(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return 'Semua';
    }

    final startStr = DateFormat('yyyyMMdd').format(start);
    final endStr = DateFormat('yyyyMMdd').format(end);

    if (startStr == endStr) {
      return startStr;
    }

    return '${startStr}_${endStr}';
  }

  /// Get human-readable date range
  static String getDateRangeLabel(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return 'Semua Data';
    }

    final startStr = DateFormat('dd MMM yyyy', 'id_ID').format(start);
    final endStr = DateFormat('dd MMM yyyy', 'id_ID').format(end);

    if (DateFormat('yyyy-MM-dd').format(start) ==
        DateFormat('yyyy-MM-dd').format(end)) {
      return startStr;
    }

    return '$startStr - $endStr';
  }

  /// Clean old export files (optional maintenance)
  static Future<int> cleanOldExports({
    required String directoryPath,
    int daysOld = 7,
  }) async {
    try {
      final directory = Directory(directoryPath);
      if (!await directory.exists()) return 0;

      final now = DateTime.now();
      final files = await directory.list().toList();
      int deletedCount = 0;

      for (var entity in files) {
        if (entity is File && entity.path.contains('AkuntansiGo')) {
          final stat = await entity.stat();
          final age = now.difference(stat.modified).inDays;

          if (age > daysOld) {
            await entity.delete();
            deletedCount++;
          }
        }
      }

      return deletedCount;
    } catch (e) {
      return 0;
    }
  }

  /// Validate export data
  static bool validateExportData(List<dynamic> data) {
    return data.isNotEmpty;
  }

  /// Get export statistics
  static Map<String, dynamic> getExportStats({
    required int totalRecords,
    required int fileSize,
    required String format,
  }) {
    return {
      'totalRecords': totalRecords,
      'fileSize': fileSize,
      'fileSizeFormatted': _formatBytes(fileSize),
      'format': format,
      'exportTime': DateTime.now().toIso8601String(),
    };
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }
}
