import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart'; // Tarih ve saat biçimlendirme için intl paketi

// İlaç model sınıfı
class Medicine {
  final int id;
  final String name;
  final String time;

  Medicine({required this.id, required this.name, required this.time});

  // İlaç nesnesini haritaya dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time': time,
    };
  }
}

// MedicinePage, ilaç ekleme ve güncelleme işlemlerini gerçekleştiren sayfa
class MedicinePage extends StatefulWidget {
  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  final _nameController = TextEditingController();
  final _timeController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Medicine> _medicines = [];

  @override
  void initState() {
    super.initState();
    _loadMedicines(); // İlaç verilerini yükle
  }

  // İlaçları veritabanından yükle
  void _loadMedicines() async {
    List<Map<String, dynamic>> medicinesMap =
        await _databaseHelper.getMedicines();
    List<Medicine> medicines = medicinesMap
        .map((medicine) => Medicine(
              id: medicine['id'],
              name: medicine['name'],
              time: medicine['time'],
            ))
        .toList();

    setState(() {
      _medicines = medicines;
    });
  }

  // İlaç ekleme veya güncelleme işlemleri için diyalog kutusu aç
  void _addOrUpdateMedicine({Medicine? medicine}) {
    final isUpdating = medicine != null;
    if (isUpdating) {
      // Güncelleme işlemi için mevcut verilerle doldur
      _nameController.text = medicine.name;
      _timeController.text = medicine.time;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isUpdating ? 'İlacı Güncelle' : 'Yeni İlaç Ekle'),
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
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (isUpdating) {
                  // İlaç güncelleme işlemi
                  await _databaseHelper.updateMedicine({
                    'id': medicine.id,
                    'name': _nameController.text,
                    'time': _timeController.text,
                  });
                  _showNotification('İlaç Güncellendi', _nameController.text);
                  print(
                      'Updated medicine: ${_nameController.text} at ${_formatDateTime(DateTime.now())}');
                } else {
                  // Yeni ilaç ekleme işlemi
                  await _databaseHelper.insertMedicine({
                    'name': _nameController.text,
                    'time': _timeController.text,
                  });
                  _showNotification('Yeni İlaç Eklendi', _nameController.text);
                  print(
                      'Added new medicine: ${_nameController.text} at ${_formatDateTime(DateTime.now())}');
                }
                _nameController.clear();
                _timeController.clear();
                _loadMedicines();
                Navigator.of(context).pop();
              },
              child: Text(isUpdating ? 'Güncelle' : 'Ekle'),
            ),
          ],
        );
      },
    );
  }

  // İlaç silme işlemi
  void _deleteMedicine(int id) async {
    await _databaseHelper.deleteMedicine(id);
    _loadMedicines(); // İlaçları yeniden yükle
    print(
        'Deleted medicine with ID: $id at ${_formatDateTime(DateTime.now())}');
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
        title: Text('İlaçlar'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _medicines.length,
              itemBuilder: (context, index) {
                final medicine = _medicines[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(
                      medicine.name,
                      style: TextStyle(
                        fontFamily: 'Helvetica', // Özel yazı tipi
                        fontWeight: FontWeight.bold, // Kalın yazı tipi
                      ),
                    ),
                    subtitle: Text('Saat: ${medicine.time}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _addOrUpdateMedicine(medicine: medicine),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMedicine(medicine.id),
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
        onPressed: () => _addOrUpdateMedicine(),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Sağ alt köşeye al
    );
  }
}
