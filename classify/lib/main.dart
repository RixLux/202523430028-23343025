import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(const ClassifyApp());
}

class ClassifyApp extends StatelessWidget {
  const ClassifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TFLite Flutter x86_64',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAE1FA),
        useMaterial3: true,
      ),
      home: const ClassificationScreen(),
    );
  }
}

class ClassificationScreen extends StatefulWidget {
  const ClassificationScreen({super.key});

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  bool _loading = true;
  File? _image;
  String? _label;
  double? _confidence;
  final _picker = ImagePicker();

  Interpreter? _interpreter;
  List<String>? _labels;

  @override
  void initState() {
    super.initState();
    _initTflite();
  }

  Future<void> _initTflite() async {
    try {
      await _loadModel();
      await _loadLabels();
      setState(() {
        _loading = false;
      });
    } catch (e) {
      debugPrint("Error initializing TFLite: $e");
    }
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/model_unquant.tflite');
    debugPrint("Model loaded successfully");
  }

  Future<void> _loadLabels() async {
    final labelsData = await rootBundle.loadString('assets/labels.txt');
    _labels = labelsData.split('\n').where((s) => s.isNotEmpty).toList();
    debugPrint("Labels loaded: ${_labels?.length}");
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  Future<void> _classifyImage(File imageFile) async {
    setState(() {
      _loading = true;
    });

    try {
      // 1. Preprocess image
      final imageData = imageFile.readAsBytesSync();
      img.Image? originalImage = img.decodeImage(imageData);
      if (originalImage == null) return;

      // MobileNetV2 usually takes 224x224
      img.Image resizedImage = img.copyResize(originalImage, width: 224, height: 224);

      // 2. Prepare input tensor
      // Shape: [1, 224, 224, 3]
      var input = Float32List(1 * 224 * 224 * 3).reshape([1, 224, 224, 3]);
      for (var y = 0; y < 224; y++) {
        for (var x = 0; x < 224; x++) {
          var pixel = resizedImage.getPixel(x, y);
          // Normalization: (x - 127.5) / 127.5 -> Range [-1, 1]
          input[0][y][x][0] = (pixel.r - 127.5) / 127.5;
          input[0][y][x][1] = (pixel.g - 127.5) / 127.5;
          input[0][y][x][2] = (pixel.b - 127.5) / 127.5;
        }
      }

      // 3. Prepare output tensor
      // Assuming model outputs a list of probabilities [1, num_classes]
      var output = Float32List(1 * _labels!.length).reshape([1, _labels!.length]);

      // 4. Run inference
      _interpreter?.run(input, output);

      // 5. Postprocess results
      List<double> results = List<double>.from(output[0]);
      double maxProb = -1.0;
      int maxIndex = -1;
      for (int i = 0; i < results.length; i++) {
        if (results[i] > maxProb) {
          maxProb = results[i];
          maxIndex = i;
        }
      }

      setState(() {
        _label = _labels![maxIndex];
        _confidence = maxProb;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Classification error: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _classifyImage(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            const Text(
              "Recognize Fruit Easily",
              style: TextStyle(
                color: Color(0xFF5A4B5A),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Classify",
              style: TextStyle(
                color: Color(0xFF322A32),
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: _loading
                  ? _buildLoader()
                  : _buildPreview(),
            ),
            const Spacer(),
            _buildBottomButtons(),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return Container(
      width: 280,
      height: 280,
      decoration: _softBoxDecoration(),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF5A4B5A)),
          SizedBox(height: 20),
          Text("Processing...", style: TextStyle(color: Color(0xFF5A4B5A))),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Column(
      children: [
        Container(
          height: 280,
          width: 280,
          decoration: _softBoxDecoration(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: _image == null
                ? const Icon(Icons.image_outlined, size: 80, color: Color(0xFF5A4B5A))
                : Image.file(_image!, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 40),
        if (_label != null)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Text(
                  _label!.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF322A32),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Confidence: ${(_confidence! * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(color: Color(0xFF5A4B5A), fontSize: 16),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          icon: Icons.camera_alt_rounded,
          label: "Camera",
          onTap: () => _pickImage(ImageSource.camera),
        ),
        const SizedBox(width: 24),
        _buildActionButton(
          icon: Icons.photo_library_rounded,
          label: "Gallery",
          onTap: () => _pickImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _softBoxDecoration(),
            child: Icon(icon, color: const Color(0xFF5A4B5A), size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Color(0xFF5A4B5A), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  BoxDecoration _softBoxDecoration() {
    return BoxDecoration(
      color: const Color(0xFFFAE1FA),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(8, 8)),
        BoxShadow(color: Colors.white.withOpacity(0.8), blurRadius: 15, offset: const Offset(-8, -8)),
      ],
    );
  }
}
