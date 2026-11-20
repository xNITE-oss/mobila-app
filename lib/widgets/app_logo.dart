import 'package:material_ui/material_ui.dart';

/// Ilova logotipi: yashil doira ichida oq «±» belgisi.
///
/// Logotip rasm faylidan olinmaydi, balki [CustomPaint] yordamida
/// chiziladi. Shu sababli u har qanday o'lchamda tiniq chiqadi.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 88});

  /// Logotipning eni va bo'yi.
  final double size;

  /// Logotip ranglari (ilovaning asosiy rangi bilan uyg'un).
  static const Color lightColor = Color(0xFF26A69A);
  static const Color darkColor = Color(0xFF00695C);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Kalkulyator logotipi',
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [lightColor, darkColor],
          ),
          boxShadow: [
            BoxShadow(
              color: darkColor.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: CustomPaint(painter: _PlusMinusPainter()),
      ),
    );
  }
}

/// «±» belgisini chizadi: tepada plyus, pastda minus.
class _PlusMinusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.085
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final arm = size.width * 0.17; // chiziq uzunligining yarmi
    final plusY = size.height * 0.40;
    final minusY = size.height * 0.69;

    // Plyus: gorizontal va vertikal chiziq.
    canvas.drawLine(
      Offset(centerX - arm, plusY),
      Offset(centerX + arm, plusY),
      paint,
    );
    canvas.drawLine(
      Offset(centerX, plusY - arm),
      Offset(centerX, plusY + arm),
      paint,
    );
    // Minus: bitta gorizontal chiziq.
    canvas.drawLine(
      Offset(centerX - arm, minusY),
      Offset(centerX + arm, minusY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
