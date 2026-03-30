import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:namer_app/services/cloudinaryAPI.dart';
import 'package:namer_app/services/firestoreAPI.dart';
import 'package:namer_app/services/imagePicker.dart';

import '../widgets/buttons.dart';
import '../widgets/text_fields.dart';
import '../helper/size_config.dart';
import '../services/notificationsAPI.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final genderController = TextEditingController();
  final birthdateController = TextEditingController();
  final validPhoneNumber = GlobalKey<FormState>();
  String profileImageURL = "", username = "", email = "";
  PhoneNumber phoneNumber = PhoneNumber(countryISOCode: '', countryCode: '', number: '');

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  bool validateUserData() {
    return (validPhoneNumber.currentState?.validate() ?? false) && nameController.text.length <= 16;
  }

  void updateUser() async{
    await updateUserData(
      name: nameController.text.isEmpty ? null : nameController.text,
      phone: phoneNumber.number.isEmpty ? null : ("${phoneNumber.countryCode} ${phoneNumber.number}"),
      gender: genderController.text.isEmpty ? null : genderController.text,
      birthdate: birthdateController.text.isEmpty ? null : birthdateController.text,
      profileImageURL: profileImageURL.isEmpty ? null : profileImageURL
    );
  }

  void loadUserData() async {
    final doc = await getUserDetails();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        username = data['username'];
        email = data['email'];
        if (data['name'] != 'None') nameController.text = data['name'];
        if (data['gender'] != 'None') genderController.text = data["gender"];
        if (data['birthdate'] != 'None') birthdateController.text = data["birthdate"];
        if(profileImageURL == "") {
          profileImageURL = data["profileImageURL"];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
          toolbarHeight: SizeConfig.heightPercentage(8),
          backgroundColor: Colors.grey.shade50,
          centerTitle: true,
          title: Text('Your Profile',
            style: TextStyle(fontSize: SizeConfig.heightPercentage(2)),
          )
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: SizeConfig.widthPercentage(5), right: SizeConfig.widthPercentage(5)),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    XFile? image = await pickGalleryImage();
                    if(image != null){
                      String imageURL = await uploadProfileImageToCloudinary(image);
                      if(imageURL != "") {
                        setState(() {
                          profileImageURL = imageURL;
                        });
                      }
                    }
                  },
                  child: CircleAvatar(
                    backgroundImage: (profileImageURL == "" ? AssetImage('assets/profile_image.jpg') : NetworkImage(profileImageURL)),
                    radius: SizeConfig.heightPercentage(6),
                  ),
                ),
                SizedBox(height: SizeConfig.heightPercentage(1)),
                Text(username,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: SizeConfig.heightPercentage(2.5)),
                ),
                Text(email,
                  style: TextStyle(fontSize: SizeConfig.heightPercentage(2), color: Colors.grey),
                ),
                SizedBox(height: SizeConfig.heightPercentage(4)),
                ElevatedTextField('What\'s your name?', nameController, height: SizeConfig.heightPercentage(6.5)),
                SizedBox(height: SizeConfig.heightPercentage(2.3)),
                PhoneInputField('Phone number', validPhoneNumber, (newPhone) {phoneNumber = newPhone;}, height: SizeConfig.heightPercentage(6.5)),
                SizedBox(height: SizeConfig.heightPercentage(2.3)),
                SizedBox(
                  height: SizeConfig.heightPercentage(6.5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scaleY: 1,
                      child: DropdownMenu(
                        controller: genderController,
                        textStyle: TextStyle(fontSize: SizeConfig.heightPercentage(2)),
                        width: double.infinity,
                        hintText: 'Select your gender',
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(left: SizeConfig.widthPercentage(3.6)),
                          border: InputBorder.none
                        ),
                        dropdownMenuEntries: <DropdownMenuEntry<String>>[
                          DropdownMenuEntry(value: 'Male', label: 'Male'),
                          DropdownMenuEntry(value: 'Female', label: 'Female'),
                          DropdownMenuEntry(value: 'Other', label: 'Other'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.heightPercentage(2.3)),
                DatePickerField(birthdateController, 'What is your date of birth?', height: SizeConfig.heightPercentage(6.5)),
                SizedBox(height: SizeConfig.heightPercentage(3.5)),
                CenteredElevatedButton(() {
                  if(!validateUserData()) return;
                  NotificationsService().showNotification(
                    title: "Profile Update",
                    body: "Your profile has been successfully updated!",
                  );
                  updateUser();
                  Navigator.pop(context, true);
                }, 'Update Profile')
              ],
            ),
          )
        ),
      ),
    );
  }
}