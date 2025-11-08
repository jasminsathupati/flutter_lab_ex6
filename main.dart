import 'package:flutter/material.dart';
import 'account.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BankScreen(),
    );
  }
}

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});
  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final balCtrl = TextEditingController();
  List<Account> accounts = [];
  double total = 0;

  Future<void> load() async {
    accounts = await DatabaseHelper.instance.fetchAll();
    total = await DatabaseHelper.instance.totalMoney();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> addAccount() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper.instance.insert(Account(
        accountHolder: nameCtrl.text,
        balance: double.parse(balCtrl.text),
      ));
      nameCtrl.clear();
      balCtrl.clear();
      load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Accounts SQLite Demo"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: "Account Holder",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Enter account holder name" : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: balCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Initial Balance",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Enter balance" : null,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: addAccount,
                    child: const Text("Add Account"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (_, i) {
                  final a = accounts[i];
                  return Card(
                    child: ListTile(
                      title: Text(a.accountHolder),
                      subtitle: Text("Balance: ₹${a.balance}"),
                      trailing: a.balance == 0
                          ? const Text("Low Balance!",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold))
                          : null,
                    ),
                  );
                },
              ),
            ),
            Text(
              "Total Money in Bank: ₹$total",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
