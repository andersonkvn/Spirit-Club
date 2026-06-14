# Spirit Club Dashboard v2 — Setup Guide

## File dalam package ini
```
index.html          → Halaman login Google
dashboard.html      → Dashboard utama
supabase_setup.sql  → SQL untuk buat tabel di Supabase
SETUP.md            → Panduan ini
```

---

## LANGKAH 1 — Buat project Supabase

1. Buka https://supabase.com → klik "Start your project"
2. Login dengan GitHub atau email
3. Klik **New Project** → isi nama `spirit-club` → pilih region **Southeast Asia (Singapore)**
4. Tunggu ~2 menit sampai project siap

---

## LANGKAH 2 — Jalankan SQL setup

1. Di Supabase, buka **SQL Editor** (ikon database di sidebar kiri)
2. Salin seluruh isi file `supabase_setup.sql`
3. Tempel di editor, lalu klik **Run**
4. Ganti email contoh dengan Gmail asli member sebelum run

---

## LANGKAH 3 — Aktifkan Google Login

1. Di Supabase → **Authentication → Providers → Google** → aktifkan
2. Buka https://console.cloud.google.com
3. **APIs & Services → Credentials → Create Credentials → OAuth 2.0 Client ID**
4. Application type: **Web application**
5. Di "Authorized redirect URIs" tambahkan:
   ```
   https://SUPABASE_PROJECT_ID.supabase.co/auth/v1/callback
   ```
6. Salin **Client ID** dan **Client Secret** → paste ke Supabase Google provider
7. Simpan

---

## LANGKAH 4 — Isi konfigurasi di file HTML

Buka `index.html` dan `dashboard.html`, ganti 3 baris ini:

```js
// Di index.html dan dashboard.html:
const SUPABASE_URL      = 'https://XXXXX.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGci...';   // dari Supabase > Settings > API

// Di dashboard.html saja:
const ADMIN_EMAILS = ['email_kamu@gmail.com'];
```

Nilai URL dan Key ada di Supabase → **Settings → API**.

---

## LANGKAH 5 — Deploy ke Vercel (direkomendasikan)

### Cara A: Via GitHub (otomatis deploy setiap ada perubahan)
1. Buat repository baru di https://github.com (mis. `spirit-club`)
2. Upload semua file ke repo
3. Buka https://vercel.com → Login dengan GitHub
4. Klik **Add New Project** → pilih repo `spirit-club`
5. **Framework Preset: Other** (biarkan default)
6. Klik **Deploy** → tunggu ~1 menit
7. URL live: `https://spirit-club.vercel.app` (atau custom domain)

### Cara B: Via Vercel CLI (langsung dari folder)
```bash
npm i -g vercel
cd spirit-club-v2
vercel
# Ikuti petunjuk, pilih "Other" framework
```

### Setting redirect di Supabase setelah Vercel live
Tambahkan URL Vercel ke Supabase → **Authentication → URL Configuration**:
- Site URL: `https://spirit-club.vercel.app`
- Redirect URLs: `https://spirit-club.vercel.app/dashboard.html`

---

## LANGKAH 6 — Tambah member baru

### Via panel Admin di dashboard (mudah):
1. Login sebagai admin
2. Klik tab **Admin**
3. Isi form Tambah Member → klik Tambah

### Via Supabase SQL Editor:
```sql
INSERT INTO daftar_member (id_member, nama_member, email, handicap, base_score)
VALUES ('M006', 'Nama Baru', 'email@gmail.com', 15, 200);
```

---

## Formula Handicap yang dipakai

```
Handicap per game = (Base Score - Average) × 0.8
Base Score default = 200

Contoh: Average 165 → Handicap = (200 - 165) × 0.8 = 28
Total Handicap Series = Total Scratch + (Handicap × 3)
```

Base score bisa diubah per member di tabel `daftar_member`.

---

## Fitur dashboard

| Fitur | Keterangan |
|-------|-----------|
| 🏆 Leaderboard | Ranking semua member: Average, HC, Total Scratch, Total HC, High Series, High Game |
| ⚡ Weekly High Series | Top 5 total skor tertinggi per sesi |
| 🎯 Weekly High Game | Top 5 skor game tunggal tertinggi |
| 📊 Statistik saya | Average, HS, HG, Handicap, Total sesi |
| 📈 Tren mingguan | Grafik average + total scratch, filter 4/8/semua sesi |
| 🎱 Distribusi game | Bar chart sebaran skor per rentang |
| 📋 Tabel per sesi | Game 1/2/3, Total Scratch, HC, Total HC, Average, High Game |
| ➕ Input skor | Preview otomatis: total, avg, HC, total HC |
| ⚙️ Admin | Tambah member, lihat semua member terdaftar |
