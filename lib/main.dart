final pdf = pw.Document();

final logoData = await rootBundle.load('assets/logo.png');
final logo = pw.MemoryImage(logoData.buffer.asUint8List());

pdf.addPage(
  pw.Page(
    build: (context) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            pw.Image(logo, width: 70),
            pw.SizedBox(width: 12),
            pw.Text(
              'Shamil Daily Report',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Text('Date: ${now.day}/${now.month}/${now.year}'),
        pw.SizedBox(height: 12),
        pw.Text('รายรับ: ${todayIncome.toStringAsFixed(0)}'),
        pw.Text('รายจ่าย: ${todayExpense.toStringAsFixed(0)}'),
        pw.Text('กำไร: ${todayProfit.toStringAsFixed(0)}'),
      ],
    ),
  ),
);

await file.writeAsBytes(await pdf.save());
