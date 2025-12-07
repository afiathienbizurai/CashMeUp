import 'package:flutter/material.dart';

class GoalCard extends StatefulWidget {
  const GoalCard({super.key});

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  bool showMenu = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xffddeaff),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TEXT CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Sepatu Baru",
                      style: TextStyle(
                        color: Color(0xff2a4c8a),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Untuk keperluan acara",
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Target Harga",
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      "Rp 100.000,00",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Terkumpul saat ini",
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      "Rp 45.000,00",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Update terakhir\n11 November 2025",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              // PIE PROGRESS
              Column(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 0.45,
                          strokeWidth: 12,
                          backgroundColor: Colors.orange.shade100,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.orange),
                        ),
                        const Text(
                          "45%",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 5),

                  // MENU BUTTON
                  GestureDetector(
                    onTap: () => setState(() => showMenu = !showMenu),
                    child: const Icon(Icons.more_horiz),
                  ),
                ],
              ),
            ],
          ),
        ),

        // MENU POPUP
        if (showMenu)
          Positioned(
            right: 0,
            top: 60,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Column(
                children: [
                  menuItem("Edit", Colors.black),
                  menuItem("Hapus", Colors.red),
                  menuItem("Pilih", Colors.black),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget menuItem(String text, Color color) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(text, style: TextStyle(color: color)),
      ),
    );
  }
}
