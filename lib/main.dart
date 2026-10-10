import 'package:flutter/material.dart';

void main() {
  runApp(const KimAddonsApp());
}

class KimAddonsApp extends StatelessWidget {
  const KimAddonsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kim Addons 3D',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0202),
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class AddonItem {
  final String title;
  final String category;
  final String description;
  final IconData icon;
  final String rating;
  bool isFavorite;
  bool isDownloaded;

  AddonItem({
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
    this.rating = '4.9',
    this.isFavorite = false,
    this.isDownloaded = false,
  });
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String searchQuery = "";

  final List<AddonItem> addons = [
    AddonItem(
      title: 'سيف الحمم البركانية 3D',
      category: 'أسلحة أسطورية',
      description: 'سيف متطور يطلق نيران بركانية بدمار ثلاثي الأبعاد.',
      icon: Icons.local_fire_department_rounded,
      rating: '5.0',
    ),
    AddonItem(
      title: 'قرية المدى المخفية HD',
      category: 'خرائط بقاء',
      description: 'خريطة تفاعلية مع أنفاق سرية وموارد نادرة.',
      icon: Icons.terrain_rounded,
      rating: '4.8',
    ),
    AddonItem(
      title: 'سكن المحارب التنين',
      category: 'سكنات فخمة',
      description: 'سكن ثلاثي الأبعاد بتأثيرات ضوئية متحركة.',
      icon: Icons.shield_rounded,
      rating: '4.9',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<AddonItem> filteredAddons = addons.where((item) {
      return item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    List<AddonItem> favoriteAddons = addons.where((item) => item.isFavorite).toList();
    List<AddonItem> downloadedAddons = addons.where((item) => item.isDownloaded).toList();

    final List<Widget> pages = [
      Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF2A0808), Color(0xFF150404)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.25),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
              border: Border.all(color: const Color(0xFF8B0000).withOpacity(0.5), width: 1.5),
            ),
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'ابحث عن إضافات وخرائط ثلاثية الأبعاد...',
                hintStyle: TextStyle(color: Colors.white54, fontSize: 13),
                prefixIcon: Icon(Icons.search_rounded, color: Color(0xFFFF3333)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAddons.length,
              itemBuilder: (context, index) {
                final addon = filteredAddons[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF320A0A), Color(0xFF1A0303)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFB71C1C).withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                      const BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFD32F2F).withOpacity(0.4), width: 1.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF1744), Color(0xFF8B0000)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.5),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(addon.icon, color: Colors.white, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD32F2F).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFFFF5252), width: 0.8),
                                    ),
                                    child: Text(
                                      addon.category,
                                      style: const TextStyle(color: Color(0xFFFF8A8A), fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                  Text(addon.rating, style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                addon.title,
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                addon.description,
                                style: const TextStyle(color: Colors.white60, fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() => addon.isDownloaded = true);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('تم تحميل ${addon.title} بنجاح!')),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors: addon.isDownloaded
                                              ? [Colors.green.shade700, Colors.green.shade900]
                                              : [const Color(0xFFFF1744), const Color(0xFFB71C1C)],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (addon.isDownloaded ? Colors.green : Colors.red).withOpacity(0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            addon.isDownloaded ? Icons.check_circle_rounded : Icons.file_download_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            addon.isDownloaded ? 'تم التحميل' : 'تحميل 3D',
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      addon.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                      color: addon.isFavorite ? const Color(0xFFFF1744) : Colors.white38,
                                      size: 26,
                                    ),
                                    onPressed: () {
                                      setState(() => addon.isFavorite = !addon.isFavorite);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      favoriteAddons.isEmpty
          ? const Center(child: Text('لا توجد عناصر في المفضلات بعد', style: TextStyle(color: Colors.white38)))
          : ListView.builder(
              itemCount: favoriteAddons.length,
              itemBuilder: (context, i) => ListTile(
                leading: Icon(favoriteAddons[i].icon, color: Colors.redAccent),
                title: Text(favoriteAddons[i].title, style: const TextStyle(color: Colors.white)),
                subtitle: Text(favoriteAddons[i].category, style: const TextStyle(color: Colors.white54)),
              ),
            ),
      downloadedAddons.isEmpty
          ? const Center(child: Text('لم تقم بتحميل أي إضافة حتى الآن', style: TextStyle(color: Colors.white38)))
          : ListView.builder(
              itemCount: downloadedAddons.length,
              itemBuilder: (context, i) => ListTile(
                leading: Icon(downloadedAddons[i].icon, color: Colors.greenAccent),
                title: Text(downloadedAddons[i].title, style: const TextStyle(color: Colors.white)),
                subtitle: const Text('جاهز للتثبيت في ماين كرافت', style: TextStyle(color: Colors.greenAccent)),
              ),
            ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kim Addons 🎮', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: true,
        backgroundColor: const Color(0xFF150404),
        elevation: 10,
        shadowColor: Colors.red.withOpacity(0.5),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF120303),
          selectedItemColor: const Color(0xFFFF3333),
          unselectedItemColor: Colors.white38,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.style_rounded), label: 'الرئيسية 3D'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: 'المفضلات'),
            BottomNavigationBarItem(icon: Icon(Icons.download_for_offline_rounded), label: 'التحميلات'),
          ],
        ),
      ),
    );
  }
}
