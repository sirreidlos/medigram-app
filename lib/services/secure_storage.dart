import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A service class that provides secure storage functionality for sensitive data.
/// 
/// This service uses [FlutterSecureStorage] to store data securely on mobile platforms.
/// For Android, it uses encrypted shared preferences, and for iOS, it uses the keychain.
/// 
/// The service is implemented as a singleton to ensure consistent access across the app.
class SecureStorageService {
  /// Singleton instance of [SecureStorageService]
  static final SecureStorageService _instance = SecureStorageService._internal();
  
  /// Factory constructor that returns the singleton instance
  factory SecureStorageService() => _instance;

  /// The underlying secure storage instance with platform-specific configurations
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true, // Uses Android's EncryptedSharedPreferences for better security
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock, // Data is available after first device unlock
    ),
  );

  /// Private constructor for singleton implementation
  SecureStorageService._internal();

  /// Writes a value to secure storage
  /// 
  /// [key] - The key to store the value under
  /// [value] - The value to store
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Reads a value from secure storage
  /// 
  /// [key] - The key to read the value from
  /// Returns the stored value, or null if no value exists for the given key
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Deletes a value from secure storage
  /// 
  /// [key] - The key of the value to delete
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Clears all values from secure storage
  /// 
  /// This is typically called during logout to remove all stored credentials
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
