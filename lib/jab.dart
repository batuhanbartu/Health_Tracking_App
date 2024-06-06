import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart'; // Tarih ve saat biçimlendirme için intl paketi

// İğne model sınıfı
class Jab {
  final int id;
  final String name;
  final String location;
  final String time;

  Jab({
    required this.id,
    required this.name,
    required this.location,
    required this.time,
  });

  // İğne nesnesini haritaya dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'time': time,
    };
  }
}

// JabPage, iğne ekleme ve güncelleme işlemlerini gerçekleştiren sayfa
class JabPage extends StatefulWidget {
  @override
  _JabPageState createState() => _JabPageState();
}

class _JabPageState extends State<JabPage> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _timeController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Jab> _jabs = [];

  @override
  void initState() {
    super.initState();
    _loadJabs(); // İğne verilerini yükle
  }

  // İğneleri veritabanından yükle
  void _loadJabs() async {
    List<Map<String, dynamic>> jabsMap = await _databaseHelper.getJabs();
    List<Jab> jabs = jabsMap
        .map((jab) => Jab(
              id: jab['id'],
              name: jab['name'],
              location: jab['location'],
              time: jab['time'],
            ))
        .toList();

    setState(() {
      _jabs = jabs;
    });
  }

  // İğne ekleme veya güncelleme işlemleri için diyalog kutusu aç
  void _addOrUpdateJab({Jab? jab}) {
    final isUpdating = jab != null;
    if (isUpdating) {
      // Güncelleme işlemi için mevcut verilerle doldur
      _nameController.text = jab.name;
      _locationController.text = jab.location;
      _timeController.text = jab.time;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isUpdating ? 'İğneyi Güncelle' : 'Yeni İğne Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Ad'),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Vurulma Yeri'),
              ),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Saat'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (isUpdating) {
                  // İğne güncelleme işlemi
                  await _databaseHelper.updateJab({
                    'id': jab.id,
                    'name': _nameController.text,
                    'location': _locationController.text,
                    'time': _timeController.text,
                  });
                  _showNotification('İğne Güncellendi', _nameController.text);
                  print(
                      'Updated jab: ${_nameController.text} at ${_formatDateTime(DateTime.now())}');
                } else {
                  // Yeni iğne ekleme işlemi
                  await _databaseHelper.insertJab({
                    'name': _nameController.text,
                    'location': _locationController.text,
                    'time': _timeController.text,
                  });
                  _showNotification('Yeni İğne Eklendi', _nameController.text);
                  print(
                      'Added new jab: ${_nameController.text} at ${_formatDateTime(DateTime.now())}');
                }
                _nameController.clear();
                _locationController.clear();
                _timeController.clear();
                _loadJabs();
                Navigator.of(context).pop();
              },
              child: Text(isUpdating ? 'Güncelle' : 'Ekle'),
            ),
          ],
        );
      },
    );
  }

  // İğne silme işlemi
  void _deleteJab(int id) async {
    await _databaseHelper.deleteJab(id);
    _loadJabs(); // İğneleri yeniden yükle
    print('Deleted jab with ID: $id at ${_formatDateTime(DateTime.now())}');
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
        title: Text('İğneler'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _jabs.length,
              itemBuilder: (context, index) {
                final jab = _jabs[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(
                      jab.name,
                      style: TextStyle(
                        fontFamily: 'Helvetica', // Özel yazı tipi
                        fontWeight: FontWeight.bold, // Kalın yazı tipi
                      ),
                    ),
                    subtitle:
                        Text('Vurulma Yeri: ${jab.location} Saat: ${jab.time}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _addOrUpdateJab(jab: jab),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteJab(jab.id),
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
        onPressed: () => _addOrUpdateJab(),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Sağ alt köşeye al
    );
  }
}
