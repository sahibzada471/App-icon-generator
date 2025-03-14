import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AppIcons extends StatefulWidget {
  const AppIcons({super.key});

  @override
  State<AppIcons> createState() => _AppIconsState();
}

class _AppIconsState extends State<AppIcons> {
  // Variable to hold the selected image file
  File? _selectedImage;

  // State variables for checkboxes
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;

  // Method to pick an image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path); // Update the image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final h = MediaQuery.of(context).size.height;
    // final w = MediaQuery.of(context).size.width;

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
                  height: h * 0.5, // 50% of screen height
                  width: w * 0.7, // 60% of screen width
                  color: Colors.white,
                  child: Center(
                    child: _selectedImage == null
                        ? Column(
                            children: [
                              GestureDetector(
                                onTap:
                                    _pickImage, // Trigger image picker when tapped
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
                                    height: h * 0.3, // 30% of screen height
                                    width: w * 0.6, // 50% of screen width
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
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
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
                  SizedBox(height: 10),
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
                            // Optional spacing between text and divider
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(
                                    255, 240, 235, 235), // Color of the divider
                                thickness: 2, // Thickness of the divider
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  const TextSpan(
                                    text: "iPhone",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const TextSpan(
                                    text: "-11 different file and size",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  const TextSpan(
                                    text: "Android",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const TextSpan(
                                    text: "-04 different file and size",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  const TextSpan(
                                    text: "iPad",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const TextSpan(
                                    text: "-05 different file and size",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  const TextSpan(
                                    text: "Web",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const TextSpan(
                                    text: "-03 different file and size",
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
                                SizedBox(
                                  width: 9,
                                ),
                                // Optional spacing between text and divider
                                Expanded(
                                  child: Divider(
                                    color: Color.fromARGB(255, 240, 235,
                                        235), // Color of the divider
                                    thickness: 2, // Thickness of the divider
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                                height:
                                    10), // Add some spacing between the text and the checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value:
                                      isChecked2, // This is the boolean value controlling the checkbox state
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked2 =
                                          value!; // Update the checkbox state
                                    });
                                  },
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      const TextSpan(
                                        text: "Android",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const TextSpan(
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
                                    border: Border.all(
                                        color: Colors.black), // Black border
                                    borderRadius: BorderRadius.circular(
                                        5), // Optional rounded corners
                                  ),
                                  alignment: Alignment
                                      .center, // Centers the text inside
                                  child: Text(
                                    'File name',
                                    style: TextStyle(
                                        color: Colors
                                            .black), // Ensures text is visible
                                  ),
                                ),
                                // Spacing between elements
                                SizedBox(
                                  height: 30,
                                  width:
                                      130, // Set the desired width for the TextField
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border:
                                          OutlineInputBorder(), // Adds a border to the text field
                                      hintText: 'Enter file name',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal:
                                              10), // Adjust padding for smaller height
                                    ),
                                    style: TextStyle(
                                        fontSize:
                                            14), // Adjust text size if needed
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Change file name for all generated Android"),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Image"),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(270, 36), // Decreased size
                                  side: BorderSide(
                                      color: Colors.black), // Adds border
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5), // Optional rounded corners
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4), // Adjusts padding
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize
                                      .min, // Ensures the button takes minimal space
                                  children: [
                                    Icon(Icons.download_outlined,
                                        size: 18), // Reduced icon size
                                    SizedBox(
                                        width:
                                            5), // Space between icon and text
                                    Text(
                                      "Generate",
                                      style: TextStyle(
                                          fontSize: 14), // Smaller text
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

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashWidth = 5;
    double dashSpace = 5;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    startX = size.width;
    while (startX > 0) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX - dashWidth, size.height),
        paint,
      );
      startX -= dashWidth + dashSpace;
    }

    startY = size.height;
    while (startY > 0) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY - dashWidth),
        paint,
      );
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
