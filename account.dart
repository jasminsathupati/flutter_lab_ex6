class Account {
  int? id;
  String accountHolder;
  double balance;

  Account({this.id, required this.accountHolder, required this.balance});

  Map<String, dynamic> toMap() {
    return {'id': id, 'accountHolder': accountHolder, 'balance': balance};
  }

  factory Account.fromMap(Map<String, dynamic> row) {
    return Account(
      id: row['id'],
      accountHolder: row['accountHolder'],
      balance: (row['balance'] as num).toDouble(),
    );
  }
}
