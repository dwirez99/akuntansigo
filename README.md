# 📊 AKUNTANSIGO

*Aplikasi Perhitungan Pemasukan dan Pengeluaran Dana Sederhana*

[![Flutter](https://img.shields.io/badge/Flutter-3.38.1-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.10.1-blue.svg)](https://dart.dev/)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Linux%20%7C%20Windows%20%7C%20macOS-green.svg)](https://flutter.dev/)

---

## 📱 Tentang Aplikasi

AkuntansiGo adalah aplikasi manajemen keuangan sederhana yang dirancang untuk membantu Anda melacak pemasukan dan pengeluaran dengan mudah. Aplikasi ini cocok untuk:
- 💼 Usaha kecil dan menengah
- 🏫 Organisasi sekolah/kampus
- 👥 Komunitas dan yayasan
- 💰 Keuangan pribadi
- 📈 Pengelolaan dana proyek

---

## ✨ Fitur Utama

### 1. 📂 Manajemen Kategori (CRUD)
- ✅ Tambah, Edit, Hapus, dan Lihat kategori
- ✅ Kategori dengan nama dan deskripsi
- ✅ Export daftar kategori ke Excel
- 📝 Contoh: Pembangunan, Sumbangan, Dana BOS, Event, Gaji, dll.

### 2. 💰 Manajemen Transaksi (CRUD)
- ✅ Tambah, Edit, Hapus, dan Lihat transaksi
- ✅ Jenis: Pemasukan dan Pengeluaran
- ✅ **Pencarian & Filter**: Cari transaksi dengan search bar
- ✅ **Sorting**: Urutkan berdasarkan Tanggal/Nama/Nominal (Ascending/Descending)
- 📊 Field: Tanggal, Nama Transaksi, Kategori, Nominal, Keterangan

### 3. 📊 Analisis Keuangan
- ✅ Dashboard dengan ringkasan total pemasukan, pengeluaran, dan saldo
- ✅ Grafik perbandingan pemasukan vs pengeluaran
- ✅ Grafik pie chart analisis per kategori
- ✅ Grafik line chart trend bulanan
- ✅ Filter analisis berdasarkan rentang waktu
- ✅ Top 5 kategori dengan transaksi tertinggi

### 4. 📄 Laporan PDF
- ✅ Generate laporan keuangan dalam format PDF
- ✅ Filter berdasarkan tanggal dan kategori
- ✅ Laporan detail transaksi dan ringkasan analisis
- ✅ Print atau share laporan PDF

### 5. 📤 Export ke Excel (NEW! 🎉)
- ✅ **Export Transaksi** dengan multiple sheets:
  - Sheet Ringkasan (Total & Analisis)
  - Sheet Pemasukan
  - Sheet Pengeluaran  
  - Sheet Semua Data
- ✅ **Export Kategori** ke Excel
- ✅ **Filter Export**:
  - Rentang waktu (Semua/Bulan Ini/Custom)
  - Jenis transaksi (Pemasukan/Pengeluaran)
  - Filter per kategori
- ✅ **Auto Styling**: Color coding, format currency, percentage
- ✅ **Share Functionality** (Android/iOS) atau **Buka Folder** (Desktop)
- 📊 Compatible dengan Excel, Google Sheets, LibreOffice Calc

### 6. 🔍 Search & Sort (NEW! 🎉)
- ✅ **Search Bar**: Cari transaksi berdasarkan nama, keterangan, atau kategori
- ✅ **Sort Options**: 
  - Urutkan berdasarkan Tanggal, Nama, atau Nominal
  - Ascending (Naik) atau Descending (Turun)
- ✅ Real-time filtering
- ✅ Info counter hasil pencarian

---

## 🛠️ Tech Stack

| Komponen | Teknologi |
|----------|-----------|
| **Framework** | Flutter 3.38.1 |
| **Language** | Dart 3.10.1 |
| **State Management** | Riverpod 2.5.1 |
| **Database** | SQLite (sqflite + sqflite_common_ffi) |
| **PDF Generation** | pdf 3.10.4 + printing 5.12.0 |
| **Excel Export** | syncfusion_flutter_xlsio 24.2.9 |
| **Charts** | fl_chart 0.66.2 |
| **File Sharing** | share_plus 7.2.2 |
| **Internationalization** | intl 0.18.1 (Bahasa Indonesia) |

---

## 📦 Instalasi & Setup

### Prerequisites
- Flutter SDK 3.0 atau lebih baru
- Dart 3.0 atau lebih baru
- Android Studio / VS Code
- (Optional) LibreOffice / Microsoft Excel untuk membuka file export

### Langkah Instalasi

1. **Clone Repository**
```bash
git clone https://github.com/yourusername/akuntansigo.git
cd akuntansigo
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Run Application**
```bash
# Android/iOS
flutter run

# Linux Desktop
flutter run -d linux

# Windows Desktop
flutter run -d windows

# macOS Desktop
flutter run -d macos
```

4. **Build Release**
```bash
# Android APK
flutter build apk --release

# Linux
flutter build linux --release

# Windows
flutter build windows --release
```

---

## 🎯 Cara Menggunakan

### Menambah Kategori
1. Buka menu **"Kelola Kategori"**
2. Klik tombol **+** (Floating Action Button)
3. Isi nama kategori dan deskripsi
4. Klik **"Simpan Kategori"**

### Menambah Transaksi
1. Buka menu **"Kelola Transaksi"**
2. Klik tombol **+**
3. Pilih jenis (Pemasukan/Pengeluaran)
4. Pilih kategori, isi nominal, tanggal, dan keterangan
5. Klik **"Simpan Transaksi"**

### Melihat Analisis
1. Kembali ke **Home** atau buka menu **"Analisis"**
2. Lihat dashboard dengan grafik dan ringkasan
3. Gunakan filter tanggal untuk analisis periode tertentu

### Export Data ke Excel
1. Buka **"Kelola Transaksi"** atau **"Kelola Kategori"**
2. Klik icon **Download** (⬇️) di pojok kanan atas
3. Pilih filter export (rentang waktu, jenis, kategori)
4. Klik **"Export Sekarang"**
5. **Mobile**: Klik "Bagikan" → Pilih app (WhatsApp, Email, dll)
6. **Desktop**: Klik "Buka Folder" → Copy/move file

### Generate Laporan PDF
1. Dari menu analisis, klik tombol **"Generate PDF"**
2. Pilih filter (tanggal, kategori)
3. Preview atau langsung print/share

---

## 📂 Struktur Project

```
akuntansigo/
├── lib/
│   ├── core/
│   │   ├── db/
│   │   │   └── database_helper.dart      # SQLite database management
│   │   └── export/
│   │       ├── excel_exporter.dart       # Excel export logic
│   │       └── export_helper.dart        # Export utilities
│   ├── models/
│   │   ├── kategori.dart                 # Kategori model
│   │   ├── transaksi.dart                # Transaksi model
│   │   └── analisis_data.dart            # Analysis data models
│   ├── providers/
│   │   ├── kategori_provider.dart        # Kategori state management
│   │   ├── transaksi_provider.dart       # Transaksi state management
│   │   └── analisis_provider.dart        # Analysis state management
│   ├── screens/
│   │   ├── home_screen.dart              # Dashboard/Home
│   │   ├── kategori_screen.dart          # Kategori management
│   │   ├── kategori_form_screen.dart     # Add/Edit kategori
│   │   ├── transaksi_screen.dart         # Transaksi management + Search/Sort
│   │   ├── transaksi_form_screen.dart    # Add/Edit transaksi
│   │   └── analisis_screen.dart          # Analysis & charts
│   ├── widgets/
│   │   ├── summary_card.dart             # Summary widgets
│   │   ├── kategori_pie_chart.dart       # Pie chart widget
│   │   ├── bulanan_line_chart.dart       # Line chart widget
│   │   ├── transaksi_list_item.dart      # Transaksi list item
│   │   └── export_dialog.dart            # Export dialog (NEW!)
│   └── main.dart                         # App entry point
├── assets/
│   └── images/
│       └── logo.png                      # App logo
├── EXPORT_FEATURE.md                     # Export feature documentation
├── PANDUAN_EXPORT.md                     # Export user guide (Bahasa Indonesia)
├── TROUBLESHOOTING.md                    # Common issues & solutions
└── README.md                             # This file
```

---

## 🎨 Screenshots

*Coming soon - Add screenshots of your app here*

---

## 🚀 Fitur Mendatang (Roadmap)

- [ ] **CSV Export** - Export data ke format CSV
- [ ] **Autentikasi** - Login & multi-user support
- [ ] **Level Akses** - Admin/Bendahara role management
- [ ] **Cloud Backup** - Sync ke Google Drive/Dropbox
- [ ] **Auto Export** - Scheduled export (daily/weekly/monthly)
- [ ] **Budget Planning** - Set budget dan track spending
- [ ] **Reminder** - Notifikasi jika pengeluaran melebihi budget
- [ ] **Multi-Currency** - Support mata uang selain Rupiah
- [ ] **Recurring Transactions** - Transaksi berulang otomatis
- [ ] **Receipt Scanning** - OCR untuk scan nota/kwitansi
- [ ] **Dark Mode** - Theme gelap untuk kenyamanan mata
- [ ] **Widgets** - Home screen widget untuk quick view

---

## 📚 Dokumentasi Lengkap

- **[EXPORT_FEATURE.md](EXPORT_FEATURE.md)** - Technical documentation untuk fitur export
- **[PANDUAN_EXPORT.md](PANDUAN_EXPORT.md)** - Panduan pengguna fitur export (Bahasa Indonesia)
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Solusi masalah umum dan troubleshooting

---

## 🐛 Known Issues

### Non-Critical (Bisa Diabaikan)
- ⚠️ Keyboard event warning di Linux desktop (Flutter framework issue)
- ⚠️ Syncfusion license watermark (gunakan community license gratis)

### Platform Limitations
- ℹ️ Share functionality tidak tersedia di desktop (gunakan "Buka Folder" sebagai alternatif)

Lihat [TROUBLESHOOTING.md](TROUBLESHOOTING.md) untuk detail dan solusi.

---

## 🤝 Contributing

Kontribusi sangat diterima! Jika Anda ingin berkontribusi:

1. Fork repository ini
2. Buat branch baru (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

---

## 📝 Changelog

### v1.0.1 (2024-12-15)
- ✨ **NEW**: Export to Excel feature
- ✨ **NEW**: Search & Sort functionality untuk transaksi
- ✨ **NEW**: Platform-specific share/open folder
- 🐛 Fixed: Database initialization untuk desktop platforms
- 📚 Added: Comprehensive documentation (Export guide, Troubleshooting)
- 🎨 Improved: UI/UX dengan better filtering dan sorting

### v1.0.0 (Initial Release)
- ✅ CRUD Kategori
- ✅ CRUD Transaksi
- ✅ Dashboard & Analisis
- ✅ PDF Report generation
- ✅ Charts & visualizations
- ✅ SQLite database
- ✅ Bahasa Indonesia support

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👨‍💻 Developer

Developed with ❤️ using Flutter

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - UI Framework
- [Riverpod](https://riverpod.dev/) - State Management
- [fl_chart](https://pub.dev/packages/fl_chart) - Beautiful charts
- [Syncfusion](https://www.syncfusion.com/flutter-widgets) - Excel export
- [sqflite](https://pub.dev/packages/sqflite) - SQLite database

---

## 📞 Support

Jika ada pertanyaan atau butuh bantuan:
- 📖 Baca [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- 📖 Baca [PANDUAN_EXPORT.md](PANDUAN_EXPORT.md)
- 🐛 Buat issue di GitHub
- 📧 Contact: your.email@example.com

---

**⭐ Jika aplikasi ini bermanfaat, jangan lupa beri star di GitHub! ⭐**

---

*Last updated: December 15, 2024*
*Version: 1.0.1*