import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ProcessMiningPage extends StatefulWidget {
  @override
  State<ProcessMiningPage> createState() => _ProcessMiningPageState();
}

class _ProcessMiningPageState extends State<ProcessMiningPage> {
  String _output = "Henüz analiz yapılmadı.";

  Future<void> pickAndAnalyzeCsv() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.path != null) {
      String csvPath = result.files.single.path!;

      try {
        // Python scriptini çalıştır
        ProcessResult pr = await Process.run('python', ['main.py', csvPath]);

        if (pr.exitCode == 0) {
          var data = jsonDecode(pr.stdout);
          setState(() {
            _output = formatResult(data);
          });
        } else {
          setState(() {
            _output = "Python hata verdi:\n${pr.stderr}";
          });
        }
      } catch (e) {
        setState(() {
          _output = "Çalıştırma hatası: $e";
        });
      }
    }
  }

  String formatResult(dynamic data) {
    StringBuffer sb = StringBuffer();

    sb.writeln("[1] Her Case ID'nin Toplam Süresi:");
    data["CaseDurations"].forEach((k, v) => sb.writeln("$k: $v"));

    sb.writeln("\n[2] En Sık Gerçekleşen Adımlar:");
    data["FrequentActivities"].forEach((k, v) => sb.writeln("$k: $v"));

    sb.writeln("\n[3] Ortalama Süreç Tamamlanma Süresi:");
    sb.writeln(data["AverageCompletionTime"]);

    sb.writeln("\n[4] En Sık Adım Geçişleri:");
    data["TransitionFrequency"].forEach((k, v) => sb.writeln("$k: $v"));

    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Süreç Madenciliği Uygulaması")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickAndAnalyzeCsv,
              child: Text("CSV Dosyası Seç ve Analiz Et"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(_output),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
