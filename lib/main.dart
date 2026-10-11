import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KimAddonsApp());
}

class KimAddonsApp extends StatefulWidget {
  const KimAddonsApp({super.key});

  @override
  State<KimAddonsApp> createState() => _KimAddonsAppState();
}

class _KimAddonsAppState extends State<KimAddonsApp> {
  bool isDarkMode = true;
  Color primaryThemeColor = const Color(0xFFC62828);
  String currentLanguage = 'العربية';

  void toggleTheme() => setState(() => isDarkMode = !isDarkMode);
  void changePrimaryColor(Color newColor) => setState(() => primaryThemeColor = newColor);
  void changeLanguage(String lang) => setState(() => currentLanguage = lang);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kim Addons Pro',
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
        primaryColor: primaryThemeColor,
        toggleTheme: toggleTheme,
        changePrimaryColor: changePrimaryColor,
        currentLanguage: currentLanguage,
        changeLanguage: changeLanguage,
      ),
    );
  }
}

class AddonModel {
  final String title;
  final String category;
  final String description;

  AddonModel({required this.title, required this.category, required this.description});
}

// ------------------- الواجهة الرئيسية المباشرة -------------------
class MainNavigationScreen extends StatefulWidget {
  final bool isDarkMode;
  final Color primaryColor;
  final VoidCallback toggleTheme;
  final Function(Color) changePrimaryColor;
  final String currentLanguage;
  final Function(String) changeLanguage;

  const MainNavigationScreen({
    super.key,
    required this.isDarkMode,
    required this.primaryColor,
    required this.toggleTheme,
    required this.changePrimaryColor,
    required this.currentLanguage,
    required this.changeLanguage,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String searchQuery = "";

  static List<AddonModel> allAddons = [
    AddonModel(
      title: 'سيف الحمم البركانية',
      category: 'أسلحة أسطورية',
      description: 'سيف متطور يطلق نيران بركانية بدمار ثلاثي الأبعاد.',
    ),
    AddonModel(
      title: 'قرية المدى المخفية',
      category: 'خرائط بقاء',
      description: 'خريطة تفاعلية مع أنفاق سرية وموارد نادرة.',
    ),
    AddonModel(
      title: 'سكن المحارب التنين',
      category: 'سكنات فخمة',
      description: 'سكن ثلاثي الأبعاد بتأثيرات ضوئية متحركة.',
    ),
  ];

  void _showSettingsModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('إعدادات التطبيق والتخصيص', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('تغيير مظهر التطبيق (داكن / فاتح)'),
                trailing: Switch(
                  value: widget.isDarkMode,
                  onChanged: (val) {
                    widget.toggleTheme();
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('اختر لون التطبيق الأساسي'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _colorOption(const Color(0xFFC62828)),
                    _colorOption(const Color(0xFF1E88E5)),
                    _colorOption(const Color(0xFF43A047)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _colorOption(Color color) {
    return GestureDetector(
      onTap: () {
        widget.changePrimaryColor(color);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 24,
        height: 24,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  Widget _buildList() {
    final filtered = allAddons.where((e) => e.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();

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
            leading: CircleAvatar(
              backgroundColor: widget.primaryColor.withOpacity(0.15),
              child: Icon(Icons.extension, color: widget.primaryColor),
            ),
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
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
          Expanded(child: _buildList()),
        ],
      ),
      const Center(child: Text('المحفوظات الفارغة')),
      const Center(child: Text('التحميلات الفارغة')),
      ProfileScreen(primaryColor: widget.primaryColor, onAddonAdded: () => setState(() {})),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kim Addons 🎮', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: widget.isDarkMode ? const Color(0xFF1A1A1A) : widget.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsModal,
          ),
        ],
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
}

// ------------------- صفحة الملف الشخصي -------------------
class ProfileScreen extends StatelessWidget {
  final Color primaryColor;
  final VoidCallback onAddonAdded;

  const ProfileScreen({super.key, required this.primaryColor, required this.onAddonAdded});

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
          const Text('وضع الزائر الاحترافي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminPanelScreen(
                    primaryColor: primaryColor,
                    onAddonAdded: onAddonAdded,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
            label: const Text('لوحة تحكم الأدمن (إضافة مود)', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ------------------- صفحة الأدمن الفورية -------------------
class AdminPanelScreen extends StatefulWidget {
  final Color primaryColor;
  final VoidCallback onAddonAdded;

  const AdminPanelScreen({super.key, required this.primaryColor, required this.onAddonAdded});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  void _add() {
    if (_titleController.text.isEmpty) return;
    MainNavigationScreenState.allAddons.add(
      AddonModel(
        title: _titleController.text,
        category: 'إضافة جديدة',
        description: _descController.text.isNotEmpty ? _descController.text : 'بدون وصف',
      ),
    );
    widget.onAddonAdded();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إضافة المود بنجاح إلى التطبيق! 🚀')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة تحكم الأدمن'), backgroundColor: widget.primaryColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'اسم المود')),
            const SizedBox(height: 10),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'الوصف')),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
              onPressed: _add,
              child: const Text('إضافة المود فوراً', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class for state reference
class MainNavigationScreenState {}
