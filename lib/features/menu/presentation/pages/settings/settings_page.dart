import 'package:flutter/material.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/custom_back_header.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/custom_switch.dart';
import 'package:reserv_plus/features/shared/services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _biometricEnabled = true;
  bool _offlineQrEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final biometric = await SettingsService.getBiometricEnabled();
    final offlineQr = await SettingsService.getOfflineQrEnabled();

    if (mounted) {
      setState(() {
        _biometricEnabled = biometric;
        _offlineQrEnabled = offlineQr;
      });
    }
  }

  Future<void> _setBiometricEnabled(bool value) async {
    setState(() {
      _biometricEnabled = value;
    });
    await SettingsService.setBiometricEnabled(value);
  }

  Future<void> _setOfflineQrEnabled(bool value) async {
    setState(() {
      _offlineQrEnabled = value;
    });
    await SettingsService.setOfflineQrEnabled(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomBackHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildTitle(),
                  const SizedBox(height: 24),
                  _buildSettingsCard(),
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
      'Налаштування',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1,
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            title: 'Змінити код для входу',
            showSwitch: false,
            onTap: () {
              // TODO: Navigate to change PIN code
            },
          ),
          _buildDivider(),
          _buildSettingsItem(
            title: 'Дозволити біометрію',
            showSwitch: true,
            switchValue: _biometricEnabled,
            onSwitchChanged: _setBiometricEnabled,
          ),
          _buildDivider(),
          _buildSettingsItem(
            title: 'Перевіряти QR офлайн',
            showSwitch: true,
            switchValue: _offlineQrEnabled,
            onSwitchChanged: _setOfflineQrEnabled,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required bool showSwitch,
    bool? switchValue,
    ValueChanged<bool>? onSwitchChanged,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: showSwitch ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            if (showSwitch && switchValue != null && onSwitchChanged != null)
              CustomSwitch(
                value: switchValue,
                onChanged: onSwitchChanged,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey[300],
      ),
    );
  }
}
