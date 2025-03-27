#!/bin/bash

# Script untuk memperbaiki masalah TypeScript dengan pnpm
# Simpan sebagai fix-typescript.sh dan jalankan dari root proyek

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

# 1. Perbaiki tsconfig.json untuk Next.js
print_step "Memperbaiki tsconfig.json untuk Next.js..."

cat > apps/mobile/tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "es2022",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    },
    "typeRoots": [
      "./node_modules/.pnpm/@types",
      "./node_modules/@types"
    ]
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

# 2. Reinstall @types packages
print_step "Reinstall @types packages..."
pnpm install @types/node@latest @types/react@latest @types/react-dom@latest --save-dev

# 3. Buat symlink untuk type definitions jika belum ada
print_step "Membuat symlink untuk type definitions..."

mkdir -p node_modules/@types
mkdir -p apps/mobile/node_modules/@types

# Node
if [ -d "node_modules/.pnpm/@types+node@"* ]; then
  NODE_TYPE_DIR=$(find node_modules/.pnpm/@types+node@* -maxdepth 0 -type d | head -n 1)
  if [ -n "$NODE_TYPE_DIR" ]; then
    print_info "Membuat symlink untuk @types/node..."
    ln -sf "$NODE_TYPE_DIR/node_modules/@types/node" node_modules/@types/
    ln -sf "$NODE_TYPE_DIR/node_modules/@types/node" apps/mobile/node_modules/@types/
  fi
fi

# React
if [ -d "node_modules/.pnpm/@types+react@"* ]; then
  REACT_TYPE_DIR=$(find node_modules/.pnpm/@types+react@* -maxdepth 0 -type d | head -n 1)
  if [ -n "$REACT_TYPE_DIR" ]; then
    print_info "Membuat symlink untuk @types/react..."
    ln -sf "$REACT_TYPE_DIR/node_modules/@types/react" node_modules/@types/
    ln -sf "$REACT_TYPE_DIR/node_modules/@types/react" apps/mobile/node_modules/@types/
  fi
fi

# React DOM
if [ -d "node_modules/.pnpm/@types+react-dom@"* ]; then
  REACT_DOM_TYPE_DIR=$(find node_modules/.pnpm/@types+react-dom@* -maxdepth 0 -type d | head -n 1)
  if [ -n "$REACT_DOM_TYPE_DIR" ]; then
    print_info "Membuat symlink untuk @types/react-dom..."
    ln -sf "$REACT_DOM_TYPE_DIR/node_modules/@types/react-dom" node_modules/@types/
    ln -sf "$REACT_DOM_TYPE_DIR/node_modules/@types/react-dom" apps/mobile/node_modules/@types/
  fi
fi

# 4. Clear TypeScript cache
print_step "Membersihkan cache TypeScript..."
find . -name "*.tsbuildinfo" -type f -delete
find . -name ".next" -type d -exec rm -rf {} +

print_step "Selesai!"
print_info "Silakan coba build atau jalankan proyek Anda kembali."
