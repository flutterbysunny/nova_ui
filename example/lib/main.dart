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
  int _selectedChip = 0;
  List<int> _selectedChips = [0];
  String? _selectedCountry;
  String? _selectedFramework;
  bool _termsAccepted = false;
  bool _newsletter = false;
  List<String> _checkboxGroup = ['Flutter'];

  bool _switchNotifications = true;
  bool _switchDarkMode = false;
  bool _switchMarketing = false;
  bool _switchSmall = true;
  bool _switchLarge = false;

  bool _roundedChecked = true;
  bool _circleChecked = true;
  bool _squareChecked = true;

  final _searchController = TextEditingController();
  bool _searchLoading = false;
  int _currentStep = 1;

  int _tabIndex = 0;
  int _tabIndex2 = 0;
  int _tabIndex3 = 0;

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
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

                  NovaSpacing.gapXl,

                  // Tag
                  NovaContainer(
                    padding: NovaSpacing.paddingHV(10, 4),
                    borderRadius: NovaRadius.sm,
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
                        style: TextStyle(color: context.novaPrimary),
                      ),
                    ),
                  ),

                  // Login button
                  NovaButton(
                    text: 'Login',
                    loading: _loading,
                    onPressed: _onLogin,
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
                          style: TextStyle(color: context.novaTextSecondary),
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

                  NovaSpacing.gapXl,

                  // ── Widget Showcase ───────────────────────────────

                  Divider(
                    color: context.novaTextSecondary.withValues(alpha: 0.15),
                  ),

                  NovaSpacing.gapMd,

                  Text(
                    'Widget Showcase',
                    style: TextStyle(
                      color: context.novaTextSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),

                  NovaSpacing.gapMd,

                  // ── NovaLoader ────────────────────────────────────
                  NovaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NovaLoader',
                          style: TextStyle(
                            color: context.novaTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        NovaSpacing.gapMd,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Circular
                            Column(
                              children: [
                                NovaLoader(color: primary[500]),
                                NovaSpacing.gapSm,
                                Text(
                                  'circular',
                                  style: TextStyle(
                                    color: context.novaTextSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            // Dots
                            Column(
                              children: [
                                NovaLoader(
                                  type: NovaLoaderType.dots,
                                  color: primary[500],
                                  size: 28,
                                ),
                                NovaSpacing.gapSm,
                                Text(
                                  'dots',
                                  style: TextStyle(
                                    color: context.novaTextSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            // Linear
                            Column(
                              children: [
                                NovaLoader(
                                  type: NovaLoaderType.linear,
                                  color: primary[500],
                                  width: 80,
                                ),
                                NovaSpacing.gapSm,
                                Text(
                                  'linear',
                                  style: TextStyle(
                                    color: context.novaTextSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  NovaSpacing.gapMd,

                  // ── NovaDialog ────────────────────────────────────
                  NovaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NovaDialog',
                          style: TextStyle(
                            color: context.novaTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        NovaSpacing.gapMd,
                        Row(
                          children: [
                            Expanded(
                              child: NovaButton(
                                text: 'Success',
                                height: 40,
                                backgroundColor: const Color(0xFF22C55E),
                                onPressed: () => NovaDialog.show(
                                  context: context,
                                  title: 'Profile Saved',
                                  message:
                                  'Your changes have been saved successfully.',
                                  type: NovaDialogType.success,
                                ),
                              ),
                            ),
                            NovaSpacing.gapSmH,
                            Expanded(
                              child: NovaButton(
                                text: 'Warning',
                                height: 40,
                                backgroundColor: const Color(0xFFF59E0B),
                                onPressed: () => NovaDialog.show(
                                  context: context,
                                  title: 'Log Out?',
                                  message:
                                  'This will log you out of all devices.',
                                  type: NovaDialogType.warning,
                                  confirmText: 'Logout',
                                  cancelText: 'Cancel',
                                ),
                              ),
                            ),
                            NovaSpacing.gapSmH,
                            Expanded(
                              child: NovaButton(
                                text: 'Danger',
                                height: 40,
                                backgroundColor:
                                Theme.of(context).colorScheme.error,
                                onPressed: () => NovaDialog.show(
                                  context: context,
                                  title: 'Delete Account?',
                                  message:
                                  'This action cannot be undone.',
                                  type: NovaDialogType.danger,
                                  confirmText: 'Delete',
                                  cancelText: 'Cancel',
                                  barrierDismissible: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  NovaSpacing.gapMd,

                  // ── NovaBadge ─────────────────────────────────────
                  NovaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NovaBadge',
                          style: TextStyle(
                            color: context.novaTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        NovaSpacing.gapMd,

                        // Status labels
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            NovaBadge(
                              label: 'Active',
                              color: NovaBadgeColor.success,
                            ),
                            NovaBadge(
                              label: 'Pending',
                              color: NovaBadgeColor.warning,
                              variant: NovaBadgeVariant.soft,
                            ),
                            NovaBadge(
                              label: 'Failed',
                              color: NovaBadgeColor.danger,
                              variant: NovaBadgeVariant.outlined,
                            ),
                            NovaBadge(
                              label: 'Draft',
                              color: NovaBadgeColor.neutral,
                              variant: NovaBadgeVariant.soft,
                            ),
                            NovaBadge(
                              label: 'New',
                              color: NovaBadgeColor.primary,
                            ),
                          ],
                        ),

                        NovaSpacing.gapMd,

                        // Dot + Count + Overlay
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Dot
                            Column(
                              children: [
                                NovaBadge(
                                  isDot: true,
                                  color: NovaBadgeColor.success,
                                ),
                                NovaSpacing.gapSm,
                                Text(
                                  'dot',
                                  style: TextStyle(
                                    color: context.novaTextSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            // Count
                            Column(
                              children: [
                                NovaBadge(
                                  count: 5,
                                  color: NovaBadgeColor.danger,
                                ),
                                NovaSpacing.gapSm,
                                Text(
                                  'count',
                                  style: TextStyle(
                                    color: context.novaTextSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            // Overlay on icon
                            Column(
                              children: [
                                NovaBadge(
                                  count: 12,
                                  color: NovaBadgeColor.danger,
                                  child: Icon(
                                    Icons.notifications_outlined,
                                    size: 28,
                                    color: context.novaTextPrimary,
                                  ),
                                ),
                                NovaSpacing.gapSm,
                                Text(
                                  'overlay',
                                  style: TextStyle(
                                    color: context.novaTextSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            // 99+ overflow
                            Column(
                              children: [
                                NovaBadge(
                                  count: 150,
                                  color: NovaBadgeColor.primary,
                                ),
                                NovaSpacing.gapSm,
                                Text(
                                  '99+',
                                  style: TextStyle(
                                    color: context.novaTextSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  NovaSpacing.gapMd,

// ── NovaShimmer ───────────────────────────────────
                  NovaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NovaShimmer',
                          style: TextStyle(
                            color: context.novaTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        NovaSpacing.gapMd,

                        // List skeleton
                        NovaShimmer.list(itemCount: 3),

                        NovaSpacing.gapMd,

                        // Card skeleton
                        NovaShimmer.card(),
                      ],
                    ),
                  ),
                  NovaSpacing.gapMd,

// ── NovaAvatar ────────────────────────────────────
                  NovaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NovaAvatar',
                          style: TextStyle(
                            color: context.novaTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        NovaSpacing.gapMd,

                        // Sizes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            NovaAvatar(name: 'A', size: NovaAvatarSize.xs),
                            NovaAvatar(name: 'AB', size: NovaAvatarSize.sm),
                            NovaAvatar(name: 'John Doe', size: NovaAvatarSize.md),
                            NovaAvatar(name: 'Nova UI', size: NovaAvatarSize.lg),
                            NovaAvatar(name: 'Flutter', size: NovaAvatarSize.xl),
                          ],
                        ),

                        NovaSpacing.gapMd,

                        // Online indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            NovaAvatar(
                              name: 'John Doe',
                              showOnlineIndicator: true,
                              isOnline: true,
                            ),
                            NovaAvatar(
                              name: 'Jane Smith',
                              showOnlineIndicator: true,
                              isOnline: false,
                            ),
                            NovaAvatar(
                              icon: Icons.person_rounded,
                              showOnlineIndicator: true,
                            ),
                            NovaAvatar(
                              name: 'Nova',
                              borderColor: NovaColors.indigo[400],
                              borderWidth: 2,
                              showOnlineIndicator: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  NovaSpacing.gapMd,

// ── NovaChip ──────────────────────────────────────
                  NovaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NovaChip',
                          style: TextStyle(
                            color: context.novaTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        NovaSpacing.gapMd,

                        // Variants
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            NovaChip(label: 'Filled', variant: NovaChipVariant.filled),
                            NovaChip(label: 'Soft', variant: NovaChipVariant.soft),
                            NovaChip(label: 'Outlined', variant: NovaChipVariant.outlined),
                          ],
                        ),

                        NovaSpacing.gapSm,

                        // Colors
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            NovaChip(label: 'Primary', color: NovaChipColor.primary),
                            NovaChip(label: 'Success', color: NovaChipColor.success),
                            NovaChip(label: 'Warning', color: NovaChipColor.warning),
                            NovaChip(label: 'Danger', color: NovaChipColor.danger),
                            NovaChip(label: 'Neutral', color: NovaChipColor.neutral),
                          ],
                        ),

                        NovaSpacing.gapSm,

                        // With icons + deletable
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            NovaChip(
                              label: 'Flutter',
                              icon: Icons.flutter_dash,
                              color: NovaChipColor.primary,
                            ),
                            NovaChip(
                              label: 'Remove me',
                              onDeleted: () {},
                              color: NovaChipColor.danger,
                              variant: NovaChipVariant.outlined,
                            ),
                          ],
                        ),

                        NovaSpacing.gapSm,

                        // Single select group
                        NovaChipGroup(
                          chips: const ['All', 'Design', 'Code', 'Testing'],
                          selectedIndex: _selectedChip,
                          onChanged: (i) => setState(() => _selectedChip = i),
                        ),

                        NovaSpacing.gapSm,

                        // Multi select group
                        NovaChipGroup.multi(
                          chips: const ['Flutter', 'Dart', 'Firebase'],
                          selectedIndexes: _selectedChips,
                          onMultiChanged: (indexes) =>
                              setState(() => _selectedChips = indexes),
                        ),
                      ],
                    ),
                  ),
                  NovaSpacing.gapMd,

// ── NovaToast ─────────────────────────────────────
                  NovaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NovaToast',
                          style: TextStyle(
                            color: context.novaTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        NovaSpacing.gapMd,
                        Row(
                          children: [
                            Expanded(
                              child: NovaButton(
                                text: 'Info',
                                height: 40,
                                onPressed: () => NovaToast.show(
                                  context: context,
                                  message: 'This is an info message.',
                                ),
                              ),
                            ),
                            NovaSpacing.gapSmH,
                            Expanded(
                              child: NovaButton(
                                text: 'Success',
                                height: 40,
                                backgroundColor: const Color(0xFF22C55E),
                                onPressed: () => NovaToast.show(
                                  context: context,
                                  message: 'Profile saved successfully!',
                                  type: NovaToastType.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                        NovaSpacing.gapSm,
                        Row(
                          children: [
                            Expanded(
                              child: NovaButton(
                                text: 'Warning',
                                height: 40,
                                backgroundColor: const Color(0xFFF59E0B),
                                onPressed: () => NovaToast.show(
                                  context: context,
                                  message: 'Check your connection.',
                                  type: NovaToastType.warning,
                                  position: NovaToastPosition.top,
                                ),
                              ),
                            ),
                            NovaSpacing.gapSmH,
                            Expanded(
                              child: NovaButton(
                                text: 'Error',
                                height: 40,
                                backgroundColor: Theme.of(context).colorScheme.error,
                                onPressed: () => NovaToast.show(
                                  context: context,
                                  message: 'Something went wrong.',
                                  type: NovaToastType.error,
                                  position: NovaToastPosition.top,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  NovaSpacing.gapMd,

// ── NovaBottomSheet ───────────────────────────────
                  NovaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NovaBottomSheet',
                          style: TextStyle(
                            color: context.novaTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        NovaSpacing.gapMd,
                        Row(
                          children: [
                            // Custom content
                            Expanded(
                              child: NovaButton(
                                text: 'Custom',
                                height: 40,
                                variant: NovaButtonVariant.outlined,
                                onPressed: () => NovaBottomSheet.show(
                                  context: context,
                                  title: 'Edit Profile',
                                  subtitle: 'Update your information',
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      NovaTextField(
                                        label: 'Name',
                                        hintText: 'John Doe',
                                      ),
                                      NovaSpacing.gapMd,
                                      NovaTextField(
                                        label: 'Bio',
                                        hintText: 'Tell us about yourself...',
                                        maxLines: 3,
                                      ),
                                      NovaSpacing.gapMd,
                                      NovaButton(
                                        text: 'Save Changes',
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            NovaSpacing.gapSmH,
                            // Actions sheet
                            Expanded(
                              child: NovaButton(
                                text: 'Actions',
                                height: 40,
                                onPressed: () => NovaBottomSheet.showActions(
                                  context: context,
                                  title: 'Sort By',
                                  subtitle: 'Choose a sort order',
                                  actions: [
                                    NovaSheetAction(
                                      label: 'Newest First',
                                      icon: Icons.schedule_rounded,
                                      onTap: () {},
                                    ),
                                    NovaSheetAction(
                                      label: 'Oldest First',
                                      icon: Icons.history_rounded,
                                      onTap: () {},
                                    ),
                                    NovaSheetAction(
                                      label: 'Most Popular',
                                      icon: Icons.trending_up_rounded,
                                      onTap: () {},
                                    ),
                                    NovaSheetAction(
                                      label: 'Delete All',
                                      icon: Icons.delete_outline_rounded,
                                      isDestructive: true,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  NovaSpacing.gapMd,

// ── NovaDropdown ──────────────────────────────────
                  NovaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NovaDropdown',
                          style: TextStyle(
                            color: context.novaTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        NovaSpacing.gapMd,

                        // Country dropdown
                        NovaDropdown<String>(
                          label: 'Country',
                          hintText: 'Select a country',
                          prefixIcon: const Icon(Icons.language_rounded),
                          value: _selectedCountry,
                          items: const [
                            NovaDropdownItem(value: 'in', label: 'India'),
                            NovaDropdownItem(
                                value: 'us', label: 'United States'),
                            NovaDropdownItem(
                                value: 'uk', label: 'United Kingdom'),
                            NovaDropdownItem(value: 'ca', label: 'Canada'),
                          ],
                          onChanged: (v) =>
                              setState(() => _selectedCountry = v),
                        ),

                        NovaSpacing.gapMd,

                        // Framework dropdown with icons
                        NovaDropdown<String>(
                          label: 'Framework',
                          hintText: 'Select a framework',
                          prefixIcon: const Icon(Icons.code_rounded),
                          value: _selectedFramework,
                          items: const [
                            NovaDropdownItem(
                              value: 'flutter',
                              label: 'Flutter',
                              icon: Icons.flutter_dash,
                            ),
                            NovaDropdownItem(
                              value: 'react',
                              label: 'React Native',
                              icon: Icons.phone_android_rounded,
                            ),
                            NovaDropdownItem(
                              value: 'kotlin',
                              label: 'Kotlin',
                              icon: Icons.android_rounded,
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => _selectedFramework = v),
                          validator: (v) =>
                          v == null
                              ? 'Please select a framework'
                              : null,
                        ),
                      ],
                    ),
                  ),
                  // ── NovaCheckbox ──────────────────────────────────
                  NovaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NovaCheckbox',
                          style: TextStyle(
                            color: context.novaTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        NovaSpacing.gapMd,

                        // Simple
                        NovaCheckbox(
                          value: _termsAccepted,
                          label: 'Accept terms and conditions',
                          onChanged: (v) => setState(() => _termsAccepted = v!),
                        ),

                        NovaSpacing.gapSm,

                        // With sublabel
                        NovaCheckbox(
                          value: _newsletter,
                          label: 'Marketing emails',
                          sublabel: 'Receive updates about new features',
                          onChanged: (v) => setState(() => _newsletter = v!),
                        ),

                        NovaSpacing.gapSm,

                        // ✅ Row hataya — seedha Column mein
                        // ✅ State se connect karo
                        NovaCheckbox(
                          value: _roundedChecked,
                          shape: NovaCheckboxShape.rounded,
                          label: 'Rounded',
                          onChanged: (v) => setState(() => _roundedChecked = v!),
                        ),

                        NovaSpacing.gapSm,

                        NovaCheckbox(
                          value: _circleChecked,
                          shape: NovaCheckboxShape.circle,
                          label: 'Circle',
                          onChanged: (v) => setState(() => _circleChecked = v!),
                        ),

                        NovaSpacing.gapSm,

                        NovaCheckbox(
                          value: _squareChecked,
                          shape: NovaCheckboxShape.square,
                          label: 'Square',
                          onChanged: (v) => setState(() => _squareChecked = v!),
                        ),

                        NovaSpacing.gapMd,

                        // Group
                        NovaCheckboxGroup(
                          items: const [
                            'Flutter',
                            'Dart',
                            'Firebase',
                            'Supabase'
                          ],
                          selectedItems: _checkboxGroup,
                          onChanged: (items) =>
                              setState(() => _checkboxGroup = items),
                        ),
                      ],
                    ),
                  ),
                  NovaSpacing.gapMd,

// ── NovaSwitch ────────────────────────────────────
                  NovaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NovaSwitch',
                          style: TextStyle(
                            color: context.novaTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        NovaSpacing.gapMd,

                        // With label
                        NovaSwitch(
                          value: _switchNotifications,
                          label: 'Push Notifications',
                          onChanged: (v) =>
                              setState(() => _switchNotifications = v),
                        ),

                        NovaSpacing.gapMd,

                        // With sublabel
                        NovaSwitch(
                          value: _switchDarkMode,
                          label: 'Dark Mode',
                          sublabel: 'Switch between light and dark theme',
                          onChanged: (v) => setState(() => _switchDarkMode = v),
                        ),

                        NovaSpacing.gapMd,

                        // Label left — settings style
                        NovaSwitch(
                          value: _switchMarketing,
                          label: 'Marketing Emails',
                          sublabel: 'Receive updates and offers',
                          labelPosition: NovaSwitchLabelPosition.left,
                          onChanged: (v) =>
                              setState(() => _switchMarketing = v),
                        ),

                        NovaSpacing.gapMd,

                        // Sizes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                NovaSwitch(
                                  value: _switchSmall,
                                  size: NovaSwitchSize.sm,
                                  onChanged: (v) =>
                                      setState(() => _switchSmall = v),
                                ),
                                NovaSpacing.gapSm,
                                Text(
                                  'sm',
                                  style: TextStyle(
                                    color: context.novaTextSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                NovaSwitch(
                                  value: _switchNotifications,
                                  size: NovaSwitchSize.md,
                                  onChanged: (v) =>
                                      setState(() => _switchNotifications = v),
                                ),
                                NovaSpacing.gapSm,
                                Text(
                                  'md',
                                  style: TextStyle(
                                    color: context.novaTextSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                NovaSwitch(
                                  value: _switchLarge,
                                  size: NovaSwitchSize.lg,
                                  onChanged: (v) =>
                                      setState(() => _switchLarge = v),
                                ),
                                NovaSpacing.gapSm,
                                Text(
                                  'lg',
                                  style: TextStyle(
                                    color: context.novaTextSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        NovaSpacing.gapMd,

                        // Disabled
                        NovaSwitch(
                          value: true,
                          label: 'Disabled On',
                          enabled: false,
                          onChanged: (_) {},
                        ),

                        NovaSpacing.gapSm,

                        NovaSwitch(
                          value: false,
                          label: 'Disabled Off',
                          enabled: false,
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                  ),
                  NovaSpacing.gapMd,

// ── NovaSearchBar ─────────────────────────────────
                  NovaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NovaSearchBar',
                          style: TextStyle(
                            color: context.novaTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        NovaSpacing.gapMd,

                        // Simple
                        NovaSearchBar(
                          hintText: 'Search anything...',
                          onChanged: (q) => debugPrint('Query: $q'),
                        ),

                        NovaSpacing.gapMd,

                        // With debounce
                        NovaSearchBar(
                          controller: _searchController,
                          hintText: 'Search with debounce...',
                          debounce: const Duration(milliseconds: 500),
                          onChanged: (q) => debugPrint('Debounced: $q'),
                          onSubmitted: (q) => debugPrint('Submitted: $q'),
                        ),

                        NovaSpacing.gapMd,

                        // Loading state
                        // Loading state — ab properly kaam karega
                        NovaSearchBar(
                          hintText: _searchLoading ? 'Searching...' : 'Search with loading...',
                          isLoading: _searchLoading,
                          onChanged: (q) async {
                            if (q.isEmpty) return;
                            setState(() => _searchLoading = true);
                            await Future.delayed(const Duration(seconds: 2)); // simulate API
                            if (mounted) setState(() => _searchLoading = false);
                          },
                        ),

                        NovaSpacing.gapMd,

                        // Disabled
                        NovaSearchBar(
                          hintText: 'Disabled search',
                          enabled: false,
                          onChanged: (_) {},
                        ),

                        NovaSpacing.gapMd,

                        // Pill shape
                        NovaSearchBar(
                          hintText: 'Pill shape search...',
                          borderRadius: BorderRadius.circular(999),
                          onChanged: (q) => debugPrint('Pill: $q'),
                        ),
                      ],
                    ),
                  ),
                  NovaSpacing.gapMd,

// ── NovaStepIndicator ─────────────────────────────
                  NovaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NovaStepIndicator',
                          style: TextStyle(
                            color: context.novaTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        NovaSpacing.gapMd,

                        // Numbered
                        NovaStepIndicator(
                          totalSteps: 4,
                          currentStep: _currentStep,
                          labels: const ['Account', 'Profile', 'Review', 'Done'],
                        ),

                        NovaSpacing.gapMd,

                        // Dots
                        Center(
                          child: NovaStepIndicator(
                            totalSteps: 5,
                            currentStep: _currentStep,
                            style: NovaStepIndicatorStyle.dots,
                            size: 28,
                          ),
                        ),

                        NovaSpacing.gapMd,

                        // Progress bar
                        NovaStepIndicator(
                          totalSteps: 4,
                          currentStep: _currentStep,
                          style: NovaStepIndicatorStyle.progress,
                          labels: const ['Account', 'Profile', 'Review', 'Done'],
                        ),

                        NovaSpacing.gapMd,

                        // Controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NovaButton(
                              text: 'Prev',
                              width: 100,
                              height: 40,
                              variant: NovaButtonVariant.outlined,
                              onPressed: _currentStep > 0
                                  ? () => setState(() => _currentStep--)
                                  : null,
                            ),
                            NovaSpacing.gapMdH,
                            NovaButton(
                              text: 'Next',
                              width: 100,
                              height: 40,
                              onPressed: _currentStep < 3
                                  ? () => setState(() => _currentStep++)
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  NovaSpacing.gapMd,

// ── NovaTabBar ────────────────────────────────────
                  NovaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NovaTabBar',
                          style: TextStyle(
                            color: context.novaTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        NovaSpacing.gapMd,

                        // Pill style
                        Text(
                          'Pill',
                          style: TextStyle(
                            color: context.novaTextSecondary,
                            fontSize: 11,
                          ),
                        ),
                        NovaSpacing.gapSm,
                        NovaTabBar(
                          selectedIndex: _tabIndex,
                          activeTextColor: Colors.white,
                          tabs: const [
                            NovaTabItem(label: 'All'),
                            NovaTabItem(label: 'Active'),
                            NovaTabItem(label: 'Done'),
                          ],
                          onChanged: (i) => setState(() => _tabIndex = i),
                        ),

                        NovaSpacing.gapMd,

                        // Underline style
                        Text(
                          'Underline',
                          style: TextStyle(
                            color: context.novaTextSecondary,
                            fontSize: 11,
                          ),
                        ),
                        NovaSpacing.gapSm,
                        NovaTabBar(
                          selectedIndex: _tabIndex2,
                          style: NovaTabBarStyle.underline,
                          tabs: const [
                            NovaTabItem(label: 'Feed', icon: Icons.home_rounded),
                            NovaTabItem(label: 'Search', icon: Icons.search_rounded),
                            NovaTabItem(label: 'Inbox', icon: Icons.mail_rounded, badge: 3),
                            NovaTabItem(label: 'Profile', icon: Icons.person_rounded),
                          ],
                          onChanged: (i) => setState(() => _tabIndex2 = i),
                        ),

                        NovaSpacing.gapMd,

                        // Filled style
                        Text(
                          'Filled',
                          style: TextStyle(
                            color: context.novaTextSecondary,
                            fontSize: 11,
                          ),
                        ),
                        NovaSpacing.gapSm,
                        NovaTabBar(
                          selectedIndex: _tabIndex3,
                          style: NovaTabBarStyle.filled,
                          tabs: const [
                            NovaTabItem(label: 'Day'),
                            NovaTabItem(label: 'Week'),
                            NovaTabItem(label: 'Month'),
                          ],
                          onChanged: (i) => setState(() => _tabIndex3 = i),
                        ),
                      ],
                    ),
                  ),
                  NovaSpacing.gapXl,

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}