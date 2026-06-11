import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("تم تسجيل الدخول بنجاح!"),
            backgroundColor: const Color(0xFF6C63FF),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "حدث خطأ ما، يرجى المحاولة لاحقاً.";
      if (e.code == 'user-not-found') {
        errorMessage = "هذا الحساب غير موجود.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "كلمة المرور غير صحيحة.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "صيغة البريد الإلكتروني غير صحيحة.";
      } else if (e.code == 'user-disabled') {
        errorMessage = "تم تعطيل هذا الحساب.";
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: const Color(0xFFFF6B6B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("خطأ: ${e.toString()}"),
            backgroundColor: const Color(0xFFFF6B6B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: Stack(
        children: [
          // Background design
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6C63FF).withOpacity(0.4),
                    const Color(0xFF6C63FF).withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF8B5CF6).withOpacity(0.3),
                    const Color(0xFF8B5CF6).withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        size: 50,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "مرحباً بك مجدداً 👋",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "قم بتسجيل الدخول للمتابعة",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Form Card
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              style: const TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF6C63FF)),
                                hintText: "البريد الإلكتروني",
                                hintStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.normal),
                                filled: true,
                                fillColor: const Color(0xFFF0F2F8),
                                contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
                                ),
                                errorStyle: const TextStyle(color: Color(0xFFFF6B6B)),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "يرجى إدخال البريد الإلكتروني";
                                }
                                final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!emailRegExp.hasMatch(value.trim())) {
                                  return "يرجى إدخال بريد إلكتروني صحيح";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            
                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              style: const TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.w600),
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6C63FF)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey[500],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                hintText: "كلمة المرور",
                                hintStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.normal),
                                filled: true,
                                fillColor: const Color(0xFFF0F2F8),
                                contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
                                ),
                                errorStyle: const TextStyle(color: Color(0xFFFF6B6B)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "يرجى إدخال كلمة المرور";
                                }
                                if (value.length < 6) {
                                  return "يجب ألا تقل كلمة المرور عن 6 أحرف";
                                }
                                return null;
                              },
                            ),
                            
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF6C63FF),
                                  padding: const EdgeInsets.only(top: 12),
                                ),
                                child: const Text("نسيت كلمة المرور؟", style: TextStyle(fontWeight: FontWeight.w700)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF6C63FF).withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : const Text(
                                            "تسجيل الدخول",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Go to Register Screen
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ليس لديك حساب؟ ",
                          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "إنشاء حساب جديد",
                            style: TextStyle(
                              color: Color(0xFF6C63FF),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

