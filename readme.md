# GreenCycleBank (GCB)

![GreenCycleBank Logo](https://via.placeholder.com/150x150/b9f732/000000?text=GCB)

## 📋 Deskripsi Proyek

GreenCycleBank (GCB) adalah platform pengelolaan sampah berbasis circular economy yang menghubungkan 4 aktor utama dalam ekosistem pengelolaan sampah:

- **Nasabah**: Pengguna individu yang dapat menjual sampah
- **Bank Sampah**: Tempat pengumpulan dan penyortiran sampah
- **Pengelola Sampah**: Perusahaan/stakeholder yang mengolah sampah
- **Pemerintah**: Pengawas dan regulator

Aplikasi ini dirancang untuk mengatasi masalah TPA open dumping yang sering mengalami longsor karena curah hujan tinggi, sambil memberikan insentif ekonomi kepada masyarakat melalui sistem gamifikasi penukaran sampah.

## 🚀 Tujuan

1. Mengurangi sampah di TPA dengan prinsip ekonomi sirkular
2. Memberikan tambahan penghasilan bagi masyarakat melalui penjualan sampah
3. Menciptakan rantai nilai sampah yang terstruktur dan terukur
4. Menyediakan data pengelolaan sampah yang akurat bagi pemerintah
5. Mengedukasi masyarakat tentang pemilahan dan daur ulang sampah

## 💻 Tech Stack

GreenCycleBank dikembangkan dengan modern tech stack:

### Frontend
- **Next.js 15** - Framework React untuk aplikasi web
- **React 19** - Library UI untuk membangun antarmuka pengguna
- **Tailwind CSS** - Framework CSS untuk styling
- **shadcn/ui** - Komponen UI yang dapat disesuaikan
- **TypeScript** - Untuk type-safety dan pengembangan yang lebih baik

### Backend
- **NestJS** - Framework Node.js untuk backend
- **PostgreSQL/Supabase** - Database dan backend-as-a-service

### Infrastruktur & Tools
- **Drizzle ORM** - ORM TypeScript modern untuk database
- **Zod** - Validasi skema TypeScript
- **Sentry** - Pemantauan error
- **Turborepo** - Pengelolaan monorepo
- **Docker** - Kontainerisasi

## 📁 Struktur Folder

Proyek ini menggunakan arsitektur monorepo dengan struktur sebagai berikut:

```
green-cycle-bank/
├── apps/
│   ├── mobile/       # Aplikasi Next.js frontend (mobile-first)
│   │   ├── src/
│   │   │   ├── app/        # App Router Next.js
│   │   │   ├── components/ # Komponen UI
│   │   │   ├── lib/        # Utilitas dan fungsi
│   │   │   └── ...
│   └── api/          # Backend NestJS
│       ├── src/
│       │   ├── modules/    # Modul fitur (auth, users, transactions, dll)
│       │   ├── common/     # Kode yang digunakan bersama
│       │   └── ...
├── packages/
│   ├── db/           # Skema database dan migrasi (Drizzle ORM)
│   ├── validators/   # Skema validasi Zod
│   └── config/       # Konfigurasi shared
├── docker-compose.yml
└── turbo.json        # Konfigurasi Turborepo
```

## 🔧 Cara Penggunaan

### Prasyarat

- Node.js v18 atau lebih baru
- pnpm
- PostgreSQL (atau Docker untuk container PostgreSQL)
- Git

### Instalasi

1. Clone repositori dengan submodule:

```bash
git clone --recurse-submodules git@github.com:lanss-id/GreenCycleBank.git
cd GreenCycleBank
```

2. Instalasi dependencies:

```bash
pnpm install
```

3. Buat file `.env` di root proyek:

```
# Database
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/greencyclebank

# Supabase (opsional)
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key

# API
NEXT_PUBLIC_API_URL=http://localhost:3001
PORT=3001
```

4. Setup database:

```bash
# Menggunakan Docker (direkomendasikan)
docker-compose up -d postgres

# Atau gunakan PostgreSQL lokal
# Buat database dengan nama 'greencyclebank'
```

5. Jalankan migrasi database:

```bash
pnpm run db:generate
pnpm run db:push
```

### Menjalankan Aplikasi

#### Development Mode

```bash
# Menjalankan semua aplikasi
pnpm run dev

# Menjalankan hanya frontend
pnpm --filter mobile dev

# Menjalankan hanya backend
pnpm --filter api dev
```

#### Menggunakan Docker

```bash
docker-compose up -d
```

### Akses Aplikasi

- Frontend: http://localhost:3000
- Backend API: http://localhost:3001/api

## 🔄 Fitur Utama

- 🔐 **Autentikasi Multi-Aktor**: Sistem login khusus untuk setiap aktor
- 📱 **Mobile-First Design**: Dioptimalkan untuk penggunaan mobile
- 🗺️ **Nearby Bank Sampah**: Menemukan bank sampah terdekat
- 💰 **Transaksi Sampah**: Proses jual beli sampah yang mudah
- 🏆 **Gamifikasi**: Sistem reward untuk nasabah dengan poin dan achievement
- 📊 **Analytics**: Dashboard khusus untuk pemerintah
- 🔄 **Circular Economy**: Alur pengelolaan sampah berkelanjutan

## 🤝 Kontribusi

Kontribusi selalu diterima! Silakan buat Issue atau Pull Request dengan fitur/perbaikan yang ingin Anda tambahkan.

## 📄 Lisensi

Proyek ini menggunakan lisensi [MIT](LICENSE).

---

Dikembangkan oleh @PixelPecel 💚 untuk Indonesia yang lebih bersih
