import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  // Инициализация камеры с проверкой разрешений
  Future<void> initializeCamera() async {
    try {
      // Проверяем разрешение на камеру
      final permission = await Permission.camera.request();
      if (!permission.isGranted) {
        throw Exception('Разрешение на камеру не предоставлено');
      }

      // Получаем доступные камеры
      _cameras = await availableCameras();
      if (_cameras!.isEmpty) {
        throw Exception('Камера не найдена');
      }

      // Создаем контроллер камеры
      _controller = CameraController(
        _cameras![0], // Используем заднюю камеру
        ResolutionPreset.high, // Высокое разрешение для лучшего сканирования
        enableAudio: false, // Отключаем аудио
      );

      // Инициализируем камеру
      await _controller!.initialize();
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      rethrow;
    }
  }

  // Получить контроллер камеры
  CameraController? get controller => _controller;

  // Проверить инициализирована ли камера
  bool get isInitialized => _isInitialized;

  // Получить превью камеры
  Widget get cameraPreview {
    if (!_isInitialized || _controller == null) {
      return const Center(
        child: Text('Камера не инициализирована'),
      );
    }
    return CameraPreview(_controller!);
  }

  // Освобождение ресурсов камеры
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }
}
