import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view_models/controller/aboutYou/aboutYou_view_model.dart';
import 'package:path_provider/path_provider.dart';

// List<File> Gallayimage = [];

class UploadPhotoAboutScreen extends StatefulWidget {
  bool fromEditScreen;
  UploadPhotoAboutScreen({required this.fromEditScreen});
  @override
  State<UploadPhotoAboutScreen> createState() => UploadPhotoAboutScreenState();
}

class UploadPhotoAboutScreenState extends State<UploadPhotoAboutScreen> {
  RxList<File> EditScreenImagesPathList = <File>[].obs;
  AboutYouViewModel aboutYouViewModel = Get.put(AboutYouViewModel());

  final picker = ImagePicker();
  Future<void> _pickImages() async {
    // List<Asset> resultList = [];
    List<File> selectedImages = [];
    try {
      // resultList = await MultipleImagesPicker.pickImages(
      //   maxImages: 10 - ImagesPathList.length,
      //   enableCamera: true,
      //   materialOptions: MaterialOptions(
      //     actionBarColor: "#abcdef",
      //     statusBarColor: "#abcdef",
      //     actionBarTitle: "Select Images",
      //     allViewTitle: "All Photos",
      //   ),
      // );
      final pickedFile = await picker.pickMultiImage(
          imageQuality: 70, maxHeight: 1000, maxWidth: 1000);
      List<XFile> xfilePick = pickedFile;

      setState(
        () {
          if (xfilePick.isNotEmpty) {
            for (var i = 0; i < xfilePick.length; i++) {
              selectedImages.add(File(xfilePick[i].path));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nothing is selected')));
          }
        },
      );
    } on Exception catch (e) {
      print('Handling Exception Khushal ${e.toString()}');
      Utils.snackBar('Error', e.toString(), true);
    }

    if (!mounted) return;

    // for (var asset in resultList) {
    //   final byteData = await asset.getByteData();
    //   final buffer = byteData.buffer.asUint8List();

    //   final compressedImageData = await FlutterImageCompress.compressWithList(
    //     buffer,
    //     quality: 85,
    //   );

    //   final tempFile =
    //       File('${(await getTemporaryDirectory()).path}/${asset.name}');
    //   await tempFile.writeAsBytes(compressedImageData);

    //   selectedImages.add(tempFile);

    //   // Print original and compressed image sizes
    //   print('Original image size: ${buffer.lengthInBytes} bytes');
    //   print('Compressed image size: ${compressedImageData.length} bytes');
    // }

    setState(() {
      if (widget.fromEditScreen == true) {
        EditScreenImagesPathList.addAll(selectedImages);
      }
    

      ImagesPathList.addAll(selectedImages);
      print("Printing Image path list length ${ImagesPathList.length}");
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: ImagesPathList.length < 2 &&
                widget.fromEditScreen == false
            ? Align(
                heightFactor: 2,
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextClass(
                        size: 14,
                        fontWeight: FontWeight.w400,
                        title: 'Please upload minimum 2 images.',
                        fontColor: primaryDark),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )
            : Align(
                heightFactor: 1,
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(primaryDark)),
                    onPressed: () {
                      if (widget.fromEditScreen == false) {
                        aboutYouViewModel.imageList = ImagesPathList;
                        Get.back(result: ImagesPathList.length.obs);
                      } else {
                        Get.back(result: EditScreenImagesPathList);
                        ImagesPathList.clear();
                      }
                    },
                    child: TextClass(
                      fontColor: Colors.white,
                      title: '    Done    ',
                      fontWeight: FontWeight.w600,
                      size: 18,
                    )),
              ),
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: Text('Upload Photos for your Profile'),
        ),
        floatingActionButton: ImagesPathList.length > 9
            ? Container()
            : FloatingActionButton(
                onPressed: () {
                  ShowDialog(context);
                },
                backgroundColor: primaryDark,
                child: Icon(Icons.upload),
              ),
        body: GridView.builder(
          padding: EdgeInsets.all(20),
          itemCount: ImagesPathList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 250,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            return Stack(alignment: Alignment.bottomRight, children: [
              Container(
                // width: Get.width * .1,
                // height: Get.height * .2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        image: FileImage(ImagesPathList[index]),
                        fit: BoxFit.cover)),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      ImagesPathList.removeAt(index);
                    });
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                  ))
            ]);
          },
        ));
  }

  void ShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          alignment: Alignment.center,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      // _pickImage(ImageSource.gallery);
                      _pickImages();
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TextClass(
                            size: 14,
                            fontWeight: FontWeight.w600,
                            title: 'Choose from Gallery',
                            fontColor: Colors.white)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      // _pickImage(ImageSource.camera);
                      _pickImages();
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TextClass(
                            size: 14,
                            fontWeight: FontWeight.w600,
                            title: 'Click a Photo',
                            fontColor: Colors.white)
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
