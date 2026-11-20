import 'package:material_ui/material_ui.dart';

import '../logic/auth_service.dart';
import '../widgets/app_logo.dart';
import 'calculator_screen.dart';

/// Login oynasi: login va parol so'raladi, to'g'ri bo'lsa kalkulyator
/// oynasi ochiladi.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.authService = const AuthService()});

  /// Login va parolni tekshiruvchi xizmat.
  final AuthService authService;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Parol yashirilganmi (nuqtalar bilan ko'rsatiladimi).
  bool _obscurePassword = true;

  /// Login yoki parol noto'g'ri bo'lganda ko'rsatiladigan xabar.
  String? _authError;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// "Kirish" tugmasi bosilganda ishlaydi.
  void _submit() {
    FocusScope.of(context).unfocus();
    setState(() => _authError = null);

    // 1. Maydonlar to'ldirilganini tekshirish.
    if (!_formKey.currentState!.validate()) return;

    // 2. Login va parolni tekshirish.
    final login = _loginController.text.trim();
    final signedIn = widget.authService.signIn(login, _passwordController.text);
    if (!signedIn) {
      setState(() => _authError = "Login yoki parol noto'g'ri");
      return;
    }

    // 3. Kalkulyator oynasiga o'tish. `pushReplacement` login oynasini
    //    yopadi, shuning uchun "orqaga" tugmasi bu yerga qaytarmaydi.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => CalculatorScreen(username: login),
      ),
    );
  }

  /// Foydalanuvchi maydonni tahrirlay boshlasa, eski xato xabari o'chadi.
  void _clearAuthError(String _) {
    if (_authError != null) setState(() => _authError = null);
  }

  /// Kiritish maydonlarining umumiy ko'rinishi: to'ldirilgan fon va
  /// yumaloq burchaklar.
  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            // Mazmun kam bo'lsa ham sahifa butun ekranni egallaydi.
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                const _Header(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Tizimga kirish',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              key: const Key('login_field'),
                              controller: _loginController,
                              decoration: _fieldDecoration(
                                label: 'Login',
                                icon: Icons.person_outline,
                              ),
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              enableSuggestions: false,
                              onChanged: _clearAuthError,
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty)
                                  ? 'Loginni kiriting'
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              key: const Key('password_field'),
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: _fieldDecoration(
                                label: 'Parol',
                                icon: Icons.lock_outline,
                                suffixIcon: IconButton(
                                  key: const Key('password_visibility_button'),
                                  tooltip: _obscurePassword
                                      ? "Parolni ko'rsatish"
                                      : 'Parolni yashirish',
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                              onChanged: _clearAuthError,
                              onFieldSubmitted: (_) => _submit(),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'Parolni kiriting'
                                  : null,
                            ),
                            if (_authError != null) ...[
                              const SizedBox(height: 16),
                              _ErrorBanner(message: _authError!),
                            ],
                            const SizedBox(height: 22),
                            FilledButton(
                              key: const Key('login_button'),
                              onPressed: _submit,
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                textStyle: theme.textTheme.titleMedium,
                              ),
                              child: const Text('Kirish'),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Sinov uchun: login — ${AuthService.demoLogin}, '
                              'parol — ${AuthService.demoPassword}',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Oynaning yuqori qismi: rangli fon ustida logotip va sarlavha.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF4511E), Color(0xFFBF360C)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
          child: Column(
            children: [
              const AppLogo(size: 76, onColor: true),
              const SizedBox(height: 18),
              Text(
                'Xush kelibsiz',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Kalkulyatordan foydalanish uchun tizimga kiring',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Qizil fonli xato xabari.
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      key: const Key('login_error'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: scheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: scheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}
