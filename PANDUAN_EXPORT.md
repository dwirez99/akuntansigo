# 📤 Panduan Export Data - AkuntansiGo

## Ringkasan Cepat

Export data memungkinkan Anda menyimpan dan membagikan data keuangan dalam format Excel (.xlsx) yang dapat dibuka di Microsoft Excel, Google Sheets, atau aplikasi spreadsheet lainnya.

---

## 🚀 Cara Menggunakan Export

### A. Export Transaksi

#### Langkah 1: Buka Menu Transaksi
1. Dari halaman utama, pilih **"Kelola Transaksi"**
2. Anda akan melihat daftar semua transaksi

#### Langkah 2: Klik Tombol Export
1. Di pojok kanan atas, klik icon **Download** (⬇️)
2. Dialog export akan muncul

#### Langkah 3: Pilih Filter (Opsional)
Anda dapat memfilter data yang akan di-export:

**Rentang Waktu:**
- ⭕ **Semua Data** - Export semua transaksi
- ⭕ **Bulan Ini** - Hanya transaksi bulan berjalan
- ⭕ **Pilih Rentang** - Tentukan tanggal mulai dan akhir

**Jenis Transaksi:**
- ☑️ **Pemasukan** - Include transaksi pemasukan
- ☑️ **Pengeluaran** - Include transaksi pengeluaran
- 💡 Centang keduanya untuk export semua jenis

**Filter Kategori:**
- Pilih kategori tertentu atau **"Semua Kategori"**

#### Langkah 4: Export
1. Klik tombol **"Export Sekarang"**
2. Tunggu proses export selesai (biasanya beberapa detik)
3. Dialog sukses akan muncul

#### Langkah 5: Bagikan atau Simpan
**Di Android/iOS:**
- Klik tombol **"Bagikan"**
- Pilih aplikasi (WhatsApp, Email, Google Drive, dll)

**Di Desktop (Linux/Windows/Mac):**
- Klik tombol **"Buka Folder"**
- File manager akan terbuka di lokasi file
- Copy atau pindahkan file sesuai kebutuhan

---

### B. Export Kategori

#### Langkah-langkah:
1. Buka **"Kelola Kategori"**
2. Klik icon **Download** (⬇️) di pojok kanan atas
3. File kategori akan langsung di-export
4. Pilih **"Bagikan"** (mobile) atau **"Buka Folder"** (desktop)

---

## 📊 Isi File Excel

File Excel yang dihasilkan memiliki beberapa sheet:

### Sheet 1: Ringkasan
Berisi informasi ringkasan:
- 💰 Total Pemasukan
- 💸 Total Pengeluaran
- 💵 Saldo (Pemasukan - Pengeluaran)
- 📊 Jumlah transaksi per jenis
- 📈 Analisis per kategori dengan persentase

### Sheet 2: Pemasukan
Daftar lengkap transaksi pemasukan dengan kolom:
- No
- Tanggal
- Nama Transaksi
- Kategori
- Jenis
- Nominal
- Keterangan

### Sheet 3: Pengeluaran
Daftar lengkap transaksi pengeluaran (sama seperti sheet Pemasukan)

### Sheet 4: Semua Data
Gabungan semua transaksi (Pemasukan + Pengeluaran)

---

## 🎨 Penjelasan Warna

File Excel menggunakan color coding untuk memudahkan pembacaan:

- 🟢 **Hijau** - Nominal pemasukan
- 🔴 **Merah** - Nominal pengeluaran
- 🔵 **Biru** - Header kolom
- 🟡 **Kuning** - Total/Summary

---

## 📁 Lokasi File

### Android
File tersimpan di internal storage aplikasi:
```
/data/data/com.example.akuntansigo/app_flutter/documents/
```

Untuk mengakses, gunakan fitur **"Bagikan"** lalu simpan ke lokasi yang Anda inginkan.

### iOS
File tersimpan di Application Documents Directory. Gunakan fitur **"Bagikan"** untuk menyimpan ke Files app atau iCloud.

### Linux
```
~/.local/share/akuntansigo/app_flutter/documents/
```

Atau klik **"Buka Folder"** untuk membuka langsung.

### Windows
```
C:\Users\[NamaAnda]\AppData\Roaming\akuntansigo\documents\
```

### macOS
```
~/Library/Application Support/akuntansigo/documents/
```

---

## 📝 Format Nama File

File export memiliki format nama:
```
AkuntansiGo_Export_YYYYMMDD_HHMMSS.xlsx
```

**Contoh:**
- `AkuntansiGo_Export_20241215_143022.xlsx`
  - Tanggal: 15 Desember 2024
  - Waktu: 14:30:22

Untuk kategori:
```
AkuntansiGo_Kategori_YYYYMMDD_HHMMSS.xlsx
```

---

## 💡 Tips & Trik

### 1. Export Data Berkala
- Export data setiap bulan untuk backup
- Simpan di Google Drive atau Cloud storage
- Gunakan untuk analisis di luar aplikasi

### 2. Filter untuk Data Spesifik
- Export per kategori untuk analisis detail
- Export per bulan untuk laporan bulanan
- Combine dengan Excel untuk buat pivot table

### 3. Berbagi dengan Akuntan
- Export semua data
- Bagikan via email atau WhatsApp
- File Excel mudah dibaca oleh siapa saja

### 4. Membuat Backup
- Export "Semua Data" secara berkala
- Simpan dengan nama yang jelas (misal: Backup_Desember_2024.xlsx)
- Simpan di multiple lokasi (PC, Cloud, External drive)

### 5. Analisis Lanjutan di Excel
File yang di-export dapat digunakan untuk:
- Membuat pivot table
- Membuat grafik custom
- Menghitung statistik tambahan
- Membandingkan data antar periode

---

## ❓ Pertanyaan Umum (FAQ)

### Q: Apakah data saya aman saat export?
**A:** Ya! File hanya tersimpan di perangkat Anda. Tidak ada data yang dikirim ke server atau cloud tanpa izin Anda.

### Q: Berapa lama proses export?
**A:** Biasanya beberapa detik. Untuk data sangat banyak (>1000 transaksi), bisa sampai 30 detik.

### Q: Apakah bisa export ke PDF?
**A:** Saat ini hanya Excel (.xlsx) yang tersedia. PDF akan ditambahkan di versi mendatang.

### Q: Apakah bisa export ke CSV?
**A:** Belum tersedia saat ini, tapi akan ditambahkan di update berikutnya.

### Q: File Excel tidak bisa dibuka, kenapa?
**A:** Pastikan menggunakan:
- Microsoft Excel 2007 atau lebih baru
- Google Sheets (upload file)
- LibreOffice Calc (gratis)
- WPS Office

### Q: Mengapa tombol "Bagikan" tidak muncul di desktop?
**A:** Di desktop (Linux/Windows/Mac), fitur share tidak tersedia. Sebagai gantinya, gunakan tombol **"Buka Folder"** untuk membuka file manager, lalu copy/move file secara manual.

### Q: Apakah bisa auto-export otomatis setiap bulan?
**A:** Fitur ini belum tersedia, tapi sudah masuk dalam roadmap pengembangan.

### Q: Apakah bisa customize format Excel?
**A:** Saat ini format sudah fixed dengan styling optimal. Custom template akan ditambahkan di versi mendatang.

---

## 🆘 Bantuan

Jika mengalami masalah:

1. **Cek TROUBLESHOOTING.md** untuk solusi masalah umum
2. **Pastikan storage cukup** (minimal 50MB free space)
3. **Restart aplikasi** jika export gagal
4. **Update aplikasi** ke versi terbaru

---

## 📞 Contoh Penggunaan

### Skenario 1: Laporan Bulanan untuk Akuntan
```
1. Pilih "Pilih Rentang"
2. Set tanggal: 1 Nov - 30 Nov 2024
3. Centang Pemasukan & Pengeluaran
4. Pilih "Semua Kategori"
5. Export
6. Bagikan via Email ke akuntan
```

### Skenario 2: Analisis Pengeluaran Kategori Tertentu
```
1. Pilih "Bulan Ini"
2. Centang hanya "Pengeluaran"
3. Pilih kategori: "Makanan & Minuman"
4. Export
5. Buka di Excel untuk analisis detail
```

### Skenario 3: Backup Tahunan
```
1. Pilih "Pilih Rentang"
2. Set tanggal: 1 Jan - 31 Des 2024
3. Centang semua
4. Export
5. Simpan dengan nama: Backup_Keuangan_2024.xlsx
6. Upload ke Google Drive
```

---

## 🎯 Best Practices

### ✅ DO:
- Export data secara berkala (minimal 1x per bulan)
- Simpan backup di multiple lokasi
- Gunakan filter untuk data spesifik
- Rename file dengan nama yang jelas
- Verifikasi data setelah export

### ❌ DON'T:
- Jangan edit file Excel yang akan di-import kembali (fitur belum ada)
- Jangan export terlalu sering (boros storage)
- Jangan share file yang berisi data sensitif tanpa password protection

---

## 🔐 Keamanan & Privacy

- ✅ File disimpan lokal di perangkat Anda
- ✅ Tidak ada data yang dikirim ke server
- ✅ Anda kontrol penuh siapa yang dapat akses file
- ⚠️ Jika share file, pastikan penerima terpercaya
- 💡 Untuk data sensitif, gunakan password protection di Excel

---

**Selamat menggunakan fitur Export! 📊✨**

Jika ada pertanyaan atau saran, silakan hubungi developer atau buat issue di repository.

---

*Terakhir diupdate: 15 Desember 2024*
*Versi: 1.0.1*