import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roastedmoon_legalease/settings_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  bool _obscurePassword = true;
  bool _isSaving = false;
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = FirebaseAuth.instance.currentUser;
    _nameController.text = user?.displayName ?? "Bulan Gosong";
    _emailController.text = user?.email ?? "user@example.com";
    _passController.text = "********"; // Password isn't retrievable for security
  }

Future<void> _handleUpdate() async {
  setState(() => _isSaving = true);
  try {
    final user = FirebaseAuth.instance.currentUser;

    // 1. Update Display Name
    if (_nameController.text.isNotEmpty) {
      await user?.updateDisplayName(_nameController.text);
    }

    // 2. Update Email (Only if changed)
    if (_emailController.text != user?.email) {
      await user?.verifyBeforeUpdateEmail(_emailController.text);
      // Note: This sends a verification email to the NEW address
    }

    // 3. Update Password (Only if user typed a new one)
    if (_passController.text.isNotEmpty && _passController.text != "********") {
      await user?.updatePassword(_passController.text);
    }
    
    setState(() => _isEditing = false);
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account details saved and updated!")),
    );
  } catch (e) {
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error: Please log out and back in to change security info.")),
    );
  }
  setState(() => _isSaving = false);
}

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 1. Profile Header
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFE3F2FD),
              child: Icon(Icons.person, size: 50, color: Color(0xFF0086FF)),
            ),
            const SizedBox(height: 25),

            // 2. Info Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF0086FF).withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
                ],
              ),
              child: _isEditing ? _buildEditForm() : _buildInfoDisplay(),
            ),

            const SizedBox(height: 30),

            // 3. Accessibility Settings (Font Slider Fix)
            _buildSettingsSection(settings),

            const SizedBox(height: 30),

            // 4. Logout
            TextButton.icon(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text("Logout Account", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI: INFO DISPLAY ---
  Widget _buildInfoDisplay() {
    return Column(
      children: [
        _infoRow(Icons.person_outline, "Name", _nameController.text),
        const Divider(height: 30),
        _infoRow(Icons.email_outlined, "Email", _emailController.text),
        const SizedBox(height: 25),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _isEditing = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0086FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  // --- UI: EDIT FORM ---
  Widget _buildEditForm() {
    return Column(
      children: [
        _editField("Full Name", _nameController, false),
        const SizedBox(height: 15),
        _editField("Email", _emailController, false),
        const SizedBox(height: 15),
        _editField("New Password", _passController, true),
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _isEditing = false),
                child: const Text("Cancel"),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                onPressed: _isSaving ? null : _handleUpdate, // Disable button while saving
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0086FF)),
                child: _isSaving 
                  ? const SizedBox(
                  height: 20, 
                  width: 20, 
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                )
              : const Text("Save", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsSection(SettingsProvider settings) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Accessibility", 
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
      ),
      const SizedBox(height: 15),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            // --- FONT SIZE OPTIONS ---
            _buildRadioOption(settings, "Small", 0.8, 12),
            const Divider(height: 1),
            _buildRadioOption(settings, "Medium", 1.0, 16),
            const Divider(height: 1),
            _buildRadioOption(settings, "Large", 1.2, 20),
            
            const Divider(height: 20, thickness: 1, color: Colors.black12),
            
            // --- DYSLEXIC FONT TOGGLE (Modern Switch) ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Dyslexic Friendly Font",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Switch(
                    value: settings.isDyslexicFont,
                    activeThumbColor: const Color(0xFF0086FF),
                    onChanged: (bool val) {
                      settings.toggleDyslexicFont(val);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

  Widget _buildRadioOption(SettingsProvider settings, String label, double value, double previewSize) {
    return RadioGroup<double>(
      groupValue: settings.fontSizeFactor,
      onChanged: (double? val) {
        if (val != null) settings.setFontSize(val);
      },
      child: InkWell(
        onTap: () => settings.setFontSize(value),
        child: Row(
          children: [
            Radio<double>(
              value: value,
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFF0086FF);
                }
                return Colors.grey;
              }),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: previewSize,
                fontWeight: settings.fontSizeFactor == value ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _editField(String label, TextEditingController controller, bool isPass) {
    return TextField(
      controller: controller,
      obscureText: isPass && _obscurePassword,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: isPass ? IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}