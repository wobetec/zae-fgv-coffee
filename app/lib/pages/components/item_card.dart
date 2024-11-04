import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final double rating;
  final VoidCallback onTap;

  const ItemCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.rating,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.orangeAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Row(
          children: [
            // Imagem ou Placeholder
            Container(
              width: 90,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xFFEEF3FC),
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl.isEmpty
                  ? Icon(
                      Icons.fastfood,
                      size: 50,
                      color: Colors.grey,
                    )
                  : null,
            ),
            SizedBox(width: 15),
            Expanded(
              child: SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Informações textuais
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF232323),
                              fontFamily: 'Roboto-SemiBold',
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF80869A),
                              fontFamily: 'Roboto-Regular',
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 4),
                              Text(
                                rating.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF80869A),
                                  fontFamily: 'Roboto-Regular',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Ícone de seta
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
