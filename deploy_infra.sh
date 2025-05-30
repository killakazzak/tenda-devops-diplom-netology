#!/usr/bin/env bash
set -eo pipefail  # Безопасное выполнение: выход при ошибках

# =============================================
# ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ И ПУТИ
# =============================================
BASE_DIR="/home/tenda/tenda-devops-diplom-netology"
declare -A PATHS=(
    [SA]="${BASE_DIR}/yc-sa"
    [BUCKET]="${BASE_DIR}/yc-bucket"
    [INFRA]="${BASE_DIR}/yc-main-infra"
    [KUBESPRAY]="${BASE_DIR}/yc-main-infra/kubespray"
)

# =============================================
# ФУНКЦИИ ДЛЯ ЛОГИРОВАНИЯ
# =============================================
log_header() {
    echo -e "\n\033[1;34m[+] $1\033[0m"
}

log_success() {
    echo -e "\033[1;32m✓ $1\033[0m"
}

log_info() {
    echo -e "\033[1;36m» $1\033[0m"
}

# =============================================
# ОСНОВНЫЕ ОПЕРАЦИИ
# =============================================
main() {
    # Генерация IAM токена
    log_header "ГЕНЕРАЦИЯ IAM ТОКЕНА"
    export TF_VAR_token=$(yc iam create-token)
    log_success "Токен получен"

    # Сервисный аккаунт
    run_terraform "SA" "Создание сервисного аккаунта"

    # S3 Бакет
    run_terraform "BUCKET" "Создание S3 бакета"
    source "${PATHS[BUCKET]}/.env"
    log_success "Переменные окружения загружены"

    # Основная инфраструктура
    run_terraform "INFRA" "Развертывание основной инфраструктуры"

    # Установка кластера Kubernetes
    install_kubernetes

    # Настройка kubectl
    configure_kubectl

    # Проверка окружения
    validate_environment
}

run_terraform() {
    local key=$1
    local message=$2
    log_header "$message"
    cd "${PATHS[$key]}"
    terraform init
    terraform validate
    terraform apply -auto-approve
    log_success "Операция завершена: $message"
}

install_kubernetes() {
    log_header "УСТАНОВКА KUBERNETES КЛАСТЕРА"
    cd "${PATHS[KUBESPRAY]}"
    pip install -r requirements.txt
    ansible-playbook -i inventory/mycluster/inventory-default.ini cluster.yml -b -v
    log_success "Kubernetes кластер развернут"
}

configure_kubectl() {
    log_header "НАСТРОЙКА KUBECONFIG"
    mkdir -p ~/.kube/
    export API_ENDPOINT=$(cd "${PATHS[INFRA]}"; terraform output -raw api_endpoint)
    
    ssh -o StrictHostKeyChecking=no ubuntu@$API_ENDPOINT \
        "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/config
    
    sed -i "s/127.0.0.1/$API_ENDPOINT/g" ~/.kube/config
    kubectl config set-cluster cluster.local --insecure-skip-tls-verify=true
    
    log_success "Kubeconfig настроен для кластера: $API_ENDPOINT"
}

validate_environment() {
    log_header "ПРОВЕРКА РАЗВЕРТЫВАНИЯ"
    
    log_info "Сервисные аккаунты:"
    yc iam service-account list
    
    log_info "\nS3 Бакеты:"
    yc storage bucket list
    
    log_info "\nVPC Сети:"
    yc vpc network list
    
    log_info "\nVPC Подсети:"
    yc vpc subnet list
    
    log_info "\nKubernetes Ноды:"
    kubectl get nodes -o wide
    
    log_info "\nKubernetes Поды:"
    kubectl get pods -A
}

# =============================================
# ЗАПУСК СКРИПТА
# =============================================
main "$@"
