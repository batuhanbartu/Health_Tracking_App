import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart'; // Tarih ve saat biçimlendirme için intl paketi

// Serum model sınıfı
class Serum {
  final int id;
  final String name;
  final String time;
  final String dose;

  Serum({
    required this.id,
    required this.name,
    required this.time,
    required this.dose,
  });

  // Serum nesnesini haritaya dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'dose': dose,
    };
  }
}

// SerumPage, serum ekleme ve güncelleme işlemlerini gerçekleştiren sayfa
class SerumPage extends StatefulWidget {
  @override
  _SerumPageState createState() => _SerumPageState();
}

class _SerumPageState extends State<SerumPage> {
  final _nameController = TextEditingController();
  final _timeController = TextEditingController();
  final _doseController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Serum> _serums = [];

  @override
  void initState() {
    super.initState();
    _loadSerums(); // Serum verilerini yükle
  }

  // Serumları veritabanından yükle
  void _loadSerums() async {
    List<Map<String, dynamic>> serumsMap = await _databaseHelper.getSerums();
    List<Serum> serums = serumsMap
        .map((serum) => Serum(
              id: serum['id'],
              name: serum['name'],
              time: serum['time'],
              dose: serum['dose'],
            ))
        .toList();

    setState(() {
      _serums = serums;
    });
  }

  // Serum ekleme veya güncelleme işlemleri için diyalog kutusu aç
  void _addOrUpdateSerum({Serum? serum}) {
    final isUpdating = serum != null;
    if (isUpdating) {
      // Güncelleme işlemi için mevcut verilerle doldur
      _nameController.text = serum.name;
      _timeController.text = serum.time;
      _doseController.text = serum.dose;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isUpdating ? 'Serumu Güncelle' : 'Yeni Serum Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Ad'),
              ),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Saat'),
              ),
              TextField(
                controller: _doseController,
                decoration: InputDecoration(labelText: 'Doz'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (isUpdating) {
                  // Serum güncelleme işlemi
                  await _databaseHelper.updateSerum({
                    'id': serum.id,
                    'name': _nameController.text,
                    'time': _timeController.text,
                    'dose': _doseController.text,
                  });
                  _showNotification('Serum Güncellendi', _nameController.text);
                  print(
                      'Updated serum: ${_nameController.text} at ${_formatDateTime(DateTime.now())}');
                } else {
                  // Yeni serum ekleme işlemi
                  await _databaseHelper.insertSerum({
                    'name': _nameController.text,
                    'time': _timeController.text,
                    'dose': _doseController.text,
                  });
                  _showNotification('Yeni Serum Eklendi', _nameController.text);
                  print(
                      'Added new serum: ${_nameController.text} at ${_formatDateTime(DateTime.now())}');
                }
                _nameController.clear();
                _timeController.clear();
                _doseController.clear();
                _loadSerums();
                Navigator.of(context).pop();
              },
              child: Text(isUpdating ? 'Güncelle' : 'Ekle'),
            ),
          ],
        );
      },
    );
  }

  // Serum silme işlemi
  void _deleteSerum(int id) async {
    await _databaseHelper.deleteSerum(id);
    _loadSerums(); // Serumları yeniden yükle
    print('Deleted serum with ID: $id at ${_formatDateTime(DateTime.now())}');
  }

  // Tarih ve saat biçimlendirme
  String _formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  // Bildirim simülasyonu
  void _showNotification(String title, String body) {
    print('$title: $body'); // Bildirim mesajını konsola yazdır
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Serumlar'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _serums.length,
              itemBuilder: (context, index) {
                final serum = _serums[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(
                      serum.name,
                      style: TextStyle(
                        fontFamily: 'Helvetica', // Özel yazı tipi
                        fontWeight: FontWeight.bold, // Kalın yazı tipi
                      ),
                    ),
                    subtitle: Text('Saat: ${serum.time} Doz: ${serum.dose}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _addOrUpdateSerum(serum: serum),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteSerum(serum.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addOrUpdateSerum(),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Sağ alt köşeye al
    );
  }
}
