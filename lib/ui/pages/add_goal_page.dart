import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/goal_model.dart';
import '../../providers/goal_provider.dart';
import '../widgets/primary_button.dart';

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({super.key});

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  final _currentController = TextEditingController();
  int _selectedColorIdx = 6; // Default Indigo
  bool _isLoading = false;

  void _saveGoal() async {
    if (_titleController.text.isEmpty || _targetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama dan Target wajib diisi")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final newGoal = GoalModel(
        id: '',
        title: _titleController.text,
        targetAmount: int.parse(_targetController.text.replaceAll(RegExp(r'[^0-9]'), '')),
        currentAmount: _currentController.text.isEmpty 
            ? 0 
            : int.parse(_currentController.text.replaceAll(RegExp(r'[^0-9]'), '')),
        colorIdx: _selectedColorIdx,
      );

      await context.read<GoalProvider>().addGoal(newGoal);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Buat Goal Baru", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: AppTheme.dark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("NAMA GOAL"),
            _buildInput(_titleController, "Contoh: Beli Laptop", TextInputType.text),
            const SizedBox(height: 20),
            
            _buildLabel("TARGET DANA (RP)"),
            _buildInput(_targetController, "0", TextInputType.number),
            const SizedBox(height: 20),

            _buildLabel("SUDAH TERKUMPUL (OPSIONAL)"),
            _buildInput(_currentController, "0", TextInputType.number),
            const SizedBox(height: 24),

            _buildLabel("PILIH WARNA LABEL"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(AppTheme.colorPalette.length, (index) {
                final color = AppTheme.colorPalette[index]['bg']!;
                final isSelected = _selectedColorIdx == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColorIdx = index),
                  child: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: AppTheme.primary, width: 2) : null,
                    ),
                    child: isSelected ? const Icon(Icons.check, size: 20, color: AppTheme.primary) : null,
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),
            PrimaryButton(text: "Simpan Goal", onPressed: _saveGoal, isLoading: _isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppTheme.font.copyWith(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.muted)),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint, TextInputType type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none, hintStyle: TextStyle(color: AppTheme.muted.withOpacity(0.5))),
      ),
    );
  }
}