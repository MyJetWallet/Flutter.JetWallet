// class LoadingChartView extends HookWidget {
//   const LoadingChartView({
//     Key? key,
//     required this.height,
//     required this.showLoader,
//   }) : super(key: key);
//
//   final double height;
//   final bool showLoader;
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = useProvider(sColorPod);
//     final chartNotifier = useProvider(
//       chartNotipod.notifier,
//     );
//     final chartState = useProvider(
//       chartNotipod,
//     );
//
//     return Container(
//       height: height,
//       width: double.infinity,
//       color: colors.grey5,
//       child: Stack(
//         children: [
//           if (showLoader)
//             const Positioned(
//               left: 0,
//               right: 0,
//               top: 80,
//               child: LoaderSpinner(),
//             ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: SizedBox(
//               height: 36,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _resolutionButton(
//                     text: Period.day,
//                     showUnderline: chartState.resolution == Period.day,
//                     onTap: chartState.resolution == Period.day
//                         ? null
//                         : () {
//                             chartNotifier.fetchAssetCandles(
//                               Period.day,
//                             );
//                           },
//                   ),
//                   _resolutionButton(
//                     text: Period.week,
//                     showUnderline: chartState.resolution == Period.week,
//                     onTap: chartState.resolution == Period.week
//                         ? null
//                         : () {
//                             chartNotifier.fetchAssetCandles(
//                               Period.week,
//                             );
//                           },
//                   ),
//                   _resolutionButton(
//                     text: Period.month,
//                     showUnderline: chartState.resolution == Period.month,
//                     onTap: chartState.resolution == Period.month
//                         ? null
//                         : () {
//                             chartNotifier.fetchAssetCandles(
//                               Period.month,
//                             );
//                           },
//                   ),
//                   _resolutionButton(
//                     text: Period.year,
//                     showUnderline: chartState.resolution == Period.year,
//                     onTap: chartState.resolution == Period.year
//                         ? null
//                         : () {
//                             chartNotifier.fetchAssetCandles(
//                               Period.year,
//                             );
//                           },
//                   ),
//                   _resolutionButton(
//                     text: Period.all,
//                     showUnderline: chartState.resolution == Period.all,
//                     onTap: chartState.resolution == Period.all
//                         ? null
//                         : () {
//                             chartNotifier.fetchAssetCandles(
//                               Period.all,
//                             );
//                           },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _resolutionButton({
//     void Function()? onTap,
//     required String text,
//     required bool showUnderline,
//   }) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const SizedBox(
//           height: 12.5,
//         ),
//         Container(
//           width: 36,
//           margin: const EdgeInsets.symmetric(
//             horizontal: 5,
//           ),
//           child: InkWell(
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             onTap: () {
//               if (onTap != null) {
//                 onTap();
//               }
//             },
//             child: Text(
//               text,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 1.5,
//         ),
//         if (showUnderline)
//           Container(
//             width: 36,
//             height: 3,
//             margin: const EdgeInsets.only(
//               top: 5,
//             ),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(2),
//               color: Colors.black,
//             ),
//           )
//         else
//           const SizedBox(
//             height: 8,
//           )
//       ],
//     );
//   }
// }
