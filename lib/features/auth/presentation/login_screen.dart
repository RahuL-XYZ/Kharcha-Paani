import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/route_names.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final success = await ref.read(authControllerProvider.notifier).login(
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (success && mounted) {
      context.go(RouteNames.home);
    }
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF2C2C2C);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && _obscurePassword,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          style: TextStyle(color: textColor, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: textColor.withValues(alpha: 0.4),
              fontSize: 13,
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF5B5C3), width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF5B5C3), width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF5C431), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: textColor.withValues(alpha: 0.5),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF2C2C2C);
    final bgColor = isDark ? const Color(0xFF131B2E) : const Color(0xFFFDF7F4); // Soft warm bg

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Illustration
                Center(
                  child: Image.asset(
                    'assets/images/login_img.png',
                    height: 220,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Titles
                Text(
                  'Welcome Back!',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.authLoginSubtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: textColor.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 32),

                if (authState.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      authState.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Form Fields
                _buildTextField(
                  label: 'Email',
                  hint: 'Enter your email address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return AppLocalizations.of(context)!.authEmailEmptyError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passwordController,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleLogin(),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return AppLocalizations.of(context)!.authPasswordEmptyError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Log In Button
                ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5B5C3), // Soft Rose Pink
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: authState.isLoading
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          'Log In Now',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
                const SizedBox(height: 24),

                // Forgot Password
                Center(
                  child: TextButton(
                    onPressed: () => context.push(RouteNames.forgotPassword),
                    child: Text(
                      'Forgot password ?',
                      style: GoogleFonts.plusJakartaSans(
                        color: textColor.withValues(alpha: 0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.plusJakartaSans(
                        color: textColor.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(authControllerProvider.notifier).clearError();
                        context.push(RouteNames.register);
                      },
                      child: Text(
                        "Sign Up then",
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFF5B5C3),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
