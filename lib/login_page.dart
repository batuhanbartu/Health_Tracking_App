import 'package:flutter/material.dart';
import 'package:health_tracking_app/home_page.dart'; // Ana sayfa için gerekli olan dosyanın eklenmesi
import 'package:health_tracking_app/database_helper.dart'; // Veritabanı işlemleri için yardımcı sınıfın eklenmesi

// LoginPage sınıfı, kullanıcı adı ve şifre ile giriş işlemlerini gerçekleştiren sayfa
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() =>
      _LoginPageState(); // State nesnesinin oluşturulması
}

class _LoginPageState extends State<LoginPage> {
  // Kullanıcı adı ve şifre için text controller'lar
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Veritabanı işlemleri için yardımcı nesne
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Buton oluşturma metodu
  Widget buildButton({
    required String label,
    required VoidCallback onPressed,
    Color? color,
    List<Color>? gradient,
  }) {
    return Container(
      width: double.infinity, // Konteynırın tam genişlik kaplaması
      height: 50, // Yükseklik
      decoration: BoxDecoration(
        gradient: gradient != null
            ? LinearGradient(
                colors: gradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null, // Gradient varsa kullanılır
        color: color, // Renk veya gradient yoksa renk kullanılır
        borderRadius: BorderRadius.circular(30), // Köşe yuvarlaklığı
      ),
      child: ElevatedButton(
        onPressed: onPressed, // Tıklama olayı
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Butonun arka plan rengi şeffaf
          shadowColor: Colors.transparent, // Gölge rengi
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16), // Buton metni
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "lib/assets/images/login_logo.jpg"), // Arka plan resmi
            fit: BoxFit.cover, // Resmin kaplama modu
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0), // İç boşluk
            child: SingleChildScrollView(
              // Kaydırılabilir ekran
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // İçerikleri merkeze hizalama
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextField(
                    controller:
                        _usernameController, // Kullanıcı adı giriş alanı
                    decoration: InputDecoration(
                      labelText: 'Kullanıcı Adı', // Etiket
                      prefixIcon: Icon(Icons.person), // Ön simge
                      border: OutlineInputBorder(), // Çerçeve
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7), // Dolgu rengi
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _passwordController, // Şifre giriş alanı
                    decoration: InputDecoration(
                      labelText: 'Şifre', // Etiket
                      prefixIcon: Icon(Icons.lock), // Ön simge
                      border: OutlineInputBorder(), // Çerçeve
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7), // Dolgu rengi
                    ),
                    obscureText: true, // Şifrenin gizlenmesi
                  ),
                  SizedBox(height: 20.0),
                  buildButton(
                    label: 'Giriş Yap', // Buton metni
                    onPressed: () async {
                      final username =
                          _usernameController.text; // Kullanıcı adı alınır
                      final password = _passwordController.text; // Şifre alınır
                      if (await _databaseHelper.loginUser(username, password)) {
                        // Giriş başarılı ise
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                                username: username), // Ana sayfaya yönlendir
                          ),
                        );
                      } else {
                        // Giriş başarısız ise
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Giriş başarısız!'), // Hata mesajı göster
                          ),
                        );
                      }
                    },
                    gradient: [
                      Color.fromARGB(
                          255, 190, 0, 0), // Gradient başlangıç rengi
                      Colors.blue.shade400, // Gradient bitiş rengi
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Hesabın yok mu ?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => _buildRegisterDialog(),
                        ),
                        child: Text(
                          "Hesap oluştur",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Kullanıcı kayıt diyalog penceresi
  Widget _buildRegisterDialog() {
    final TextEditingController _newUsernameController =
        TextEditingController();
    final TextEditingController _newPasswordController =
        TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();

    return AlertDialog(
      title: Text('Hesap Oluştur'), // Diyalog başlığı
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _newUsernameController,
            decoration: InputDecoration(
                labelText: 'Kullanıcı Adı'), // Kullanıcı adı giriş alanı
          ),
          TextField(
            controller: _newPasswordController,
            decoration:
                InputDecoration(labelText: 'Şifre'), // Şifre giriş alanı
            obscureText: true,
          ),
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
                labelText: 'Şifreyi Onayla'), // Şifre teyit alanı
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // İptal düğmesi
          child: Text('İptal'),
        ),
        TextButton(
          onPressed: () {
            final username = _newUsernameController.text;
            final password = _newPasswordController.text;
            final confirmPassword = _confirmPasswordController.text;
            if (password == confirmPassword) {
              // Şifreler uyuşuyorsa
              _databaseHelper.registerUser(
                  username, password); // Kullanıcı kayıt
              Navigator.of(context).pop(); // Diyalogu kapat
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Kullanıcı oluşturuldu!')), // Başarı mesajı
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Şifreler uyuşmuyor!')), // Hata mesajı
              );
            }
          },
          child: Text('Oluştur'), // Kayıt düğmesi
        ),
      ],
    );
  }
}
