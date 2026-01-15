import 'package:flutter/material.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/app_header.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/draggable_bottom_sheet.dart';
import 'package:reserv_plus/features/shared/services/session_service.dart';

class ActiveSessionsPage extends StatefulWidget {
  const ActiveSessionsPage({super.key});

  @override
  State<ActiveSessionsPage> createState() => _ActiveSessionsPageState();
}

class _ActiveSessionsPageState extends State<ActiveSessionsPage> {
  String _deviceName = 'Android';
  String _connectionDate = '';
  String _lastActivity = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    // Обновляем последнюю активность при открытии страницы
    await SessionService.updateLastActivity();

    final deviceName = await SessionService.getDeviceName();
    final firstLaunch = await SessionService.getFirstLaunchDate();
    final lastActivity = await SessionService.getLastActivity();

    if (mounted) {
      setState(() {
        _deviceName = deviceName;
        _connectionDate = SessionService.formatConnectionDate(firstLaunch);
        _lastActivity = SessionService.formatLastActivity(lastActivity);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildTitle(),
                  const SizedBox(height: 24),
                  _buildSessionCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Активні сесії',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1,
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSessionDetailSheet(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCurrentSessionLabel(),
                  const SizedBox(height: 20),
                  _buildDeviceName(),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(child: _buildConnectionDate()),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _buildLastActivity(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSessionDetailSheet(BuildContext context) {
    DraggableBottomSheet.show(
      context: context,
      title: 'Підключений\nпристрій',
      child: _buildSessionDetailCard(),
    );
  }

  Widget _buildSessionDetailCard() {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section with padding
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Device name
                Text(
                  _deviceName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                // Current session label
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(56, 142, 60, 1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Поточна сесія',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Full width divider
          const Divider(
            color: Color.fromRGBO(200, 200, 200, 1),
            thickness: 1,
            height: 1,
          ),
          // Bottom section with padding
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Connection date row
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Дата\nпідключення:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1,
                      ),
                    ),
                    Text(
                      _connectionDate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Last activity row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Остання\nактивність:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1,
                      ),
                    ),
                    Text(
                      _lastActivity,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSessionLabel() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(56, 142, 60, 1),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Поточна сесія',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceName() {
    return Text(
      _isLoading ? 'Завантаження...' : _deviceName,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1,
      ),
    );
  }

  Widget _buildConnectionDate() {
    return Text(
      _isLoading ? '' : 'Дата підключення: $_connectionDate',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color.fromRGBO(106, 103, 88, 0.8),
        height: 1,
      ),
    );
  }

  Widget _buildLastActivity() {
    return Text(
      _isLoading ? '' : 'Остання активність: $_lastActivity',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color.fromRGBO(106, 103, 88, 0.8),
        height: 1,
      ),
    );
  }
}
