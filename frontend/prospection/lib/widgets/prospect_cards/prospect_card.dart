// import 'package:flutter/material.dart';
// import '../../models/prospect.dart';
// import '../../utils/themes/glass_theme.dart';

// /// Widget pour afficher une carte de prospect
// class ProspectCard extends StatelessWidget {
//   final ProspectData prospect;
//   final VoidCallback? onTap;

//   const ProspectCard({
//     super.key,
//     required this.prospect,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GlassBox(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 24,
//                   backgroundColor: G.green,
//                   child: Text(
//                     prospect.initials,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         prospect.name,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Text(
//                         prospect.institution,
//                         style: const TextStyle(
//                           color: G.textMedium,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 StatusBadge(status: prospect.status),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Text(
//               prospect.interest,
//               style: const TextStyle(
//                 color: G.textMedium,
//                 fontSize: 13,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
