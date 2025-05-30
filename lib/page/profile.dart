import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medigram_app/components/button.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/models/doctor/doctor.dart';
import 'package:medigram_app/page/edit_profile.dart';
import 'package:medigram_app/page/new_doctor.dart';
import 'package:medigram_app/services/doctor_service.dart';
import 'package:medigram_app/services/user_service.dart';
import 'package:medigram_app/services/auth_service.dart';
import 'package:medigram_app/models/user/user.dart';
import 'package:medigram_app/models/user/user_detail.dart';
import 'package:medigram_app/page/login.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  User? _user;
  UserDetail? _userDetail;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userResponse = await UserService().getOwnInfo();
      if (userResponse.statusCode == 200) {
        final userData = jsonDecode(userResponse.body);
        setState(() {
          _user = User.fromJson(userData);
        });

        // Load user details
        final detailResponse = await UserService().getOwnDetail();
        if (detailResponse.statusCode == 200) {
          final detailData = jsonDecode(detailResponse.body);
          setState(() {
            _userDetail = UserDetail.fromJson(detailData);
          });
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load user data';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await AuthService().logout();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to logout. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            screenPadding,
            topScreenPadding,
            screenPadding,
            screenPadding,
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Text(_error!, style: TextStyle(color: Colors.red)))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: screenPadding,
                      children: [
                        Text("Profile", style: header2),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(screenPadding),
                            child: Column(
                              spacing: screenPadding,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                  title: Text(_userDetail?.name ?? 'Not set',
                                      style: header1),
                                  subtitle: Text(
                                    _user?.email ?? '',
                                    style: body,
                                  ),
                                ),
                                const Divider(),
                                _buildInfoRow('NIK',
                                    _userDetail?.nik.toString() ?? 'Not set'),
                                _buildInfoRow(
                                    'Gender',
                                    _userDetail?.gender == null
                                        ? 'Not set'
                                        : _userDetail!.gender == "M"
                                            ? "Male"
                                            : "Female"),
                                _buildInfoRow(
                                  'Date of Birth',
                                  _userDetail?.dob == null
                                      ? 'Not set'
                                      : DateFormat("dd MMMM yyyy")
                                          .format(_userDetail!.dob),
                                ),
                                Column(
                                  spacing: 0,
                                  children: [
                                    Container(
                                        // padding: EdgeInsets.all(16),
                                        child: Button(
                                            "Edit Profile",
                                            () => Navigator.push(context,
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return EditProfile();
                                                })),
                                            false,
                                            false,
                                            false)),
                                    Button(
                                        "Create Doctor Account",
                                        () => Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return NewDoctor();
                                            })),
                                        true,
                                        false,
                                        false),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _logout(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(color: Color(0xffffff))),
                            child: Text("Logout", style: header2),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  Future<UserDetail> getUser() async {
    final response = await UserService().getOwnDetail();
    Map<String, dynamic> data = jsonDecode(response.body);
    UserDetail user = UserDetail.fromJson(data);
    return user;
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: content,
        ),
        Text(value, style: body),
      ],
    );
  }
}
