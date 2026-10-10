import 'package:flutter/material.dart';

void main() {
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
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى كتابة البريد وكلمة المرور')),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, anim, secAnim) => MainNavigationScreen(
          userName: _nameController.text.isNotEmpty ? _nameController.text : 'أحمد المنلا',
          isDarkMode: widget.isDarkMode,
          primaryColor: widget.primaryColor,
          toggleTheme: widget.toggleTheme,
          changePrimaryColor: widget.changePrimaryColor,
          currentLanguage: widget.currentLanguage,
          changeLanguage: widget.changeLanguage,
        ),
        transitionsBuilder: (context, anim, secAnim, child) {
          return FadeTransition(opacity: anim, child: ScaleTransition(scale: anim, child: child));
        },
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

  late List<AddonItem> addons;

  @override
  void initState() {
    super.initState();
    addons = [
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
          Expanded(
            child: ListView.builder(
              itemCount: filteredAddons.length,
              itemBuilder: (context, index) {
                final addon = filteredAddons[index];
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  curve: Curves.easeOut,
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
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            addon.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: addon.isFavorite ? widget.primaryColor : Colors.grey,
                          ),
                          onPressed: () => setState(() => addon.isFavorite = !addon.isFavorite),
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
          ? const Center(child: Text('لا توجد مضافات في المحفوظات بعد'))
          : ListView.builder(
              itemCount: favoriteAddons.length,
              itemBuilder: (context, index) => ListTile(
                leading: Icon(favoriteAddons[index].icon, color: widget.primaryColor),
                title: Text(favoriteAddons[index].title),
                subtitle: Text(favoriteAddons[index].category),
              ),
            ),
      downloadedAddons.isEmpty
          ? const Center(child: Text('لم تقم بتحميل أي إضافة حتى الآن'))
          : ListView.builder(
              itemCount: downloadedAddons.length,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(downloadedAddons[index].title),
                subtitle: const Text('جاهز للتثبيت في ماين كرافت'),
              ),
            ),
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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_currentIndex],
      ),
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
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: widget.primaryColor.withOpacity(0.2),
                child: Icon(Icons.person, size: 60, color: widget.primaryColor),
              ),
              CircleAvatar(
                radius: 16,
                backgroundColor: widget.primaryColor,
                child: const Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ],
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
