import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Images_set.dart';
import 'Api_services.dart';

class AppIcons extends StatefulWidget {
  const AppIcons({super.key});

  @override
  State<AppIcons> createState() => _AppIconsState();
}

class _AppIconsState extends State<AppIcons> {
  File? _selectedImage;
  bool isChecked1 = false; // iPhone
  bool isChecked2 = false; // Android
  bool isChecked3 = false; // iPad
  bool isChecked4 = false; // macOS
  bool isChecked5 = false; // watchOS (new separate checkbox)
  final IconGeneratorService _iconService = IconGeneratorService();
  final TextEditingController _outputNameController = TextEditingController();
  bool _isGenerating = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _handleGenerateIcons() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    final platforms = [
      if (isChecked1) 'iphone',
      if (isChecked2) 'android',
      if (isChecked3) 'ipad',
      if (isChecked4) 'macos',
      if (isChecked5) 'watchos', // Added watchOS platform
    ];

    if (platforms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one platform')),
      );
      return;
    }

    if (_isGenerating) return;
    setState(() => _isGenerating = true);

    final currentContext = context;
    
    showDialog(
      context: currentContext,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await _iconService.generateIcons(
        imageFile: _selectedImage!,
        platforms: platforms,
        outputName: _outputNameController.text.isEmpty 
            ? 'app-icons' 
            : _outputNameController.text,
      );

      if (mounted) {
        Navigator.of(currentContext).pop();
      }

      if (result['success'] == true) {
        await _iconService.downloadAndSaveZip(
          context,
          'outputDirectory', // Replace with the actual directory path
          'fileName.zip',    // Replace with the desired file name
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(currentContext).showSnackBar(
            SnackBar(
              content: Text('Error: ${result['error']}'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(currentContext).pop();
        ScaffoldMessenger.of(currentContext).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: CustomPaint(
                painter: DottedBorderPainter(),
                child: Container(
                  height: h * 0.5,
                  width: w * 0.7,
                  color: Colors.white,
                  child: Center(
                    child: _selectedImage == null
                        ? Column(
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: const Icon(
                                  Icons.photo_outlined,
                                  size: 70.0,
                                  color: Colors.black,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Click or drag image file (1024 x 1024)",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.blueGrey,
                                    ),
                                    height: h * 0.3,
                                    width: w * 0.6,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 10),
                                    child: const Text(
                                      "Create stunning Icons\nwith Appicons.ai",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Positioned(
                                    top: 20,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 20.0),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: Image.asset(
                                              'assets/ai-generated.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "App icon generator",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Drag or select an app icon image\n(1024 x 1024) to generate different app icon\n sizes for all platforms",
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "IOS and Android",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 240, 235, 235),
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // iPhone Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked1,
                              onChanged: (value) {
                                setState(() {
                                  isChecked1 = value!;
                                });
                              },
                            ),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "iPhone",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: " - 11 different file and size",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // watchOS Checkbox (now separate)
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked5,
                              onChanged: (value) {
                                setState(() {
                                  isChecked5 = value!;
                                });
                              },
                            ),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "watchOS",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: " - 08 different file and size",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // iPad Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked3,
                              onChanged: (value) {
                                setState(() {
                                  isChecked3 = value!;
                                });
                              },
                            ),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "iPad",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: " - 05 different file and size",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // macOS Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked4,
                              onChanged: (value) {
                                setState(() {
                                  isChecked4 = value!;
                                });
                              },
                            ),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "macOS",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: " - 11 different file and size",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  "Android",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 9),
                                Expanded(
                                  child: Divider(
                                    color: Color.fromARGB(255, 240, 235, 235),
                                    thickness: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Android Checkbox (now separate)
                            Row(
                              children: [
                                Checkbox(
                                  value: isChecked2,
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked2 = value!;
                                    });
                                  },
                                ),
                                RichText(
                                  text: const TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Android",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: "-04 different file and size",
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'File name',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 130,
                                  child: TextField(
                                    controller: _outputNameController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter file name',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                    ),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text("Change file name for all generated Android"),
                            const SizedBox(height: 10),
                            const Text("Image"),
                            Center(
                              child: ElevatedButton(
                                onPressed: _isGenerating ? null : _handleGenerateIcons,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(270, 36),
                                  side: const BorderSide(color: Colors.black),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.download_outlined, size: 18),
                                    const SizedBox(width: 5),
                                    Text(
                                      _isGenerating ? "Generating..." : "Generate",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                   SizedBox(
                    height: 30,
                  ),
                  Divider(
                    color: Color.fromARGB(
                        255, 240, 235, 235), // Color of the divider
                    thickness: 3, // Thickness of the divider
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "You can now donwload",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.black, // Ensures text is visible
                            ),
                            children: [
                              TextSpan(
                                text: "Application for ",
                                style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold), // Normal weight
                              ),
                              TextSpan(
                                text: "Desktop",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue), // Bold text
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset("assets/Device.png"),
                        SizedBox(
                          height: 50, // Reduced height
                          width: 180, // Set width for better structure
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 68, 9, 207),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                                side: BorderSide(
                                    color: Colors.black), // Black border
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10), // Adjust padding
                            ),
                            child: Text(
                              "Download",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white), // Adjust font
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(
                    color: Color.fromARGB(
                        255, 240, 235, 235), // Color of the divider
                    thickness: 3, // Thickness of the divider
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Features",
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 230,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white, // Background color
                                border: Border.all(
                                    color: Colors.black,
                                    width: 1), // Solid border
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.home,
                                    size: 100,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    "Multi plstform",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Work on both\nwindow and\nmacOS",
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 230,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white, // Background color
                                border: Border.all(
                                    color: Colors.black,
                                    width: 1), // Solid border
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.work_off_rounded,
                                    size: 100,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    "Work Offline",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "No need for\ninterent\nconnection",
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 230,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white, // Background color
                                border: Border.all(
                                    color: Colors.black,
                                    width: 1), // Solid border
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.payment,
                                    size: 100,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    "Pay Once",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "One time\npayment,lifetime\nupdates",
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 230,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white, // Background color
                                border: Border.all(
                                    color: Colors.black,
                                    width: 1), // Solid border
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.monetization_on,
                                    size: 100,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    "Money Back",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Up to 30 days\nmoney back\nguarantee",
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Divider(
                          color: Color.fromARGB(
                              255, 240, 235, 235), // Color of the divider
                          thickness: 3, // Thickness of the divider
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "DON'T JUST TAKE OUR WORD FOR IT",
                          style: TextStyle(color: Colors.blue),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Column(
                          children: [
                            Text(
                              "See What Others Are\nSaying",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20), // Spacing
                            Container(
                              height: 130,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.message_rounded),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                        "What a grate app,Thanks for making\nthis available!"),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "@entropyfanatic",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            Container(
                              height: 130,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.message_rounded),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                        "Saved me a bunch of time and hassle.\nEnabled me to easilyExperiment with\ndifferent icons."),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Jeck bannett",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            Container(
                              height: 130,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.message_rounded),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                        "What a grate app,Thanks for making\nthis available!"),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "@entropyfanatic",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            Container(
                              height: 130,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.message_rounded),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text("Cool app - saved me heaps of time!"),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "@francois",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Divider(
                          color: Color.fromARGB(
                              255, 240, 235, 235), // Color of the divider
                          thickness: 3, // Thickness of the divider
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Boost Your productivity",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        Text(
                          "Your favorite appicon functionality bundled in a desktop\napp",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Stack(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 68, 9, 207),
                                minimumSize: Size(200, 36), // Decreased size
                                side: BorderSide(
                                    color: Colors.black), // Adds border
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Optional rounded corners
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4), // Adjusts padding
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Ensures the button takes minimal space
                                children: [
                                  // Space between icon and text
                                  Text(
                                    "Donwload",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white), // Smaller text
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: w * 0.40,
                              ),
                              child: Container(
                                // height: h * 0.03,
                                // width: w * 0.09,
                                height: 22,
                                width: 55,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Colors.black,
                                      width: 1), // Border added
                                ),
                                child: Center(
                                    child: Text(
                                  "30% off",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
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

