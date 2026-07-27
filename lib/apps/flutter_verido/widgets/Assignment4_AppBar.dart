import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Assignment4AppBar extends StatelessWidget implements PreferredSizeWidget {
  const Assignment4AppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, '/');
        },
      ),
      title: Text('Sort & Filter', style: TextStyle(fontSize: 20.sp)),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text(
            'CLEAR',
            style: TextStyle(color: Colors.white, fontSize: 20.sp),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20.w),
          child: TextButton(
            onPressed: () {},
            child: Text(
              'APPLY',
              style: TextStyle(color: Colors.white, fontSize: 20.sp),
            ),
          ),
        ),
      ],
    );
  }
}
