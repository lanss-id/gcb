#!/bin/bash

# Script untuk setup otomatis submodule GreenCycleBank menggunakan SSH
# Ganti username GitHub sesuai dengan milik Anda
GITHUB_USER="lanss-id"

# Warna output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}===== Setup Otomatis Submodule GreenCycleBank dengan SSH =====${NC}"

# Periksa apakah Git terinstal
if ! command -v git &> /dev/null; then
    echo -e "${RED}Git tidak ditemukan. Silakan install Git terlebih dahulu.${NC}"
    exit 1
fi

# Periksa SSH key
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo -e "${YELLOW}SSH key tidak ditemukan. Buat SSH key terlebih dahulu?${NC}"
    read -p "Buat SSH key? (y/n): " create_key
    if [[ $create_key == "y" || $create_key == "Y" ]]; then
        ssh-keygen -t rsa -b 4096 -C "maulanakayyis354@gmail.com"
        echo -e "${YELLOW}Tambahkan SSH key berikut ke GitHub:${NC}"
        cat ~/.ssh/id_rsa.pub
        echo -e "${YELLOW}Kunjungi: https://github.com/settings/keys untuk menambahkan key${NC}"
        read -p "Tekan Enter jika sudah menambahkan SSH key ke GitHub..."
    else
        echo -e "${RED}SSH key dibutuhkan untuk menggunakan protokol SSH.${NC}"
        exit 1
    fi
fi

# Asumsikan kita berada di root direktori project
ROOT_DIR=$(pwd)

# 1. Buat repositori di GitHub secara programatis (memerlukan GitHub CLI)
echo -e "${GREEN}Membuat repositori di GitHub...${NC}"
if command -v gh &> /dev/null; then
    gh repo create $GITHUB_USER/GreenCycleBank --public -y || true
    gh repo create $GITHUB_USER/gcb-mobile --public -y || true
    gh repo create $GITHUB_USER/gcb-api --public -y || true
    gh repo create $GITHUB_USER/gcb-packages --public -y || true
else
    echo -e "${YELLOW}GitHub CLI tidak ditemukan. Silakan buat repositori secara manual di GitHub:${NC}"
    echo "- $GITHUB_USER/GreenCycleBank"
    echo "- $GITHUB_USER/gcb-mobile"
    echo "- $GITHUB_USER/gcb-api"
    echo "- $GITHUB_USER/gcb-packages"

    read -p "Tekan Enter jika sudah membuat repositori tersebut..."
fi

# 2. Inisialisasi repositori utama
echo -e "${GREEN}Inisialisasi repositori utama...${NC}"
git init
echo "node_modules
.turbo
.env*
*.log
.pnpm-store/" > .gitignore

# 3. Buat direktori sementara
echo -e "${GREEN}Membuat struktur sementara...${NC}"
TEMP_DIR=$(mktemp -d)
mkdir -p $TEMP_DIR/gcb-mobile
mkdir -p $TEMP_DIR/gcb-api
mkdir -p $TEMP_DIR/gcb-packages

# 4. Salin konten ke direktori sementara
echo -e "${GREEN}Menyalin konten ke direktori sementara...${NC}"
cp -r apps/mobile/* $TEMP_DIR/gcb-mobile/
cp -r apps/api/* $TEMP_DIR/gcb-api/
cp -r packages/* $TEMP_DIR/gcb-packages/

# 5. Setup dan push repositori individual
echo -e "${GREEN}Setup repositori gcb-mobile...${NC}"
cd $TEMP_DIR/gcb-mobile
git init
echo "node_modules
.next
.turbo
dist
build
.env*
.vercel
*.log" > .gitignore
git add .
git commit -m "Initial commit for GCB Mobile frontend"
git branch -M main
git remote add origin git@github.com:$GITHUB_USER/gcb-mobile.git
git push -u origin main -f

echo -e "${GREEN}Setup repositori gcb-api...${NC}"
cd $TEMP_DIR/gcb-api
git init
echo "node_modules
dist
.env*
*.log" > .gitignore
git add .
git commit -m "Initial commit for GCB API backend"
git branch -M main
git remote add origin git@github.com:$GITHUB_USER/gcb-api.git
git push -u origin main -f

echo -e "${GREEN}Setup repositori gcb-packages...${NC}"
cd $TEMP_DIR/gcb-packages
git init
echo "node_modules
dist
*.log" > .gitignore
git add .
git commit -m "Initial commit for GCB shared packages"
git branch -M main
git remote add origin git@github.com:$GITHUB_USER/gcb-packages.git
git push -u origin main -f

# 6. Kembali ke direktori utama
cd $ROOT_DIR

# 7. Hapus direktori apps dan packages
echo -e "${GREEN}Pembersihan direktori...${NC}"
rm -rf apps/mobile/* apps/api/* packages/*

# 8. Tambahkan submodules
echo -e "${GREEN}Menambahkan submodules...${NC}"
git submodule add git@github.com:$GITHUB_USER/gcb-mobile.git apps/mobile
git submodule add git@github.com:$GITHUB_USER/gcb-api.git apps/api
git submodule add git@github.com:$GITHUB_USER/gcb-packages.git packages

# 9. Commit dan push repositori utama
echo -e "${GREEN}Commit dan push repositori utama...${NC}"
git add .
git commit -m "Initial setup with submodules"
git branch -M main
git remote add origin git@github.com:$GITHUB_USER/GreenCycleBank.git
git push -u origin main -f

# 10. Bersihkan direktori sementara
echo -e "${GREEN}Membersihkan direktori sementara...${NC}"
rm -rf $TEMP_DIR

echo -e "${GREEN}Setup selesai! Struktur submodule berhasil dibuat.${NC}"
echo -e "${YELLOW}Untuk clone repositori dengan submodules:${NC}"
echo "git clone --recurse-submodules git@github.com:$GITHUB_USER/GreenCycleBank.git"
