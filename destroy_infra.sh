#!/usr/bin/env bash
set -eo pipefail

# =============================================
# КОНФИГУРАЦИЯ ПУТЕЙ
# =============================================
BASE_DIR="/home/tenda/tenda-devops-diplom-netology"
declare -A PATHS=(
    [SA]="${BASE_DIR}/yc-sa"
    [BUCKET]="${BASE_DIR}/yc-bucket"
    [INFRA]="${BASE_DIR}/yc-main-infra"
)

# =============================================
# ФУНКЦИИ ЛОГИРОВАНИЯ
# =============================================
log_header() {
    echo -e "\n\033[1;34m[+] $1\033[0m"
}

log_warning() {
    echo -e "\033[1;33m⚠️  $1\033[0m"
}

log_error() {
    echo -e "\033[1;31m✗ $1\033[0m"
}

log_success() {
    echo -e "\033[1;32m✓ $1\033[0m"
}

# =============================================
# ОСНОВНЫЕ ФУНКЦИИ
# =============================================
get_token() {
    log_header "ГЕНЕРАЦИЯ IAM ТОКЕНА"
    export TF_VAR_token=$(yc iam create-token)
    log_success "Токен получен"
}

load_bucket_env() {
    log_header "ЗАГРУЗКА ПЕРЕМЕННЫХ БАКЕТА"
    cd "${PATHS[BUCKET]}"
    if [ -f .env ]; then
        source .env
        export AWS_ACCESS_KEY_ID
        export AWS_SECRET_ACCESS_KEY
        log_success "Переменные бакета загружены"
    else
        log_error "Файл .env не найден! Удаление невозможно"
        exit 1
    fi
}

destroy_infra() {
    local path=$1
    local name=$2
    
    log_header "УДАЛЕНИЕ: $name"
    cd "$path"
    
    terraform init -no-color
    terraform validate -no-color
    terraform destroy -auto-approve -no-color
    
    log_success "Ресурсы удалены: $name"
}

# =============================================
# ОСНОВНОЙ ПРОЦЕСС УДАЛЕНИЯ
# =============================================
main() {
    get_token
    load_bucket_env  # Загружаем переменные ДО удаления инфраструктуры
    
    # Удаление основной инфраструктуры
    destroy_infra "${PATHS[INFRA]}" "Основная инфраструктура"
    
    # Удаление бакета
    destroy_infra "${PATHS[BUCKET]}" "S3 Бакет"
    
    # Удаление сервисного аккаунта
    destroy_infra "${PATHS[SA]}" "Сервисный аккаунт"
    
    log_success "\nВСЯ ИНФРАСТРУКТУРА УСПЕШНО УДАЛЕНА"
}

# =============================================
# ЗАПУСК СКРИПТА
# =============================================
main "$@"
