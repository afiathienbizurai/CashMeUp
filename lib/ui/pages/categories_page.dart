import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme.dart';
import '../../models/category_model.dart';
import '../../providers/category_provider.dart';
import 'category_form_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Kategori Saya", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: AppTheme.dark),
      ),
      body: StreamBuilder<List<CategoryModel>>(
        stream: context.watch<CategoryProvider>().getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          final categories = snapshot.data ?? [];
          final incomeCats = categories.where((c) => c.type == 'income').toList();
          final expenseCats = categories.where((c) => c.type == 'expense').toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tombol Tambah Besar
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryFormPage())),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(border: Border.all(color: AppTheme.primary.withOpacity(0.5), style: BorderStyle.solid), borderRadius: BorderRadius.circular(16), color: Colors.indigo.shade50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.plus, size: 14, color: AppTheme.primary),
                        const SizedBox(width: 8),
                        Text("Tambah Kategori Baru", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                if (incomeCats.isNotEmpty) ...[
                  Text("PEMASUKAN", style: AppTheme.font.copyWith(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.muted)),
                  const SizedBox(height: 12),
                  ...incomeCats.map((c) => _buildCategoryItem(context, c)),
                  const SizedBox(height: 24),
                ],

                if (expenseCats.isNotEmpty) ...[
                  Text("PENGELUARAN", style: AppTheme.font.copyWith(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.muted)),
                  const SizedBox(height: 12),
                  ...expenseCats.map((c) => _buildCategoryItem(context, c)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryModel category) {
    final colors = AppTheme.colorPalette[category.colorIdx];
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryFormPage(categoryToEdit: category))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.bgApp)),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: colors['bg'], shape: BoxShape.circle),
              child: Center(child: Text(category.name[0], style: TextStyle(fontWeight: FontWeight.bold, color: colors['text']))),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(category.name, style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, color: AppTheme.dark))),
            const Icon(Icons.edit, size: 16, color: AppTheme.muted),
          ],
        ),
      ),
    );
  }
}