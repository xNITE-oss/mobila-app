import 'package:material_ui/material_ui.dart';

/// Ilova logotipi: burchaklari yumaloq to'q sariq kvadrat ichida «÷» belgisi.
///
/// Logotip rasm faylidan olinmaydi, balki [CustomPaint] yordamida
/// chiziladi. Shu sababli u har qanday o'lchamda tiniq chiqadi.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 88, this.onColor = false});

  /// Logotipning eni va bo'yi.
  final double size;

  /// Logotip rangli fon ustida turadimi. `true` bo'lsa, kvadrat oq,
  /// belgi esa rangli chiziladi.
  final bool onColor;

  /// Logotip ranglari (ilovaning asosiy rangi bilan uyg'un).
  static const Color lightColor = Color(0xFFFF7043);
  static const Color darkColor = Color(0xFFD84315);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Kalkulyator logotipi',
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.28),
          color: onColor ? Colors.white : null,
          gradient: onColor
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [lightColor, darkColor],
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: CustomPaint(
          painter: _DividePainter(color: onColor ? darkColor : Colors.white),
        ),
      ),
    );
  }
}

/// «÷» belgisini chizadi: o'rtada chiziq, tepasida va pastida nuqta.
class _DividePainter extends CustomPainter {
  const _DividePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final line = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round;
    final dot = Paint()..color = color;

    final half = size.width * 0.20; // chiziq uzunligining yarmi
    final gap = size.height * 0.19; // nuqtadan chiziqqacha masofa
    final radius = size.width * 0.055;

    canvas.drawLine(center - Offset(half, 0), center + Offset(half, 0), line);
    canvas.drawCircle(center - Offset(0, gap), radius, dot);
    canvas.drawCircle(center + Offset(0, gap), radius, dot);
  }

  @override
  bool shouldRepaint(_DividePainter oldDelegate) => oldDelegate.color != color;
}
