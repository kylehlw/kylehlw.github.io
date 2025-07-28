#!/bin/bash

# TrueNAS Scale 监控系统自动化部署脚本
# 作者: Kyle
# 日期: 2025-07-22
# 功能: 自动部署 Prometheus + Node Exporter + Grafana 监控系统

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置变量
MONITORING_DIR="/mnt/pool/monitoring"
PROMETHEUS_PORT="9090"
GRAFANA_PORT="3000"
NODE_EXPORTER_PORT="9100"

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# 显示横幅
show_banner() {
    echo -e "${BLUE}"
    echo "=================================================="
    echo "    TrueNAS Scale 监控系统自动化部署脚本"
    echo "=================================================="
    echo "    包含: Prometheus + Node Exporter + Grafana"
    echo "    作者: Kyle"
    echo "    日期: 2025-07-22"
    echo "=================================================="
    echo -e "${NC}"
}

# 检查系统要求
check_requirements() {
    log_step "检查系统要求..."
    
    # 检查是否为TrueNAS Scale
    if [ ! -f "/etc/os-release" ] || ! grep -q "TrueNAS-SCALE" /etc/os-release; then
        log_warn "检测到非TrueNAS Scale系统，脚本可能不完全兼容"
    fi
    
    # 检查Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker未安装，请先安装Docker"
        log_info "安装命令: curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh"
        exit 1
    fi
    
    # 检查Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose未安装，请先安装Docker Compose"
        log_info "安装命令: sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-\$(uname -s)-\$(uname -m)\" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose"
        exit 1
    fi
    
    # 检查端口占用
    check_port_availability
    
    log_info "系统要求检查通过"
}

# 检查端口可用性
check_port_availability() {
    log_info "检查端口可用性..."
    
    local ports=($PROMETHEUS_PORT $GRAFANA_PORT $NODE_EXPORTER_PORT)
    
    for port in "${ports[@]}"; do
        if netstat -tlnp 2>/dev/null | grep -q ":$port "; then
            log_error "端口 $port 已被占用，请释放端口后重试"
            exit 1
        fi
    done
    
    log_info "所有端口可用"
}

# 创建目录结构
create_directories() {
    log_step "创建监控系统目录结构..."
    
    mkdir -p "$MONITORING_DIR"
    cd "$MONITORING_DIR"
    
    mkdir -p prometheus/{data,config}
    mkdir -p grafana/{data,provisioning/{datasources,dashboards}}
    
    log_info "目录结构创建完成: $MONITORING_DIR"
}

# 创建Prometheus配置
create_prometheus_config() {
    log_step "创建Prometheus配置文件..."
    
    cat > "$MONITORING_DIR/prometheus/config/prometheus.yml" << 'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
    scrape_interval: 5s

  - job_name: 'truenas-system'
    static_configs:
      - targets: ['localhost:9100']
    scrape_interval: 10s
    metrics_path: /metrics
    scheme: http
EOF

    log_info "Prometheus配置文件创建完成"
}

# 创建Grafana数据源配置
create_grafana_datasource() {
    log_step "创建Grafana数据源配置..."
    
    cat > "$MONITORING_DIR/grafana/provisioning/datasources/prometheus.yml" << 'EOF'
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
EOF

    log_info "Grafana数据源配置创建完成"
}

# 创建Docker Compose配置
create_docker_compose() {
    log_step "创建Docker Compose配置文件..."
    
    cat > "$MONITORING_DIR/docker-compose.yml" << EOF
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    ports:
      - "$PROMETHEUS_PORT:9090"
    volumes:
      - ./prometheus/config:/etc/prometheus
      - ./prometheus/data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=200h'
      - '--web.enable-lifecycle'
    networks:
      - monitoring

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: unless-stopped
    ports:
      - "$GRAFANA_PORT:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin123
      - GF_USERS_ALLOW_SIGN_UP=false
    volumes:
      - ./grafana/data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning
    networks:
      - monitoring

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    ports:
      - "$NODE_EXPORTER_PORT:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)(\$\$|/)'
    networks:
      - monitoring

networks:
  monitoring:
    driver: bridge
EOF

    log_info "Docker Compose配置文件创建完成"
}

# 创建管理脚本
create_management_script() {
    log_step "创建服务管理脚本..."
    
    cat > "$MONITORING_DIR/manage.sh" << 'EOF'
#!/bin/bash

# TrueNAS Scale 监控系统管理脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 显示帮助信息
show_help() {
    echo "TrueNAS Scale 监控系统管理脚本"
    echo ""
    echo "用法: $0 [命令]"
    echo ""
    echo "命令:"
    echo "  start     启动所有服务"
    echo "  stop      停止所有服务"
    echo "  restart   重启所有服务"
    echo "  status    显示服务状态"
    echo "  logs      显示服务日志"
    echo "  update    更新服务镜像"
    echo "  backup    备份数据"
    echo "  restore   恢复数据"
    echo "  help      显示此帮助信息"
}

# 启动服务
start_services() {
    log_info "启动监控服务..."
    docker-compose up -d
    log_info "服务启动完成"
}

# 停止服务
stop_services() {
    log_info "停止监控服务..."
    docker-compose down
    log_info "服务停止完成"
}

# 重启服务
restart_services() {
    log_info "重启监控服务..."
    docker-compose restart
    log_info "服务重启完成"
}

# 显示状态
show_status() {
    log_info "服务状态:"
    docker-compose ps
    echo ""
    log_info "端口状态:"
    netstat -tlnp | grep -E ':(3000|9090|9100)' || echo "端口未监听"
}

# 显示日志
show_logs() {
    log_info "显示服务日志..."
    docker-compose logs -f
}

# 更新镜像
update_images() {
    log_info "更新服务镜像..."
    docker-compose pull
    docker-compose up -d
    log_info "镜像更新完成"
}

# 备份数据
backup_data() {
    log_info "备份监控数据..."
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup_dir="backup_${timestamp}"
    
    mkdir -p "$backup_dir"
    cp -r prometheus/data "$backup_dir/"
    cp -r grafana/data "$backup_dir/"
    cp -r prometheus/config "$backup_dir/"
    cp -r grafana/provisioning "$backup_dir/"
    
    tar -czf "${backup_dir}.tar.gz" "$backup_dir"
    rm -rf "$backup_dir"
    
    log_info "备份完成: ${backup_dir}.tar.gz"
}

# 恢复数据
restore_data() {
    if [ -z "$1" ]; then
        log_error "请指定备份文件路径"
        exit 1
    fi
    
    log_info "恢复监控数据..."
    backup_file="$1"
    
    if [ ! -f "$backup_file" ]; then
        log_error "备份文件不存在: $backup_file"
        exit 1
    fi
    
    # 停止服务
    docker-compose down
    
    # 解压备份
    tar -xzf "$backup_file"
    backup_dir=$(basename "$backup_file" .tar.gz)
    
    # 恢复数据
    rm -rf prometheus/data grafana/data prometheus/config grafana/provisioning
    cp -r "$backup_dir"/* .
    rm -rf "$backup_dir"
    
    # 启动服务
    docker-compose up -d
    
    log_info "数据恢复完成"
}

# 主函数
main() {
    case "$1" in
        start)
            start_services
            ;;
        stop)
            stop_services
            ;;
        restart)
            restart_services
            ;;
        status)
            show_status
            ;;
        logs)
            show_logs
            ;;
        update)
            update_images
            ;;
        backup)
            backup_data
            ;;
        restore)
            restore_data "$2"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "未知命令: $1"
            show_help
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"
EOF

    chmod +x "$MONITORING_DIR/manage.sh"
    log_info "管理脚本创建完成"
}

# 启动服务
start_services() {
    log_step "启动监控服务..."
    
    cd "$MONITORING_DIR"
    docker-compose up -d
    
    log_info "服务启动完成"
}

# 检查服务状态
check_services() {
    log_step "检查服务状态..."
    
    sleep 15
    
    cd "$MONITORING_DIR"
    
    # 检查容器状态
    log_info "容器状态:"
    docker-compose ps
    
    # 检查端口
    log_info "端口状态:"
    netstat -tlnp | grep -E ":(3000|9090|9100)" || log_warn "部分端口可能未启动"
    
    # 检查服务健康状态
    check_service_health
}

# 检查服务健康状态
check_service_health() {
    log_info "检查服务健康状态..."
    
    local truenas_ip=$(hostname -I | awk '{print $1}')
    
    # 检查Prometheus
    if curl -s "http://$truenas_ip:$PROMETHEUS_PORT/-/healthy" > /dev/null; then
        log_info "✓ Prometheus 运行正常"
    else
        log_warn "✗ Prometheus 可能未完全启动"
    fi
    
    # 检查Node Exporter
    if curl -s "http://$truenas_ip:$NODE_EXPORTER_PORT/metrics" > /dev/null; then
        log_info "✓ Node Exporter 运行正常"
    else
        log_warn "✗ Node Exporter 可能未完全启动"
    fi
    
    # 检查Grafana
    if curl -s "http://$truenas_ip:$GRAFANA_PORT/api/health" > /dev/null; then
        log_info "✓ Grafana 运行正常"
    else
        log_warn "✗ Grafana 可能未完全启动"
    fi
}

# 显示访问信息
show_access_info() {
    local truenas_ip=$(hostname -I | awk '{print $1}')
    
    log_step "监控系统部署完成！"
    echo ""
    echo -e "${GREEN}访问信息:${NC}"
    echo "=================================================="
    echo -e "Grafana:     ${BLUE}http://$truenas_ip:$GRAFANA_PORT${NC}"
    echo -e "用户名:      ${YELLOW}admin${NC}"
    echo -e "密码:        ${YELLOW}admin123${NC}"
    echo ""
    echo -e "Prometheus:  ${BLUE}http://$truenas_ip:$PROMETHEUS_PORT${NC}"
    echo -e "Node Exporter: ${BLUE}http://$truenas_ip:$NODE_EXPORTER_PORT${NC}"
    echo "=================================================="
    echo ""
    log_warn "重要提醒:"
    echo "1. 请立即修改Grafana默认密码！"
    echo "2. 建议配置防火墙规则限制访问"
    echo "3. 定期备份监控数据"
    echo ""
    log_info "管理命令: cd $MONITORING_DIR && ./manage.sh [命令]"
}

# 显示完成信息
show_completion() {
    log_step "部署完成！"
    echo ""
    echo -e "${GREEN}下一步操作:${NC}"
    echo "1. 访问Grafana并修改默认密码"
    echo "2. 导入Node Exporter仪表板"
    echo "3. 配置告警规则"
    echo "4. 设置数据备份计划"
    echo ""
    echo -e "${YELLOW}常用管理命令:${NC}"
    echo "cd $MONITORING_DIR"
    echo "./manage.sh status    # 查看服务状态"
    echo "./manage.sh logs      # 查看服务日志"
    echo "./manage.sh backup    # 备份数据"
    echo "./manage.sh update    # 更新镜像"
}

# 主函数
main() {
    show_banner
    
    # 检查是否以root权限运行
    if [ "$EUID" -eq 0 ]; then
        log_warn "检测到root权限运行，建议使用普通用户权限"
    fi
    
    check_requirements
    create_directories
    create_prometheus_config
    create_grafana_datasource
    create_docker_compose
    create_management_script
    start_services
    check_services
    show_access_info
    show_completion
}

# 错误处理
trap 'log_error "部署过程中发生错误，请检查日志"; exit 1' ERR

# 执行主函数
main "$@" 