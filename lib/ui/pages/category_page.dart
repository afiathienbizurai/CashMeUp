import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/category_model.dart';
import '../../providers/category_provider.dart';
import '../widgets/primary_button.dart';

class CategoryFormPage extends StatefulWidget {
  final CategoryModel? categoryToEdit; // Jika null = Mode Tambah

  const CategoryFormPage({super.key, this.categoryToEdit});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _nameController = TextEditingController();
  String _selectedType = 'expense';
  int _selectedColorIdx = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.categoryToEdit != null) {
      // Isi form dengan data lama jika mode Edit
      _nameController.text = widget.categoryToEdit!.name;
      _selectedType = widget.categoryToEdit!.type;
      _selectedColorIdx = widget.categoryToEdit!.colorIdx;
    }
  }

  void _saveCategory() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama kategori wajib diisi")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final category = CategoryModel(
        id: widget.categoryToEdit?.id ?? '', // ID lama jika edit, kosong jika baru
        name: _nameController.text,
        type: _selectedType,
        colorIdx: _selectedColorIdx,
      );

      final provider = context.read<CategoryProvider>();
      
      if (widget.categoryToEdit != null) {
        await provider.updateCategory(category);
      } else {
        await provider.addCategory(category);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.categoryToEdit != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEdit ? "Edit Kategori" : "Tambah Kategori", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: AppTheme.dark),
        actions: [
          // Tombol Hapus (Hanya muncul saat Edit)
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete, color: AppTheme.danger),
              onPressed: () async {
                 final confirm = await showDialog(
                   context: context, 
                   builder: (ctx) => AlertDialog(
                     title: const Text("Hapus Kategori?"),
                     content: const Text("Kategori ini akan hilang selamanya."),
                     actions: [
                       TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
                       TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
                     ],
                   )
                 );
                 
                 if (confirm == true) {
                   await context.read<CategoryProvider>().deleteCategory(widget.categoryToEdit!.id);
                   if (mounted) Navigator.pop(context);
                 }
              },
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle Type
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: AppTheme.bgApp, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  _buildTypeOption("Pengeluaran", 'expense'),
                  _buildTypeOption("Pemasukan", 'income'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Input Nama
            Text("NAMA KATEGORI", style: AppTheme.font.copyWith(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.muted)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.bgApp)),
              child: Row(
                children: [
                  // Live Preview Inisial
                  CircleAvatar(
                    backgroundColor: AppTheme.colorPalette[_selectedColorIdx]['bg'],
                    radius: 16,
                    child: Text(
                      _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : "?",
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.colorPalette[_selectedColorIdx]['text']),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      onChanged: (val) => setState(() {}), // Refresh untuk update preview
                      decoration: const InputDecoration(hintText: "Contoh: Liburan", border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Color Picker
            Text("PILIH WARNA LABEL", style: AppTheme.font.copyWith(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.muted)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12, runSpacing: 12,
              children: List.generate(AppTheme.colorPalette.length, (index) {
                final color = AppTheme.colorPalette[index]['bg']!;
                final isSelected = _selectedColorIdx == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColorIdx = index),
                  child: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: isSelected ? Border.all(color: AppTheme.primary, width: 2) : null),
                    child: isSelected ? const Icon(Icons.check, size: 20, color: AppTheme.primary) : null,
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),
            PrimaryButton(text: isEdit ? "Simpan Perubahan" : "Buat Kategori", onPressed: _saveCategory, isLoading: _isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption(String label, String value) {
    bool isSelected = _selectedType == value;
    Color activeColor = value == 'expense' ? AppTheme.danger : AppTheme.success;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
          ),
          child: Text(
            label, 
            textAlign: TextAlign.center, 
            style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? activeColor : AppTheme.muted, fontSize: 12)
          ),
        ),
      ),
    );
  }
}