import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  final cityCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  bool saving = false;

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    phoneCtrl.dispose();
    cityCtrl.dispose();
    areaCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => saving = true);

    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      "authProvider": user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : "email",
      "email": user.email ?? "",
      "firstName": firstNameCtrl.text.trim(),
      "lastName": lastNameCtrl.text.trim(),
      "phone": phoneCtrl.text.trim(),
      "phoneVerified": false,
      "profileCompleted": true,
      "location": {
        "method": "manual",
        "city": cityCtrl.text.trim(),
        "area": areaCtrl.text.trim(),
        "addressText": addressCtrl.text.trim(),
      },
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (mounted) setState(() => saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إكمال البيانات")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: firstNameCtrl,
                  decoration: const InputDecoration(labelText: "الاسم الأول"),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "مطلوب" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: lastNameCtrl,
                  decoration: const InputDecoration(labelText: "اسم العائلة"),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "مطلوب" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: "رقم الهاتف"),
                  validator: (v) {
                    final s = (v ?? "").trim();
                    if (s.isEmpty) return "مطلوب";
                    if (s.length < 9) return "رقم غير صحيح";
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "الموقع (إدخال يدوي)",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: cityCtrl,
                  decoration: const InputDecoration(labelText: "المدينة"),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "مطلوب" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: areaCtrl,
                  decoration: const InputDecoration(labelText: "المنطقة"),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "مطلوب" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: addressCtrl,
                  decoration: const InputDecoration(labelText: "وصف العنوان"),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: saving ? null : _saveProfile,
                  child: saving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("متابعة"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
