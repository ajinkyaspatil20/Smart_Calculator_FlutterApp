import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mathInterestController = TextEditingController();

  String role = "Student";
  String difficultyLevel = "Intermediate";
  String favoriteMathField = "Algebra";

  final List<String> difficultyLevels = [
    "Beginner",
    "Intermediate",
    "Advanced"
  ];
  final List<String> mathFields = [
    "Algebra",
    "Geometry",
    "Calculus",
    "Trigonometry",
    "Statistics"
  ];

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _usernameController.text = userProvider.username;
    _mathInterestController.text = userProvider.mathInterest;
    role = userProvider.role.isNotEmpty ? userProvider.role : "Student";
    difficultyLevel = userProvider.difficultyLevel.isNotEmpty
        ? userProvider.difficultyLevel
        : "Intermediate";
    favoriteMathField = userProvider.favoriteMathField.isNotEmpty
        ? userProvider.favoriteMathField
        : "Algebra";
    if (userProvider.profileImagePath != null) {
      _profileImage = File(userProvider.profileImagePath!);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _mathInterestController.dispose();
    super.dispose();
  }

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ Profile Updated Successfully!",
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🟢 Profile Picture Selection
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: _profileImage != null
                          ? ClipOval(
                              child: Image.file(
                                _profileImage!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(Icons.person,
                              size: 60,
                              color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Tap to change profile picture",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontSize: 14),
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Create Your Profile",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 30),

                  _buildTextField("Username", _usernameController),

                  SizedBox(height: 20),

                  _buildDropdown("Role", ["Student", "Teacher"], role,
                      (value) => setState(() => role = value!)),

                  SizedBox(height: 20),

                  _buildTextField(
                      "What do you love about math?", _mathInterestController),

                  SizedBox(height: 20),

                  _buildDropdown(
                      "Math Difficulty Level",
                      difficultyLevels,
                      difficultyLevel,
                      (value) => setState(() => difficultyLevel = value!)),

                  SizedBox(height: 20),

                  _buildDropdown(
                      "Favorite Math Field",
                      mathFields,
                      favoriteMathField,
                      (value) => setState(() => favoriteMathField = value!)),

                  SizedBox(height: 30),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          userProvider.updateUserData(
                            username: _usernameController.text,
                            role: role,
                            mathInterest: _mathInterestController.text,
                            difficultyLevel: difficultyLevel,
                            favoriteMathField: favoriteMathField,
                            profileImagePath: _profileImage?.path,
                          );
                          _showSuccessMessage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text("Save Profile",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value,
      void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      dropdownColor: Theme.of(context).colorScheme.surface,
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
