import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Veritabanı işlemlerini yöneten yardımcı sınıf
class DatabaseHelper {
  static final DatabaseHelper _instance =
      DatabaseHelper._internal(); // Singleton instance oluşturuluyor
  Database? _database; // Veritabanı nesnesi

  factory DatabaseHelper() {
    return _instance; // Singleton instance'ı döndürür
  }

  DatabaseHelper._internal() {
    _initDatabase(); // Veritabanını başlat
  }

  // Veritabanını başlatma işlemi
  Future<void> _initDatabase() async {
    final databasePath = await getDatabasesPath(); // Veritabanı dosya yolunu al
    final path =
        join(databasePath, 'app_database.db'); // Veritabanı dosya yolu oluştur

    _database = await openDatabase(
      path,
      version: 2, // Veritabanı versiyonu
      onCreate: (db, version) async {
        // Veritabanı ilk kez oluşturulduğunda tabloları oluştur
        await db.execute(
          'CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, password TEXT)', // Kullanıcılar tablosu oluştur
        );
        await db.execute(
          'CREATE TABLE medicines (id INTEGER PRIMARY KEY, name TEXT, time TEXT)', // İlaçlar tablosu oluştur
        );
        await db.execute(
          'CREATE TABLE serums (id INTEGER PRIMARY KEY, name TEXT, time TEXT, dose TEXT)', // Serumlar tablosu oluştur
        );
        await db.execute(
          'CREATE TABLE jabs (id INTEGER PRIMARY KEY, name TEXT, location TEXT, time TEXT)', // İğneler tablosu oluştur
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Veritabanı güncellendiğinde yapılacak işlemler
        if (oldVersion < 2) {
          // Eski versiyon 2'den küçükse serum tablosunu oluştur
          await db.execute(
            'CREATE TABLE serums (id INTEGER PRIMARY KEY, name TEXT, time TEXT, dose TEXT)', // Serumlar tablosu oluştur
          );
        }
        if (oldVersion < 3) {
          // Eski versiyon 3'ten küçükse iğne tablosunu oluştur
          await db.execute(
            'CREATE TABLE jabs (id INTEGER PRIMARY KEY, name TEXT, location TEXT, time TEXT)', // İğneler tablosu oluştur
          );
        }
      },
    );
  }

  // Kullanıcı kaydı ekleme fonksiyonu
  Future<void> registerUser(String username, String password) async {
    await _database?.insert(
      'users',
      {'username': username, 'password': password}, // Yeni kullanıcıyı ekle
    );
  }

  // Kullanıcı giriş kontrol fonksiyonu
  Future<bool> loginUser(String username, String password) async {
    final List<Map<String, dynamic>> users = await _database!.query(
      'users',
      where: 'username = ? AND password = ?', // Kullanıcı adı ve şifre kontrolü
      whereArgs: [username, password],
    );
    return users.isNotEmpty; // Kullanıcı var mı kontrolü
  }

  // Yeni ilaç ekleme fonksiyonu
  Future<void> insertMedicine(Map<String, dynamic> medicine) async {
    await _database?.insert(
      'medicines',
      medicine,
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Çakışma durumunda güncelle
    );
  }

  // İlaçları getirme fonksiyonu
  Future<List<Map<String, dynamic>>> getMedicines() async {
    return await _database!.query('medicines'); // İlaçları getir
  }

  // İlaç güncelleme fonksiyonu
  Future<void> updateMedicine(Map<String, dynamic> medicine) async {
    await _database!.update(
      'medicines',
      medicine,
      where: 'id = ?',
      whereArgs: [medicine['id']], // Güncellenecek ilacı id'ye göre bul
    );
  }

  // İlaç silme fonksiyonu
  Future<void> deleteMedicine(int id) async {
    await _database!.delete(
      'medicines',
      where: 'id = ?',
      whereArgs: [id], // Silinecek ilacı id'ye göre bul
    );
  }

  // Yeni serum ekleme fonksiyonu
  Future<void> insertSerum(Map<String, dynamic> serum) async {
    await _database?.insert(
      'serums',
      serum,
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Çakışma durumunda güncelle
    );
  }

  // Serumları getirme fonksiyonu
  Future<List<Map<String, dynamic>>> getSerums() async {
    return await _database!.query('serums'); // Serumları getir
  }

  // Serum güncelleme fonksiyonu
  Future<void> updateSerum(Map<String, dynamic> serum) async {
    await _database!.update(
      'serums',
      serum,
      where: 'id = ?',
      whereArgs: [serum['id']], // Güncellenecek serumu id'ye göre bul
    );
  }

  // Serum silme fonksiyonu
  Future<void> deleteSerum(int id) async {
    await _database!.delete(
      'serums',
      where: 'id = ?',
      whereArgs: [id], // Silinecek serumu id'ye göre bul
    );
  }

  // Yeni iğne ekleme fonksiyonu
  Future<void> insertJab(Map<String, dynamic> jab) async {
    await _database?.insert(
      'jabs',
      jab,
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Çakışma durumunda güncelle
    );
  }

  // İğneleri getirme fonksiyonu
  Future<List<Map<String, dynamic>>> getJabs() async {
    return await _database!.query('jabs'); // İğneleri getir
  }

  // İğne güncelleme fonksiyonu
  Future<void> updateJab(Map<String, dynamic> jab) async {
    await _database!.update(
      'jabs',
      jab,
      where: 'id = ?',
      whereArgs: [jab['id']], // Güncellenecek iğneyi id'ye göre bul
    );
  }

  // İğne silme fonksiyonu
  Future<void> deleteJab(int id) async {
    await _database!.delete(
      'jabs',
      where: 'id = ?',
      whereArgs: [id], // Silinecek iğneyi id'ye göre bul
    );
  }
}
