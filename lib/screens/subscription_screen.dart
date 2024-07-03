import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morning_buddies/utils/design_palette.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Subscribe",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSubscriptionPlanButton(
                  context,
                  screenHeight,
                  planName: "Monthly Plan",
                  amount: 10.00,
                  duration: const Duration(days: 30),
                ),
                const SizedBox(height: 4),
                _buildSubscriptionPlanButton(
                  context,
                  screenHeight,
                  planName: "Annual Plan",
                  amount: 100.00,
                  duration: const Duration(days: 365),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPlanButton(
    BuildContext context,
    double screenHeight, {
    required String planName,
    required double amount,
    required Duration duration,
  }) {
    final formattedDate = DateFormat('d, MMMM, yyyy').format(DateTime.now());
    /*
      💡 이부분 로직 분리가 추후에 필요합니다.
      신규 가입 -> 단순히 30/365를 더함
      갱신 -> 보유 날짜에 30/365를 더함
      일단 신규가입 Case만 구현해두고, 추후에 API 나오면 로직 분리 하겠습니다.
    */
    final endDate = DateTime.now().add(duration);
    final formattedEndDate = DateFormat('d, MMMM, yyyy').format(endDate);

    return _SubscriptionPlanButton(
      planName: planName,
      amount: "\$${amount.toStringAsFixed(2)}",
      begins: formattedDate,
      ends: formattedEndDate,
      onPressed: () => _showSubscriptionBottomSheet(
        context,
        screenHeight,
        amount: amount,
        begins: formattedDate,
        ends: formattedEndDate,
      ),
    );
  }

  // 모달 바텀 시트 표시 함수
  void _showSubscriptionBottomSheet(
    BuildContext context,
    double screenHeight, {
    required double amount,
    required String begins,
    required String ends,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _SubscriptionBottomSheet(
        screenHeight: screenHeight,
        amount: amount,
        begins: begins,
        ends: ends,
      ),
    );
  }
}

// 구독 플랜 버튼 위젯
class _SubscriptionPlanButton extends StatelessWidget {
  final String planName;
  final String amount;
  final String begins;
  final String ends;
  final VoidCallback onPressed;

  const _SubscriptionPlanButton({
    required this.planName,
    required this.amount,
    required this.begins,
    required this.ends,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(360, 100),
        foregroundColor: Colors.black,
        backgroundColor: ColorStyles.orange,
        side: BorderSide.none,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(planName, style: Constants.titleTextStyle),
          Text(amount, style: Constants.titleTextStyle),
        ],
      ),
    );
  }
}

// 모달 바텀 시트 위젯
class _SubscriptionBottomSheet extends StatelessWidget {
  final double screenHeight;
  final double amount;
  final String begins;
  final String ends;

  const _SubscriptionBottomSheet({
    Key? key,
    required this.screenHeight,
    required this.amount,
    required this.begins,
    required this.ends,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(Constants.descriptionText),
            ),
            ListTile(
              title: const Text("Month", style: Constants.infoTitleStyle),
              trailing: Text(DateFormat('MMMM').format(DateTime.now()),
                  style: Constants.amountTextStyle),
            ),
            ListTile(
              title: const Text("Amount", style: Constants.infoTitleStyle),
              trailing: Text("Amount-\$${amount.toStringAsFixed(2)}",
                  style: Constants.amountTextStyle),
            ),
            ListTile(
              title: const Text("Begins", style: Constants.infoTitleStyle),
              trailing: Text(begins, style: Constants.amountTextStyle),
            ),
            ListTile(
              title: const Text("Ends", style: Constants.infoTitleStyle),
              trailing: Text(ends, style: Constants.amountTextStyle),
            ),
            const ListTile(
              title: Text("Type", style: Constants.infoTitleStyle),
              trailing: Text("Standard", style: Constants.amountTextStyle),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(172, 47),
                    foregroundColor: ColorStyles.secondaryOrange,
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                        width: 2.0, color: ColorStyles.secondaryOrange),
                  ),
                  onPressed: () {},
                  child: const Text('Renew'),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(172, 47),
                    foregroundColor: Colors.white,
                    backgroundColor: ColorStyles.secondaryOrange,
                    side: const BorderSide(
                        width: 2.0, color: ColorStyles.secondaryOrange),
                  ),
                  onPressed: () {},
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Constants {
  Constants._(); // private 생성자를 통해 인스턴스 생성 방지

  static const titleTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  static const descriptionText =
      "Morning Buddies is here to support what you want and what you need to achieve. You can join in any group no matter how many you want while subscribing. Morning Buddies are now happy to welcome your will!";
  static const amountTextStyle = TextStyle(fontSize: 12);
  static const infoTitleStyle = TextStyle(
    color: ColorStyles.secondaryOrange,
    fontWeight: FontWeight.bold,
  );
}
