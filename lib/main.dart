// Make sure to add following packages to pubspec.yaml:
// * media_kit
// * media_kit_video
// * media_kit_libs_video
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Provides [VideoController] & [Video] etc.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  if (!sharedPreferences.containsKey('images')) {
    sharedPreferences.setString('images', json.encode([]));
  }
  MediaKit.ensureInitialized();
  runApp(
    MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyScreen(),
    ),
  );
}

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);
  @override
  State<MyScreen> createState() => MyScreenState();
}

class MyScreenState extends State<MyScreen> {
  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);
  Uint8List? imgz;
  @override
  void initState() {
    super.initState();
    // Play a [Media] or [Playlist].
    // connect();
  }

  void connect(String ip, String id, String pass, String streamOpt) {
    try {
      player.open(
        Media('rtsp://$id:$pass@$ip:554/$streamOpt'),
      );
    } catch (e) {
      debugPrint('connecttion error : ${e.toString()}');
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  List<Map<String, dynamic?>> imagesList = [];
  Future<List<Map<String, dynamic>>> getImages() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    imagesList = List<Map<String, dynamic>>.from(
        json.decode(sharedPreferences.getString('images') ?? ''));
    return imagesList;
  }

  TextEditingController ipController = TextEditingController()
    ..text = '192.168.1.100';
  TextEditingController idController = TextEditingController()..text = 'office';
  TextEditingController passwordController = TextEditingController()
    ..text = 'office';
  List<String> streamOptions = ['1920x1080', '640x360'];
  String selectedOption = '640x360';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Live CCTV Camera'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stream Stream Quality :',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                  child: DropdownButtonFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1 //this has no effect
                                ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1 //this has no effect
                                ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1 //this has no effect
                                ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1 //this has no effect
                                ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintStyle: const TextStyle(color: Colors.black)),
                      // validator: (value) =>
                      //     value == null ? "Select a country" : null,
                      dropdownColor: Colors.white,
                      value: selectedOption,
                      menuMaxHeight: MediaQuery.of(context).size.height / 1.5,
                      isExpanded: false,
                      onChanged: (value) {
                        selectedOption = value!;
                        FocusScope.of(context).unfocus();
                      },
                      hint: Text('Search Device'),
                      items: streamOptions
                          .map<DropdownMenuItem<String>>((dynamic value) {
                        return DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        );
                      }).toList())),
              const SizedBox(
                height: 10,
              ),
              TextField(
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                controller: ipController,
                // controller: _registerValueController,

                decoration: InputDecoration(
                    label: const Text('Camera ip'),
                    labelStyle: const TextStyle(color: Colors.black),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.black, width: 1 //this has no effect
                          ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.grey, width: 1 //this has no effect
                          ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.black, width: 1 //this has no effect
                          ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.black, width: 1 //this has no effect
                          ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter camera ip address",
                    hintStyle: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                controller: idController,
                // controller: _registerValueController,

                decoration: InputDecoration(
                    label: const Text('Camera name'),
                    labelStyle: const TextStyle(color: Colors.black),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.black, width: 1 //this has no effect
                          ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.grey, width: 1 //this has no effect
                          ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.black, width: 1 //this has no effect
                          ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.black, width: 1 //this has no effect
                          ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter camera name/ I'd",
                    hintStyle: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                controller: passwordController,
                // controller: _registerValueController,

                decoration: InputDecoration(
                    label: const Text('Camera Pasword'),
                    labelStyle: const TextStyle(color: Colors.black),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.black, width: 1 //this has no effect
                          ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.grey, width: 1 //this has no effect
                          ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.black, width: 1 //this has no effect
                          ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.black, width: 1 //this has no effect
                          ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter Time in seconds",
                    hintStyle: const TextStyle(color: Colors.white)),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 9.0 / 16.0,
                // Use [Video] widget to display video output.
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Video(controller: controller),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black)),
                      onPressed: () async {
                        Uint8List? img = await player.screenshot();
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        List<Map<String, dynamic>> myList =
                            List<Map<String, dynamic>>.from(json.decode(
                                sharedPreferences.getString('images') ?? ''));
                        String data = String.fromCharCodes(img!);
                        // log(data);
                        myList.add({'image': data});
                        sharedPreferences.setString(
                            'images', json.encode(myList));
                        setState(() {});
                      },
                      child: const Text('Capture')),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black)),
                      onPressed: () async {
                        setState(() {
                          String streamOpt = '';
                          if (selectedOption == streamOptions[0]) {
                            streamOpt = 'stream1';
                          } else {
                            streamOpt = 'stream2';
                          }
                          if (ipController.text.isEmpty ||
                              passwordController.text.isEmpty ||
                              idController.text.isEmpty) {
                            SnackBar(content: Text('Field cannot be empty'));
                          } else {
                            connect(ipController.text, idController.text,
                                passwordController.text, streamOpt);
                          }
                        });
                      },
                      child: Text('Stream')),
                ],
              ),
              FutureBuilder(
                future: getImages(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: imagesList.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 200,
                        width: 400,
                        child: Image.memory(Uint8List.fromList(
                            (imagesList[index]['image'].toString().codeUnits))),
                      );
                    },
                  );
                },
              ),

              // ElevatedButton(
              //     onPressed: () {
              //       log((utf8.encode(imagesList[0]['image']).toString().codeUnits)
              //           .toString());
              //     },
              //     child: Text('print'))
              // imgz != null
              //     ? SizedBox(
              //         height: 100,
              //         width: 100,
              //         child: Image.memory(imgz!),
              //       )
              //     : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
