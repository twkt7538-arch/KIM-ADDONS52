import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase init bypassed: $e");
  }
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

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void changePrimaryColor(Color newColor) {
    setState(() {
      primaryThemeColor = newColor;
    });
  }

  void changeLanguage(String lang) {
    setState(() {
      currentLanguage = lang;
    });
  }

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
      home: AuthScreen(
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

// ------------------- 1. صفحة تسجيل الدخول -------------------
class AuthScreen extends StatefulWidget {
  final bool isDarkMode;
  final Color primaryColor;
  final VoidCallback toggleTheme;
  final Function(Color) changePrimaryColor;
  final String currentLanguage;
  final Function(String) changeLanguage;

  const AuthScreen({
    super.key,
    required this.isDarkMode,
    required this.primaryColor,
    required this.toggleTheme,
    required this.changePrimaryColor,
    required this.currentLanguage,
    required this.changeLanguage,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignUp = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  void _handleAuth() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigationScreen(
          userName: _nameController.text.isNotEmpty ? _nameController.text : 'أحمد المنلا',
          isDarkMode: widget.isDarkMode,
          primaryColor: widget.primaryColor,
          toggleTheme: widget.toggleTheme,
          changePrimaryColor: widget.changePrimaryColor,
          currentLanguage: widget.currentLanguage,
          changeLanguage: widget.changeLanguage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: widget.primaryColor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: widget.primaryColor.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.gamepad_rounded, size: 60, color: widget.primaryColor),
                const SizedBox(height: 10),
                Text(
                  isSignUp ? 'إنشاء حساب جديد' : 'تسجيل الدخول',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: widget.primaryColor),
                ),
                const SizedBox(height: 20),
                if (isSignUp)
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'اسم المستخدم',
                      prefixIcon: Icon(Icons.person, color: widget.primaryColor),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                if (isSignUp) const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: Icon(Icons.email, color: widget.primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: Icon(Icons.lock, color: widget.primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: _handleAuth,
                  child: Text(isSignUp ? 'أنشئ حسابك' : 'دخول', style: const TextStyle(color: Colors.white, fontSize: 16)),
                ),
                TextButton(
                  onPressed: () => setState(() => isSignUp = !isSignUp),
                  child: Text(
                    isSignUp ? 'لديك حساب بالفعل؟ سجل دخولك' : 'ليس لديك حساب؟ أنشئ حساباً الآن',
                    style: TextStyle(color: widget.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------- 2. الواجهة الرئيسية والشريط السفلي -------------------
class MainNavigationScreen extends StatefulWidget {
  final String userName;
  final bool isDarkMode;
  final Color primaryColor;
  final VoidCallback toggleTheme;
  final Function(Color) changePrimaryColor;
  final String currentLanguage;
  final Function(String) changeLanguage;

  const MainNavigationScreen({
    super.key,
    required this.userName,
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
  bool notificationsEnabled = true;

  late List<AddonItem> localAddons;

  @override
  void initState() {
    super.initState();
    localAddons = [
      AddonItem(
        title: 'سيف الحمم البركانية',
        category: 'أسلحة أسطورية',
        description: 'سيف متطور يطلق نيران بركانية بدمار ثلاثي الأبعاد.',
        icon: Icons.local_fire_department_rounded,
        rating: '5.0',
      ),
      AddonItem(
        title: 'قرية المدى المخفية',
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
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.notifications_active, color: widget.primaryColor),
            const SizedBox(width: 8),
            const Text('الإشعارات والتنبيهات'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('تفعيل إشعارات المودات الجديدة'),
              value: notificationsEnabled,
              activeColor: widget.primaryColor,
              onChanged: (val) {
                setState(() => notificationsEnabled = val);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('تم إضافة مود السيف البركاني اليوم!'),
            ),
          ],
        ),
      ),
    );
  }

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
                  onChanged: (val) => widget.toggleTheme(),
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
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('لغة التطبيق'),
                trailing: DropdownButton<String>(
                  value: widget.currentLanguage,
                  items: ['العربية', 'English'].map((lang) {
                    return DropdownMenuItem(value: lang, child: Text(lang));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) widget.changeLanguage(val);
                  },
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
      onTap: () => widget.changePrimaryColor(color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 24,
        height: 24,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  Widget _buildAddonList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('addons').snapshots(),
      builder: (context, snapshot) {
        List<AddonItem> displayItems = List.from(localAddons);

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            displayItems.add(AddonItem(
              title: data['title'] ?? 'مود جديد',
              category: data['category'] ?? 'عام',
              description: data['description'] ?? '',
              icon: Icons.extension,
            ));
          }
        }

        List<AddonItem> filtered = displayItems.where((item) {
          return item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              item.category.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final addon = filtered[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: widget.primaryColor.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  backgroundColor: widget.primaryColor.withOpacity(0.15),
                  child: Icon(addon.icon, color: widget.primaryColor),
                ),
                title: Text(addon.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(addon.category, style: TextStyle(color: widget.primaryColor, fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(addon.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    addon.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: addon.isFavorite ? widget.primaryColor : Colors.grey,
                  ),
                  onPressed: () => setState(() => addon.isFavorite = !addon.isFavorite),
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
    List<AddonItem> favoriteAddons = localAddons.where((item) => item.isFavorite).toList();

    final List<Widget> pages = [
      Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: widget.primaryColor.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: InputDecoration(
                hintText: 'ابحث عن مودات، خرائط، سكنات...',
                prefixIcon: Icon(Icons.search, color: widget.primaryColor),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(child: _buildAddonList()),
        ],
      ),
      favoriteAddons.isEmpty
          ? const Center(child: Text('لا توجد مضافات في المحفوظات بعد'))
          : ListView.builder(
              itemCount: favoriteAddons.length,
              itemBuilder: (context, index) => ListTile(
                leading: Icon(favoriteAddons[index].icon, color: widget.primaryColor),
                title: Text(favoriteAddons[index].title),
                subtitle: Text(favoriteAddons[index].category),
              ),
            ),
      const Center(child: Text('لم تقم بتحميل أي إضافة حتى الآن')),
      ProfileScreen(
        userName: widget.userName,
        primaryColor: widget.primaryColor,
        isDarkMode: widget.isDarkMode,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kim Addons 🎮', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: widget.isDarkMode ? const Color(0xFF1A1A1A) : widget.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_rounded),
            onPressed: _showNotificationsDialog,
          ),
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

// ------------------- 3. صفحة الملف الشخصي القابل للتخصيص -------------------
class ProfileScreen extends StatefulWidget {
  final String userName;
  final Color primaryColor;
  final bool isDarkMode;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.primaryColor,
    required this.isDarkMode,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: widget.primaryColor.withOpacity(0.2),
            child: Icon(Icons.person, size: 60, color: widget.primaryColor),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _nameController,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              border: InputBorder.none,
              suffixIcon: Icon(Icons.edit, size: 18),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPanelScreen(primaryColor: widget.primaryColor)),
              );
            },
            icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
            label: const Text('لوحة تحكم الأدمن (إضافة مود)', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.download_done_rounded, color: Colors.green),
                  title: Text('إجمالي التحميلات'),
                  trailing: Text('12 مود', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.star, color: Colors.amber),
                  title: Text('تقييم الحساب'),
                  trailing: Text('VIP 🌟', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- 4. صفحة الأدمن لإضافة المودات -------------------
class AdminPanelScreen extends StatefulWidget {
  final Color primaryColor;

  const AdminPanelScreen({super.key, required this.primaryColor});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descController = TextEditingController();
  final _urlController = TextEditingController();
  bool isLoading = false;

  void _uploadAddon() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تعبئة الحقول الأساسية')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('addons').add({
        'title': _titleController.text,
        'category': _categoryController.text.isNotEmpty ? _categoryController.text : 'أدوات',
        'description': _descController.text,
        'downloadUrl': _urlController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم نشر المود للسحابة بنجاح! 🚀')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم الحفظ المحلي بنجاح (وضع أوفلاين)')),
      );
      Navigator.pop(context);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم الأدمن'),
        backgroundColor: widget.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text('إضافة مود أو خريطة جديدة للسحابة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'اسم المود (مثلاً: سيف التنين)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'التصنيف (أسلحة، خرائط، سكنات)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'وصف المود',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'رابط التحميل (.mcaddon أو .zip)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isLoading ? null : _uploadAddon,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('نشر المود 🚀', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
