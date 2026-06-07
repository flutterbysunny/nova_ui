import 'package:flutter/material.dart';
import 'package:nova_ui/nova_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: NovaTheme.light(),
      darkTheme: NovaTheme.dark(),
      themeMode: ThemeMode.system,
      title: 'Nova UI Demo',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Step 4 ka fayda — context se colors lo, hardcode mat karo
    final primary = NovaColors.indigo;
    final isLight = !context.isDark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isLight
                ? [
              NovaColors.slate[50]!,
              NovaColors.indigo[50]!,
              NovaColors.slate[100]!,
            ]
                : [
              NovaColors.slate[900]!,
              const Color(0xFF1E1B4B),
              NovaColors.slate[900]!,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            // ✅ NovaSpacing token
            padding: NovaSpacing.paddingPage.copyWith(top: NovaSpacing.xxxl),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  NovaContainer(
                    width: 52,
                    height: 52,
                    // ✅ NovaRadius token
                    borderRadius: NovaRadius.lg,
                    gradient: LinearGradient(
                      colors: [primary[500]!, primary[400]!],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.blur_circular_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),

                  // ✅ NovaSpacing gap widget
                  NovaSpacing.gapXl,

                  // Tag
                  NovaContainer(
                    padding: NovaSpacing.paddingHV(10, 4),
                    // ✅ NovaRadius token
                    borderRadius: NovaRadius.sm,
                    // ✅ withValues — no deprecation warning
                    color: primary[500]!.withValues(alpha: 0.15),
                    child: Text(
                      'NOVA UI',
                      style: TextStyle(
                        color: primary[300],
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  NovaSpacing.gapSm,

                  Text(
                    'Welcome back',
                    style: TextStyle(
                      // ✅ Theme-aware text color
                      color: context.novaTextPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Sign in to continue',
                    style: TextStyle(
                      // ✅ Theme-aware muted color
                      color: context.novaTextSecondary,
                      fontSize: 15,
                    ),
                  ),

                  NovaSpacing.gapXl,

                  // Email
                  NovaTextField(
                    controller: _emailController,
                    label: 'Email',
                    hintText: 'you@example.com',
                    prefixIcon: const Icon(Icons.mail_outline_rounded),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                    v == null || !v.contains('@')
                        ? 'Valid email required'
                        : null,
                  ),

                  NovaSpacing.gapMd,

                  // Password
                  NovaTextField(
                    controller: _passwordController,
                    label: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onLogin(),
                    validator: (v) =>
                    v == null || v.length < 6
                        ? 'Min 6 characters'
                        : null,
                  ),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password?',
                        // ✅ Theme primary color
                        style: TextStyle(color: context.novaPrimary),
                      ),
                    ),
                  ),

                  // Login button
                  NovaButton(
                    text: 'Login',
                    loading: _loading,
                    onPressed: _onLogin,
                    // ✅ NovaColors swatch
                    backgroundColor: primary[500],
                  ),

                  NovaSpacing.gapLg,

                  // Divider
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: Color(0x1FFFFFFF)),
                      ),
                      Padding(
                        padding: NovaSpacing.paddingH(12),
                        child: Text(
                          'or continue with',
                          style: TextStyle(
                            // ✅ withValues instead of withOpacity
                            color: context.novaTextSecondary
                                .withValues(alpha: 0.5),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Color(0x1FFFFFFF)),
                      ),
                    ],
                  ),

                  NovaSpacing.gapMd,

                  // Google button
                  NovaButton(
                    text: 'Continue with Google',
                    variant: NovaButtonVariant.outlined,
                    icon: const Icon(Icons.g_mobiledata_rounded, size: 22),
                    onPressed: () {},
                    foregroundColor: context.novaTextSecondary,
                  ),

                  NovaSpacing.gapXl,

                  // Sign up link
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: context.novaTextSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: context.novaPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}