import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }
  runApp(const KimAddonsApp());
}

class AddonModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String downloadLink;

  AddonModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.downloadLink,
  });

  factory AddonModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddonModel(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? 'عام',
      description: data['description'] ?? '',
      downloadLink: data['downloadLink'] ?? '',
    );
  }
}

class KimAddonsApp extends StatefulWidget {
  const KimAddonsApp({super.key});

  @override
  State<KimAddonsApp> createState() => _KimAddonsAppState();
}

class _KimAddonsAppState extends State<KimAddonsApp> {
  bool isDarkMode = true;
  bool notificationsEnabled = true;
  Color primaryThemeColor = const Color(0xFFC62828);
  String currentLanguage = 'العربية';

  void toggleTheme() => setState(() => isDarkMode = !isDarkMode);
  void toggleNotifications() => setState(() => notificationsEnabled = !notificationsEnabled);
  void changePrimaryColor(Color newColor) => setState(() => primaryThemeColor = newColor);
  void changeLanguage(String lang) => setState(() => currentLanguage = lang);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kim Addons',
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF4F4F9),
        primaryColor: primaryThemeColor,
        colorScheme: isDarkMode 
            ? ColorScheme.dark(primary: primaryThemeColor) 
            : ColorScheme.light(primary: primaryThemeColor),
        fontFamily: 'Roboto',
      ),
      home: MainNavigationScreen(
        isDarkMode: isDarkMode,
        notificationsEnabled: notificationsEnabled,
        primaryColor: primaryThemeColor,
        currentLanguage: currentLanguage,
        toggleTheme: toggleTheme,
        toggleNotifications: toggleNotifications,
        changePrimaryColor: changePrimaryColor,
        changeLanguage: changeLanguage,
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final Color primaryColor;
  final String currentLanguage;
  final VoidCallback toggleTheme;
  final VoidCallback toggleNotifications;
  final Function(Color) changePrimaryColor;
  final Function(String) changeLanguage;

  const MainNavigationScreen({
    super.key,
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.primaryColor,
    required this.currentLanguage,
    required this.toggleTheme,
    required this.toggleNotifications,
    required this.changePrimaryColor,
    required this.changeLanguage,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String searchQuery = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildCloudAddonsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('addons').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('خطأ في الاتصال بالسحابة: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];
        List<AddonModel> addons = docs.map((doc) => AddonModel.fromDoc(doc)).toList();

        final filtered = addons.where((e) => e.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();

        if (filtered.isEmpty) {
          return const Center(
            child: Text(
              'لا توجد مودات حالياً.\nأضف موداً جديداً من لوحة الأدمن لتظهر هنا سحابياً!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final item = filtered[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: widget.primaryColor.withOpacity(0.2)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  backgroundColor: widget.primaryColor.withOpacity(0.15),
                  child: Icon(Icons.cloud_done, color: widget.primaryColor),
                ),
                title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.category, style: TextStyle(color: widget.primaryColor, fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.download_rounded, color: Colors.green),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('رابط التحميل: ${item.downloadLink}')),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: InputDecoration(
                hintText: 'ابحث عن المودات والخرائط...',
                prefixIcon: Icon(Icons.search, color: widget.primaryColor),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(child: _buildCloudAddonsList()),
        ],
      ),
      const Center(child: Text('المحفوظات الفارغة')),
      const Center(child: Text('التحميلات الفارغة')),
      ProfileScreen(primaryColor: widget.primaryColor),
    ];

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: widget.primaryColor.withOpacity(0.2),
                    child: Icon(Icons.settings, color: widget.primaryColor),
                  ),
                  const SizedBox(width: 12),
                  const Text('إعدادات التطبيق', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(height: 30),
              SwitchListTile(
                title: const Text('المظهر الداكن'),
                secondary: const Icon(Icons.dark_mode),
                value: widget.isDarkMode,
                onChanged: (val) => widget.toggleTheme(),
              ),
              SwitchListTile(
                title: const Text('التنبيهات والإشعارات'),
                secondary: const Icon(Icons.notifications),
                value: widget.notificationsEnabled,
                onChanged: (val) => widget.toggleNotifications(),
              ),
              const Divider(height: 20),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('اللغة'),
                trailing: DropdownButton<String>(
                  value: widget.currentLanguage,
                  underline: const SizedBox(),
                  items: ['العربية', 'English'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) widget.changeLanguage(val);
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text('اختر لون التطبيق الأساسي:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _colorOption(const Color(0xFFC62828)),
                  _colorOption(const Color(0xFF1E88E5)),
                  _colorOption(const Color(0xFF43A047)),
                  _colorOption(const Color(0xFF8E24AA)),
                ],
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? const Color(0xFF1A1A1A) : widget.primaryColor,
        elevation: 0,
        // صورة/شعار التطبيق على الجانب بدلاً من النص والرمز
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.apps, color: Colors.white, size: 24),
            ),
          ],
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: widget.primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_rounded), label: 'المحفوظات'),
          BottomNavigationBarItem(icon: Icon(Icons.download_rounded), label: 'التحميلات'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'حسابي'),
        ],
      ),
    );
  }

  Widget _colorOption(Color color) {
    return GestureDetector(
      onTap: () => widget.changePrimaryColor(color),
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.primaryColor == color ? Colors.white : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final Color primaryColor;

  const ProfileScreen({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: primaryColor.withOpacity(0.2),
            child: Icon(Icons.person, size: 50, color: primaryColor),
          ),
          const SizedBox(height: 10),
          const Text('لوحة إدارة السحابة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CloudAdminPanel(primaryColor: primaryColor),
                ),
              );
            },
            icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
            label: const Text('لوحة الأدمن (نشر مود سحابياً)', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class CloudAdminPanel extends StatefulWidget {
  final Color primaryColor;

  const CloudAdminPanel({super.key, required this.primaryColor});

  @override
  State<CloudAdminPanel> createState() => _CloudAdminPanelState();
}

class _CloudAdminPanelState extends State<CloudAdminPanel> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descController = TextEditingController();
  final _linkController = TextEditingController();
  bool isLoading = false;

  void _uploadToCloud() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال اسم المود على الأقل')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('addons').add({
        'title': _titleController.text,
        'category': _categoryController.text.isNotEmpty ? _categoryController.text : 'عام',
        'description': _descController.text.isNotEmpty ? _descController.text : 'بدون وصف',
        'downloadLink': _linkController.text.isNotEmpty ? _linkController.text : 'https://example.com',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم نشر المود سحابياً بنجاح! 🚀')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء النشر: $e')),
      );
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة الأدمن السحابية'),
        backgroundColor: widget.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'اسم المود'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'التصنيف (أسلحة، خرائط، سكنات)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'وصف المود'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _linkController,
              decoration: const InputDecoration(labelText: 'رابط التحميل المباشر (.mcaddon)'),
            ),
            const SizedBox(height: 30),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _uploadToCloud,
                    child: const Text('نشر المود سحابياً ☁️🚀', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
          ],
        ),
      ),
    );
  }
}
