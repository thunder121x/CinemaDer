import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cinemader/readdata/getusername.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:cinemader/feature/home/presentation/profile_screen.dart';

class WorkerDetailsPage extends StatelessWidget {
  final Map<String, dynamic>  usher;
  final String usherId;
  final String name;
  final String image;
  final Color color;
  final String job;
  final String jobTitle;

  const WorkerDetailsPage(
      {Key? key,
      required this.name,
      required this.image,
      required this.color,
      required this.job,
      required this.jobTitle, required this.usher, required this.usherId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration difference = (usher['contract_expiration_date'].toDate()).difference(usher['contract_signing_date'].toDate());
    int daysDifference = difference.inDays;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          color: color.withOpacity(0.12),
          child: Stack(
            children: [
              Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                job,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 40),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    spreadRadius: 0.1,
                                    blurRadius: 2,
                                    offset: Offset(0, 5))
                              ],
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.blueAccent,
                              image: DecorationImage(
                                  image: NetworkImage(image), fit: BoxFit.cover)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(jobTitle,
                            style: const TextStyle(color: Colors.black54)),
                      ),
                    ],
                  ),
                ],
              ),
              DraggableScrollableSheet(
                  initialChildSize: 0.65,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 40, left: 20, right: 20),
                        child: ListView(
                          controller: scrollController,
                          children: [
                            const Text(
                              "Stats",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // SizedBox(
                            //   height: 15,
                            // ),
                            Row(children: [
                              Text("Employee ID:",
                                  style: TextStyle(fontSize: 16)),
                            //   Padding(
                            //     padding:
                            //         const EdgeInsets.symmetric(horizontal: 5.0),
                            //     child: new GestureDetector(
                            //         child: new Icon(
                            //           Icons.copy,
                            //           size: 16,
                            //         ),
                            //         onTap: () {
                            //           Clipboard.setData(
                            //                   new ClipboardData(text: usherId))
                            //               .then((value) =>
                            //                   Fluttertoast.showToast(
                            //                       msg: "Copied",
                            //                       gravity:
                            //                           ToastGravity.CENTER));
                            //         }),
                            //   ),
                              Expanded(
                                  child: AutoSizeText(
                                "${usherId}",
                                style: TextStyle(fontSize: 18),
                                minFontSize: 14,
                                maxLines: 1,
                              )),
                            ]),
                            // SizedBox(
                            //   height: 15,
                            // ),
                            Row(children: [
                              Text("E-mail: ", style: TextStyle(fontSize: 18)),
                              GetUserData(
                                  documentId: usherId,
                                  field: 'email',
                                  textStyle: TextStyle(fontSize: 18),
                                  maxLines: 1),
                            ]),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                                "Contract Expiration Date: ${formatDateTimestamp(usher['contract_signing_date'])}",
                                style: TextStyle(fontSize: 18)),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                                "Contract Expiration Date: ${formatDateTimestamp(usher['contract_expiration_date'])}",
                                style: TextStyle(fontSize: 18)),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                iconContainer(Colors.redAccent, Icons.monetization_on_rounded,
                                    " Salary", usher['salary'] ),
                                iconContainer(
                                    Colors.deepPurpleAccent.withOpacity(0.5),
                                    Icons.date_range_rounded,
                                    "  day",
                                    daysDifference),
                                // iconContainer(Colors.blue, Ionicons.ribbon,
                                //     "  credits", 43),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Last Updates",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            lastUpdatesContainer(name, "General",
                                usher['general']),
                            const SizedBox(
                              height: 20,
                            ),
                            lastUpdatesContainer(name, "Attitude",
                                usher['attitude']),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget iconContainer(Color color, IconData icon, String title, int number) {
    return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.withOpacity(0.06),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 40,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  number.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  title,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            )
          ],
        ));
  }

  Widget lastUpdatesContainer(String name, String title, String desc) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.07),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name + " " + desc,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
