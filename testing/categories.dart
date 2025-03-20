import 'package:kite/data/categories.dart';
import 'package:kite/logic/categories.dart';

const kCategoryModels = [
  CategoryModel(name: 'World', file: 'world.json'),
  CategoryModel(name: 'USA', file: 'usa.json'),
  CategoryModel(name: 'Business', file: 'business.json'),
  CategoryModel(name: 'Technology', file: 'tech.json')
];

const String kCategoriesJson = '''
{
  "timestamp": 1741958498,
  "categories": [
    {
      "name": "World",
      "file": "world.json"
    },
    {
      "name": "USA",
      "file": "usa.json"
    },
    {
      "name": "Business",
      "file": "business.json"
    },
    {
      "name": "Technology",
      "file": "tech.json"
    }
  ]
}
''';

const kCategories = [
  Category("World", []),
  Category("USA", []),
  Category("Business", []),
  Category("Technology", []),
  Category("Science", []),
  Category("Sports", []),
  Category("Gaming", []),
  Category("Bay Area", []),
  Category("Linux & OSS", []),
  Category("Cryptocurrency", []),
  Category("Europe", []),
  Category("UK", []),
  Category("Ukraine", []),
  Category("Brazil", []),
  Category("Australia", []),
  Category("Estonia", []),
  Category("Mexico", []),
  Category("Germany", []),
  Category("Germany | Hesse", []),
  Category("Italy", []),
  Category("Canada", []),
  Category("Thailand", []),
  Category("Serbia", []),
  Category("USA | Vermont", []),
  Category("Japan", []),
  Category("Israel", []),
  Category("New Zealand", []),
  Category("Portugal", []),
  Category("France", []),
  Category("Poland", []),
  Category("Slovenia", []),
  Category("Spain", []),
  Category("Ireland", []),
  Category("Belgium", []),
  Category("The Netherlands", []),
  Category("Romania", []),
  Category("OnThisDay", [])
];

final _categories = [
  {"name": "World", "file": "world.json"},
  {"name": "USA", "file": "usa.json"},
  {"name": "Business", "file": "business.json"},
  {"name": "Technology", "file": "tech.json"},
  {"name": "Science", "file": "science.json"},
  {"name": "Sports", "file": "sports.json"},
  {"name": "Gaming", "file": "gaming.json"},
  {"name": "Bay Area", "file": "bay.json"},
  {"name": "Linux & OSS", "file": "linux & oss.json"},
  {"name": "Cryptocurrency", "file": "cryptocurrency.json"},
  {"name": "Europe", "file": "europe.json"},
  {"name": "UK", "file": "uk.json"},
  {"name": "Ukraine", "file": "ukraine.json"},
  {"name": "Brazil", "file": "brazil.json"},
  {"name": "Australia", "file": "australia.json"},
  {"name": "Estonia", "file": "estonia.json"},
  {"name": "Mexico", "file": "mexico.json"},
  {"name": "Germany", "file": "germany.json"},
  {"name": "Germany | Hesse", "file": "germany | hesse.json"},
  {"name": "Italy", "file": "italy.json"},
  {"name": "Canada", "file": "canada.json"},
  {"name": "Thailand", "file": "thailand.json"},
  {"name": "Serbia", "file": "serbia.json"},
  {"name": "USA | Vermont", "file": "usa | vermont.json"},
  {"name": "Japan", "file": "japan.json"},
  {"name": "Israel", "file": "israel.json"},
  {"name": "New Zealand", "file": "new zealand.json"},
  {"name": "Portugal", "file": "portugal.json"},
  {"name": "France", "file": "france.json"},
  {"name": "Poland", "file": "poland.json"},
  {"name": "Slovenia", "file": "slovenia.json"},
  {"name": "Spain", "file": "spain.json"},
  {"name": "Ireland", "file": "ireland.json"},
  {"name": "Belgium", "file": "belgium.json"},
  {"name": "The Netherlands", "file": "the netherlands.json"},
  {"name": "Romania", "file": "romania.json"},
  {"name": "OnThisDay", "file": "onthisday.json"}
];
