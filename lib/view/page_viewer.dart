import 'package:flutter/material.dart';
import 'package:cinemader/view/home.dart';
import 'package:cinemader/view/signup_usher.dart';
import 'package:cinemader/core/theme/app_color.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:hr_management_app/view/home.dart';

class PageViewer extends StatelessWidget {
  const PageViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: [
              HomePage(),
              Movie(),
              SignupUsher()
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45)),
                color: AppColor.secondaryColor,
              ),
              width: MediaQuery.of(context).size.width,
              height: 90,
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      AntDesign.like1,
                      color: Colors.white,
                    ),
                    Icon(
                      AntDesign.menu_fold,
                      color: Colors.white30,
                    ),
                    Icon(
                      AntDesign.user,
                      color: Colors.white30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
