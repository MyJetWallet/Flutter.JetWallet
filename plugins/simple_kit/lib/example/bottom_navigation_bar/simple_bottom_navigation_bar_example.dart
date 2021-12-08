import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

class SimpleBottomNavigationBarExample extends HookWidget {
  const SimpleBottomNavigationBarExample({Key? key}) : super(key: key);

  static const routeName = '/simple_bottom_navigation_bar_example';

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    final actionActive = useState(false);
    final animationController = useAnimationController();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Stack(
            children: [
              Container(
                color: Colors.grey,
                child: SBottomNavigationBar(
                  animationController: animationController,
                  portfolioNotifications: 1,
                  newsNotifications: 99,
                  profileNotifications: 100,
                  selectedIndex: 0,
                  actionActive: false,
                  onActionTap: () {},
                  onChanged: (value) {},
                ),
              ),
              Column(
                children: [
                  Container(
                    color: Colors.blue[100],
                    child: const SizedBox(
                      height: 14.0,
                      width: double.infinity,
                      child: Center(
                        child: Text('14px'),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        width: 56.0,
                        color: Colors.red[100],
                        child: Stack(
                          children: [
                            const SMarketDefaultIcon(),
                            Container(
                              color: Colors.yellow[200],
                              width: 56.0,
                              child: Center(
                                child: Text(
                                  '56px ->',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.yellow[200],
                              height: 56.0,
                              width: 12.0,
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: Center(
                                  child: Text(
                                    '56px ->',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 56.0,
                        color: Colors.red[100],
                        child: const SPortfolioDefaultIcon(),
                      ),
                      const Spacer(),
                      Container(
                        width: 56.0,
                        color: Colors.red[100],
                        child: const SActionDefaultIcon(),
                      ),
                      const Spacer(),
                      Container(
                        width: 56.0,
                        color: Colors.red[100],
                        child: const SNewsDefaultIcon(),
                      ),
                      const Spacer(),
                      Stack(
                        children: [
                          Container(
                            width: 56.0,
                            color: Colors.red[100]!.withOpacity(0.2),
                            child: const SProfileDefaultIcon(),
                          ),
                          Container(
                            width: 56.0,
                            height: 6.0,
                            color: Colors.red[100],
                            child: Center(
                              child: Text(
                                '6px',
                                style: TextStyle(
                                  fontSize: 7.sp,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              width: 6.0,
                              height: 56.0,
                              color: Colors.red[100],
                              child: Center(
                                child: Text(
                                  '6px',
                                  style: TextStyle(
                                    fontSize: 7.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                  Container(
                    color: Colors.blue[100],
                    child: const SizedBox(
                      height: 26.0,
                      width: double.infinity,
                      child: Center(
                        child: Text('26px'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          SBottomNavigationBar(
            animationController: animationController,
            portfolioNotifications: 1,
            newsNotifications: 99,
            profileNotifications: 100,
            selectedIndex: selectedIndex.value,
            actionActive: actionActive.value,
            onActionTap: () {
              actionActive.value = !actionActive.value;
            },
            onChanged: (value) {
              selectedIndex.value = value;
            },
          ),
        ],
      ),
    );
  }
}
