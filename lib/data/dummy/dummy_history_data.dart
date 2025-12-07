import '../models/transaction_model.dart';

final dummyTransactions = [
  TransactionModel(
    id: '1',
    title: 'Gaji Bulanan',
    amount: 4500000,
    date: DateTime(2025, 1, 10),
    category: 'Income',
    isIncome: true,
  ),
  TransactionModel(
    id: '2',
    title: 'Transportasi',
    amount: 25000,
    date: DateTime(2025, 1, 11),
    category: 'Transport',
    isIncome: false,
  ),
  TransactionModel(
    id: '3',
    title: 'Makan Siang',
    amount: 30000,
    date: DateTime(2025, 1, 11),
    category: 'Food',
    isIncome: false,
  ),
  TransactionModel(
    id: '4',
    title: 'Freelance Project',
    amount: 1200000,
    date: DateTime(2025, 1, 12),
    category: 'Income',
    isIncome: true,
  ),
];
