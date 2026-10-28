import 'dart:convert';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class BackupItem {
  final String folderName;
  final String folderPath;
  final String dbFilePath;
  final DateTime timestamp;
  final int sizeBytes;

  BackupItem({
    required this.folderName,
    required this.folderPath,
    required this.dbFilePath,
    required this.timestamp,
    required this.sizeBytes,
  });

  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  String get formattedDate {
    return DateFormat('EEE, dd MMM yyyy • hh:mm a').format(timestamp);
  }
}

class BackupService {
  static const String _configFile = 'backup_config.json';

  /// Returns the path to the active SQLite database file.
  static Future<File> getActiveDatabaseFile() async {
    final supportDir = await getApplicationSupportDirectory();
    return File(p.join(supportDir.path, 'traila.db'));
  }

  /// Returns the current configured backup directory. Defaults to Documents/Amjid_Traila_Backups.
  static Future<String> getBackupDirectory() async {
    try {
      final supportDir = await getApplicationSupportDirectory();
      final configFile = File(p.join(supportDir.path, _configFile));
      if (await configFile.exists()) {
        final content = await configFile.readAsString();
        final Map<String, dynamic> data = jsonDecode(content);
        if (data['backup_path'] != null && data['backup_path'].toString().isNotEmpty) {
          final customDir = Directory(data['backup_path'].toString());
          if (await customDir.exists()) {
            return customDir.path;
          }
        }
      }
    } catch (_) {}

    // Fallback: Documents/Amjid_Traila_Backups
    final docsDir = await getApplicationDocumentsDirectory();
    final defaultDir = Directory(p.join(docsDir.path, 'Amjid_Traila_Backups'));
    if (!await defaultDir.exists()) {
      await defaultDir.create(recursive: true);
    }
    return defaultDir.path;
  }

  /// Saves the user-selected backup directory path.
  static Future<void> setBackupDirectory(String newPath) async {
    final supportDir = await getApplicationSupportDirectory();
    final configFile = File(p.join(supportDir.path, _configFile));
    final data = {'backup_path': newPath, 'updated_at': DateTime.now().toIso8601String()};
    await configFile.writeAsString(jsonEncode(data));
  }

  /// Opens a desktop directory picker to allow the user to choose their backup folder.
  static Future<String?> pickBackupDirectory() async {
    final String? selectedDirectory = await getDirectoryPath(
      confirmButtonText: 'Select Backup Storage Location',
    );
    if (selectedDirectory != null && selectedDirectory.isNotEmpty) {
      await setBackupDirectory(selectedDirectory);
      return selectedDirectory;
    }
    return null;
  }

  /// Creates a complete snapshot backup of `traila.db` inside a timestamped folder:
  /// Folder Name Format: [DayName]_[dd-MMMM-yyyy]_[hh-mm-a]
  /// Example: Wednesday_28-October-2026_08-45-PM
  static Future<BackupItem> createBackup({String? customDestinationDir}) async {
    final baseDir = customDestinationDir ?? await getBackupDirectory();
    final now = DateTime.now();
    
    // Windows friendly name: Day name, Date, and Time
    final folderName = DateFormat('EEEE_dd-MMMM-yyyy_hh-mm-a').format(now);
    final targetFolder = Directory(p.join(baseDir, folderName));

    if (!await targetFolder.exists()) {
      await targetFolder.create(recursive: true);
    }

    final activeDb = await getActiveDatabaseFile();
    if (!await activeDb.exists()) {
      throw Exception('Active database file does not exist at: ${activeDb.path}');
    }

    final destDbFile = File(p.join(targetFolder.path, 'traila.db'));
    await activeDb.copy(destDbFile.path);

    // Also copy WAL files if present to prevent any uncommitted data loss
    final walFile = File('${activeDb.path}-wal');
    if (await walFile.exists()) {
      try {
        await walFile.copy(p.join(targetFolder.path, 'traila.db-wal'));
      } catch (_) {}
    }

    final shmFile = File('${activeDb.path}-shm');
    if (await shmFile.exists()) {
      try {
        await shmFile.copy(p.join(targetFolder.path, 'traila.db-shm'));
      } catch (_) {}
    }

    final dbSize = await destDbFile.length();

    // Write a rich manifest file
    final manifest = {
      'system': 'Amjid Trailer Maker Management System',
      'version': '3.0 Pro Enterprise',
      'backupTimestamp': now.toIso8601String(),
      'folderName': folderName,
      'dbSizeBytes': dbSize,
      'createdAt': DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
    };

    final manifestFile = File(p.join(targetFolder.path, 'backup_manifest.json'));
    await manifestFile.writeAsString(const JsonEncoder.withIndent('  ').convert(manifest));

    return BackupItem(
      folderName: folderName,
      folderPath: targetFolder.path,
      dbFilePath: destDbFile.path,
      timestamp: now,
      sizeBytes: dbSize,
    );
  }

  /// Lists all valid backups located in the configured backup directory.
  static Future<List<BackupItem>> listBackups() async {
    final baseDir = Directory(await getBackupDirectory());
    if (!await baseDir.exists()) return [];

    final List<BackupItem> backups = [];
    final entities = await baseDir.list().toList();

    for (final entity in entities) {
      if (entity is Directory) {
        final dbFile = File(p.join(entity.path, 'traila.db'));
        if (await dbFile.exists()) {
          final stat = await dbFile.stat();
          final folderName = p.basename(entity.path);
          
          DateTime time = stat.modified;
          // Try to parse from manifest
          final manifestFile = File(p.join(entity.path, 'backup_manifest.json'));
          if (await manifestFile.exists()) {
            try {
              final content = await manifestFile.readAsString();
              final data = jsonDecode(content);
              if (data['backupTimestamp'] != null) {
                time = DateTime.parse(data['backupTimestamp']);
              }
            } catch (_) {}
          }

          backups.add(BackupItem(
            folderName: folderName,
            folderPath: entity.path,
            dbFilePath: dbFile.path,
            timestamp: time,
            sizeBytes: stat.size,
          ));
        }
      }
    }

    // Sort newest first
    backups.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return backups;
  }

  /// Opens desktop file picker for the user to select an existing backup (.db file or folder).
  static Future<String?> pickBackupFileToRestore() async {
    const typeGroup = XTypeGroup(
      label: 'Database',
      extensions: ['db', 'sqlite', 'sqlite3'],
    );
    final XFile? file = await openFile(
      acceptedTypeGroups: const [typeGroup],
      confirmButtonText: 'Select Backup Database',
    );
    return file?.path;
  }

  /// Restores a selected database file by replacing the active `traila.db`.
  static Future<void> restoreDatabase(String sourceDbPath) async {
    final sourceFile = File(sourceDbPath);
    if (!await sourceFile.exists()) {
      throw Exception('Selected backup database file does not exist: $sourceDbPath');
    }

    final activeDb = await getActiveDatabaseFile();

    // Remove old active WAL and SHM to guarantee clean start with restored file
    final walFile = File('${activeDb.path}-wal');
    if (await walFile.exists()) {
      try {
        await walFile.delete();
      } catch (_) {}
    }

    final shmFile = File('${activeDb.path}-shm');
    if (await shmFile.exists()) {
      try {
        await shmFile.delete();
      } catch (_) {}
    }

    // Overwrite active database file
    await sourceFile.copy(activeDb.path);
  }

  /// Opens the backup directory in Windows File Explorer.
  static Future<void> openInExplorer(String folderPath) async {
    if (Platform.isWindows) {
      await Process.run('explorer.exe', [folderPath]);
    }
  }
}
