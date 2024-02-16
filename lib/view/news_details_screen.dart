import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDetailsScreen extends StatefulWidget {
  final String newImage, newsTitle, newsDate, author, description, content, source;
  const NewsDetailsScreen({super.key,
  required this.newImage,
    required this.newsTitle,
    required this.newsDate,
    required this.source,
    required this.author,
    required this.content,
    required this.description,

  });

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width*1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            height: height*.45,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50)
              ),
              child: CachedNetworkImage(
                imageUrl: widget.newImage,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
              ),
            ),
          ),
          Container(
            height: height*.6,
            margin: EdgeInsets.only(top: height*.4),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListView(
              children: [
                Text(widget.newsTitle,
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.only( top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.author,
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                      Text(widget.newsDate,
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(widget.source,
                    style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.blue),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(widget.description,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black54),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
