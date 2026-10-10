import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase status: $e");
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

class AddonModel {
  final String title;
  final String category;
  final String description;

  AddonModel({required this.title, required this.category, required this.description});
}

// ------------------- 1. صفحة الدخول -------------------
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
                BoxShadow(color: widget.primaryColor.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
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

// ------------------- 2. الواجهة الرئيسية -------------------
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

  static List<AddonModel> defaultAddons = [
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
  ];

  Widget _buildList() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('addons').get(),
      builder: (context, snapshot) {
        List<AddonModel> items = List.from(defaultAddons);

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            items.add(AddonModel(
              title: data['title'] ?? 'مود جديد',
              category: data['category'] ?? 'عام',
              description: data['description'] ?? '',
            ));
          }
        }

        final filtered = items.where((e) => e.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();

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
      const Center(child: Text('المحفوظات')),
      const Center(child: Text('التحميلات')),
      ProfileScreen(
        userName: widget.userName,
        primaryColor: widget.primaryColor,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kim Addons 🎮', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: widget.isDarkMode ? const Color(0xFF1A1A1A) : widget.primaryColor,
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

// ------------------- 3. صفحة الملف الشخصي والأدمن -------------------
class ProfileScreen extends StatelessWidget {
  final String userName;
  final Color primaryColor;

  const ProfileScreen({super.key, required this.userName, required this.primaryColor});

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
          Text(userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPanelScreen(primaryColor: primaryColor)),
              );
            },
            icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
            label: const Text('لوحة تحكم الأدمن', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class AdminPanelScreen extends StatefulWidget {
  final Color primaryColor;
  const AdminPanelScreen({super.key, required this.primaryColor});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  void _add() async {
    if (_titleController.text.isEmpty) return;
    try {
      await FirebaseFirestore.instance.collection('addons').add({
        'title': _titleController.text,
        'description': _descController.text,
        'category': 'عام',
      });
    } catch (_) {}
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة الأدمن'), backgroundColor: widget.primaryColor),
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
              child: const Text('نشر المود', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
