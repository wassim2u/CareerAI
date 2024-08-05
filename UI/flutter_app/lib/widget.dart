import 'package:flutter/material.dart';


// typedef NavigateWidgetBuilder = Widget Function();

// mixin NavigateMixin on Widget {
//   NavigateWidgetBuilder? get navigationBuilder;

//   Future<T?> navigate<T>(BuildContext context) {
//     if (navigationBuilder == null) {
//       return Future.value();
//     } else {
//       return Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => navigationBuilder!(),
//         ),
//       );
//     }
//   }
// }

// const kNavigationCardRadius = 8.0;

// class NavigationCard extends StatelessWidget with NavigateMixin {
//   const NavigationCard({
//     Key? key,
//     this.margin,
//     this.borderRadius =
//         const BorderRadius.all(Radius.circular(kNavigationCardRadius)),
//     this.navigationBuilder,
//     required this.child,
//   }) : super(key: key);

//   final EdgeInsetsGeometry? margin;
//   final BorderRadius? borderRadius;
//   final Widget child;
//   final NavigateWidgetBuilder? navigationBuilder;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       margin: margin,
//       shape: borderRadius != null
//           ? RoundedRectangleBorder(borderRadius: borderRadius!)
//           : null,
//       child: InkWell(
//         borderRadius: borderRadius,
//         onTap: () => navigate(context),
//         child: child,
//       ),
//     );
//   }
// }

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  TitleAppBar(
    this.title, {
    Key? key,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
       leading: IconButton(
          icon: Icon(Icons.home_rounded), // Different icon for back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
    );
  }
}








class FadeTransitionExample extends StatefulWidget {
  final Widget widgetToFade;

  const FadeTransitionExample(
      {super.key,
        required this.widgetToFade});


  @override
  State<FadeTransitionExample> createState() => _FadeTransitionExampleState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _FadeTransitionExampleState extends State<FadeTransitionExample>
    with TickerProviderStateMixin {


  late final Widget widgetToFadeCopy;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();
  
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widgetToFadeCopy = widget.widgetToFade;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FadeTransition(
        opacity: _animation,
        child: Padding(padding: EdgeInsets.all(8), child: widgetToFadeCopy)),
    );

    //   AnimatedBuilder(
    //     animation: _controller,
    //     builder: (context, child) {
    //       final animationPercent = Curves.easeOut.transform(
    //                       _itemSlideIntervals[i].transform(_staggeredController.value),
    //       );
    //       final opacity = animationPercent;
    //       final slideDistance = (1.0 - animationPercent) * 150;

    //       return Opacity(
    //         opacity: opacity,
    //         child: Transform.translate(
    //           offset: Offset(slideDistance, 0),
    //           child: child,
    //         ),
    //       );
    //     },
    //   child: Text("hello"),
    // )],
  // );
    
    
  
  
  }
}
