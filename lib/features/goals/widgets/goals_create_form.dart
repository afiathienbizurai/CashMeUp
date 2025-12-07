import 'package:flutter/material.dart';

class GoalsCreateForm extends StatelessWidget {
  const GoalsCreateForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xfff1f1f1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Tulis tujuan",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Keterangan",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          TextField(
            decoration: InputDecoration(
              hintText: "Target Harga",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 10),

          const TextField(
            decoration: InputDecoration(
              hintText: "Visualisasi grafis",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Simpan"),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Hapus"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
