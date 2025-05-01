import 'package:flutter/material.dart';
import 'package:justeatmockup/repositories/restaurant_repository.dart';
import 'package:justeatmockup/screens/home/restaurant_search_view_model.dart';
import 'package:justeatmockup/services/restaurant_api_service.dart';
import 'package:provider/provider.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(
    MyApp(),     // ← contains *all* your routes
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JustEat Mockup',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(225, 247, 156, 38)),
        useMaterial3: true,
      ),
      // Cannot use home: here, because we need to pass the repository to the HomeScreen
      //home: HomeScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':  
            return MaterialPageRoute(
              builder: (_) => MultiProvider(
                providers: [
                  // 1️⃣ Repository lives only for this page
                  Provider(create: (_) => RestaurantRepository(RestaurantApiService())),

                  // 2️⃣ ViewModel depends on that repo
                  ChangeNotifierProvider(
                    lazy: false,
                    create: (context) {
                      final vm = RestaurantSearchViewModel(
                        context.read<RestaurantRepository>(),
                      );
                      vm.search(); // Trigger the search when the screen is loaded
                      return vm;
                    },
                  ),
                ],
                child: const HomeScreen(),
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}






