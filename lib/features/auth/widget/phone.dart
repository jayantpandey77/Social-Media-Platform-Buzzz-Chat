import 'package:buzzzchat/features/auth/controller.dart';
import 'package:buzzzchat/features/auth/widget/varificationbox.dart';
import 'package:flutter/material.dart';
import 'package:buzzzchat/utils.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Phone extends ConsumerStatefulWidget {
  const Phone({super.key});
  @override
  ConsumerState<Phone> createState() => _PhoneState();
}

class _PhoneState extends ConsumerState<Phone> {
  final phoneController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  Country? country;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void verify() {
    if (formkey.currentState!.validate()) {
      String phoneNumber = phoneController.text.trim();
      Varificationbox(verificationId: "data").varify(context, ref);
      if (country != null && phoneNumber.isNotEmpty) {
        ref.read(authControllerProvider).signInWithPhone(
            context, '+${country!.phoneCode}$phoneNumber', ref);
      } else {
        showSnackBar(context: context, content: 'Fill out all the fields');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: Center(
                child: Text(
                  " Varify Contact ",
                  style: TextStyle(fontSize: width * 0.1),
                ),
              ),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Form(
                        key: formkey,
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                showCountryPicker(
                                    context: context,
                                    onSelect: (Country ncountry) {
                                      setState(() {
                                        country = ncountry;
                                      });
                                    });
                              },
                              child: (country != null)
                                  ? Text('+${country!.displayName}',
                                  style: TextStyle(fontSize: 21))
                                  : Text('Pick Country'),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              style: TextStyle(fontSize: 25),
                              controller: phoneController,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    value.trim().length != 10) {
                                  return "Enter Valid Contact Number";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                prefixIcon: (country != null)
                                    ? Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    '+${country!.phoneCode} |',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                )
                                    : Icon(Icons.phone),
                                labelText: "Phone",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              actions: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: Navigator.of(context).pop,
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: verify,
                        child: const Text(
                          "Varify",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
      child: Text(
        "Use Phone No.",
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: const Color.fromARGB(255, 73, 7, 255)),
      ),
    );
  }
}
