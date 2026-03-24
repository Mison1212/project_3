import 'package:flutter/material.dart';
import '../../../data/models/transaction/job_model.dart';
import '../../../core/utils/pdf_service.dart';

class JobDetailPage extends StatelessWidget {
  final JobModel job;

  JobDetailPage({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Lowongan"),
        actions: [
          // Tombol Download PDF (Syarat Elisitasi #4)
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => PdfService.generateJobPdf(job),
            tooltip: "Download PDF",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(job.location, style: TextStyle(color: Colors.grey[700])),
            Divider(height: 30),
            Text("Gaji Estimasi:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Rp ${job.salary}"),
            SizedBox(height: 20),
            Text("Deskripsi Pekerjaan:", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(job.description),
            SizedBox(height: 40),
            
            // Tombol Utama Cetak PDF di bawah
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => PdfService.generateJobPdf(job),
                icon: Icon(Icons.picture_as_pdf),
                label: Text("CETAK DETAIL LOKER (PDF)"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}