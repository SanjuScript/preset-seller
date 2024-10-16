import 'package:flutter/material.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'New preset available!',
      'subtitle': 'Check out the latest preset updates.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      'title': 'Discount on premium presets!',
      'subtitle': 'Get 20% off on all premium presets now.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'title': 'Your order has been shipped!',
      'subtitle': 'Track your order in the app.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'title': 'New feature released!',
      'subtitle': 'Check out the new features in the app.',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter for new messages
    List<Map<String, dynamic>> newMessages = notifications
        .where((notification) =>
            DateTime.now().difference(notification['timestamp']).inDays < 1)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const HelperText1(
          text: "Notifications",
          color: Colors.black87,
          fontSize: 25,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length +
            (newMessages.isNotEmpty ? 2 : 1), // Adjusted item count for headers
        itemBuilder: (context, index) {
          // Show "New Messages" header if there are new messages
          if (newMessages.isNotEmpty && index == 0) {
            return _buildHeader('New Messages', newMessages.length);
          }

          // Show new messages under "New Messages"
          if (newMessages.isNotEmpty && index <= newMessages.length) {
            return _buildNotificationTile(newMessages[index - 1]);
          }

          // Show "All Messages" header after new messages
          if (newMessages.isNotEmpty && index == newMessages.length + 1) {
            return _buildHeader('All Messages', notifications.length);
          }

          // Get the actual notification index for all messages
          int notificationIndex = newMessages.isNotEmpty
              ? index -
                  newMessages.length -
                  2 // Adjust for new messages and header
              : index - 1; // Adjust for header only

          // Show the notification tile for all messages
          return _buildNotificationTile(notifications[notificationIndex]);
        },
      ),
    );
  }

  Widget _buildHeader(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notification) {
    // Determine whether to show date or time based on the notification age
    bool isNew =
        DateTime.now().difference(notification['timestamp']).inDays < 1;

    String timeString;
    if (isNew) {
      timeString =
          '${notification['timestamp'].hour}:${notification['timestamp'].minute < 10 ? '0' : ''}${notification['timestamp'].minute}';
    } else {
      timeString =
          '${notification['timestamp'].day}/${notification['timestamp'].month}/${notification['timestamp'].year} ${notification['timestamp'].hour}:${notification['timestamp'].minute < 10 ? '0' : ''}${notification['timestamp'].minute}';
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          notification['title'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification['subtitle'],
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4), // Spacing
            Text(
              timeString,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white54,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.notifications, color: Colors.white),
      ),
    );
  }
}
