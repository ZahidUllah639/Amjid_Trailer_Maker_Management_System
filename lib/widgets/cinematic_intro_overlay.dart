import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

/// A world-class, cinematic startup intro animation overlay for Amjid Trailer Makers ERP.
/// Features animated obsidian cosmic mesh, glowing ripple shockwaves, high-tech telemetry
/// boot sequence, neon progress bar, and seamless fluid reveal into the workspace.
class CinematicIntroOverlay extends StatefulWidget {
  final VoidCallback onFinished;

  const CinematicIntroOverlay({super.key, required this.onFinished});

  @override
  State<CinematicIntroOverlay> createState() => _CinematicIntroOverlayState();
}

class _CinematicIntroOverlayState extends State<CinematicIntroOverlay> with TickerProviderStateMixin {
  late AnimationController _masterController;
  late AnimationController _pulseController;
  late AnimationController _progressController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _telemetryOpacity;
  late Animation<double> _fadeAllOut;

  int _telemetryStep = 0;
  final List<String> _telemetryLogs = [
    'Initializing Drifting SQLite Industrial Core...',
    'Calibrating 58mm & 80mm High-Speed POS Thermal Engine...',
    'Synchronizing Treasury Digital Vault & Ledger Accounts...',
    'System Primed • Entering Executive Command Center...',
  ];

  Timer? _telemetryTimer;

  @override
  void initState() {
    super.initState();

    // 1. Fast, Snappy Master Sequence Controller (1.1 seconds total)
    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1150),
    );

    // 2. Pulse Controller for glowing shockwaves
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    // 3. Progress bar 0% -> 100%
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 920),
    );

    // Logo pop-in with bounce
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.40, curve: Curves.easeOutBack),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.28, curve: Curves.easeOut),
      ),
    );

    // Title reveal
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.18, 0.48, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.18, 0.48, curve: Curves.easeOutCubic),
      ),
    );

    // Telemetry logs
    _telemetryOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.30, 0.60, curve: Curves.easeIn),
      ),
    );

    // Final Fade-out reveal
    _fadeAllOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.78, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    // Fast cycle through boot telemetry logs
    _telemetryTimer = Timer.periodic(const Duration(milliseconds: 180), (timer) {
      if (mounted && _telemetryStep < _telemetryLogs.length - 1) {
        setState(() => _telemetryStep++);
      } else {
        timer.cancel();
      }
    });

    // Start animations
    _masterController.forward();
    _progressController.forward();

    _masterController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinished();
      }
    });
  }

  @override
  void dispose() {
    _telemetryTimer?.cancel();
    _masterController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _skip() {
    _telemetryTimer?.cancel();
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_masterController, _pulseController, _progressController]),
      builder: (context, child) {
        final double pulse = _pulseController.value;
        final double progress = _progressController.value;

        return FadeTransition(
          opacity: _fadeAllOut,
          child: GestureDetector(
            onTap: _skip,
            behavior: HitTestBehavior.opaque,
            child: Material(
              color: Colors.transparent,
              child: Stack(
              children: [
                // 1. Deep Obsidian Cosmic Background
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.2,
                      colors: [
                        Color(0xFF0F172A), // Slate 900
                        Color(0xFF090D16), // Darker Obsidian
                        Color(0xFF020408), // Pitch Black
                      ],
                    ),
                  ),
                ),

                // 2. Animated Floating Ambient Mesh Blobs
                Positioned(
                  top: -100 + (pulse * 40),
                  left: -50 + (pulse * 30),
                  child: Container(
                    width: 450,
                    height: 450,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF4F46E5).withValues(alpha: 0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -80 - (pulse * 30),
                  right: -60 - (pulse * 40),
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF06B6D4).withValues(alpha: 0.20),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Frosted Glass Backdrop
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(color: Colors.transparent),
                ),

                // 4. Central Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo with expanding concentric ripples
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Concentric glowing rings
                          Container(
                            width: 150 + (pulse * 50),
                            height: 150 + (pulse * 50),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF6366F1).withValues(alpha: (1 - pulse) * 0.4),
                                width: 2,
                              ),
                            ),
                          ),
                          Container(
                            width: 120 + (pulse * 30),
                            height: 120 + (pulse * 30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF38BDF8).withValues(alpha: (1 - pulse) * 0.6),
                                width: 1.5,
                              ),
                            ),
                          ),

                          // Main Metallic Emblem Container
                          ScaleTransition(
                            scale: _logoScale,
                            child: FadeTransition(
                              opacity: _logoOpacity,
                              child: Container(
                                width: 104,
                                height: 104,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF312E81),
                                      Color(0xFF1E1B4B),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFF818CF8).withValues(alpha: 0.6),
                                    width: 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6366F1).withValues(alpha: 0.5),
                                      blurRadius: 30,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/Logo.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(
                                      Icons.precision_manufacturing_rounded,
                                      color: Color(0xFF818CF8),
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Animated Brand Typography
                      SlideTransition(
                        position: _titleSlide,
                        child: FadeTransition(
                          opacity: _titleOpacity,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Color(0xFFE0E7FF),
                                    Color(0xFFA5B4FC),
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  'AMJID TRAILER MAKERS',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 4.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 1.5,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.transparent, const Color(0xFF38BDF8).withValues(alpha: 0.8)],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'NEXT-GEN INDUSTRIAL ERP • DIGITAL LEDGERS & POS',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2.2,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 24,
                                    height: 1.5,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [const Color(0xFF38BDF8).withValues(alpha: 0.8), Colors.transparent],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Telemetry Boot Sequence Box
                      FadeTransition(
                        opacity: _telemetryOpacity,
                        child: Container(
                          width: 440,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF334155).withValues(alpha: 0.6),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF10B981).withValues(alpha: 0.8),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'SYSTEM BOOTLOADER',
                                        style: TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${(progress * 100).toInt()}%',
                                    style: const TextStyle(
                                      color: Color(0xFF818CF8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Active log message
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Text(
                                  '> ${_telemetryLogs[_telemetryStep]}',
                                  key: ValueKey(_telemetryStep),
                                  style: const TextStyle(
                                    color: Color(0xFFE2E8F0),
                                    fontSize: 12.5,
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // High-tech Glowing Progress Bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  height: 4,
                                  width: double.infinity,
                                  color: const Color(0xFF1E293B),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FractionallySizedBox(
                                      widthFactor: progress.clamp(0.0, 1.0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF4F46E5),
                                              Color(0xFF38BDF8),
                                              Color(0xFF10B981),
                                            ],
                                          ),
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
                    ],
                  ),
                ),

                // 5. Skip Button in Top Right
                Positioned(
                  top: 24,
                  right: 28,
                  child: FadeTransition(
                    opacity: _titleOpacity,
                    child: TextButton.icon(
                      onPressed: _skip,
                      icon: const Icon(Icons.fast_forward_rounded, size: 16, color: Color(0xFF94A3B8)),
                      label: const Text(
                        'Skip Intro (Esc)',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  }
}
