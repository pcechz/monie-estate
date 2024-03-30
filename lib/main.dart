import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monieestate/pages/home_page.dart';
import 'package:monieestate/pages/map_screen.dart';
import 'package:monieestate/services/bottom_bar.dart';
import 'package:monieestate/services/navigation_service.dart';
import 'package:monieestate/utils/customColor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NavigationService _navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MonieEstate',
      theme: ThemeData(
        colorScheme: const ColorScheme.light()
      ),
      navigatorKey: _navigationService.navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: ""),
        // '/home': (context) => HomePage(),
        // '/explore': (context) => ExplorePage(),
      },
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;
  final List<Color> colors = [CustomColor.primary, CustomColor.primary, CustomColor.primary, CustomColor.primary, CustomColor.primary];
  // final List<Color> backgroundColors = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 5, vsync: this);
    tabController.animation!.addListener(
          () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color unselectedColor = colors[currentPage].computeLuminance() < 0.5 ? Colors.white : Colors.black;
    return SafeArea(
      child: Scaffold(
        body:
        BottomBar(
          borderRadius: BorderRadius.circular(500),
          duration: Duration(seconds: 1),
          curve: Curves.decelerate,
          showIcon: false,
          width: MediaQuery.of(context).size.width * 0.9,
          start: 4,
          end: 0,
          barAlignment: Alignment.bottomCenter,
          reverse: false,
          hideOnScroll: false,
          scrollOpposite: false,
          onBottomBarHidden: () {},
          onBottomBarShown: () {},
          body: (context, controller) => TabBarView(
            controller: tabController,
            dragStartBehavior: DragStartBehavior.down,
            physics: const BouncingScrollPhysics(),
            children: [MapScreen(), MapScreen(), RealEstateHomePage(), MapScreen(), MapScreen()],
          ),
          child: TabBar(
            padding: EdgeInsets.zero,
            controller: tabController,
            dividerHeight: 0,
            labelPadding: EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 5),
            indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
                    color: CustomColor.transparentBlack,
                    width: 0),
                insets: EdgeInsets.fromLTRB(16, 0, 16, 0)),
            tabs: [
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == 0 ? CustomColor.primary : Colors.black, // Background color
                ),
                child: Center(
                    child: Icon(
                      IconsaxBold.search_normal_1,
                      color:  unselectedColor,
                      size: 30,
                    )),
              ),
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == 1 ? CustomColor.primary : Colors.black, // Background color
                ),
                child: Center(
                    child: Icon(
                      IconsaxBold.message,
                      color:  unselectedColor,
                      size: 30,
                    )),
              ),
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == 2 ? CustomColor.primary : Colors.black, // Background color
                ),
                child: Center(
                    child: Icon(
                      IconsaxBold.home,
                      color:  unselectedColor,
                      size: 30,
                    )),
              ),
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == 3 ? CustomColor.primary : Colors.black, // Background color
                ),
                child: Center(
                    child: Icon(
                      IconsaxBold.heart,
                      color:  unselectedColor,
                      size: 30,
                    )),
              ),
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == 4 ? CustomColor.primary : Colors.black, // Background color
                ),
                child: Center(
                    child: Icon(
                      IconsaxBold.user,
                      color:  unselectedColor,
                      size: 30,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}