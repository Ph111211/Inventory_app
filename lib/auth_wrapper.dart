import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/presentation/pages/login_page.dart';
import 'tasks/presentation/screens/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Đang loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang kiểm tra trạng thái đăng nhập...'),
                ],
              ),
            ),
          );
        }
        
        // Có lỗi
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Có lỗi xảy ra: ${snapshot.error}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Reload the app
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        }
        
        // Kiểm tra user đã đăng nhập chưa
        if (snapshot.hasData && snapshot.data != null) {
          // Đã đăng nhập -> Hiện StudentsPage
          return HomeScreen();
        } else {
          // Chưa đăng nhập -> Hiện LoginPage
          return LoginPage();
        }
      },
    );
  }
}