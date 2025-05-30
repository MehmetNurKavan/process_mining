# Mini Süreç Madenciliği Uygulaması

Bu proje, kullanıcıdan `.csv` dosyası alarak temel süreç madenciliği analizleri yapan bir uygulamadır. Arka planda Python kullanılarak analizler yapılır, kullanıcı arayüzü ise Flutter (web veya masaüstü) ile sunulur.

---

## 🔧 Teknolojiler

* 📊 **Python**: Veri analizi için `pandas`, `matplotlib`, `Flask`
* 💻 **Flutter**: Arayüz (Windows/Mac/Linux/Web için)
* 📁 **CSV Dosya Analizi**
* 🌐 **HTTP API** ile Flutter <-> Python iletişimi

---

## 📁 Klasör Yapısı

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

## 🚀 Kurulum ve Çalıştırma

### 1. Python Backend (API)

#### 📦 Gereksinimler:

* Python 3.8+
* pip

#### ⚖️ Kurulum:

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

#### `app.py` örnek içeriği:

```python
from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd

app = Flask(__name__)
CORS(app)

@app.route('/analyze', methods=['POST'])
def analyze():
    file = request.files['file']
    df = pd.read_csv(file)
    df['Start Time'] = pd.to_datetime(df['Start Time'])
    df['End Time'] = pd.to_datetime(df['End Time'])

    durations = df.groupby('Case ID').agg({'Start Time': 'min', 'End Time': 'max'})
    durations['Total Duration'] = durations['End Time'] - durations['Start Time']
    case_durations = durations['Total Duration'].astype(str).to_dict()

    activity_counts = df['Activity Name'].value_counts().to_dict()

    avg_duration = str((durations['End Time'] - durations['Start Time']).mean())

    transitions = []
    for case_id, group in df.groupby('Case ID'):
        sorted_group = group.sort_values('Start Time')
        acts = list(sorted_group['Activity Name'])
        for i in range(len(acts)-1):
            transitions.append((acts[i], acts[i+1]))
    transition_counts = pd.Series(transitions).value_counts().to_dict()

    return jsonify({
        'case_durations': case_durations,
        'activity_counts': activity_counts,
        'average_duration': avg_duration,
        'transition_counts': transition_counts
    })

if __name__ == '__main__':
    app.run(debug=True)
```

---

### 2. Flutter Arayüz (Frontend)

#### 🧰 Gereksinimler:

* Flutter SDK yüklü
* (Masaüstü için) `flutter config --enable-windows-desktop` komutu çalıştırılmış olmalı
* (Web için) Chrome tarayıcı yüklü

#### 📦 Gerekli Paketler (`pubspec.yaml`):

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.4.0
  file_picker: ^10.1.9
```

#### 🚀 Flutter Projeyi Başlat:

```bash
cd frontend/flutter_project
flutter pub get
flutter run -d chrome  # ya da masaüstü için: flutter run -d windows
```

#### `main.dart` Örnek İçeriği:

```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ProcessMiningApp());
}

class ProcessMiningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Süreç Madenciliği',
      home: ProcessMiningPage(),
    );
  }
}

class ProcessMiningPage extends StatefulWidget {
  @override
  _ProcessMiningPageState createState() => _ProcessMiningPageState();
}

class _ProcessMiningPageState extends State<ProcessMiningPage> {
  String result = "";

  Future<void> uploadAndAnalyze() async {
    FilePickerResult? picked = await FilePicker.platform.pickFiles();
    if (picked != null && picked.files.single.bytes != null) {
      var uri = Uri.parse("http://127.0.0.1:5000/analyze");
      var request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes('file', picked.files.single.bytes!,
            filename: picked.files.single.name));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      setState(() {
        result = const JsonEncoder.withIndent('  ').convert(jsonDecode(responseBody));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mini Süreç Madenciliği")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: uploadAndAnalyze,
              child: Text("CSV Dosyası Seç ve Analiz Et"),
            ),
            SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: Text(result))),
          ],
        ),
      ),
    );
  }
}
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