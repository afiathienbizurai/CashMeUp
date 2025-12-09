import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme.dart';
import '../../models/transaction_model.dart';
import '../../models/category_model.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../widgets/primary_button.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedType = 'expense';
  CategoryModel? _selectedCategory;
  bool _isLoading = false;

  void _saveTransaction() async {
    if (_amountController.text.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nominal dan Kategori wajib diisi")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final newTransaction = TransactionModel(
          id: '',
          title: _noteController.text.isEmpty ? _selectedCategory!.name : _noteController.text,
          amount: int.parse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), '')),
          type: _selectedType,
          date: DateTime.now(),
          category: _selectedCategory!.name,
          colorIdx: _selectedCategory!.colorIdx, 
        );

      await context.read<TransactionProvider>().addTransaction(newTransaction);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showCategoryModal(List<CategoryModel> categories) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text("Pilih Kategori", style: AppTheme.font.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (ctx, index) {
                  final cat = categories[index];
                  return ListTile(
                    title: Text(cat.name, style: AppTheme.font.copyWith(fontWeight: FontWeight.bold)),
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.bgApp,
                      child: Text(cat.name[0], style: const TextStyle(color: AppTheme.dark, fontWeight: FontWeight.bold)),
                    ),
                    onTap: () {
                      setState(() => _selectedCategory = cat);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Catat Keuangan", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.dark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<CategoryModel>>(
        stream: context.watch<CategoryProvider>().getCategories(),
        builder: (context, snapshot) {
          final categories = snapshot.data?.where((c) => c.type == _selectedType).toList() ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Nominal Input
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppTheme.bgApp),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      Text("MASUKKAN NOMINAL", style: AppTheme.font.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.muted, letterSpacing: 1.5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Rp", style: AppTheme.font.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 200,
                            child: TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: AppTheme.font.copyWith(fontSize: 40, fontWeight: FontWeight.w800, color: AppTheme.dark),
                              decoration: const InputDecoration(hintText: "0", border: InputBorder.none, hintStyle: TextStyle(color: Color(0xFFE2E8F0))),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Category Selector
                GestureDetector(
                  onTap: () => _showCategoryModal(categories),
                  child: _buildInputCard(
                    icon: _selectedCategory == null 
                        ? const Icon(Icons.category, color: Colors.white, size: 16)
                        : Text(_selectedCategory!.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    label: _selectedCategory?.name ?? "Pilih Kategori",
                    iconBgColor: AppTheme.dark,
                    trailing: const Icon(Icons.keyboard_arrow_down, color: AppTheme.muted),
                  ),
                ),
                const SizedBox(height: 16),

                // Type Toggle
                GestureDetector(
                  onTap: () => setState(() {
                    _selectedType = _selectedType == 'expense' ? 'income' : 'expense';
                    _selectedCategory = null;
                  }),
                  child: _buildInputCard(
                    icon: FaIcon(FontAwesomeIcons.rightLeft, size: 14, color: _selectedType == 'expense' ? AppTheme.danger : AppTheme.success),
                    label: "Tipe Transaksi",
                    iconBgColor: _selectedType == 'expense' ? AppTheme.danger.withOpacity(0.1) : AppTheme.success.withOpacity(0.1),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _selectedType == 'expense' ? AppTheme.danger : AppTheme.success,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_selectedType == 'expense' ? "Pengeluaran" : "Pemasukan", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Note Input
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.bgApp)),
                  child: TextField(
                    controller: _noteController,
                    decoration: InputDecoration(hintText: "Tambah Catatan...", hintStyle: TextStyle(color: AppTheme.muted.withOpacity(0.5), fontSize: 14), border: InputBorder.none),
                  ),
                ),
                const SizedBox(height: 40),

                PrimaryButton(text: "Simpan Transaksi", onPressed: _saveTransaction, isLoading: _isLoading),
                const SizedBox(height: 16),
                TextButton(onPressed: () => Navigator.pop(context), child: Text("Batalkan", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, color: AppTheme.muted))),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputCard({required Widget icon, required String label, required Color iconBgColor, required Widget trailing}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.bgApp)),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(12)),
            child: Center(child: icon),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 14))),
          trailing,
        ],
      ),
    );
  }
}