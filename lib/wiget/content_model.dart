class UnboardingContent{
  String image;
  String title;
  String description;
  UnboardingContent({required this.description, required this.image, required this.title});
}

List<UnboardingContent> contents=[
  UnboardingContent(description: 'Pick your food our menu\n     more than 35 times',
  image: "assets/screen1.png",
  title: "Select from our\n      Best Menu"),
  UnboardingContent(description: 'You can pay cash on delivery and\n    card payment is available', 
  image: 'assets/screen2.png', 
  title: 'Easy and online payment'),
  UnboardingContent(description: 'Delivery your food at\n       your doorstep', image: 'assets/screen3.png', title: 'Quick delivery at\n      your doerstep')
];