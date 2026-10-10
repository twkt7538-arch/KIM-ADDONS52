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
  String currentLanguage = 'العربية';

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
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
      title: 'Kim Addons',
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
        primaryColor: Colors.greenAccent,
        colorScheme: isDarkMode
            ? ColorScheme.dark(primary: Colors.greenAccent, secondary: Colors.tealAccent, surface: const Color(0xFF1E1E1E))
            : ColorScheme.light(primary: Colors.green, secondary: Colors.teal, surface: Colors.white),
      ),
      home: HomeScreen(
        isDarkMode: isDarkMode,
        toggleTheme: toggleTheme,
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
  bool isFavorite;

  AddonItem({
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
    this.isFavorite = false,
  });
}

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  final String currentLanguage;
  final Function(String) changeLanguage;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
    required this.currentLanguage,
    required this.changeLanguage,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<AddonItem> addons = [
    AddonItem(
      title: 'سيف الحمم البركانية',
      category: 'أسلحة',
      description: 'سيف أسطوري يطلق نيران على الوحوش بضغطة واحدة.',
      icon: Icons.flash_on,
    ),
    AddonItem(
      title: 'قرية المدى المخفية',
      category: 'خرائط بقاء',
      description: 'خريطة بقاء صعبة مع موارد مخفية وأسرار مثيرة.',
      icon: Icons.map,
    ),
    AddonItem(
      title: 'سكن المحارب الأسطوري',
      category: 'سكينات',
      description: 'سكن فريد بتصميم مظلم ورهيب لمغامراتك.',
      icon: Icons.person,
    ),
    AddonItem(
      title: 'تكسشر باكمان الواقعي',
      category: 'حزم رسوميات',
      description: 'تعديل رسومات اللعبة لتصبح واقعية وعالية الدقة.',
      icon: Icons.palette,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showDownloadDialog(BuildContext context, AddonItem addon) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Download',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: FadeTransition(
            opacity: animation,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Icon(addon.icon, color: Colors.greenAccent),
                  const SizedBox(width: 10),
                  const Text('تحميل الإضافة'),
                ],
              ),
              content: Text('هل تريد حقاً بدء تحميل "${addon.title}" لتطبيقها في ماين كرافت؟'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء', style: TextStyle(color: Colors.redAccent)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم بدء تحميل ${addon.title} بنجاح! 🚀'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  child: const Text('تحميل الآن', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kim Addons 🎮', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    isDarkMode: widget.isDarkMode,
                    toggleTheme: widget.toggleTheme,
                    currentLanguage: widget.currentLanguage,
                    changeLanguage: widget.changeLanguage,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1b5e20), Color(0xFF004d40)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.sports_esports, size: 40, color: Colors.greenAccent),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'متجر إضافات ماين كرافت',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'اختر إضافتك المفضلة وثبتها بضغطة زر!',
                            style: TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'الإضافات المتاحة:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: addons.length,
                  itemBuilder: (context, index) {
                    final addon = addons[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.greenAccent.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(addon.icon, color: Colors.greenAccent, size: 28),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                addon.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                addon.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: addon.isFavorite ? Colors.redAccent : Colors.grey,
                                size: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  addon.isFavorite = !addon.isFavorite;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      addon.isFavorite ? 'تم الإضافة إلى المفضلة ❤️' : 'تمت الإزالة من المفضلة 🤍',
                                    ),
                                    duration: const Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                addon.category,
                                style: const TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              addon.description,
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent.withOpacity(0.2),
                                  foregroundColor: Colors.greenAccent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.download_rounded, size: 18),
                                label: const Text('تحميل'),
                                onPressed: () => _showDownloadDialog(context, addon),
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
        ),
      ),
    );
  }
}

// شاشة الإعدادات الجديدة
class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  final String currentLanguage;
  final Function(String) changeLanguage;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
    required this.currentLanguage,
    required this.changeLanguage,
  });

  void _showAuthBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'تسجيل الدخول / إنشاء حساب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تسجيل الدخول بنجاح! 🎉'), behavior: SnackBarBehavior.floating),
                    );
                  },
                  child: const Text('دخول / تسجيل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // قسم الحساب
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.greenAccent),
              title: const Text('حساب المستخدم'),
              subtitle: const Text('تسجيل الدخول أو إنشاء حساب جديد'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showAuthBottomSheet(context),
            ),
          ),
          const SizedBox(height: 12),
          // قسم المظهر
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: SwitchListTile(
              secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Colors.greenAccent),
              title: const Text('الوضع الداكن'),
              value: isDarkMode,
              onChanged: (value) => toggleTheme(),
            ),
          ),
          const SizedBox(height: 12),
          // قسم اللغة
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.greenAccent),
              title: const Text('لغة التطبيق'),
              subtitle: Text(currentLanguage),
              trailing: DropdownButton<String>(
                value: currentLanguage,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'العربية', child: Text('العربية')),
                  DropdownMenuItem(value: 'English', child: Text('English')),
                ],
                onChanged: (value) {
                  if (value != null) changeLanguage(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
