import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';
import 'package:news_app/view/categories-screen.dart';
import 'package:news_app/view/news_details_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

import 'models/categories-news-model-dart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 enum FilterList { bbcNews, aryNews, independent, reuters, cnn, alJazeera}
class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM, dd, yyyy');
  String name = 'bbc-news';
  FilterList? selectedMenu;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width*1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoriesScreen()));
          },
          icon: Image.asset('images/category_icon.png',
          height: 30,
          width: 30,),
        ),
        title: Text('News', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),),
        actions: [
            PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
                icon: Icon(Icons.more_vert, size: 24,),
                onSelected: (FilterList item){
                  if(FilterList.bbcNews.name == item.name){
                  name = 'bbc-news';
                }
                if(FilterList.alJazeera.name == item.name){
                  name = 'al-jazeera-english';
                }
                if(FilterList.independent.name == item.name){
                  name = 'independent';
                }
                if(FilterList.aryNews.name == item.name){
                  name = 'ary-news';
                }
                if(FilterList.cnn.name == item.name){
                  name = 'cnn';
                }
                setState(() {

                });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
                  PopupMenuItem<FilterList>(
                      value: FilterList.bbcNews,
                      child: Text('BBC News'),),
                  PopupMenuItem<FilterList>(
                    value: FilterList.independent,
                    child: Text('Independent'),),
                  PopupMenuItem<FilterList>(
                    value: FilterList.cnn,
                    child: Text('CNN News'),),
                  PopupMenuItem<FilterList>(
                    value: FilterList.alJazeera,
                    child: Text('Al Jazeera'),),
                  PopupMenuItem<FilterList>(
                    value: FilterList.aryNews,
                    child: Text('Ary News'),),
                ]
            )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              future: newsViewModel.fetechNewsChannelHeadlinesApi(name),
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
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> NewsDetailsScreen(
                              newImage: snapshot.data!.articles![index].urlToImage.toString(),
                              newsTitle: snapshot.data!.articles![index].title.toString(),
                              newsDate: format.format(dateTime),
                              author: snapshot.data!.articles![index].author.toString(),
                              description: snapshot.data!.articles![index].description.toString(),
                              content: snapshot.data!.articles![index].content.toString(),
                              source: snapshot.data!.articles![index].source!.name.toString(),
                            ), ));
                          },
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                               Container(
                                 height: height*0.6,
                                  width: width*0.9,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: height*0.02,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data?.articles?[index]?.urlToImage?.toString() ?? '',

                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(child: spinkit2,) ,
                                      //errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red,),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.bottomCenter,
                                      height: height*.22,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width*0.7,
                                            child: Text(snapshot.data!.articles![index].title.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                              GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Spacer(),
                                          Expanded(
                                            child: Container(
                                              //alignment: Alignment.bottomLeft,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 15.0),
                                                    child: Text(snapshot.data!.articles![index].source!.name.toString(),
                                                      style:
                                                      GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                  Text(format.format(dateTime),
                                                    style:
                                                    GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
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
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsModelApi('General'),
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
                        itemCount: snapshot.data!.articles!.length,
                        shrinkWrap: true,
                        //scrollDirection: Axis.vertical,
                        itemBuilder: (context, index){
                          DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
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
          ),
        ],
      ),
    );
  }
}
const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);