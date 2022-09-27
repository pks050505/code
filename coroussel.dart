class PromotionHomeWidget extends StatelessWidget {
  const PromotionHomeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: [
            Image.asset('asserts/images/corouselimage.jpg'),
            Image.asset('asserts/images/corouselimage2.jpg'),
            Image.asset('asserts/images/corouselimage3.jpg'),
          ],
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1,
          ),
        ),
      ],
    );
  }
}
