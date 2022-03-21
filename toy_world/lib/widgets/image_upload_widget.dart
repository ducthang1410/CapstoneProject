// import 'dart:io';
// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:path/path.dart';
//
// class ImageUpload extends StatefulWidget {
//   const ImageUpload({Key? key}) : super(key: key);
//
//   @override
//   State<ImageUpload> createState() => _ImageUploadState();
// }
//
// class _ImageUploadState extends State<ImageUpload> {
//   firebase_storage.FirebaseStorage storage =
//       firebase_storage.FirebaseStorage.instance;
//
//   File? _photo;
//   final ImagePicker _picker = ImagePicker();
//   List<XFile>? imageFileList = [];
//
//   List<Asset> images = <Asset>[];
//   String _error = 'No Error Dectected';
//
//   Widget buildGridView() {
//     return GridView.count(
//       crossAxisCount: 6,
//       children: List.generate(images.length, (index) {
//         Asset asset = images[index];
//         // return AssetThumb(
//         //   asset: asset,
//         //   width: 300,
//         //   height: 300,
//         // );
//         return Padding(
//           padding: const EdgeInsets.all(2.0),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               AssetThumb(
//                 asset: asset,
//                 width: 300,
//                 height: 300,
//               ),
//               Positioned(
//                 top: -4,
//                 right: -4,
//                 child: Container(
//                   color: const Color.fromRGBO(255, 255, 244, 0.2),
//                   child: IconButton(
//                     onPressed: () {
//                       images!.removeAt(index);
//                       setState(() {});
//                     },
//                     icon: const Icon(Icons.delete),
//                     color: Colors.black87,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Future<void> loadAssets() async {
//     List<Asset> resultList = <Asset>[];
//     String error = 'No Error Detected';
//
//     try {
//       resultList = await MultiImagePicker.pickImages(
//         maxImages: 100,
//         enableCamera: true,
//         selectedAssets: images,
//         cupertinoOptions: const CupertinoOptions(
//           takePhotoIcon: "chat",
//           doneButtonTitle: "Fatto",
//         ),
//         materialOptions: const MaterialOptions(
//           actionBarColor: "#abcdef",
//           actionBarTitle: "Select Photo",
//           allViewTitle: "All Photos",
//           useDetailsView: false,
//           selectCircleStrokeColor: "#000000",
//         ),
//       );
//     } on Exception catch (e) {
//       error = e.toString();
//     }
//     if (!mounted) return;
//
//     setState(() {
//       images = resultList;
//       _error = error;
//     });
//   }
//
//   void selectImages() async {
//     final List<XFile>? selectedImages = await _picker.pickMultiImage();
//     if (selectedImages!.isNotEmpty) {
//       imageFileList!.addAll(selectedImages);
//     }
//
//     print("Length: " + imageFileList!.length.toString());
//     setState(() {});
//   }
//
//   Future imgFromGallery() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedFile != null) {
//         _photo = File(pickedFile.path);
//         uploadFile();
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   Future imgFromCamera() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//
//     setState(() {
//       if (pickedFile != null) {
//         _photo = File(pickedFile.path);
//         uploadFile();
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   Future uploadFile({String? base, String? directory}) async {
//     if (_photo == null) return;
//     final fileName = basename(_photo!.path);
//     final destination = 'Post/$fileName';
//
//     try {
//       final ref = firebase_storage.FirebaseStorage.instance
//           .ref()
//           .child(destination + "/");
//       await ref.putFile(_photo!);
//     } catch (e) {
//       print('Error occured');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Multiple Images'),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             ElevatedButton(
//               child: Text("Pick images"),
//               // onPressed: () {
//               //   selectImages();
//               // },
//               onPressed: loadAssets,
//             ),
//             Expanded(
//               child: buildGridView(),
//             )
//             // Expanded(
//             //   child: GridView.builder(
//             //       itemCount: imageFileList!.length,
//             //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             //           crossAxisCount: 3),
//             //       itemBuilder: (BuildContext context, int index) {
//             //         return Padding(
//             //             padding: const EdgeInsets.all(2.0),
//             //             child: Stack(
//             //               fit: StackFit.expand,
//             //               children: [
//             //                 Image.file(
//             //                   File(imageFileList![index].path),
//             //                   fit: BoxFit.cover,
//             //                 ),
//             //                 Positioned(
//             //                   top: -4,
//             //                   right: -4,
//             //                   child: Container(
//             //                     color: const Color.fromRGBO(255, 255, 244, 0.2),
//             //                     child: IconButton(
//             //                       onPressed: () {
//             //                         imageFileList!.removeAt(index);
//             //                         setState(() {});
//             //                       },
//             //                       icon: const Icon(Icons.delete),
//             //                       color: Colors.black87,
//             //                     ),
//             //                   ),
//             //                 )
//             //               ],
//             //             ));
//             //       }),
//             // )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showPicker(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return SafeArea(
//             child: Wrap(
//               children: <Widget>[
//                 ListTile(
//                     leading: Icon(Icons.photo_library),
//                     title: Text('Gallery'),
//                     onTap: () {
//                       imgFromGallery();
//                       Navigator.of(context).pop();
//                     }),
//                 ListTile(
//                   leading: Icon(Icons.photo_camera),
//                   title: new Text('Camera'),
//                   onTap: () {
//                     imgFromCamera();
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }
