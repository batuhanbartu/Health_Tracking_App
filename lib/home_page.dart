import 'package:flutter/material.dart';

// HomePage sınıfı, kullanıcı adı alarak ana ekranı oluşturur
class HomePage extends StatelessWidget {
  final String username; // Kullanıcı adını alacak değişken

  HomePage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // AppBar'ın arka planının genişlemesini sağlar
      appBar: AppBar(
        title: Text(
          'Hoşgeldiniz $username',
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0), // Metin rengi
            fontWeight: FontWeight.bold, // Kalın yazı tipi
            fontSize: 24, // Yazı tipi boyutu
          ),
        ),
        backgroundColor: Colors.transparent, // Arka plan rengini şeffaf yapar
        elevation: 0, // Gölgeyi kaldırır
        centerTitle: true, // Başlığı ortalar
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: const Color.fromARGB(
                  255, 0, 0, 0)), // Geri düğmesi ikonu ve rengi
          onPressed: () {
            // LoginPage'e yönlendirme yapar ve diğer sayfaları temizler
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Colors.blue.shade400
            ], // Arka plan renkleri
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ), // Arka plan rengi degrade olacak şekilde ayarlandı
        child: SafeArea(
          child: Center(
            child: GridView.count(
              crossAxisCount: 2, // GridView'da iki sütun olacak
              padding: EdgeInsets.all(16.0), // GridView içindeki boşluklar
              childAspectRatio:
                  1, // Kutu en-boy oranı 1:1 olacak şekilde ayarlandı
              children: <Widget>[
                _buildCategoryItem(
                    context,
                    'İlaçlar',
                    'lib/assets/images/ilac_resmi.jpg',
                    '/medicine'), // İlaçlar kategorisi
                _buildCategoryItem(
                    context,
                    'İğneler',
                    'lib/assets/images/igne_resmi.jpg',
                    '/jab'), // İğneler kategorisi
                _buildCategoryItem(
                    context,
                    'Serumlar',
                    'lib/assets/images/serum_resmi.jpg',
                    '/serum'), // Serumlar kategorisi
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Kategori öğesi oluşturma fonksiyonu
  Widget _buildCategoryItem(
      BuildContext context, String title, String imagePath, String route) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15.0), // Kartın kenarlarını yuvarlatır
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // İlgili sayfaya yönlendirme
          Navigator.pushNamed(context, route);
        },
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(imagePath,
                  fit: BoxFit.cover), // Kutuya resim ekler ve kaplama modu
            ),
            Center(
              child: Container(
                color: Colors.black.withOpacity(0.5), // Şeffaf arka plan
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white, // Metin rengi
                    fontSize: 30, // Yazı tipi boyutu
                    fontWeight: FontWeight.bold, // Kalın yazı tipi
                  ),
                  textAlign: TextAlign.center, // Metni ortalar
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
