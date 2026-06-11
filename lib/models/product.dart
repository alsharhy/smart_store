class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(rate: (json["rate"] as num).toDouble(), count: json["count"]);
  }

  Map<String, dynamic> toJson() {
    return {"rate": rate, "count": count};
  }
}

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  // Parse from dummyjson.com API response
  factory Product.fromJson(Map<String, dynamic> json) {
    // dummyjson.com uses "thumbnail" for images and "rating" as a direct number
    final String imageUrl = json["thumbnail"] ?? json["image"] ?? "";
    final dynamic ratingValue = json["rating"];

    Rating parsedRating;
    if (ratingValue is Map<String, dynamic>) {
      // fakestoreapi.com format: {"rate": 4.5, "count": 120}
      parsedRating = Rating.fromJson(ratingValue);
    } else if (ratingValue is num) {
      // dummyjson.com format: rating is just a number
      parsedRating = Rating(rate: ratingValue.toDouble(), count: 0);
    } else {
      parsedRating = Rating(rate: 0.0, count: 0);
    }

    return Product(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      description: json["description"] ?? "",
      category: json["category"] ?? "",
      image: imageUrl,
      rating: parsedRating,
    );
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  factory Product.fromDoc(Map<String, dynamic> doc) {
    return Product(
      id: doc["id"] ?? 0,
      title: doc["title"] ?? "",
      price: (doc["price"] as num?)?.toDouble() ?? 0.0,
      description: doc["description"] ?? "",
      category: doc["category"] ?? "",
      image: doc["image"] ?? "",
      rating: Rating.fromJson(doc["rating"] ?? {"rate": 0.0, "count": 0}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "description": description,
      "category": category,
      "image": image,
      "rating": rating.toJson(),
    };
  }
}
