import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  // Checkbox states for 3x and 4x (exclusive selection)
  bool isChecked1 = false;
  bool isChecked2 = false;

  // Checkbox states for iOS and Android (independent selection)
  bool isIosChecked = false;
  bool isAndroidChecked = false;

  // Selected image file
  File? _selectedImage;

  // Function to pick an image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _updateSelection(bool isFirst) {
    setState(() {
      isChecked1 = isFirst;
      isChecked2 = !isFirst;
    });
  }

  @override
  Widget build(BuildContext context) {

    //  double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CustomPaint(
                    painter: DottedBorderPainter(),
                    child: Container(
                      height: 400,
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: _selectedImage == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.photo_outlined, size: 70),
                                SizedBox(height: 18),
                                Text(
                                  "Click or drag the largest image(s) to this area",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : Image.file(_selectedImage!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Image Sets Generator",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              /// **3x or 4x selection (Exclusive)**
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 0.8,
                    child: Checkbox(
                      value: isChecked1,
                      onChanged: (bool? value) {
                        _updateSelection(true);
                      },
                    ),
                  ),
                  Text(
                    "3x",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "OR",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Transform.scale(
                    scale: 0.8,
                    child: Checkbox(
                      value: isChecked2,
                      onChanged: (bool? value) {
                        _updateSelection(false);
                      },
                    ),
                  ),
                  const Text(
                    "4x",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Drag or Select the largest image(s) to generate\ndifferent sizes for all platforms",
                textAlign: TextAlign.center,
              ),

              /// **iOS and Android selection (Independent)**
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isIosChecked,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isIosChecked = newValue!;
                            });
                          },
                        ),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "IOS ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "(Recommended for high quality)",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isAndroidChecked,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isAndroidChecked = newValue!;
                            });
                          },
                        ),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Android ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "(Faster processing but lower quality)",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                  ],
                ),
              ),

              /// **Generate Button**
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(270, 36), // Decreased size
                    side: BorderSide(color: Colors.black), // Adds border
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5), // Optional rounded corners
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4), // Adjusts padding
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize
                        .min, // Ensures the button takes minimal space
                    children: [
                      Icon(Icons.download_outlined,
                          size: 18), // Reduced icon size
                      SizedBox(width: 5), // Space between icon and text
                      Text(
                        "Generate",
                        style: TextStyle(fontSize: 14), // Smaller text
                      ),
                    ],
                  ),
                ),
              ), SizedBox(
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
            ),),
           
          );
       
  }
}

/// Custom Painter for Dotted Border
class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double dashWidth = 8, dashSpace = 4;

    // Top Border
    for (double x = 0; x < size.width; x += dashWidth + dashSpace) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
    }

    // Right Border
    for (double y = 0; y < size.height; y += dashWidth + dashSpace) {
      canvas.drawLine(
          Offset(size.width, y), Offset(size.width, y + dashWidth), paint);
    }

    // Bottom Border
    for (double x = size.width; x > 0; x -= dashWidth + dashSpace) {
      canvas.drawLine(
          Offset(x, size.height), Offset(x - dashWidth, size.height), paint);
    }

    // Left Border
    for (double y = size.height; y > 0; y -= dashWidth + dashSpace) {
      canvas.drawLine(Offset(0, y), Offset(0, y - dashWidth), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
