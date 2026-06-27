import 'package:flutter/material.dart';
import '../../widgets/auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _formController;
  late AnimationController _bgController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _formSlide;
  late Animation<double> _formOpacity;
  late Animation<double> _bgAnim;

  bool _showForm = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const Color navyDark = Color(0xFF0A0E27);
  static const Color navy = Color(0xFF0D1B4B);
  static const Color navyMid = Color(0xFF112466);
  static const Color cyan = Color(0xFF00D4FF);
  static const Color cyanLight = Color(0xFF7EEEFF);

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _bgAnim = Tween<double>(begin: 0, end: 1).animate(_bgController);

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic));
    _formOpacity = Tween<double>(begin: 0, end: 1).animate(_formController);

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _showForm = true);
    _formController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _formController.dispose();
    _bgController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Simulate account creation (no real backend yet).
    // We just hold the form briefly, then send the user back to
    // Login so they sign in with their new credentials themselves.
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Account created! Please sign in.'),
        backgroundColor: const Color(0xFF00D4FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    Navigator.of(context).pop(); // back to LoginScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _bgAnim,
          builder: (_, child) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  navyDark,
                  Color.lerp(navy, navyMid, _bgAnim.value)!,
                  navyDark,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: child,
          ),
          child: Stack(
            children: [
              Positioned(
                  top: -60,
                  right: -60,
                  child: GlowCircle(color: cyan, size: 220)),
              Positioned(
                  bottom: 80,
                  left: -80,
                  child: GlowCircle(color: cyan.withOpacity(0.4), size: 200)),
              Positioned(
                  top: 200,
                  left: -40,
                  child: GlowCircle(
                      color: cyanLight.withOpacity(0.15), size: 120)),
              SafeArea(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          children: [
                            const SizedBox(height: 4),
                            AnimatedBuilder(
                              animation: _logoController,
                              builder: (_, child) => Opacity(
                                opacity: _logoOpacity.value,
                                child: Transform.scale(
                                    scale: _logoScale.value, child: child),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 88,
                                    height: 88,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [cyan, Color(0xFF0080FF)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(26),
                                      boxShadow: [
                                        BoxShadow(
                                          color: cyan.withOpacity(0.5),
                                          blurRadius: 30,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.person_add_rounded,
                                        color: Colors.white, size: 44),
                                  ),
                                  const SizedBox(height: 20),
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                      colors: [Colors.white, cyanLight],
                                    ).createShader(bounds),
                                    child: const Text(
                                      'Create Account',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Join us and start shopping',
                                    style: TextStyle(
                                      color: cyanLight.withOpacity(0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 36),
                            if (_showForm)
                              SlideTransition(
                                position: _formSlide,
                                child: FadeTransition(
                                  opacity: _formOpacity,
                                  child: Container(
                                    padding: const EdgeInsets.all(28),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.06),
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                          color: cyan.withOpacity(0.3),
                                          width: 1.5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: cyan.withOpacity(0.08),
                                            blurRadius: 40),
                                      ],
                                    ),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          PremiumField(
                                            controller: _nameController,
                                            hint: 'Full name',
                                            icon: Icons.person_outline_rounded,
                                            validator: (v) => v!.isEmpty
                                                ? 'Enter your name'
                                                : null,
                                          ),
                                          const SizedBox(height: 16),
                                          PremiumField(
                                            controller: _emailController,
                                            hint: 'Email address',
                                            icon: Icons.email_outlined,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: (v) => v!.isEmpty
                                                ? 'Enter your email'
                                                : null,
                                          ),
                                          const SizedBox(height: 16),
                                          PremiumField(
                                            controller: _passwordController,
                                            hint: 'Password',
                                            icon: Icons.lock_outline_rounded,
                                            obscureText: _obscurePassword,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscurePassword
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                color: cyanLight
                                                    .withOpacity(0.7),
                                                size: 20,
                                              ),
                                              onPressed: () => setState(() =>
                                                  _obscurePassword =
                                                      !_obscurePassword),
                                            ),
                                            validator: (v) => v!.length < 6
                                                ? 'Password must be 6+ characters'
                                                : null,
                                          ),
                                          const SizedBox(height: 16),
                                          PremiumField(
                                            controller: _confirmController,
                                            hint: 'Confirm password',
                                            icon: Icons.lock_outline_rounded,
                                            obscureText: _obscureConfirm,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscureConfirm
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                color: cyanLight
                                                    .withOpacity(0.7),
                                                size: 20,
                                              ),
                                              onPressed: () => setState(() =>
                                                  _obscureConfirm =
                                                      !_obscureConfirm),
                                            ),
                                            validator: (v) =>
                                                v != _passwordController.text
                                                    ? 'Passwords do not match'
                                                    : null,
                                          ),
                                          const SizedBox(height: 32),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 54,
                                            child: ElevatedButton(
                                              onPressed: _isLoading
                                                  ? null
                                                  : _handleRegister,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                shadowColor:
                                                    Colors.transparent,
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14),
                                                ),
                                              ),
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      cyan,
                                                      Color(0xFF0080FF)
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: cyan
                                                          .withOpacity(0.4),
                                                      blurRadius: 20,
                                                      offset:
                                                          const Offset(0, 6),
                                                    ),
                                                  ],
                                                ),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: _isLoading
                                                      ? const SizedBox(
                                                          width: 22,
                                                          height: 22,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color:
                                                                Colors.white,
                                                            strokeWidth: 2,
                                                          ),
                                                        )
                                                      : const Text(
                                                          'Create Account',
                                                          style: TextStyle(
                                                            color:
                                                                Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700,
                                                            letterSpacing: 0.5,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Already have an account? ',
                                                style: TextStyle(
                                                  color: cyanLight
                                                      .withOpacity(0.6),
                                                  fontSize: 13,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () =>
                                                    Navigator.of(context)
                                                        .pop(),
                                                child: const Text(
                                                  'Sign In',
                                                  style: TextStyle(
                                                    color: cyan,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    fontSize: 13,
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
                              ),
                            const SizedBox(height: 40),
                          ],
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
    );
  }
}