import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

@RoutePage(name: 'PDFViewScreenRouter')
class PDFViewScreen extends StatefulWidget {
  const PDFViewScreen({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<PDFViewScreen> createState() => _PDFViewScreenState();
}

class _PDFViewScreenState extends State<PDFViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List> _downloadFileFromUrl(String url) async {
    try {
      var response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      return response.data as Uint8List;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<Uint8List>(
        future: _downloadFileFromUrl(widget.url),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? PDFView(
                  pdfData: snapshot.data,
                  autoSpacing: true,
                  enableSwipe: true,
                  pageSnap: true,
                  swipeHorizontal: false,
                  nightMode: false,
                  onPageChanged: (int? page, int? total) {},
                )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
