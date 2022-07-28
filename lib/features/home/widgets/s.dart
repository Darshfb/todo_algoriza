// DropdownButtonFormField2(
// decoration: InputDecoration(
// //Add isDense true and zero Padding.
// //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
// isDense: true,
// contentPadding: EdgeInsets.zero,
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(15),
// ),
// //Add more decoration as you want here
// //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
// ),
// isExpanded: true,
// hint: const Text(
// 'Select Your Remind',
// style: TextStyle(fontSize: 14),
// ),
// icon: const Icon(
// Icons.arrow_drop_down,
// color: Colors.black45,
// ),
// iconSize: 30,
// buttonHeight: 50,
// buttonPadding: const EdgeInsets.only(left: 20, right: 10),
// dropdownDecoration: BoxDecoration(
// borderRadius: BorderRadius.circular(15),
// ),
// items: remindtems
//     .map((item) =>
// DropdownMenuItem<String>(
// value: item,
// child: Text(
// item,
// style: const TextStyle(
// fontSize: 14,
// ),
// ),
// ))
// .toList(),
// validator: (value) {
// if (value == null) {
// return 'Please select Remind';
// }
// },
// onChanged: (value) {
// remindController.text = value.toString();
//
// //Do something when changing the item if you want.
// },
// onSaved: (value) {
// },
// ),
