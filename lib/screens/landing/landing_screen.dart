import 'dart:async';
import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late AnimationController _bgController;
  late Animation<double> _bgAnim;

  int _currentPage = 0;
  Timer? _autoTimer;

  static const Color navyDark = Color(0xFF0A0E27);
  static const Color navy = Color(0xFF0D1B4B);
  static const Color cyan = Color(0xFF00D4FF);
  static const Color cyanLight = Color(0xFF7EEEFF);

  final List<_SlideData> _slides = [
    _SlideData(
      icon: Icons.smartphone_rounded,
      tag: 'ELECTRONICS',
      title: 'Latest Tech\nAt Your Fingertips',
      subtitle:
          'iPhone 15 Pro, MacBooks, Samsung TVs\nand more premium gadgets',
      color1: const Color(0xFF00D4FF),
      color2: const Color(0xFF0080FF),
      imageUrl:
          'https://images.unsplash.com/photo-1737947640001-54765a2b0287?w=800&q=80&auto=format&fit=crop',
    ),
    _SlideData(
      icon: Icons.headphones_rounded,
      tag: 'AUDIO',
      title: 'Premium Sound\nExperience',
      subtitle:
          'Sony, JBL, and top audio brands\ndelivering crystal clear sound',
      color1: const Color(0xFF9B59FF),
      color2: const Color(0xFFFF6584),
      imageUrl:
          'https://images.unsplash.com/photo-1599669454699-248893623440?w=800&q=80&auto=format&fit=crop',
    ),
    _SlideData(
      icon: Icons.directions_run_rounded,
      tag: 'FOOTWEAR',
      title: 'Step Into\nStyle & Comfort',
      subtitle:
          'Nike, Adidas Ultraboost and more\npremium footwear collections',
      color1: const Color(0xFF00E5A0),
      color2: const Color(0xFF00B4D8),
      imageUrl:
          'https://images.unsplash.com/photo-1562613521-6b5293e5b0ea?w=800&q=80&auto=format&fit=crop',
    ),
    _SlideData(
      icon: Icons.checkroom_rounded,
      tag: 'FASHION',
      title: 'Dress to\nImpress Always',
      subtitle: "Levi's, North Face and top brands\nfor every occasion",
      color1: const Color(0xFFFFBE00),
      color2: const Color(0xFFFF6584),
      imageUrl:
          'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&q=80&auto=format&fit=crop',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _bgAnim = Tween<double>(begin: 0, end: 1).animate(_bgController);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_currentPage < _slides.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _goToRegister() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const RegisterScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgAnim,
        builder: (_, child) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                navyDark,
                Color.lerp(navy, const Color(0xFF112466), _bgAnim.value)!,
                navyDark,
              ],
            ),
          ),
          child: child,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -80,
              child: _GlowOrb(color: cyan.withOpacity(0.3), size: 260),
            ),
            Positioned(
              bottom: 100,
              left: -60,
              child: _GlowOrb(color: cyan.withOpacity(0.15), size: 180),
            ),
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [cyan, Color(0xFF0080FF)],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: cyan.withOpacity(0.4),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.shopping_bag_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              ShaderMask(
                                shaderCallback: (b) => const LinearGradient(
                                  colors: [Colors.white, cyanLight],
                                ).createShader(b),
                                child: const Text(
                                  'ShopNest',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: _goToLogin,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: cyanLight.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (i) => setState(() => _currentPage = i),
                        itemCount: _slides.length,
                        itemBuilder: (_, i) => _SlideItem(
                          data: _slides[i],
                          isActive: i == _currentPage,
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: _slideAnim,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _slides.length,
                                (i) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  width: i == _currentPage ? 28 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: i == _currentPage
                                        ? cyan
                                        : cyan.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: i == _currentPage
                                        ? [
                                            BoxShadow(
                                              color: cyan.withOpacity(0.5),
                                              blurRadius: 8,
                                            )
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: ElevatedButton(
                                onPressed: _goToRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [cyan, Color(0xFF0080FF)],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: cyan.withOpacity(0.4),
                                        blurRadius: 24,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Get Started',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward_rounded,
                                            color: Colors.white, size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    color: cyanLight.withOpacity(0.6),
                                    fontSize: 13,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _goToLogin,
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: cyan,
                                      fontWeight: FontWeight.w700,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideData {
  final IconData icon;
  final String tag;
  final String title;
  final String subtitle;
  final Color color1;
  final Color color2;
  final String imageUrl;

  const _SlideData({
    required this.icon,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.color1,
    required this.color2,
    required this.imageUrl,
  });
}

class _SlideItem extends StatelessWidget {
  final _SlideData data;
  final bool isActive;

  static const Color cyanLight = Color(0xFF7EEEFF);

  const _SlideItem({required this.data, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: isActive ? 1.0 : 0.92,
            duration: const Duration(milliseconds: 400),
            child: Container(
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: data.color1.withOpacity(0.25),
                    blurRadius: 30,
                    spreadRadius: 2,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.network(
                      data.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: data.color1.withOpacity(0.1),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: data.color1,
                              strokeWidth: 2,
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                      progress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stack) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              data.color1.withOpacity(0.2),
                              data.color2.withOpacity(0.08),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(data.icon, size: 64, color: data.color1),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(32)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.45),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 14,
                    bottom: 14,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient:
                            LinearGradient(colors: [data.color1, data.color2]),
                        boxShadow: [
                          BoxShadow(
                            color: data.color1.withOpacity(0.5),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Icon(data.icon, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          AnimatedOpacity(
            opacity: isActive ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 400),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    data.color1.withOpacity(0.2),
                    data.color2.withOpacity(0.1)
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: data.color1.withOpacity(0.4)),
              ),
              child: Text(
                data.tag,
                style: TextStyle(
                  color: data.color1,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSlide(
            offset: isActive ? Offset.zero : const Offset(0, 0.2),
            duration: const Duration(milliseconds: 400),
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cyanLight.withOpacity(0.6),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 80,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}