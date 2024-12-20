class Manga {
  final String title;
  final String chapter;
  final String genre;
  final String releaseDate;
  final String malScore;
  final String author;
  final String status;
  final String serialization;
  final String animeAdaptation;
  final String synopsis;
  final String imageAsset;
  final String mangaLink;
  final List<String> imageUrls;

  Manga({
    required this.title,
    required this.chapter,
    required this.genre,
    required this.releaseDate,
    required this.malScore,
    required this.author,
    required this.status,
    required this.serialization,
    required this.animeAdaptation,
    required this.synopsis,
    required this.imageAsset,
    required this.imageUrls, 
    required this.mangaLink,
  });
}
