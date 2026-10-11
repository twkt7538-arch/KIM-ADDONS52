import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KimAddonsApp());
}

class AddonModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String version;
  final String fileType;
  final String fileSize;
  final String? imagePath;
  final String? filePath;

  AddonModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.version,
    required this.fileType,
    required this.fileSize,
    this.imagePath,
    this.filePath,
  });
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
  
  static final List<AddonModel> globalAddons = [
    AddonModel(
      id: '1',
      title: 'مود الأسلحة الأسطورية',
      category: 'أسلحة ومعدات',
      description: 'أقوى مود أسلحة لماين كرافت بيدروك مع مؤثرات بصرية مذهلة وحركات واقعية.',
      version: 'v1.2.0',
      fileType: '.mcaddon',
      fileSize: '14.5 MB',
    ),
    AddonModel(
      id: '2',
      title: 'عالم المغامرات المرعبة',
      category: 'عوالم وخرائط',
      description: 'خريطة بقاء مليئة بالألغاز المرعبة والأحاجي الصعبة.',
      version: 'v2.0.1',
      fileType: '.mcworld',
      fileSize: '45.2 MB',
    ),
  ];

  void _addNewAddon(AddonModel addon) {
    setState(() {
      globalAddons.add(addon);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredAddons = globalAddons
        .where((e) => e.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

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
          Expanded(
            child: filteredAddons.isEmpty
                ? const Center(
                    child: Text(
                      'لا توجد مودات حالياً.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredAddons.length,
                    itemBuilder: (context, index) {
                      final item = filteredAddons[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: widget.primaryColor.withOpacity(0.2)),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddonDetailsScreen(
                                  addon: item,
                                  primaryColor: widget.primaryColor,
                                  isDarkMode: widget.isDarkMode,
                                ),
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: item.imagePath != null
                                ? Image.file(
                                    File(item.imagePath!),
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 55,
                                    height: 55,
                                    color: widget.primaryColor.withOpacity(0.15),
                                    child: Icon(Icons.extension, color: widget.primaryColor, size: 30),
                                  ),
                          ),
                          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(item.category, style: TextStyle(color: widget.primaryColor, fontSize: 11)),
                                  const SizedBox(width: 8),
                                  Text('• ${item.version}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: widget.primaryColor),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      const Center(child: Text('المحفوظات')),
      const Center(child: Text('التحميلات')),
      ProfileScreen(
        primaryColor: widget.primaryColor,
        onAddAddon: _addNewAddon,
      ),
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

class AddonDetailsScreen extends StatefulWidget {
  final AddonModel addon;
  final Color primaryColor;
  final bool isDarkMode;

  const AddonDetailsScreen({
    super.key,
    required this.addon,
    required this.primaryColor,
    required this.isDarkMode,
  });

  @override
  State<AddonDetailsScreen> createState() => _AddonDetailsScreenState();
}

class _AddonDetailsScreenState extends State<AddonDetailsScreen> {
  bool isDownloading = false;
  double downloadProgress = 0.0;

  void _startDownload() async {
    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      setState(() {
        downloadProgress = i / 10.0;
      });
    }

    setState(() {
      isDownloading = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم اكتمال التنزيل بنجاح وجاهز للتثبيت في ماين كرافت! 🎮')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.addon.title),
        backgroundColor: widget.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: widget.addon.imagePath != null
                    ? Image.file(
                        File(widget.addon.imagePath!),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: widget.primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.extension, size: 60, color: widget.primaryColor),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                widget.addon.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _infoCard('الإصدار', widget.addon.version, Icons.update),
                _infoCard('النوع', widget.addon.fileType, Icons.insert_drive_file),
                _infoCard('الحجم', widget.addon.fileSize, Icons.sd_storage),
              ],
            ),
            const SizedBox(height: 25),
            const Text('التصنيف:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(widget.addon.category, style: TextStyle(color: widget.primaryColor, fontSize: 15)),
            const SizedBox(height: 20),
            const Text('وصف المود:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              widget.addon.description,
              style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            if (isDownloading) ...[
              LinearProgressIndicator(
                value: downloadProgress,
                color: widget.primaryColor,
                backgroundColor: Colors.grey.withOpacity(0.2),
                minHeight: 10,
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'جاري التنزيل... ${(downloadProgress * 100).toInt()}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: _startDownload,
                  icon: const Icon(Icons.download_rounded, color: Colors.white),
                  label: const Text('تحميل المود وتثبيته 📥', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: widget.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: widget.primaryColor, size: 22),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final Color primaryColor;
  final Function(AddonModel) onAddAddon;

  const ProfileScreen({super.key, required this.primaryColor, required this.onAddAddon});

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
          const Text('لوحة التحكم الخاصة (المطور)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminAddonPanel(
                    primaryColor: primaryColor,
                    onAdd: onAddAddon,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
            label: const Text('إضافة مود جديد من الجهاز 📂', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class AdminAddonPanel extends StatefulWidget {
  final Color primaryColor;
  final Function(AddonModel) onAdd;

  const AdminAddonPanel({super.key, required this.primaryColor, required this.onAdd});

  @override
  State<AdminAddonPanel> createState() => _AdminAddonPanelState();
}

class _AdminAddonPanelState extends State<AdminAddonPanel> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descController = TextEditingController();
  final _versionController = TextEditingController(text: 'v1.0.0');
  
  String? _selectedImagePath;
  String? _selectedFilePath;
  String _fileTypeName = '.mcaddon';
  String _fileSizeName = '10.0 MB';

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
        final name = result.files.single.name;
        if (name.endsWith('.mcpack')) {
          _fileTypeName = '.mcpack';
        } else if (name.endsWith('.mcworld')) {
          _fileTypeName = '.mcworld';
        } else {
          _fileTypeName = '.mcaddon';
        }
        
        final bytes = result.files.single.size;
        final mb = (bytes / (1024 * 1024)).toStringAsFixed(1);
        _fileSizeName = '$mb MB';
      });
    }
  }

  void _saveAddon() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال اسم المود على الأقل')),
      );
      return;
    }

    final newAddon = AddonModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      category: _categoryController.text.isNotEmpty ? _categoryController.text : 'عام',
      description: _descController.text.isNotEmpty ? _descController.text : 'بدون وصف',
      version: _versionController.text.isNotEmpty ? _versionController.text : 'v1.0.0',
      fileType: _fileTypeName,
      fileSize: _fileSizeName,
      imagePath: _selectedImagePath,
      filePath: _selectedFilePath,
    );

    widget.onAdd(newAddon);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تمت إضافة المود وحفظه بنجاح! 🚀')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة مود من الهاتف'),
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
              controller: _versionController,
              decoration: const InputDecoration(labelText: 'رقم الإصدار (مثل v1.0.0)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'وصف المود'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              onPressed: _pickImage,
              icon: const Icon(Icons.image, color: Colors.white),
              label: Text(_selectedImagePath == null ? 'اختر صورة المود من المعرض 🖼️' : 'تم اختيار الصورة بنجاح ✅', style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: _pickFile,
              icon: const Icon(Icons.insert_drive_file, color: Colors.white),
              label: Text(_selectedFilePath == null ? 'اختر ملف المود (.mcaddon / .mcpack) 📁' : 'تم اختيار الملف بنجاح ✅', style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _saveAddon,
              child: const Text('نشر المود في التطبيق 💾', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
