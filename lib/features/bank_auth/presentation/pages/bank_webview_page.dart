import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/app_header.dart';
import 'package:reserv_plus/features/bank_auth/presentation/pages/create_pin_page.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';

/// Страница с WebView для авторизации через BankID
class BankWebViewPage extends StatefulWidget {
  final String bankName;
  final String logoPath;
  final String authUrl;
  final String supportPhone;
  final String supportPhoneHint;
  final Color brandColor;

  const BankWebViewPage({
    super.key,
    required this.bankName,
    required this.logoPath,
    required this.authUrl,
    required this.supportPhone,
    required this.supportPhoneHint,
    required this.brandColor,
  });

  @override
  State<BankWebViewPage> createState() => _BankWebViewPageState();
}

class _BankWebViewPageState extends State<BankWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
              // Проверяем успешную авторизацию по URL
              _checkAuthCallback(url);
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authUrl));
  }

  /// Проверка callback URL после успешной авторизации
  void _checkAuthCallback(String url) {
    // Если URL содержит callback с успешной авторизацией
    // перенаправляем на создание PIN-кода
    if (url.contains('callback') || url.contains('success')) {
      // TODO: Переход на CreatePinPage
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => const CreatePinPage()),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Column(
          children: [
            // Header с кнопкой назад и помощи
            const AppHeader(
              showHelpButton: true,
            ),

            // Логотип банка
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Image.asset(
                  widget.logoPath,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: const Color.fromRGBO(234, 235, 228, 1),
            ),

            // WebView
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  // Индикатор загрузки
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        color: widget.brandColor,
                      ),
                    ),
                ],
              ),
            ),

            // Нижняя часть с кнопкой продолжения и телефоном поддержки
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Кнопка "Продовжити" для перехода к созданию PIN
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        NavigationUtils.pushWithHorizontalAnimation(
                          context: context,
                          page: const CreatePinPage(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.brandColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Продовжити',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Телефон поддержки банка
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: widget.brandColor.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.phone,
                          color: widget.brandColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.supportPhone,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(158, 158, 158, 1),
                            ),
                          ),
                          Text(
                            widget.supportPhoneHint,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(158, 158, 158, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
