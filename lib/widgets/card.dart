import 'package:flutter/material.dart';
import 'package:mobile_development_capstone_project/views/webview.dart';

class FancyNewsCard extends StatelessWidget {
  final String imgUrl, title, desc, content, postUrl;

  const FancyNewsCard({
    Key? key,
    required this.imgUrl,
    required this.title,
    required this.desc,
    required this.content,
    required this.postUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewsDetails(url: postUrl)),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 3.0,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Stack(
            children: <Widget>[
              imgUrl != null
                  ? Image.network(
                      imgUrl,
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Container(
                          height: 200.0,
                          width: double.infinity,
                          color: Colors.grey,
                        );
                      },
                    )
                  : Container(
                      height: 200.0,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      desc,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white70,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewsDetails(url: postUrl)),
                          ),
                          icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16.0),
                          label: const Text(
                            'Read More',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
