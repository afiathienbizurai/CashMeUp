import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Notifikasi", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: AppTheme.dark),
        actions: [
          // Tombol "Tandai Semua Dibaca"
          TextButton(
            onPressed: () async {
              if (uid != null) {
                final batch = FirebaseFirestore.instance.batch();
                final snapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('notifications')
                    .where('isRead', isEqualTo: false)
                    .get();
                
                for (var doc in snapshot.docs) {
                  batch.update(doc.reference, {'isRead': true});
                }
                await batch.commit();
              }
            },
            child: Text("Baca Semua", style: AppTheme.font.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary)),
          )
        ],
      ),
      body: uid == null 
          ? const Center(child: Text("Silakan login kembali"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('notifications')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.bellSlash, size: 40, color: AppTheme.muted),
                        const SizedBox(height: 16),
                        Text("Belum ada notifikasi", style: AppTheme.font.copyWith(color: AppTheme.muted)),
                      ],
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final isRead = data['isRead'] ?? false;
                    final timestamp = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      tileColor: isRead ? Colors.white : AppTheme.primarySoft.withOpacity(0.3), // Highlight kalau belum dibaca
                      leading: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: isRead ? Colors.grey.shade100 : AppTheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: FaIcon(
                            isRead ? FontAwesomeIcons.envelopeOpen : FontAwesomeIcons.envelope,
                            size: 16,
                            color: isRead ? AppTheme.muted : AppTheme.primary,
                          ),
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data['title'] ?? 'Info', style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(
                            DateFormat('dd MMM HH:mm').format(timestamp),
                            style: AppTheme.font.copyWith(fontSize: 10, color: AppTheme.muted),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(data['body'] ?? '', style: AppTheme.font.copyWith(fontSize: 12, color: AppTheme.dark)),
                      ),
                      onTap: () {
                        // Tandai satu notifikasi sudah dibaca saat diklik
                        if (!isRead) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .collection('notifications')
                              .doc(docs[index].id)
                              .update({'isRead': true});
                        }
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}