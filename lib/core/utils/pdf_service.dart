import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/models/transaction/job_model.dart';

class PdfService {
  static Future<void> generateJobPdf(JobModel job) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            // Pakai crossAxisAlignment (tulisan lengkap) agar tidak merah
            crossAxisAlignment: pw.CrossAxisAlignment.start, 
            children: [
              pw.Text(
                "DETAIL LOWONGAN KERJA",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Judul: ${job.title}"),
              pw.Text("Lokasi: ${job.location}"),
              pw.Text("Gaji: Rp ${job.salary}"),
              pw.SizedBox(height: 10),
              pw.Text("Deskripsi:"),
              pw.Text(job.description),
              pw.SizedBox(height: 40),
              pw.Text(
                "Dicetak melalui Platform Karir Anak Muda Papua",
                style: pw.TextStyle(
                  fontSize: 10,
                  fontStyle: pw.FontStyle.italic, 
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}