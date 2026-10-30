import 'package:pm_tugas_04_4241250019/kendaraan.dart';
import 'package:pm_tugas_04_4241250019/parkiran.dart';

Future<void> main() async {
  final parkiran = Parkiran(3);

  // Listener = layar pos jaga. Dipasang SEBELUM ada kejadian,
  // karena broadcast stream tidak menyimpan event untuk listener terlambat.
  parkiran.kejadian.listen((pesan) => print(pesan));

  // Waktu simulasi tetap supaya biaya selalu sama setiap dijalankan.
  final awal = DateTime(2026, 10, 30, 8, 0);

  // Polimorfisme: satu List berisi berbagai jenis kendaraan.
  final antrean = <Kendaraan>[
    Motor('BK 1234 AB', awal),
    Mobil('BK 88 UN', awal),
    MobilMember('BK 7 MIPA', awal),
    Truk('BK 9999 XX', awal), // kapasitas 3, truk ini akan ditolak
  ];

  for (final k in antrean) {
    try {
      await parkiran.masuk(k);
    } on ParkirPenuh catch (e) {
      print('Ditolak: ${k.jenis} ${k.plat} - $e');
    }
  }

  // Semua kendaraan yang masuk keluar 3 jam kemudian.
  final keluar = awal.add(const Duration(hours: 3));
  for (final plat in ['BK 1234 AB', 'BK 88 UN', 'BK 7 MIPA']) {
    try {
      await parkiran.keluar(plat, waktu: keluar);
    } on Exception catch (e) {
      print('Gagal keluar: $e');
    }
  }
  await parkiran.tutup();
  print('Pendapatan: Rp${parkiran.pendapatan}');
}
