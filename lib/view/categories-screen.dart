import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories-news-model-dart.dart';

import '../view_model/news_view_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM, dd, yyyy');
  String categoryName = 'bbc-news';
  List<String> categoriesList= [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width*1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        categoryName = categoriesList[index];
                        setState(() {

                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: categoryName==categoriesList[index]? Colors.blue: Colors.grey,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(categoriesList[index].toString(),
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: categoryName==categoriesList[index]? Colors.white: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

              ),
            ),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsModelApi(categoryName),
                builder: (BuildContext context, snapshot){
                  if( snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  }else{
                    return ListView.builder(
                        itemCount: snapshot.data?.articles?.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index){
                          DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data?.articles?[index]?.urlToImage?.toString() ?? '',
                                    fit: BoxFit.cover,
                                    height: height*.18,
                                    width: width*.3,
                                    placeholder: (context, url) => Container(child: SpinKitCircle(
                                      size: 50,
                                      color: Colors.blue,
                                    ),) ,
                                    //errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red,),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Container(
                                      height: height*.18,
                                      child: Column(
                                        children: [
                                          Text(snapshot.data!.articles![index].title.toString(),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                            GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w600),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 15.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [

                                                Text(snapshot.data!.articles![index].source!.name.toString(),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style:
                                                  GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500, color: Colors.blue ),
                                                ),
                                                Text(format.format(dateTime),
                                                  style:
                                                  GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],

                                      ),
                                    ),

                                  ),

                                )
                              ],

                            ),
                          );
                        }
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
