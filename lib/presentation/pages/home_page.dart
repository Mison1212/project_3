import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:papua_career_center/presentation/pages/community_page.dart';
import 'package:papua_career_center/presentation/pages/course_page.dart';
import 'job_list_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 🔥 HEADER MODERN + LOGO ASSETS
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.account_circle, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () => FirebaseAuth.instance.signOut(),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Muda Papua Center",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade900, Colors.blue.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),

                // 🔥 GANTI ICON JADI IMAGE ASSETS
                child: Center(
                  child: Opacity(
                    opacity: 0.2, // biar jadi background halus
                    child: Image.asset(
                      'assets/icon/image.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Layanan Utama",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Grid Menu Navigasi
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      _buildMenuCard(
                        context,
                        "Cari Kerja",
                        Icons.work_history_rounded,
                        Colors.orange,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobListPage(),
                          ),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        "Komunitas",
                        Icons.people_alt_rounded,
                        Colors.green,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CommunityPage(),
                          ),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        "Pelatihan",
                        Icons.menu_book_rounded,
                        Colors.orange,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CoursePage(),
                          ),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        "Info Papua",
                        Icons.newspaper_rounded,
                        Colors.red,
                        () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Ringkasan Aktivitas",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  _buildStatTile("Lowongan Baru", "12 Posisi", Colors.blue),
                  _buildStatTile(
                    "Diskusi Komunitas",
                    "5 Pesan baru",
                    Colors.teal,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String title, String subtitle, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(Icons.insights, color: color),
        title: Text(title),
        trailing: Text(
          subtitle,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
