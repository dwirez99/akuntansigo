# Changelog

All notable changes to AkuntansiGo will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.1] - 2024-12-15

### ✨ Added
- **Export to Excel Feature**
  - Export transaksi ke format Excel (.xlsx) dengan multiple sheets
  - Export kategori ke format Excel
  - Sheet Ringkasan dengan total dan analisis per kategori
  - Sheet Pemasukan dengan semua transaksi pemasukan
  - Sheet Pengeluaran dengan semua transaksi pengeluaran
  - Sheet Semua Data dengan gabungan semua transaksi
  - Auto styling: color coding, bold headers, format currency
  - Format percentage untuk analisis kategori
  
- **Export Filter Options**
  - Filter berdasarkan rentang waktu (Semua Data/Bulan Ini/Custom)
  - Filter berdasarkan jenis transaksi (Pemasukan/Pengeluaran)
  - Filter berdasarkan kategori tertentu
  - Info counter jumlah data yang akan di-export
  
- **Share & Open Folder Functionality**
  - Share file via apps (WhatsApp, Email, dll) di Android/iOS
  - Open file location di file manager untuk Desktop (Linux/Windows/Mac)
  - Platform-specific button (Bagikan vs Buka Folder)
  - Error handling untuk platform yang tidak support sharing
  
- **Search & Sort Feature**
  - Search bar untuk mencari transaksi berdasarkan nama, keterangan, atau kategori
  - Real-time filtering saat mengetik
  - Sort options: Tanggal, Nama Transaksi, Nominal
  - Toggle Ascending/Descending order
  - Visual indicator untuk sorting aktif
  - Counter hasil pencarian
  
- **Export Dialog UI**
  - Dialog dengan filter options lengkap
  - Date picker untuk custom date range
  - Radio buttons untuk rentang waktu
  - Checkboxes untuk jenis transaksi
  - Dropdown untuk filter kategori
  - Loading indicator saat export
  - Success dialog dengan file size info
  
- **Comprehensive Documentation**
  - `EXPORT_FEATURE.md` - Technical documentation
  - `PANDUAN_EXPORT.md` - User guide dalam Bahasa Indonesia
  - `TROUBLESHOOTING.md` - Common issues & solutions
  - `CHANGELOG.md` - Version history
  - `LICENSE` - MIT License
  - Updated `README.md` dengan fitur terbaru

### 🐛 Fixed
- **Database Initialization**
  - Fixed "databaseFactory not initialized" error di desktop platforms
  - Added `sqflite_common_ffi` support untuk Linux/Windows/Mac
  - Platform-specific database factory initialization
  
- **Share Function Error**
  - Fixed "shareXFiles() has not been implemented on Linux" error
  - Added platform detection untuk share functionality
  - Fallback ke "Open Folder" untuk desktop platforms
  
- **Null Safety**
  - Fixed nullable `deskripsi` field errors di KategoriScreen
  - Added null-coalescing operator untuk handle nullable strings
  - Fixed type mismatch errors

### 🎨 Improved
- **UI/UX Enhancements**
  - Better AppBar dengan export button
  - Improved TransaksiScreen dengan search dan sort
  - Visual feedback untuk active sort option
  - Info bar showing current filter/sort settings
  - Empty state dengan helpful messages
  - Clear button di search bar
  
- **Performance**
  - Optimized filtering dan sorting logic
  - Efficient list rendering dengan filtered data
  - Background export processing (no UI freeze)

### 📦 Dependencies Added
- `syncfusion_flutter_xlsio: ^24.2.9` - Excel file creation
- `share_plus: ^7.2.2` - File sharing functionality
- `permission_handler: ^11.3.0` - Storage permissions
- `sqflite_common_ffi: ^2.3.0` - Desktop SQLite support

### 📦 Dependencies Updated
- `flutter_native_splash: ^2.4.4` (downgraded for compatibility)

### 🔧 Technical Changes
- Created `ExcelExporter` class untuk export logic
- Created `ExportHelper` class untuk utilities
- Created `ExportDialog` widget
- Added platform-specific file operations
- Improved error handling dan user feedback
- Added comprehensive documentation

---

## [1.0.0] - 2024-12-01

### ✨ Initial Release

#### Core Features
- **Manajemen Kategori (CRUD)**
  - Tambah, Edit, Hapus, Lihat kategori
  - Form dengan nama kategori dan deskripsi
  - Validasi input
  - Delete confirmation dialog
  
- **Manajemen Transaksi (CRUD)**
  - Tambah, Edit, Hapus, Lihat transaksi
  - Jenis: Pemasukan dan Pengeluaran
  - Field: Tanggal, Nama Transaksi, Kategori, Nominal, Keterangan
  - Date picker untuk pilih tanggal
  - Validasi input
  - Delete confirmation dialog
  
- **Dashboard & Analisis**
  - Summary cards: Total Pemasukan, Pengeluaran, Saldo
  - Pie chart analisis per kategori
  - Line chart trend bulanan
  - Filter berdasarkan rentang waktu
  - Top 5 kategori dengan transaksi tertinggi
  
- **Laporan PDF**
  - Generate laporan keuangan dalam format PDF
  - Filter berdasarkan tanggal dan kategori
  - Detail transaksi dengan formatting
  - Ringkasan total
  - Print atau share laporan
  
- **Database**
  - SQLite database dengan sqflite
  - CRUD operations untuk kategori dan transaksi
  - Query optimizations
  - Data persistence
  
- **UI/UX**
  - Material Design 3
  - Color coding (hijau untuk pemasukan, merah untuk pengeluaran)
  - Responsive layout
  - Bottom navigation bar
  - Floating action buttons
  - Card-based UI
  
- **Internationalization**
  - Bahasa Indonesia support
  - Date formatting (DD/MM/YYYY)
  - Currency formatting (Rp format)
  - Indonesian locale

#### Technical Stack
- Flutter 3.38.1
- Dart 3.10.1
- Riverpod untuk state management
- sqflite untuk database
- fl_chart untuk visualisasi
- pdf & printing untuk PDF generation
- intl untuk internationalization

#### Platforms Supported
- ✅ Android
- ✅ iOS
- ✅ Linux Desktop
- ✅ Windows Desktop
- ✅ macOS Desktop

---

## [Unreleased]

### Planned Features
- [ ] CSV Export
- [ ] Autentikasi & Multi-user
- [ ] Level akses (Admin/Bendahara)
- [ ] Cloud Backup (Google Drive/Dropbox)
- [ ] Auto Export Scheduling
- [ ] Budget Planning & Tracking
- [ ] Reminder untuk budget limit
- [ ] Multi-Currency support
- [ ] Recurring Transactions
- [ ] Receipt Scanning (OCR)
- [ ] Dark Mode
- [ ] Home Screen Widgets
- [ ] Email Export
- [ ] Import from Excel/CSV
- [ ] Data encryption
- [ ] Offline-first sync

---

## Version Naming Convention

**Format:** MAJOR.MINOR.PATCH

- **MAJOR**: Breaking changes, major features
- **MINOR**: New features, improvements (backward compatible)
- **PATCH**: Bug fixes, minor improvements

---

## Legend

- ✨ **Added**: New features
- 🐛 **Fixed**: Bug fixes
- 🎨 **Improved**: UI/UX improvements
- 🔧 **Technical**: Technical changes
- 📦 **Dependencies**: Dependency updates
- 🔒 **Security**: Security fixes
- ⚠️ **Deprecated**: Deprecated features
- 🗑️ **Removed**: Removed features
- 📚 **Documentation**: Documentation updates

---

**For detailed feature documentation, see:**
- [README.md](README.md) - Overview & installation
- [EXPORT_FEATURE.md](EXPORT_FEATURE.md) - Export feature details
- [PANDUAN_EXPORT.md](PANDUAN_EXPORT.md) - User guide (Bahasa Indonesia)
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues

---

*Last updated: December 15, 2024*