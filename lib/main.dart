import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Record {
  String type; // income / expense
  double amount;
  DateTime date;

  Record(this.type, this.amount, this.date);
}

List<Record> records = [];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double get income =>
      records.where((r) => r.type == 'income').fold(0, (a, b) => a + b.amount);

  double get expense =>
      records.where((r) => r.type == 'expense').fold(0, (a, b) => a + b.amount);

  double get profit => income - expense;

  void addRecord(String type, double amount) {
    setState(() {
      records.add(Record(type, amount, DateTime.now()));
    });
  }

  void closeToday() {
    final today = DateTime.now();

    setState(() {
      records.removeWhere((r) =>
          r.date.year == today.year &&
          r.date.month == today.month &&
          r.date.day == today.day);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("ปิดยอดวันนี้เรียบร้อย")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shamil Ledger"),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_clock),
            onPressed: closeToday,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(child: ListTile(title: const Text("รายรับ"), trailing: Text(income.toStringAsFixed(0)))) ,
            Card(child: ListTile(title: const Text("รายจ่าย"), trailing: Text(expense.toStringAsFixed(0)))) ,
            Card(child: ListTile(title: const Text("กำไร"), trailing: Text(profit.toStringAsFixed(0)))) ,

            const SizedBox(height: 10),
            const Text("บันทึกด่วน", style: TextStyle(fontSize: 18)),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                bigBtn("+300", () => addRecord('income', 300)),
                bigBtn("+600", () => addRecord('income', 600)),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                bigBtn("-500", () => addRecord('expense', 500)),
                bigBtn("-1000", () => addRecord('expense', 1000)),
              ],
            ),

            const SizedBox(height: 12),
            const Text("ประวัติวันนี้", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, i) {
                  final r = records[records.length - 1 - i];
                  return ListTile(
                    leading: Icon(
                        r.type == 'income'
                            ? Icons.add_circle
                            : Icons.remove_circle),
                    title: Text(r.type == 'income' ? "รับเงิน" : "จ่ายเงิน"),
                    trailing: Text(
                      "${r.type == 'income' ? '+' : '-'}${r.amount.toStringAsFixed(0)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget bigBtn(String text, VoidCallback fn) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(130, 60),
    ),
    onPressed: fn,
    child: Text(text, style: const TextStyle(fontSize: 22)),
  );
}
