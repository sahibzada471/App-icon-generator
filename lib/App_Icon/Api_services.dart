import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class IconGeneratorService {
  static const String _baseUrl = 'http://192.168.0.139:3000';
  String? _lastGeneratedUrl;
  String? _lastOutputName;
  final ValueNotifier<String> _downloadProgress = ValueNotifier('0%');
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // Reset all internal state (call this after generation/download)
  void _resetState() {
    _lastGeneratedUrl = null;
    _lastOutputName = null;
    _downloadProgress.value = '0%';
  }

  Future<Map<String, dynamic>> generateIcons({
    required File imageFile,
    required List<String> platforms,
    required String outputName, Uint8List? imageBytes,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/generate-icons'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'png'),
        ),
      );

      request.fields['platform'] = platforms.join(',');
      request.fields['outputName'] = outputName;

      var response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        _lastGeneratedUrl = '$_baseUrl${data['downloadUrl']}';
        _lastOutputName = outputName;
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'error': jsonDecode(responseData)['error'] ?? 'Unknown error',
        };
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<void> downloadAndSaveZip(BuildContext context, result, String s) async {
    if (_lastGeneratedUrl == null || _lastOutputName == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file to download')),
        );
      }
      return;
    }

    try {
      // 1. Check storage permissions
      PermissionStatus status;
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        status = androidInfo.version.sdkInt >= 33
            ? await Permission.photos.request()
            : await Permission.storage.request();
      } else {
        status = await Permission.storage.request();
      }

      if (!status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Permission required to save files'),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: openAppSettings,
              ),
            ),
          );
        }
        return;
      }

      // 2. Show progress dialog
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Downloading'),
            content: ValueListenableBuilder(
              valueListenable: _downloadProgress,
              builder: (_, value, __) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('Progress: $value'),
                ],
              ),
            ),
          ),
        );
      }

      // 3. Save to Downloads folder
      final directory = await getDownloadsDirectory();
      if (directory == null) throw Exception('No downloads directory');
      
      final savePath = '${directory.path}/${_lastOutputName!.trim()}.zip';
      final dio = Dio();

      await dio.download(
        _lastGeneratedUrl!,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            _downloadProgress.value = '${(received / total * 100).toStringAsFixed(0)}%';
          }
        },
      );

      // 4. Post-download cleanup
      _resetState();
      if (context.mounted) { 
        print('File saved to $savePath');
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          
          SnackBar(
            content: const Text('Download complete!'),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () => OpenFile.open(savePath),
            ),
          ),
        );
       
      }
    } catch (e) {
      _resetState();
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}