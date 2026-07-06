import 'package:dhs_app/screens/library/tabs/airline_library_tab.dart';
import 'package:dhs_app/screens/library/tabs/gsrm_library_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.colorPrimary,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColors.colorWhite,
          appBar: AppBar(
            backgroundColor: AppColors.colorPrimary,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Library',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: AppColors.colorPrimary,
              statusBarIconBrightness: Brightness.light,
            ),
          ),
          body: Column(
            children: [
              // Tabs moved here
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: AppColors.colorPrimary,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.colorPrimary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey.shade600,
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.business, size: 18),
                            SizedBox(width: 8),
                            Text('GSRM Library'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.airplanemode_active, size: 18),
                            SizedBox(width: 8),
                            Text('Airline Library'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // TabBarView
              const Expanded(
                child: TabBarView(
                  children: [
                    GsrmLibraryTab(),
                    AirlineLibraryTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
