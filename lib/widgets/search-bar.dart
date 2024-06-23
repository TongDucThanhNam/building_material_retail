// import 'package:flutter/material.dart';
//
// class SearchBar extends StatefulWidget {
//   const SearchBar({Key? key}) : super(key: key);
//
//   @override
//   _SearchBarState createState() => _SearchBarState();
// }
//
// class _SearchBarState extends State<SearchBar> {
//   bool _isSearching = false;
//   final _textController = TextEditingController();
//
//   @override
//   void dispose() {
//     _textController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: TextField(
//         controller: _textController,
//         onChanged: (text) {
//           setState(() {
//             _isSearching = text.isNotEmpty;
//           });
//         },
//         decoration: InputDecoration(
//           hintText: 'Tìm kiếm.ffffffff..',
//           prefixIcon: const Icon(Icons.search),
//           suffixIcon: _isSearching
//               ? IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () {
//                     _textController.clear();
//                     setState(() {
//                       _isSearching = false;
//                     });
//                   },
//                 )
//               : null,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25.0),
//             borderSide: BorderSide.none,
//           ),
//           filled: true,
//           fillColor: Colors.grey[200],
//         ),
//       ),
//     );
//   }
// }
