# Mini Süreç Madenciliği Uygulaması

Bu proje, kullanıcıdan `.csv` dosyası alarak temel süreç madenciliği analizleri yapan bir uygulamadır. Arka planda Python kullanılarak analizler yapılır, kullanıcı arayüzü ise Flutter (web veya masaüstü) ile sunulur.

---

![Ekran görüntüsü 2025-05-31 145250](https://github.com/user-attachments/assets/e74ddbec-fb1b-459b-ab74-a745b1640566)
![Ekran görüntüsü 2025-05-31 150106](https://github.com/user-attachments/assets/4faedcbb-f78f-4f31-b240-72f37db80535)
![Ekran görüntüsü 2025-05-31 145908](https://github.com/user-attachments/assets/617a0a58-53e0-4aeb-a8a6-8e4359f59c6d)


## 🔧 Teknolojiler

* 📊 **Python**: Veri analizi için `pandas`, `matplotlib`, `Flask`
* 💻 **Flutter**: Arayüz (Windows/Mac/Linux/Web için)
* 📁 **CSV Dosya Analizi**
* 🌐 **HTTP API** ile Flutter <-> Python iletişimi

---

## Klasör Yapısı

```
.
├── backend/
│   ├── main.py
│   ├── requirements.txt
├── frontend/
│   └── process_mining/
│       └── lib/
│           └── main.dart
│           └── home_screen.dart
├── example_csv/
│   └── ornek_surec_verisi.csv
├── README.md
```

---

##  Kurulum ve Çalıştırma

### 1. Python Backend (API)

#### Gereksinimler:

* Python 3.8+
* pip

#### Kurulum:

```bash
cd backend
pip install -r requirements.txt
python app.py
```

#### `requirements.txt` içeriği:

```txt
pandas
flask
flask-cors
```

---

### 2. Flutter Arayüz (Frontend)

#### Gereksinimler:

* Flutter SDK yüklü
* (Masaüstü için) `flutter config --enable-windows-desktop` komutu çalıştırılmış olmalı
* (Web için) Chrome tarayıcı yüklü

#### Gerekli Paketler (`pubspec.yaml`):

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.4.0
  file_picker: ^10.1.9
```

#### Flutter Projeyi Başlat:

```bash
cd frontend/flutter_project
flutter pub get
flutter run -d chrome  # ya da masaüstü için: flutter run -d windows
```

---

## 📷 Örnek Çıktılarpip install -r requirements.txt

* [x] Her Case ID için toplam süre
* [x] En sık gerçekleşen adımlar
* [x] Ortalama süreç süreleri
* [x] En sık gerçekleşen geçişler

---

## 📌 Notlar

* Pytohn çaliştirma

```python
pip install -r requirements.txt

python main.py
```

* Python backend çalışıyorken `http://127.0.0.1:5000` adresi kullanılabilir.
* Flutter Web için `flutter run -d chrome` komutu kullanılabilir..
* Flutter Masaüstü için `flutter run -d windows` komutu kullanılabilir.
