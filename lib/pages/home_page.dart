import 'package:cached_network_image/cached_network_image.dart';
import 'package:countup/countup.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monieestate/utils/customColor.dart';
import 'package:simple_animations/animation_builder/play_animation_builder.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RealEstateHomePage extends StatefulWidget {
  @override
  _RealEstateHomePageState createState() => _RealEstateHomePageState();
}

class _RealEstateHomePageState extends State<RealEstateHomePage> {
  bool isRecentOffersVisible = false;
  bool isBottomSheetVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        isRecentOffersVisible = true;
        isBottomSheetVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double remainingHeight = constraints.maxHeight -
                _buildHeaderHeight(context) -
                _buildFeaturedSectionHeight();

            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        CustomColor.lightCreamColor,
                        CustomColor.darkCreamColor,
                      ],
                    ),
                  ),
                  child: ListView(
                    physics: ClampingScrollPhysics(), // Prevent overscroll bounce
                    children: [
                      _buildHeader(),
                      _buildFeaturedSection(),
                      SizedBox(height: 16), // Add some space below the featured section
                    ],
                  ),
                ),

                AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  bottom: isBottomSheetVisible ? 0 : -remainingHeight,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    height: isBottomSheetVisible ? remainingHeight : 0,
                    child: _buildRecentOffers(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  double _buildHeaderHeight(BuildContext context) {
    // Calculate the height of the header
    final RenderObject? renderBox = _buildHeaderKey.currentContext?.findRenderObject();
    return renderBox?.semanticBounds.height ?? 0;
  }

  double _buildFeaturedSectionHeight() {
    return 220.0;
  }

  final GlobalKey _buildHeaderKey = GlobalKey();

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlayAnimationBuilder<double>(
                tween: Tween(begin: -30.0, end: 0.0),
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                builder: (context, value, _) {
                  return Transform.translate(
                    offset: Offset(value, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        // Adjust as desired
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          // Wrap location text and icon together
                          children: [
                            Icon(
                              IconsaxBold.location,
                              size: 20.0,
                              color: CustomColor.headertextColor,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              "Saint Petersburg",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: CustomColor.headertextColor,
                                  fontFamily: 'EuclidCircularA'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              PlayAnimationBuilder<double>(
                // Location Container with slide-in
                tween: Tween(begin: 30.0, end: 0.0),
                // Starting and ending offset
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                builder: (context, value, _) {
                  return Transform.translate(
                    offset: Offset(value, 0),
                    child: CachedNetworkImage(
                      imageUrl: 'https://picsum.photos/50/50',
                      // Random image URL
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 25.0,
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                },
              ),
            ],
          ),
          PlayAnimationBuilder<double>(
            // Location Container with slide-in
            tween: Tween(begin: 0.0, end: 1.0), // Starting and ending offset
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            builder: (context, value, _) {
              return Transform.translate(
                offset: Offset(value, 0),
                child: Text(
                  'Hi, Marina',
                  style: TextStyle(
                      fontSize: 24.0,
                      color: CustomColor.headertextColor,
                      fontFamily: 'EuclidCircularA'),
                ),
              );
            },
          ),
          PlayAnimationBuilder<double>(
            // Location Container with slide-in
            tween: Tween(begin: -30.0, end: 0.0), // Starting and ending offset
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            builder: (context, value, _) {
              return Transform.translate(
                offset: Offset(value, 0),
                child: Text(
                  "Let's select your perfect place", // More generic wording
                  style: TextStyle(
                      fontSize: 36.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'EuclidCircularA'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Build Featured Listings Section
  Widget _buildFeaturedSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          PlayAnimationBuilder<double>(
            // Fade-in and scale
            tween: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOut,
            builder: (context, value, _) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildBuyButton(),
                          _buildRentButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBuyButton() {
    return Column(
      children: [
        Container(
          width: 150.0, // Adjust size as desired
          height: 150.0,
          decoration: BoxDecoration(
            color: Colors.orange[400], // Light blue color from the image
            shape: BoxShape.circle,
          ),
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Text(
                'BUY',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: Countup(
                  begin: 0.0,
                  // Starting value (change if needed)
                  end: 1034.0,
                  // Target value (change to your actual number)
                  duration: Duration(seconds: 3),
                  // Animation duration
                  curve: Curves.easeInOut,
                  // Easing animation curve
                  style: TextStyle(
                    fontSize: 28.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Offers',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRentButton() {
    return Column(
      children: [
        Container(
          width: 150.0, // Adjust size as desired
          height: 150.0,
          decoration: BoxDecoration(
            color: Colors.white70, // Yellow color from the image
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Text(
                'Rent',
                style: TextStyle(
                  fontSize: 16.0,
                  color: CustomColor.headertextColor,
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: Countup(
                  begin: 0.0,
                  // Starting value (change if needed)
                  end: 2212.0,
                  // Target value (change to your actual number)
                  duration: Duration(seconds: 3),
                  // Animation duration
                  curve: Curves.easeInOut,
                  // Easing animation curve
                  style: TextStyle(
                    fontSize: 28.0,
                    color: CustomColor.headertextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Offers',
                style: TextStyle(
                  fontSize: 16.0,
                  color: CustomColor.headertextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Recent Offers Section
  // Widget _buildRecentOffers() {
  //   return Column(
  //     children: [
  //       Center( // Centering top row
  //         child: Container(),
  //       ),
  //       SizedBox(height: 20.0), // Spacing between rows
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildRecentOffers() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: 6,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemBuilder: (context, index) => _buildOfferItem(index),
              staggeredTileBuilder: (index) => _getStaggeredTile(index),
            ),
          ),
        ],
      ),
    );
  }

  StaggeredTile _getStaggeredTile(int index) {
    if (index == 0) {
      return StaggeredTile.count(
          2, 1); // Occupy both columns for the first item
    } else {
      return StaggeredTile.count(1, 1); // Adjust height ratio as needed
    }
  }

  Widget _buildOfferItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.all( Radius.circular(10)
            ),
            child:
            Container(
              height: 200,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image(
                        image: CachedNetworkImageProvider(
                          'https://picsum.photos/400/300?random=$index',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8.0,
                    left: 8.0,
                    right: 8.0,
                    child: Container(
                      height: 40, // Adjust the height of the button
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    // Add your button functionality here
                                  },
                                  child: Text(
                                    'Lekki, Lagos',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13, // Adjust the font size
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 40, // Adjust the height of the arrow container
                                width: 40, // Adjust the width of the arrow container
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Icon(Icons.chevron_right),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )


          ),
        ),
      ],
    );
  }
}
