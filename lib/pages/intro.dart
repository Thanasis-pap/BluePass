import 'package:flutter/foundation.dart';
import 'package:passwordmanager/global_dirs.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      LeftPageRoute(page: RegisterPage()),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Theme.of(context).colorScheme.surface,
      allowImplicitScrolling: true,
      autoScrollDuration: 100000,
      infiniteAutoScroll: false,
      pages: [
        PageViewModel(
          title: "Welcome to BluePass",
          bodyWidget: Text(
            "A modern, secure & easy-to-use password manager with strong encryption.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          image: DropShadow(
            child: Gif(
              fps: 60,
              useCache: true,
              autostart: Autostart.once,
              image: AssetImage('assets/flow.gif'),
              width: 80,
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Your data is safe",
          bodyWidget: Text(
            "BluePass uses AES Encryption, the strongest encryption against brute-force attacks ever created, as well as biometric authentication.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          image: DropShadow(
            child: Image.asset(
              'assets/encryption.png',
              width: 100,
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Offline use",
          bodyWidget: Text(
            "BluePass does not require any internet access. All of your data are encrypted and stored locally, no data are stored on servers.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          image: DropShadow(
            child: Image.asset(
              'assets/cloud.png',
              width: 100,
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Transfer your data",
          bodyWidget: Text(
            "You can easily export or import data to other devices. Don't worry, your data remain encrypted during transfer.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          image: DropShadow(
            child: Image.asset(
              'assets/import_export.png',
              width: 100,
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Let's Start",
          bodyWidget: Text(
            'Click "Next" to start using BluePass',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          image: DropShadow(
    child:Image.asset(
            'assets/password.png',
            width: 80,
          ),),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      //showBackButton: true,

      //rtl: true, // Display as right-to-left
      //back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Next', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        //color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.blue,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        //color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
