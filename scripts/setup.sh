#!/bin/bash

# Script instalasi GreenCycleBank (PERBAIKAN)
# Dijalankan dari root directory project

# Warna untuk output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Fungsi untuk menampilkan pesan dengan format
print_step() {
  echo -e "${GREEN}[*]${NC} $1"
}

print_info() {
  echo -e "${YELLOW}[i]${NC} $1"
}

print_error() {
  echo -e "${RED}[!]${NC} $1"
}

# Pastikan pnpm-workspace.yaml ada
if [ ! -f "pnpm-workspace.yaml" ]; then
  print_step "Membuat pnpm-workspace.yaml..."
  cat > pnpm-workspace.yaml << EOF
packages:
  - 'apps/*'
  - 'packages/*'
EOF
  print_info "pnpm-workspace.yaml dibuat."
fi

# Install dependencies
print_step "Menginstall dependencies..."
pnpm install
if [ $? -ne 0 ]; then
  print_error "Gagal menginstall dependencies dengan cara normal."
  print_info "Mencoba menginstall dengan hoisting..."
  pnpm install --shamefully-hoist

  if [ $? -ne 0 ]; then
    print_error "Gagal menginstall dependencies. Silakan jalankan instalasi manual:"
    print_info "1. Hapus node_modules: rm -rf node_modules packages/*/node_modules apps/*/node_modules"
    print_info "2. Hapus pnpm-lock.yaml: rm -f pnpm-lock.yaml"
    print_info "3. Install ulang: pnpm install --shamefully-hoist"
    exit 1
  fi
fi
print_info "Dependencies berhasil diinstall."

# Instal tsup secara eksplisit jika belum ada
print_step "Memastikan tsup terinstall..."
if ! pnpm list -g | grep -q tsup; then
  pnpm add -g tsup
fi

# Install packages dependencies secara terpisah
print_step "Menginstall dependencies di packages/..."
for pkg in packages/*; do
  if [ -d "$pkg" ]; then
    print_info "Menginstall dependencies di $pkg..."
    (cd "$pkg" && pnpm install)
  fi
done

# Build shared packages
print_step "Membangun shared packages..."
cd packages/config && pnpm build && cd ../..
if [ $? -ne 0 ]; then
  print_error "Gagal membangun package config."
  exit 1
fi

cd packages/validators && pnpm build && cd ../..
if [ $? -ne 0 ]; then
  print_error "Gagal membangun package validators."
  exit 1
fi

cd packages/db && pnpm build && cd ../..
if [ $? -ne 0 ]; then
  print_error "Gagal membangun package db."
  exit 1
fi

print_info "Shared packages berhasil dibangun."

# Generate database schema
print_step "Menghasilkan skema database..."
pnpm --filter "@gcb/db" db:generate
if [ $? -ne 0 ]; then
  print_error "Gagal menghasilkan skema database."
  print_info "Pastikan DATABASE_URL di file .env sudah benar dan database sudah dibuat."
  exit 1
fi
print_info "Skema database berhasil dihasilkan."

# Tanya pengguna apakah ingin menjalankan migrasi database
read -p "Apakah Anda ingin menjalankan migrasi database sekarang? (y/n): " run_migration
if [[ $run_migration == "y" || $run_migration == "Y" ]]; then
  print_step "Menjalankan migrasi database..."

  # Cek jika menggunakan Docker
  if command -v docker &> /dev/null && docker ps | grep -q "postgres"; then
    print_info "Database PostgreSQL terdeteksi."
  else
    print_info "Pastikan PostgreSQL sudah berjalan dan database sudah dibuat."
  fi

  pnpm --filter "@gcb/db" db:push
  if [ $? -ne 0 ]; then
    print_error "Gagal menjalankan migrasi database."
    print_info "Pastikan DATABASE_URL di file .env sudah benar dan database sudah berjalan."
    exit 1
  fi
  print_info "Migrasi database berhasil."
else
  print_info "Migrasi database dilewati. Anda dapat menjalankannya nanti dengan: pnpm --filter \"@gcb/db\" db:push"
fi

print_step "Setup GreenCycleBank selesai!"
print_info "Untuk menjalankan aplikasi dalam mode development: pnpm run dev"
print_info "Untuk build aplikasi: pnpm run build"
print_info "Untuk menjalankan dengan Docker: docker-compose up -d"

exit 0
