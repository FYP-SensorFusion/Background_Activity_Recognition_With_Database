import 'package:lifespark/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../services/activity_database_helper.dart';
import '../widgets/avtivity_widget.dart';
import 'activity_screen.dart'; // import the ActivityScreen

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreen();
}

class _ActivitiesScreen extends State<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Activities'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/purple-sky.png'),
                  fit: BoxFit.fill),
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ActivityScreen()));
            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<List<ActivityModel>?>(
          future: DatabaseHelper.getLastDayActivities(),
          builder: (context, AsyncSnapshot<List<ActivityModel>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                return ListView.builder(
                  itemBuilder: (context, index) => ActivityWidget(
                    activity: snapshot.data![index],
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ActivityScreen(
                                    activity: snapshot.data![index],
                                  )));
                      setState(() {});
                    },
                    onLongPress: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                  'Are you sure you want to delete this note?'),
                              actions: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red)),
                                  onPressed: () async {
                                    await DatabaseHelper.deleteActivity(
                                        snapshot.data![index]);
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: const Text('Yes'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('No'),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                  itemCount: snapshot.data!.length,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ));
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Database'),
//       ),
//       body: FutureBuilder<List<ActivityModel>>(
//         future: _activityFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             final activities = snapshot.data ?? [];
//             if (activities.isEmpty) {
//               return const Center(child: Text('No activities recorded yet.'));
//             }
//             return ListView.builder(
//               itemCount: activities.length,
//               itemBuilder: (context, index) {
//                 final activity = activities[index];
//                 return GestureDetector(
//                   onLongPress: () async {
//                     final confirmDelete = await showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: const Text('Confirm Delete'),
//                           content: const Text(
//                               'Are you sure you want to delete this activity?'),
//                           actions: [
//                             ElevatedButton(
//                               style: ButtonStyle(
//                                   backgroundColor:
//                                       MaterialStateProperty.all(Colors.red)),
//                               onPressed: () async {
//                                 await DatabaseHelper.deleteActivity(
//                                     activity.id! as ActivityModel);
//                               },
//                               child: const Text('Yes'),
//                             ),
//                             ElevatedButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: const Text('No'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                     if (confirmDelete) {
//                       setState(() {
//                         _activityFuture = DatabaseHelper.getAllActivities();
//                       });
//                     }
//                   },
//                   child: ListTile(
//                     title: Text(activity.type),
//                     subtitle: Text(
//                         'Duration: ${activity.duration}\nLast updated: ${activity.lastUpdatedTime}'),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const ActivityScreen()),
//           );
//           setState(() {
//             _activityFuture = DatabaseHelper.getAllActivities();
//           });
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
