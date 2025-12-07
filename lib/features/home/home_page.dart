import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER ----------------------------------------------------------
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Haii, Nisa!",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Jangan lupa manage pengeluaranmu hari ini yaa",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.notifications_none, size: 28),
                  const SizedBox(width: 8),
                  Icon(Icons.settings_outlined, size: 28),
                ],
              ),

              const SizedBox(height: 25),

              // BALANCE TITLE ---------------------------------------------------
              Text(
                "Jumlah Saldo :",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Rp 10.000.000,00",
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  height: 1.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  shadows: [
                    Shadow(
                      blurRadius: 12,
                      color: Colors.purpleAccent.withOpacity(0.4),
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // SUMMARY CARD ----------------------------------------------------
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // INCOME
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/icons/income.png",
                                  height: 35,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Total Pemasukan",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Rp 12.000.000,00",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // EXPENSE
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/icons/expense.png",
                                  height: 35,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Total Pengeluaran",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "-Rp 2.000.000,00",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // PROGRESS BAR
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: 0.30,
                          color: Colors.purple,
                          backgroundColor: Colors.purple.withOpacity(0.2),
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "30% of your expenses, looks good.",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // TRANSAKSI TERBARU -----------------------------------------------
              Text(
                "Transaksi Terbaru",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_cafe, size: 35, color: Colors.brown),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kopi",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Makanan & Minuman",
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      "Rp 10.000,00",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // GOALS -----------------------------------------------------------
              Text(
                "Popular Goals :",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.spa, size: 40, color: Colors.pink),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Target",
                                style: GoogleFonts.poppins(fontSize: 12)),
                            Text("Rp 100.000,00",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Terkumpul saat ini",
                                style: GoogleFonts.poppins(fontSize: 12)),
                            Text("Rp 50.000,00",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value: 0.5,
                      color: Colors.pink,
                      backgroundColor: Colors.pink[100],
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      "50%",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      "Update terakhir: 11 November 2025",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // WIDGET API (GRID 2) --------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          "WIDGET API",
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          "WIDGET API",
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
