import 'package:flutter/material.dart';
import 'widgets/goal_card.dart';
import 'widgets/goals_update_form.dart';
import 'widgets/goals_create_form.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BACK BUTTON + TITLE
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Goals",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              const Text(
                "My Goals",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Text("Semangat mencapai targetnya yaa"),

              const SizedBox(height: 15),

              // GOAL CARD (UI sesuai desain)
              const GoalCard(),

              const SizedBox(height: 20),

              // UPDATE UANG GOALS
              const GoalsUpdateForm(),

              const SizedBox(height: 35),

              // SECTION NEW GOALS
              const Text(
                "+   Create New Goals",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const GoalsCreateForm(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
