#!/bin/bash

# --- ANSI 颜色定义 (用于 echo -e) ---
ANSI_RESET='\e[0m'
ANSI_BOLD='\e[1m'
ANSI_RED='\e[31m'
ANSI_GREEN='\e[32m'
ANSI_YELLOW='\e[33m'
ANSI_BLUE='\e[34m'
ANSI_MAGENTA='\e[35m'
ANSI_CYAN='\e[36m'
ANSI_WHITE='\e[37m'

CONFIG_DIR="/opt/QQ/resources/app/app_launcher/napcat/config"
BASE_NAPCAT_CONFIG="$CONFIG_DIR/napcat.json"
BASE_ONEBOT_CONFIG="$CONFIG_DIR/onebot11.json"

# --- Root 权限检查 ---
if [[ $EUID -ne 0 ]]; then
   # 尝试非交互式 sudo，看是否能直接成功 (例如，已缓存密码或 NOPASSWD)
   if sudo -n true &> /dev/null; then
       # 可以非交互式 sudo，直接重新执行 (无提示)
       sudo "$0" "$@"
       exit $? # 退出当前非 root 进程, 传递 sudo 的退出码
   else
       # 非交互式 sudo 失败，需要密码或权限不足
       # 现在显示提示信息
       if command -v dialog &> /dev/null; then
           # 使用 dialog 提示
           dialog --colors --title "需要权限" --msgbox "${FG_YELLOW}此脚本需要 root 权限来修改 '${CONFIG_DIR}' 中的文件。\n\n将通过 sudo 请求密码以获取权限。${RESET}" 10 60 2>&1 >/dev/tty
           clear
       else
           # dialog 不可用时的备用 echo 提示
           echo "提示: 此脚本需要 root 权限才能修改位于 '${CONFIG_DIR}' 的配置文件。" >&2
           echo "将通过 sudo 请求密码以获取权限..." >&2
       fi

       # 现在尝试交互式 sudo，这会提示输入密码
       sudo "$0" "$@"
       exit $? # 退出当前非 root 进程, 传递 sudo 的退出码
   fi
fi

# 检查 dialog --colors 是否安装
if ! command -v dialog --colors &> /dev/null; then
    echo "错误: 需要 'dialog --colors' 命令，请先安装。" >&2
    echo "例如: sudo apt update && sudo apt install dialog --colors" >&2
    exit 1
fi

# 检查 jq 是否安装
if ! command -v jq &> /dev/null; then
    echo "错误: 需要 'jq' 命令，请先安装。" >&2
    echo "例如: sudo apt update && sudo apt install jq" >&2
    exit 1
fi

# 检查 ss 是否安装 (通常在 iproute2 包中)
if ! command -v ss &> /dev/null; then
    echo "错误: 需要 'ss' 命令 (通常在 'iproute2' 包中)，请先安装。" >&2
    echo "例如: sudo apt update && sudo apt install iproute2" >&2
    exit 1
fi




# --- ANSI 颜色定义 (使用 ANSI-C Quoting) ---
RESET='\Zn'      # 重置为正常
BOLD='\Zb'       # 切换粗体 (效果取决于终端和 dialog --colors 版本)

# 前景色
FG_BLACK='\Z0'
FG_RED='\Z1'
FG_GREEN='\Z2'
FG_YELLOW='\Z3'
FG_BLUE='\Z4'
FG_MAGENTA='\Z5'
FG_CYAN='\Z6'
FG_WHITE='\Z7'

# --- 函数定义 ---



# 正向WS配置
configure_http_server() {
    local qq_account=$1
    local config_file="$CONFIG_DIR/onebot11_${qq_account}.json"
    local temp_file=$(mktemp) || { echo "无法创建临时文件"; exit 1; }
    trap 'rm -f "$temp_file"' EXIT # 确保退出时删除临时文件

    # 检查配置文件是否存在且可读
    if [[ ! -f "$config_file" ]] || [[ ! -r "$config_file" ]]; then
        dialog --colors --msgbox "错误：无法读取配置文件 '$config_file'。" 8 60
        return 1
    fi

    # --- 读取当前配置或设置默认值 ---
    local mode="create" # 默认为新建模式
    local current_name=""
    local current_host="0.0.0.0"
    local current_port="3000"
    local current_token=""
    local current_msg_format="array"
    local current_enable="off"
    local current_debug="off"
    local current_cors="on"
    local current_ws="on"

    # 尝试读取 network.httpServers[0]
    local server_config=$(jq -c '.network.httpServers[0] // null' "$config_file")

    if [[ "$server_config" != "null" ]]; then
        mode="modify"
        current_name=$(echo "$server_config" | jq -r '.name // ""')
        current_host=$(echo "$server_config" | jq -r '.host // "0.0.0.0"')
        current_port=$(echo "$server_config" | jq -r '.port // "3000"')
        current_token=$(echo "$server_config" | jq -r '.token // ""')
        current_msg_format=$(echo "$server_config" | jq -r '.messagePostFormat // "array"')
        [[ $(echo "$server_config" | jq -r '.enable // false') == "true" ]] && current_enable="on"
        [[ $(echo "$server_config" | jq -r '.debug // false') == "true" ]] && current_debug="on"
        [[ $(echo "$server_config" | jq -r '.enableCors // true') == "true" ]] && current_cors="on" # 默认开启
        [[ $(echo "$server_config" | jq -r '.enableWebsocket // true') == "true" ]] && current_ws="on" # 默认开启
    fi

    local title_prefix="${FG_GREEN}新建${RESET}"
    [[ "$mode" == "modify" ]] && title_prefix="${FG_YELLOW}修改${RESET}"
    local form_values
    while true; do
        # --- 显示表单 ---
        # 1. 输入框部分
        exec 3>&1
        form_values=$(dialog --colors --clear --backtitle "HTTP 服务端配置" \
            --title "$title_prefix HTTP 服务端 - $qq_account" \
            --form "请填写以下信息 (带 * 为必填):" 18 70 0 \
            "名称 (*):"     1 1 "$current_name"     1 15 40 0 \
            "Host (*):"     2 1 "$current_host"     2 15 40 0 \
            "Port (*):"     3 1 "$current_port"     3 15 40 0 \
            "Token:"        4 1 "$current_token"    4 15 40 0 \
        2>&1 1>&3)
        local form_exit_status=$?
        exec 3>&-
        clear

        if [[ $form_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi

        # 解析表单输入
        local name=$(echo "$form_values" | sed -n '1p')
        local host=$(echo "$form_values" | sed -n '2p')
        local port=$(echo "$form_values" | sed -n '3p')
        local token=$(echo "$form_values" | sed -n '4p')
        local msg_format_choice
        # 2. 消息格式选择
        exec 3>&1
        msg_format_choice=$(dialog --colors --clear --backtitle "HTTP 服务端配置" \
            --title "选择消息格式 - $qq_account" \
            --radiolist "请选择上报消息格式:(空格来选中/取消)" 10 40 2 \
            "array"  "数组格式" $([[ "$current_msg_format" == "array" ]] && echo "on" || echo "off") \
            "string" "字符串格式" $([[ "$current_msg_format" == "string" ]] && echo "on" || echo "off") \
        2>&1 1>&3)
        local radio_exit_status=$?
        exec 3>&-
        clear

        if [[ $radio_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi
        local msg_format="$msg_format_choice" # radiolist 直接返回选中的 tag
        local checklist_choices
        # 3. 开关选择
        exec 3>&1
        checklist_choices=$(dialog --colors --clear --backtitle "HTTP 服务端配置" \
            --title "启用选项 - $qq_account" \
            --checklist "请选择要启用的选项:(空格来选中/取消)" 15 50 4 \
            "enable"    "启用服务"      "$current_enable" \
            "debug"     "开启Debug"     "$current_debug" \
            "cors"      "启用CORS"      "$current_cors" \
            "websocket" "启用Websocket" "$current_ws" \
        2>&1 1>&3)
        local check_exit_status=$?
        exec 3>&-
        clear

        if [[ $check_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi

        # 解析 checklist 输出
        local enable=false; [[ "$checklist_choices" == *enable* ]] && enable=true
        local debug=false;  [[ "$checklist_choices" == *debug* ]] && debug=true
        local cors=false;   [[ "$checklist_choices" == *cors* ]] && cors=true
        local ws=false;     [[ "$checklist_choices" == *websocket* ]] && ws=true

        # --- 输入验证 ---
        local errors=()

        # 必填项检查
        [[ -z "$name" ]] && errors+=("名称不能为空")
        [[ -z "$host" ]] && errors+=("Host不能为空")
        [[ -z "$port" ]] && errors+=("Port不能为空")

        # Host 格式检查
        if [[ -n "$host" ]]; then
            if [[ "$host" == "localhost" ]]; then
                host="0.0.0.0" # 替换 localhost
            elif ! [[ "$host" =~ ^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$ ]]; then
                 errors+=("Host '$host' 不是有效的 IPv4 地址格式")
            fi
        fi

        # Port 格式和范围检查 (简单检查是否为数字)
        if [[ -n "$port" ]] && ! [[ "$port" =~ ^[0-9]+$ ]] || [[ "$port" -lt 1 ]] || [[ "$port" -gt 65535 ]]; then
            errors+=("Port '$port' 必须是 1-65535 之间的数字")
        fi

        # 名称唯一性检查 (仅在名称非空时进行)
        if [[ -n "$name" ]]; then
            local original_name_to_exclude=""
            [[ "$mode" == "modify" ]] && original_name_to_exclude=$(jq -r '.network.httpServers[0].name // ""' "$config_file")

            # 获取所有其他服务的名称
            local all_other_names=()
            readarray -t all_other_names < <(jq -r --arg exclude "$original_name_to_exclude" --arg current "$name" '
                .network | [
                    (.httpServers[]? | select(.name != $exclude and .name != $current) | .name), # 排除自己(修改模式)和当前输入
                    .httpClients[]?.name,
                    .websocketServers[]?.name,
                    .websocketClients[]?.name
                ] | map(select(. != null)) | .[]
            ' "$config_file")

            for other_name in "${all_other_names[@]}"; do
                if [[ "$name" == "$other_name" ]]; then
                    errors+=("名称 '$name' 与其他服务冲突")
                    break
                fi
            done
        fi


        # 端口占用检查 (仅在 Port 有效时进行)
        if [[ "$port" =~ ^[0-9]+$ ]] && [[ "$port" -ge 1 ]] && [[ "$port" -le 65535 ]]; then
            # 检查 TCP 监听端口
            if ss -tuln | grep -q ":${port}\s"; then
                 errors+=("端口 $port 可能已被占用")
            fi
        fi


        # --- 处理验证结果 ---
        if [[ ${#errors[@]} -gt 0 ]]; then
            # 错误标题用红色，错误项用黄色
            local error_msg="${FG_RED}输入无效:${RESET}\n\n"
            for error in "${errors[@]}"; do
                error_msg+=" - ${FG_YELLOW}$error${RESET}\n"
            done
            dialog --colors --msgbox "$error_msg" 15 60
            # 保留用户输入以便下次显示
            current_name="$name"
            current_host="$host"
            current_port="$port"
            current_token="$token"
            current_msg_format="$msg_format"
            [[ "$enable" == true ]] && current_enable="on" || current_enable="off"
            [[ "$debug" == true ]] && current_debug="on" || current_debug="off"
            [[ "$cors" == true ]] && current_cors="on" || current_cors="off"
            [[ "$ws" == true ]] && current_ws="on" || current_ws="off"
            continue # 返回循环，重新显示表单
        fi

        # --- 验证通过，构建 JSON 对象 ---
        local new_server_obj=$(jq -n \
            --arg name "$name" \
            --arg host "$host" \
            --argjson port "$port" \
            --arg token "$token" \
            --arg msg_format "$msg_format" \
            --argjson enable "$enable" \
            --argjson debug "$debug" \
            --argjson cors "$cors" \
            --argjson ws "$ws" \
            '{
                enable: $enable,
                name: $name,
                host: $host,
                port: $port,
                enableCors: $cors,
                enableWebsocket: $ws,
                messagePostFormat: $msg_format,
                token: $token,
                debug: $debug
            }')

        # --- 更新 JSON 文件 ---
        local jq_script=""
        local jq_stderr_file=$(mktemp) # 创建一个临时文件来捕获 jq 的 stderr
        # 确保 jq_stderr_file 也在退出时被删除
        trap 'rm -f "$temp_file" "$jq_stderr_file"' EXIT

        if [[ "$mode" == "modify" ]]; then
            # 修改模式：替换 httpServers 数组的第一个元素
            # 移除 | fromjson
            jq_script='.network.httpServers[0] = $new_obj'
        else
            # 新建模式：确保 network 和 httpServers 存在，然后添加
            # 移除 | fromjson
            jq_script='
                (.network //= {}) |
                (.network.httpServers //= []) |
                .network.httpServers += [$new_obj]
            '
            # 或者更健壮的写法，确保 network 是对象，httpServers 是数组
            # jq_script='
            #     (if .network == null or (.network|type) != "object" then .network = {} else . end) |
            #     (if .network.httpServers == null or (.network.httpServers|type) != "array" then .network.httpServers = [] else . end) |
            #     .network.httpServers += [$new_obj]
            # '
        fi

        # 执行 jq，将 stdout 重定向到 temp_file, 将 stderr 重定向到 jq_stderr_file
        if jq --argjson new_obj "$new_server_obj" "$jq_script" "$config_file" > "$temp_file" 2> "$jq_stderr_file"; then
            # 检查写入临时文件是否成功且内容不为空
            if [[ -s "$temp_file" ]]; then
                 # 备份原始文件 (可选但推荐)
                 # cp "$config_file" "$config_file.bak"
                 # 用临时文件覆盖原始文件
                 if mv "$temp_file" "$config_file"; then
                     dialog --colors --msgbox "${FG_GREEN}HTTP 服务端配置已成功 $title_prefix！${RESET}" 8 50
                     rm -f "$jq_stderr_file"
                     trap - EXIT
                     return 0
                 else
                     dialog --colors --msgbox "${FG_RED}错误：${RESET}无法更新配置文件 '$config_file'。权限问题？" 8 60
                     rm -f "$jq_stderr_file"
                     return 1
                 fi
            else
                 local jq_error=$(<"$jq_stderr_file")
                 # 错误消息用红色
                 dialog --colors --msgbox "${FG_RED}错误：${RESET}jq 处理后生成了空文件。请检查 jq 脚本和输入。\n\nJQ 输出(可能为空):\n$(cat "$temp_file")\n\n${FG_RED}JQ 错误:${RESET}\n$jq_error" 15 70
                 rm -f "$jq_stderr_file"
                 return 1
            fi
        else
            local jq_error=$(<"$jq_stderr_file")
            rm -f "$jq_stderr_file"
            # 错误消息用红色
            dialog --colors --msgbox "${FG_RED}错误：${RESET}使用 jq 更新 JSON 时出错。\n\n${FG_RED}JQ 错误:${RESET}\n$jq_error\n\n请检查 JSON 文件格式或 jq 命令。" 15 70
            return 1
        fi

        # 如果代码能执行到这里，说明更新逻辑有问题，强制退出循环避免死循环
        break
    done
}


# 反向HTTP客户端配置
configure_reverse_http_client() {
    local qq_account=$1
    local config_file="$CONFIG_DIR/onebot11_${qq_account}.json"
    local temp_file=$(mktemp) || { echo "无法创建临时文件"; exit 1; }
    local jq_stderr_file=$(mktemp) # 用于捕获 jq 错误
    # 确保临时文件和错误文件在退出时被删除
    trap 'rm -f "$temp_file" "$jq_stderr_file"' EXIT

    # 检查配置文件是否存在且可读
    if [[ ! -f "$config_file" ]] || [[ ! -r "$config_file" ]]; then
        dialog --colors --msgbox "${FG_RED}错误：${RESET}无法读取配置文件 '$config_file'。" 8 60
        return 1
    fi

    # --- 读取当前配置或设置默认值 ---
    local mode="create" # 默认为新建模式
    local current_name=""
    local current_url="http://localhost:8080" # 默认 URL
    local current_token=""
    local current_msg_format="array" # 默认消息格式
    local current_enable="off"       # 默认不启用
    local current_debug="off"        # 默认不开启 Debug
    local current_report_self="off" # 默认不上报自身消息

    # 尝试读取 network.httpClients[0]
    local client_config=$(jq -c '.network.httpClients[0] // null' "$config_file")

    if [[ "$client_config" != "null" ]]; then
        mode="modify"
        current_name=$(echo "$client_config" | jq -r '.name // ""')
        current_url=$(echo "$client_config" | jq -r '.url // "http://localhost:8080"')
        current_token=$(echo "$client_config" | jq -r '.token // ""')
        current_msg_format=$(echo "$client_config" | jq -r '.messagePostFormat // "array"')
        [[ $(echo "$client_config" | jq -r '.enable // false') == "true" ]] && current_enable="on"
        [[ $(echo "$client_config" | jq -r '.debug // false') == "true" ]] && current_debug="on"
        [[ $(echo "$client_config" | jq -r '.reportSelfMessage // false') == "true" ]] && current_report_self="on"
    fi

    local title_prefix="${FG_GREEN}新建${RESET}"
    [[ "$mode" == "modify" ]] && title_prefix="${FG_YELLOW}修改${RESET}"
    local form_values
    while true; do
        # --- 显示表单 ---
        # 1. 输入框部分
        exec 3>&1
        form_values=$(dialog --colors --clear --backtitle "HTTP 客户端配置" \
            --title "$title_prefix HTTP 客户端 - $qq_account" \
            --form "请填写以下信息 (带 * 为必填):" 18 70 0 \
            "名称 (*):"     1 1 "$current_name"        1 15 40 0 \
            "Url (*):"      2 1 "$current_url"         2 15 60 0 \
            "Token:"        3 1 "$current_token"       3 15 40 0 \
        2>&1 1>&3)
        local form_exit_status=$?
        exec 3>&-
        clear

        if [[ $form_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi

        # 解析表单输入
        local name=$(echo "$form_values" | sed -n '1p')
        local url=$(echo "$form_values" | sed -n '2p')
        local token=$(echo "$form_values" | sed -n '3p')
        local msg_format_choice
        # 2. 消息格式选择
        exec 3>&1
        msg_format_choice=$(dialog --colors --clear --backtitle "HTTP 客户端配置" \
            --title "选择消息格式 - $qq_account" \
            --radiolist "请选择上报消息格式:(空格来选中/取消)" 10 40 2 \
            "array"  "数组格式" $([[ "$current_msg_format" == "array" ]] && echo "on" || echo "off") \
            "string" "字符串格式" $([[ "$current_msg_format" == "string" ]] && echo "on" || echo "off") \
        2>&1 1>&3)
        local radio_exit_status=$?
        exec 3>&-
        clear

        if [[ $radio_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi
        local msg_format="$msg_format_choice"
        local checklist_choices
        # 3. 开关选择
        exec 3>&1
        checklist_choices=$(dialog --colors --clear --backtitle "HTTP 客户端配置" \
            --title "启用选项 - $qq_account" \
            --checklist "请选择要启用的选项:(空格来选中/取消)" 15 50 3 \
            "enable"      "启用服务"        "$current_enable" \
            "debug"       "开启Debug"       "$current_debug" \
            "report_self" "上报自身消息"    "$current_report_self" \
        2>&1 1>&3)
        local check_exit_status=$?
        exec 3>&-
        clear

        if [[ $check_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi

        # 解析 checklist 输出
        local enable=false; [[ "$checklist_choices" == *enable* ]] && enable=true
        local debug=false;  [[ "$checklist_choices" == *debug* ]] && debug=true
        local report_self=false; [[ "$checklist_choices" == *report_self* ]] && report_self=true

        # --- 输入验证 ---
        local errors=()
        # URL 验证正则表达式 (Perl 兼容)
        local url_regex='\b(([\w-]+://?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|/)))'

        # 必填项检查
        [[ -z "$name" ]] && errors+=("名称不能为空")
        [[ -z "$url" ]] && errors+=("Url不能为空")

        # Url 格式检查
        # 使用 grep -P 进行 Perl 兼容正则表达式匹配
        if [[ -n "$url" ]] && ! echo "$url" | grep -Pq "$url_regex"; then
             errors+=("Url '$url' 格式不正确")
        fi

        # 名称唯一性检查 (仅在名称非空时进行)
        if [[ -n "$name" ]]; then
            local original_name_to_exclude=""
            # 在修改模式下，获取当前正在修改的客户端的原始名称
            [[ "$mode" == "modify" ]] && original_name_to_exclude=$(jq -r '.network.httpClients[0].name // ""' "$config_file")

            # 获取所有其他服务的名称 (排除当前修改项的原始名称和当前输入名称)
            local all_other_names=()
            # 使用 readarray 读取 jq 输出的多行结果
            readarray -t all_other_names < <(jq -r --arg exclude "$original_name_to_exclude" --arg current "$name" '
                .network | [
                    .httpServers[]?.name,
                    # 排除自己(修改模式下原始名称)和当前输入名称
                    (.httpClients[]? | select(.name != $exclude and .name != $current) | .name),
                    .websocketServers[]?.name,
                    .websocketClients[]?.name
                ] | map(select(. != null)) | .[]
            ' "$config_file")

            # 检查冲突
            for other_name in "${all_other_names[@]}"; do
                if [[ "$name" == "$other_name" ]]; then
                    errors+=("名称 '$name' 与其他服务冲突")
                    break # 找到一个冲突就够了
                fi
            done
        fi

        # --- 处理验证结果 ---
        if [[ ${#errors[@]} -gt 0 ]]; then
            # 错误标题用红色，错误项用黄色
            local error_msg="${FG_RED}输入无效:${RESET}\n\n"
            for error in "${errors[@]}"; do
                error_msg+=" - ${FG_YELLOW}$error${RESET}\n"
            done
            dialog --colors --msgbox "$error_msg" 15 70 # 增加宽度以显示 URL
            # 保留用户输入以便下次显示 (重要的交互改进)
            current_name="$name"
            current_url="$url"
            current_token="$token"
            current_msg_format="$msg_format"
            [[ "$enable" == true ]] && current_enable="on" || current_enable="off"
            [[ "$debug" == true ]] && current_debug="on" || current_debug="off"
            [[ "$report_self" == true ]] && current_report_self="on" || current_report_self="off"
            continue # 返回循环，重新显示表单
        fi

        # --- 验证通过，构建 JSON 对象 ---
        local new_client_obj=$(jq -n \
            --arg name "$name" \
            --arg url "$url" \
            --arg token "$token" \
            --arg msg_format "$msg_format" \
            --argjson enable "$enable" \
            --argjson debug "$debug" \
            --argjson report_self "$report_self" \
            '{
                enable: $enable,
                name: $name,
                url: $url,
                reportSelfMessage: $report_self,
                messagePostFormat: $msg_format,
                token: $token,
                debug: $debug
            }')

        # --- 更新 JSON 文件 ---
        local jq_script=""

        if [[ "$mode" == "modify" ]]; then
            # 修改模式：替换 httpClients 数组的第一个元素
            jq_script='.network.httpClients[0] = $new_obj'
        else
            # 新建模式：确保 network 和 httpClients 存在，然后添加
            jq_script='
                (.network //= {}) |
                (.network.httpClients //= []) |
                .network.httpClients += [$new_obj]
            '
        fi

        # 执行 jq，将 stdout 重定向到 temp_file, 将 stderr 重定向到 jq_stderr_file
        if jq --argjson new_obj "$new_client_obj" "$jq_script" "$config_file" > "$temp_file" 2> "$jq_stderr_file"; then
            # 检查写入临时文件是否成功且内容不为空
            if [[ -s "$temp_file" ]]; then
                 # 备份原始文件 (可选但推荐)
                 # cp "$config_file" "$config_file.bak"
                 # 用临时文件覆盖原始文件
                 if mv "$temp_file" "$config_file"; then
                     dialog --colors --msgbox "${FG_GREEN}HTTP 客户端配置已成功 $title_prefix！${RESET}" 8 50
                     # 成功后不再需要 trap，清理错误文件
                     rm -f "$jq_stderr_file"
                     trap - EXIT
                     return 0 # 成功退出函数
                 else
                     dialog --colors --msgbox "${FG_RED}错误：${RESET}无法更新配置文件 '$config_file'。权限问题？" 8 60
                     # 出错也清理错误文件
                     rm -f "$jq_stderr_file"
                     return 1 # 失败退出函数
                 fi
            else
                 # jq 成功执行但输出了空文件，这通常是 jq 脚本逻辑问题
                 local jq_error_output=$(<"$jq_stderr_file") # 读取 jq 的 stderr
                 dialog --colors --msgbox "${FG_RED}错误：${RESET}jq 处理后生成了空文件。请检查 jq 脚本和输入。\n\nJQ 输出(空):\n\n${FG_RED}JQ 错误:${RESET}\n$jq_error_output" 15 70
                 rm -f "$jq_stderr_file"
                 return 1 # 失败退出函数
            fi
        else
            # jq 命令执行失败
            local jq_error_output=$(<"$jq_stderr_file") # 读取 jq 的 stderr
            rm -f "$jq_stderr_file"
            dialog --colors --msgbox "${FG_RED}错误：${RESET}使用 jq 更新 JSON 时出错。\n\n${FG_RED}JQ 错误:${RESET}\n$jq_error_output\n\n请检查 JSON 文件格式或 jq 命令。" 15 70
            return 1 # 失败退出函数
        fi

        # 理论上不应执行到这里，因为上面有 return，但为保险起见加上 break
        break
    done
}
configure_ws_server() {
    local qq_account=$1
    local config_file="$CONFIG_DIR/onebot11_${qq_account}.json"
    local temp_file=$(mktemp) || { echo "无法创建临时文件"; exit 1; }
    local jq_stderr_file=$(mktemp) # 用于捕获 jq 错误
    # 确保临时文件和错误文件在退出时被删除
    trap 'rm -f "$temp_file" "$jq_stderr_file"' EXIT

    # 检查配置文件是否存在且可读
    if [[ ! -f "$config_file" ]] || [[ ! -r "$config_file" ]]; then
        dialog --colors --msgbox "${FG_RED}错误：${RESET}无法读取配置文件 '$config_file'。" 8 60
        return 1
    fi

    # --- 读取当前配置或设置默认值 ---
    local mode="create" # 默认为新建模式
    local current_name=""
    local current_host="0.0.0.0"
    local current_port="3001" # 根据示例 JSON 使用 3001
    local current_heart_interval="30000"
    local current_token=""
    local current_msg_format="array"
    local current_enable="off"
    local current_debug="off"
    local current_report_self="off"
    local current_force_push="on" # 默认开启

    # 尝试读取 network.websocketServers[0]
    local server_config=$(jq -c '.network.websocketServers[0] // null' "$config_file")

    if [[ "$server_config" != "null" ]]; then
        mode="modify"
        current_name=$(echo "$server_config" | jq -r '.name // ""')
        current_host=$(echo "$server_config" | jq -r '.host // "0.0.0.0"')
        current_port=$(echo "$server_config" | jq -r '.port // "3001"') # 保持默认一致
        current_heart_interval=$(echo "$server_config" | jq -r '.heartInterval // "30000"')
        current_token=$(echo "$server_config" | jq -r '.token // ""')
        current_msg_format=$(echo "$server_config" | jq -r '.messagePostFormat // "array"')
        [[ $(echo "$server_config" | jq -r '.enable // false') == "true" ]] && current_enable="on"
        [[ $(echo "$server_config" | jq -r '.debug // false') == "true" ]] && current_debug="on"
        [[ $(echo "$server_config" | jq -r '.reportSelfMessage // false') == "true" ]] && current_report_self="on"
        [[ $(echo "$server_config" | jq -r '.enableForcePushEvent // true') == "true" ]] && current_force_push="on" # 默认开启
    fi

    local title_prefix="${FG_GREEN}新建${RESET}"
    [[ "$mode" == "modify" ]] && title_prefix="${FG_YELLOW}修改${RESET}"
    local form_values
    while true; do
        # --- 显示表单 ---
        # 1. 输入框部分
        exec 3>&1
        form_values=$(dialog --colors --clear --backtitle "WebSocket 服务端配置" \
            --title "$title_prefix WebSocket 服务端 - $qq_account" \
            --form "请填写以下信息 (带 * 为必填):" 18 70 0 \
            "名称 (*):"         1 1 "$current_name"             1 18 40 0 \
            "Host (*):"         2 1 "$current_host"             2 18 40 0 \
            "Port (*):"         3 1 "$current_port"             3 18 40 0 \
            "心跳间隔(ms)(*):" 4 1 "$current_heart_interval"   4 18 40 0 \
            "Token:"            5 1 "$current_token"            5 18 40 0 \
        2>&1 1>&3)
        local form_exit_status=$?
        exec 3>&-
        clear

        if [[ $form_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi

        # 解析表单输入
        local name=$(echo "$form_values" | sed -n '1p')
        local host=$(echo "$form_values" | sed -n '2p')
        local port=$(echo "$form_values" | sed -n '3p')
        local heart_interval=$(echo "$form_values" | sed -n '4p')
        local token=$(echo "$form_values" | sed -n '5p')
        local msg_format_choice
        # 2. 消息格式选择
        exec 3>&1
        msg_format_choice=$(dialog --colors --clear --backtitle "WebSocket 服务端配置" \
            --title "选择消息格式 - $qq_account" \
            --radiolist "请选择上报消息格式:(空格来选中/取消)" 10 40 2 \
            "array"  "数组格式" $([[ "$current_msg_format" == "array" ]] && echo "on" || echo "off") \
            "string" "字符串格式" $([[ "$current_msg_format" == "string" ]] && echo "on" || echo "off") \
        2>&1 1>&3)
        local radio_exit_status=$?
        exec 3>&-
        clear

        if [[ $radio_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi
        local msg_format="$msg_format_choice"
        local checklist_choices
        # 3. 开关选择
        exec 3>&1
        checklist_choices=$(dialog --colors --clear --backtitle "WebSocket 服务端配置" \
            --title "启用选项 - $qq_account" \
            --checklist "请选择要启用的选项:(空格来选中/取消)" 15 50 4 \
            "enable"      "启用服务"        "$current_enable" \
            "debug"       "开启Debug"       "$current_debug" \
            "report_self" "上报自身消息"    "$current_report_self" \
            "force_push"  "强制推送事件"    "$current_force_push" \
        2>&1 1>&3)
        local check_exit_status=$?
        exec 3>&-
        clear

        if [[ $check_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi

        # 解析 checklist 输出
        local enable=false; [[ "$checklist_choices" == *enable* ]] && enable=true
        local debug=false;  [[ "$checklist_choices" == *debug* ]] && debug=true
        local report_self=false; [[ "$checklist_choices" == *report_self* ]] && report_self=true
        local force_push=false; [[ "$checklist_choices" == *force_push* ]] && force_push=true

        # --- 输入验证 ---
        local errors=()
        local ipv4_regex='^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$'

        # 必填项检查
        [[ -z "$name" ]] && errors+=("名称不能为空")
        [[ -z "$host" ]] && errors+=("Host不能为空")
        [[ -z "$port" ]] && errors+=("Port不能为空")
        [[ -z "$heart_interval" ]] && errors+=("心跳间隔不能为空")

        # Host 格式检查
        if [[ -n "$host" ]]; then
            if [[ "$host" == "localhost" ]]; then
                host="0.0.0.0" # 替换 localhost
            elif ! [[ "$host" =~ $ipv4_regex ]]; then
                 errors+=("Host '$host' 不是有效的 IPv4 地址格式")
            fi
        fi

        # Port 格式和范围检查
        if [[ -n "$port" ]] && ! [[ "$port" =~ ^[0-9]+$ ]] || [[ "$port" -lt 1 ]] || [[ "$port" -gt 65535 ]]; then
            errors+=("Port '$port' 必须是 1-65535 之间的数字")
        fi

        # 心跳间隔格式检查 (必须是数字)
        if [[ -n "$heart_interval" ]] && ! [[ "$heart_interval" =~ ^[0-9]+$ ]]; then
             errors+=("心跳间隔 '$heart_interval' 必须是数字")
        fi

        # 名称唯一性检查 (仅在名称非空时进行)
        if [[ -n "$name" ]]; then
            local original_name_to_exclude=""
            [[ "$mode" == "modify" ]] && original_name_to_exclude=$(jq -r '.network.websocketServers[0].name // ""' "$config_file")

            local all_other_names=()
            readarray -t all_other_names < <(jq -r --arg exclude "$original_name_to_exclude" --arg current "$name" '
                .network | [
                    .httpServers[]?.name,
                    .httpClients[]?.name,
                    (.websocketServers[]? | select(.name != $exclude and .name != $current) | .name), # 排除自己(修改模式)和当前输入
                    .websocketClients[]?.name
                ] | map(select(. != null)) | .[]
            ' "$config_file")

            for other_name in "${all_other_names[@]}"; do
                if [[ "$name" == "$other_name" ]]; then
                    errors+=("名称 '$name' 与其他服务冲突")
                    break
                fi
            done
        fi

        # 端口占用检查 (仅在 Port 有效时进行)
        if [[ "$port" =~ ^[0-9]+$ ]] && [[ "$port" -ge 1 ]] && [[ "$port" -le 65535 ]]; then
            # 检查 TCP 监听端口
            if ss -tuln | grep -q ":${port}\s"; then
                 errors+=("端口 $port 可能已被占用")
            fi
        fi

        # --- 处理验证结果 ---
        if [[ ${#errors[@]} -gt 0 ]]; then
            local error_msg="${FG_RED}输入无效:${RESET}\n\n"
            for error in "${errors[@]}"; do
                error_msg+=" - ${FG_YELLOW}$error${RESET}\n"
            done
            dialog --colors --msgbox "$error_msg" 15 70
            # 保留用户输入以便下次显示
            current_name="$name"
            current_host="$host"
            current_port="$port"
            current_heart_interval="$heart_interval"
            current_token="$token"
            current_msg_format="$msg_format"
            [[ "$enable" == true ]] && current_enable="on" || current_enable="off"
            [[ "$debug" == true ]] && current_debug="on" || current_debug="off"
            [[ "$report_self" == true ]] && current_report_self="on" || current_report_self="off"
            [[ "$force_push" == true ]] && current_force_push="on" || current_force_push="off"
            continue # 返回循环，重新显示表单
        fi

        # --- 验证通过，构建 JSON 对象 ---
        local new_server_obj=$(jq -n \
            --arg name "$name" \
            --arg host "$host" \
            --argjson port "$port" \
            --argjson heart_interval "$heart_interval" \
            --arg token "$token" \
            --arg msg_format "$msg_format" \
            --argjson enable "$enable" \
            --argjson debug "$debug" \
            --argjson report_self "$report_self" \
            --argjson force_push "$force_push" \
            '{
                enable: $enable,
                name: $name,
                host: $host,
                port: $port,
                reportSelfMessage: $report_self,
                enableForcePushEvent: $force_push,
                messagePostFormat: $msg_format,
                token: $token,
                debug: $debug,
                heartInterval: $heart_interval
            }')

        # --- 更新 JSON 文件 ---
        local jq_script=""

        if [[ "$mode" == "modify" ]]; then
            # 修改模式：替换 websocketServers 数组的第一个元素
            jq_script='.network.websocketServers[0] = $new_obj'
        else
            # 新建模式：确保 network 和 websocketServers 存在，然后添加
            jq_script='
                (.network //= {}) |
                (.network.websocketServers //= []) |
                .network.websocketServers += [$new_obj]
            '
        fi

        # 执行 jq
        if jq --argjson new_obj "$new_server_obj" "$jq_script" "$config_file" > "$temp_file" 2> "$jq_stderr_file"; then
            if [[ -s "$temp_file" ]]; then
                 # cp "$config_file" "$config_file.bak" # 可选备份
                 if mv "$temp_file" "$config_file"; then
                     dialog --colors --msgbox "${FG_GREEN}WebSocket 服务端配置已成功 $title_prefix！${RESET}" 8 50
                     rm -f "$jq_stderr_file"
                     trap - EXIT
                     return 0
                 else
                     dialog --colors --msgbox "${FG_RED}错误：${RESET}无法更新配置文件 '$config_file'。权限问题？" 8 60
                     rm -f "$jq_stderr_file"
                     return 1
                 fi
            else
                 local jq_error_output=$(<"$jq_stderr_file")
                 dialog --colors --msgbox "${FG_RED}错误：${RESET}jq 处理后生成了空文件。\n\nJQ 输出(空):\n\n${FG_RED}JQ 错误:${RESET}\n$jq_error_output" 15 70
                 rm -f "$jq_stderr_file"
                 return 1
            fi
        else
            local jq_error_output=$(<"$jq_stderr_file")
            rm -f "$jq_stderr_file"
            dialog --colors --msgbox "${FG_RED}错误：${RESET}使用 jq 更新 JSON 时出错。\n\n${FG_RED}JQ 错误:${RESET}\n$jq_error_output" 15 70
            return 1
        fi

        break # 避免死循环
    done
}

configure_reverse_ws_client() {
    local qq_account=$1
    local config_file="$CONFIG_DIR/onebot11_${qq_account}.json"
    local temp_file=$(mktemp) || { echo "无法创建临时文件"; exit 1; }
    local jq_stderr_file=$(mktemp) # 用于捕获 jq 错误
    # 确保临时文件和错误文件在退出时被删除
    trap 'rm -f "$temp_file" "$jq_stderr_file"' EXIT

    # 检查配置文件是否存在且可读
    if [[ ! -f "$config_file" ]] || [[ ! -r "$config_file" ]]; then
        dialog --colors --msgbox "${FG_RED}错误：${RESET}无法读取配置文件 '$config_file'。" 8 60
        return 1
    fi

    # --- 读取当前配置或设置默认值 ---
    local mode="create" # 默认为新建模式
    local current_name=""
    local current_url="ws://localhost:8082" # 默认 URL (根据示例 JSON)
    local current_heart_interval="30000"
    local current_reconnect_interval="30000"
    local current_token=""
    local current_msg_format="array"
    local current_enable="off"
    local current_debug="off"
    local current_report_self="off"

    # 尝试读取 network.websocketClients[0]
    local client_config=$(jq -c '.network.websocketClients[0] // null' "$config_file")

    if [[ "$client_config" != "null" ]]; then
        mode="modify"
        current_name=$(echo "$client_config" | jq -r '.name // ""')
        current_url=$(echo "$client_config" | jq -r '.url // "ws://localhost:8082"')
        current_heart_interval=$(echo "$client_config" | jq -r '.heartInterval // "30000"')
        current_reconnect_interval=$(echo "$client_config" | jq -r '.reconnectInterval // "30000"')
        current_token=$(echo "$client_config" | jq -r '.token // ""')
        current_msg_format=$(echo "$client_config" | jq -r '.messagePostFormat // "array"')
        [[ $(echo "$client_config" | jq -r '.enable // false') == "true" ]] && current_enable="on"
        [[ $(echo "$client_config" | jq -r '.debug // false') == "true" ]] && current_debug="on"
        [[ $(echo "$client_config" | jq -r '.reportSelfMessage // false') == "true" ]] && current_report_self="on"
    fi

    local title_prefix="${FG_GREEN}新建${RESET}"
    [[ "$mode" == "modify" ]] && title_prefix="${FG_YELLOW}修改${RESET}"
    local form_values
    while true; do
        # --- 显示表单 ---
        # 1. 输入框部分
        exec 3>&1
        form_values=$(dialog --colors --clear --backtitle "WebSocket 客户端配置" \
            --title "$title_prefix WebSocket 客户端 - $qq_account" \
            --form "请填写以下信息 (带 * 为必填):" 18 70 0 \
            "名称 (*):"         1 1 "$current_name"                 1 19 40 0 \
            "Url (*):"          2 1 "$current_url"                  2 19 60 0 \
            "心跳间隔(ms)(*):" 3 1 "$current_heart_interval"       3 19 40 0 \
            "重连间隔(ms)(*):" 4 1 "$current_reconnect_interval"   4 19 40 0 \
            "Token:"            5 1 "$current_token"                5 19 40 0 \
        2>&1 1>&3)
        local form_exit_status=$?
        exec 3>&-
        clear

        if [[ $form_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi

        # 解析表单输入
        local name=$(echo "$form_values" | sed -n '1p')
        local url=$(echo "$form_values" | sed -n '2p')
        local heart_interval=$(echo "$form_values" | sed -n '3p')
        local reconnect_interval=$(echo "$form_values" | sed -n '4p')
        local token=$(echo "$form_values" | sed -n '5p')
        local msg_format_choice
        # 2. 消息格式选择
        exec 3>&1
        msg_format_choice=$(dialog --colors --clear --backtitle "WebSocket 客户端配置" \
            --title "选择消息格式 - $qq_account" \
            --radiolist "请选择上报消息格式:(空格来选中/取消)" 10 40 2 \
            "array"  "数组格式" $([[ "$current_msg_format" == "array" ]] && echo "on" || echo "off") \
            "string" "字符串格式" $([[ "$current_msg_format" == "string" ]] && echo "on" || echo "off") \
        2>&1 1>&3)
        local radio_exit_status=$?
        exec 3>&-
        clear

        if [[ $radio_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi
        local msg_format="$msg_format_choice"
        local checklist_choices
        # 3. 开关选择
        exec 3>&1
        checklist_choices=$(dialog --colors --clear --backtitle "WebSocket 客户端配置" \
            --title "启用选项 - $qq_account" \
            --checklist "请选择要启用的选项:(空格来选中/取消)" 15 50 3 \
            "enable"      "启用服务"        "$current_enable" \
            "debug"       "开启Debug"       "$current_debug" \
            "report_self" "上报自身消息"    "$current_report_self" \
        2>&1 1>&3)
        local check_exit_status=$?
        exec 3>&-
        clear

        if [[ $check_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi

        # 解析 checklist 输出
        local enable=false; [[ "$checklist_choices" == *enable* ]] && enable=true
        local debug=false;  [[ "$checklist_choices" == *debug* ]] && debug=true
        local report_self=false; [[ "$checklist_choices" == *report_self* ]] && report_self=true

        # --- 输入验证 ---
        local errors=()
        # URL 验证正则表达式 (Perl 兼容) - 稍微修改以更好地匹配 ws/wss
        local url_regex='\b((wss?|https?)://[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|/)))'

        # 必填项检查
        [[ -z "$name" ]] && errors+=("名称不能为空")
        [[ -z "$url" ]] && errors+=("Url不能为空")
        [[ -z "$heart_interval" ]] && errors+=("心跳间隔不能为空")
        [[ -z "$reconnect_interval" ]] && errors+=("重连间隔不能为空")

        # Url 格式检查
        if [[ -n "$url" ]]; then
             if ! echo "$url" | grep -Pq "$url_regex"; then
                 errors+=("Url '$url' 格式不正确")
             elif ! [[ "$url" =~ ^wss?:// ]]; then # 确保是 ws 或 wss 开头
                 errors+=("Url '$url' 必须以 ws:// 或 wss:// 开头")
             fi
        fi

        # 心跳间隔格式检查 (必须是数字)
        if [[ -n "$heart_interval" ]] && ! [[ "$heart_interval" =~ ^[0-9]+$ ]]; then
             errors+=("心跳间隔 '$heart_interval' 必须是数字")
        fi

        # 重连间隔格式检查 (必须是数字)
        if [[ -n "$reconnect_interval" ]] && ! [[ "$reconnect_interval" =~ ^[0-9]+$ ]]; then
             errors+=("重连间隔 '$reconnect_interval' 必须是数字")
        fi

        # 名称唯一性检查 (仅在名称非空时进行)
        if [[ -n "$name" ]]; then
            local original_name_to_exclude=""
            [[ "$mode" == "modify" ]] && original_name_to_exclude=$(jq -r '.network.websocketClients[0].name // ""' "$config_file")

            local all_other_names=()
            readarray -t all_other_names < <(jq -r --arg exclude "$original_name_to_exclude" --arg current "$name" '
                .network | [
                    .httpServers[]?.name,
                    .httpClients[]?.name,
                    .websocketServers[]?.name,
                    (.websocketClients[]? | select(.name != $exclude and .name != $current) | .name) # 排除自己(修改模式)和当前输入
                ] | map(select(. != null)) | .[]
            ' "$config_file")

            for other_name in "${all_other_names[@]}"; do
                if [[ "$name" == "$other_name" ]]; then
                    errors+=("名称 '$name' 与其他服务冲突")
                    break
                fi
            done
        fi

        # --- 处理验证结果 ---
        if [[ ${#errors[@]} -gt 0 ]]; then
            local error_msg="${FG_RED}输入无效:${RESET}\n\n"
            for error in "${errors[@]}"; do
                error_msg+=" - ${FG_YELLOW}$error${RESET}\n"
            done
            dialog --colors --msgbox "$error_msg" 15 70
            # 保留用户输入以便下次显示
            current_name="$name"
            current_url="$url"
            current_heart_interval="$heart_interval"
            current_reconnect_interval="$reconnect_interval"
            current_token="$token"
            current_msg_format="$msg_format"
            [[ "$enable" == true ]] && current_enable="on" || current_enable="off"
            [[ "$debug" == true ]] && current_debug="on" || current_debug="off"
            [[ "$report_self" == true ]] && current_report_self="on" || current_report_self="off"
            continue # 返回循环，重新显示表单
        fi

        # --- 验证通过，构建 JSON 对象 ---
        local new_client_obj=$(jq -n \
            --arg name "$name" \
            --arg url "$url" \
            --argjson heart_interval "$heart_interval" \
            --argjson reconnect_interval "$reconnect_interval" \
            --arg token "$token" \
            --arg msg_format "$msg_format" \
            --argjson enable "$enable" \
            --argjson debug "$debug" \
            --argjson report_self "$report_self" \
            '{
                enable: $enable,
                name: $name,
                url: $url,
                reportSelfMessage: $report_self,
                messagePostFormat: $msg_format,
                token: $token,
                debug: $debug,
                heartInterval: $heart_interval,
                reconnectInterval: $reconnect_interval
            }')

        # --- 更新 JSON 文件 ---
        local jq_script=""

        if [[ "$mode" == "modify" ]]; then
            # 修改模式：替换 websocketClients 数组的第一个元素
            jq_script='.network.websocketClients[0] = $new_obj'
        else
            # 新建模式：确保 network 和 websocketClients 存在，然后添加
            jq_script='
                (.network //= {}) |
                (.network.websocketClients //= []) |
                .network.websocketClients += [$new_obj]
            '
        fi

        # 执行 jq
        if jq --argjson new_obj "$new_client_obj" "$jq_script" "$config_file" > "$temp_file" 2> "$jq_stderr_file"; then
            if [[ -s "$temp_file" ]]; then
                 # cp "$config_file" "$config_file.bak" # 可选备份
                 if mv "$temp_file" "$config_file"; then
                     dialog --colors --msgbox "${FG_GREEN}WebSocket 客户端配置已成功 $title_prefix！${RESET}" 8 50
                     rm -f "$jq_stderr_file"
                     trap - EXIT
                     return 0
                 else
                     dialog --colors --msgbox "${FG_RED}错误：${RESET}无法更新配置文件 '$config_file'。权限问题？" 8 60
                     rm -f "$jq_stderr_file"
                     return 1
                 fi
            else
                 local jq_error_output=$(<"$jq_stderr_file")
                 dialog --colors --msgbox "${FG_RED}错误：${RESET}jq 处理后生成了空文件。\n\nJQ 输出(空):\n\n${FG_RED}JQ 错误:${RESET}\n$jq_error_output" 15 70
                 rm -f "$jq_stderr_file"
                 return 1
            fi
        else
            local jq_error_output=$(<"$jq_stderr_file")
            rm -f "$jq_stderr_file"
            dialog --colors --msgbox "${FG_RED}错误：${RESET}使用 jq 更新 JSON 时出错。\n\n${FG_RED}JQ 错误:${RESET}\n$jq_error_output" 15 70
            return 1
        fi

        break # 避免死循环
    done
}
configure_music_signature() {
    local qq_account=$1
    local config_file="$CONFIG_DIR/onebot11_${qq_account}.json"
    local temp_file=$(mktemp) || { echo "无法创建临时文件"; exit 1; }
    local jq_stderr_file=$(mktemp) # 用于捕获 jq 错误
    # 确保临时文件和错误文件在退出时被删除
    trap 'rm -f "$temp_file" "$jq_stderr_file"' EXIT

    # 检查配置文件是否存在且可读
    if [[ ! -f "$config_file" ]] || [[ ! -r "$config_file" ]]; then
        dialog --colors --msgbox "${FG_RED}错误：${RESET}无法读取配置文件 '$config_file'。" 8 60
        return 1
    fi

    # --- 读取当前配置或设置默认值 ---
    # 注意：这些字段在 JSON 的根级别
    local current_music_url=$(jq -r '.musicSignUrl // ""' "$config_file")
    local current_enable_local_file="on" # 默认开启
    [[ $(jq -r '.enableLocalFile2Url // true' "$config_file") == "false" ]] && current_enable_local_file="off"
    local current_parse_mult_msg="off" # 默认关闭
    [[ $(jq -r '.parseMultMsg // false' "$config_file") == "true" ]] && current_parse_mult_msg="on"

    local form_values
    while true; do
        # --- 显示表单 ---
        # 1. 输入框部分
        exec 3>&1
        form_values=$(dialog --colors --clear --backtitle "音乐签名配置" \
            --title "配置音乐签名 - $qq_account" \
            --form "请填写以下信息 (带 * 为必填):" 15 70 0 \
            "音乐签名地址 (*):" 1 1 "$current_music_url" 1 20 60 0 \
        2>&1 1>&3)
        local form_exit_status=$?
        exec 3>&-
        clear

        if [[ $form_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi

        # 解析表单输入
        local music_url=$(echo "$form_values" | sed -n '1p')
        local checklist_choices
        # 2. 开关选择
        exec 3>&1
        checklist_choices=$(dialog --colors --clear --backtitle "音乐签名配置" \
            --title "启用选项 - $qq_account" \
            --checklist "请选择要启用的选项:(空格来选中/取消)" 15 60 2 \
            "enable_local" "启用本地文件到URL" "$current_enable_local_file" \
            "parse_mult"   "启用上报解析合并消息" "$current_parse_mult_msg" \
        2>&1 1>&3)
        local check_exit_status=$?
        exec 3>&-
        clear

        if [[ $check_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi

        # 解析 checklist 输出
        local enable_local=false; [[ "$checklist_choices" == *enable_local* ]] && enable_local=true
        local parse_mult=false;   [[ "$checklist_choices" == *parse_mult* ]] && parse_mult=true

        # --- 输入验证 ---
        local errors=()
        # URL 验证正则表达式 (Perl 兼容)
        local url_regex='\b(([\w-]+://?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|/)))'

        # 必填项检查
        [[ -z "$music_url" ]] && errors+=("音乐签名地址不能为空")

        # Url 格式检查
        if [[ -n "$music_url" ]] && ! echo "$music_url" | grep -Pq "$url_regex"; then
             errors+=("音乐签名地址 '$music_url' 格式不正确")
        fi

        # --- 处理验证结果 ---
        if [[ ${#errors[@]} -gt 0 ]]; then
            # 错误标题用红色，错误项用黄色
            local error_msg="${FG_RED}输入无效:${RESET}\n\n"
            for error in "${errors[@]}"; do
                error_msg+=" - ${FG_YELLOW}$error${RESET}\n"
            done
            dialog --colors --msgbox "$error_msg" 15 70
            # 保留用户输入以便下次显示
            current_music_url="$music_url" # 保留可能无效的URL，让用户修改
            [[ "$enable_local" == true ]] && current_enable_local_file="on" || current_enable_local_file="off"
            [[ "$parse_mult" == true ]] && current_parse_mult_msg="on" || current_parse_mult_msg="off"
            continue # 返回循环，重新显示表单
        fi

        # --- 验证通过，准备更新 JSON ---
        # 注意：这里我们直接修改根级别的字段，不需要构建嵌套对象

        # --- 更新 JSON 文件 ---
        # 使用 jq 直接修改根级别字段
        # --argjson 用于传递布尔值
        if jq \
            --arg musicUrl "$music_url" \
            --argjson enableLocal "$enable_local" \
            --argjson parseMult "$parse_mult" \
            '.musicSignUrl = $musicUrl | .enableLocalFile2Url = $enableLocal | .parseMultMsg = $parseMult' \
            "$config_file" > "$temp_file" 2> "$jq_stderr_file"; then
            # 检查写入临时文件是否成功且内容不为空
            if [[ -s "$temp_file" ]]; then
                 # 备份原始文件 (可选但推荐)
                 # cp "$config_file" "$config_file.bak"
                 # 用临时文件覆盖原始文件
                 if mv "$temp_file" "$config_file"; then
                     dialog --colors --msgbox "${FG_GREEN}音乐签名配置已成功更新！${RESET}" 8 50
                     # 成功后不再需要 trap，清理错误文件
                     rm -f "$jq_stderr_file"
                     trap - EXIT
                     return 0 # 成功退出函数
                 else
                     dialog --colors --msgbox "${FG_RED}错误：${RESET}无法更新配置文件 '$config_file'。权限问题？" 8 60
                     # 出错也清理错误文件
                     rm -f "$jq_stderr_file"
                     return 1 # 失败退出函数
                 fi
            else
                 # jq 成功执行但输出了空文件，这通常是 jq 脚本逻辑问题
                 local jq_error_output=$(<"$jq_stderr_file") # 读取 jq 的 stderr
                 dialog --colors --msgbox "${FG_RED}错误：${RESET}jq 处理后生成了空文件。请检查 jq 脚本和输入。\n\nJQ 输出(空):\n\n${FG_RED}JQ 错误:${RESET}\n$jq_error_output" 15 70
                 rm -f "$jq_stderr_file"
                 return 1 # 失败退出函数
            fi
        else
            # jq 命令执行失败
            local jq_error_output=$(<"$jq_stderr_file") # 读取 jq 的 stderr
            rm -f "$jq_stderr_file"
            dialog --colors --msgbox "${FG_RED}错误：${RESET}使用 jq 更新 JSON 时出错。\n\n${FG_RED}JQ 错误:${RESET}\n$jq_error_output\n\n请检查 JSON 文件格式或 jq 命令。" 15 70
            return 1 # 失败退出函数
        fi

        # 理论上不应执行到这里，因为上面有 return，但为保险起见加上 break
        break
    done
}

configure_webui() {
    local config_file="$CONFIG_DIR/webui.json"
    local temp_file=$(mktemp) || { echo "无法创建临时文件"; exit 1; }
    local jq_stderr_file=$(mktemp) # 用于捕获 jq 错误
    # 确保临时文件和错误文件在退出时被删除
    trap 'rm -f "$temp_file" "$jq_stderr_file"' EXIT

    # --- 读取当前配置或设置默认值 ---
    local current_host="0.0.0.0"
    local current_port="6099"
    local current_token="napcat"
    local current_login_rate="5"
    local current_prefix="" # prefix 字段也读取一下，虽然不在表单里，但更新时要保留

    # 检查配置文件是否存在且可读，如果存在则读取
    if [[ -f "$config_file" ]] && [[ -r "$config_file" ]]; then
        # 使用 jq 一次性读取所有值，减少文件读取次数
        local current_config=$(jq -c '.' "$config_file" 2>/dev/null)
        if [[ -n "$current_config" ]] && [[ "$current_config" != "null" ]]; then
            current_host=$(echo "$current_config" | jq -r '.host // "0.0.0.0"')
            current_port=$(echo "$current_config" | jq -r '.port // "6099"')
            current_token=$(echo "$current_config" | jq -r '.token // "napcat"')
            current_login_rate=$(echo "$current_config" | jq -r '.loginRate // "5"')
            current_prefix=$(echo "$current_config" | jq -r '.prefix // ""')
        fi
    else
        # 如果文件不存在，首次配置时提示一下
        dialog --colors --infobox "WebUI 配置文件 '$config_file' 不存在，将使用默认值创建。" 5 60
        sleep 2 # 短暂显示提示
    fi


    local form_values
    while true; do
        # --- 显示表单 ---
        exec 3>&1
        form_values=$(dialog --colors --clear --backtitle "WebUI 配置" \
            --title "配置 WebUI" \
            --form "请填写以下信息 (所有项均为必填):" 18 70 0 \
            "Host:"        1 1 "$current_host"        1 15 40 0 \
            "Port:"        2 1 "$current_port"        2 15 40 0 \
            "Token:"       3 1 "$current_token"       3 15 40 0 \
            "Login Rate:"  4 1 "$current_login_rate"  4 15 40 0 \
        2>&1 1>&3)
        local form_exit_status=$?
        exec 3>&-
        clear

        if [[ $form_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi

        # 解析表单输入
        local host=$(echo "$form_values" | sed -n '1p')
        local port=$(echo "$form_values" | sed -n '2p')
        local token=$(echo "$form_values" | sed -n '3p')
        local login_rate=$(echo "$form_values" | sed -n '4p')

        # --- 输入验证 ---
        local errors=()
        local ipv4_regex='^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$'

        # 必填项检查
        [[ -z "$host" ]] && errors+=("Host 不能为空")
        [[ -z "$port" ]] && errors+=("Port 不能为空")
        [[ -z "$token" ]] && errors+=("Token 不能为空")
        [[ -z "$login_rate" ]] && errors+=("Login Rate 不能为空")

        # Host 格式检查
        if [[ -n "$host" ]]; then
            if [[ "$host" == "localhost" ]]; then
                host="0.0.0.0" # 替换 localhost
            elif ! [[ "$host" =~ $ipv4_regex ]]; then
                 errors+=("Host '$host' 不是有效的 IPv4 地址格式")
            fi
        fi

        # Port 格式和范围检查
        if [[ -n "$port" ]] && ! [[ "$port" =~ ^[0-9]+$ ]] || [[ "$port" -lt 1 ]] || [[ "$port" -gt 65535 ]]; then
            errors+=("Port '$port' 必须是 1-65535 之间的数字")
        fi

        # Login Rate 格式检查 (必须是数字)
        if [[ -n "$login_rate" ]] && ! [[ "$login_rate" =~ ^[0-9]+$ ]]; then
             errors+=("Login Rate '$login_rate' 必须是数字")
        fi

        # 端口占用检查 (仅在 Port 有效时进行)
        if [[ "$port" =~ ^[0-9]+$ ]] && [[ "$port" -ge 1 ]] && [[ "$port" -le 65535 ]]; then
            # 检查 TCP 监听端口
            if ss -tuln | grep -q ":${port}\s"; then
                # 端口正在监听。尝试用 curl 访问 localhost:<port> 检查是否是运行中的 WebUI
                local curl_host="127.0.0.1" # 总是检查 localhost
                local http_code=$(curl -s -o /dev/null -w '%{http_code}' --connect-timeout 2 "http://${curl_host}:${port}")
                local curl_exit_status=$? # 获取 curl 的退出状态码

                # 如果 curl 命令执行失败 (例如，连接被拒绝 - 退出码 7, 超时 - 退出码 28)
                # 或者 curl 成功但 HTTP 状态码是 000 (通常也表示连接层失败)
                if [[ $curl_exit_status -ne 0 ]] || [[ "$http_code" == "000" ]]; then
                    # 端口在监听，但无法通过 curl 访问预期的 WebUI 服务，认为端口被其他程序占用
                    errors+=("端口 $port 已被占用 (无法访问预期的 WebUI 服务)")
                # else
                    # 端口在监听，并且 curl 成功获取了 HTTP 响应 (即使是 4xx 或 5xx)
                    # 这表明很可能是正在运行的 WebUI 实例，允许用户继续配置（可能用于修改现有配置）
                    # 不添加错误信息
                fi
            fi
        fi

        # --- 处理验证结果 ---
        if [[ ${#errors[@]} -gt 0 ]]; then
            # 错误标题用红色，错误项用黄色
            local error_msg="${FG_RED}输入无效:${RESET}\n\n"
            for error in "${errors[@]}"; do
                error_msg+=" - ${FG_YELLOW}$error${RESET}\n"
            done
            dialog --colors --msgbox "$error_msg" 15 70
            # 保留用户输入以便下次显示
            current_host="$host"
            current_port="$port"
            current_token="$token"
            current_login_rate="$login_rate"
            continue # 返回循环，重新显示表单
        fi

        # --- 验证通过，准备更新 JSON ---
        # 构建要写入的 JSON 对象，注意 port 和 loginRate 需要是数字
        # 保留未在表单中出现的 prefix 字段
        local new_webui_obj=$(jq -n \
            --arg host "$host" \
            --argjson port "$port" \
            --arg token "$token" \
            --argjson loginRate "$login_rate" \
            --arg prefix "$current_prefix" \
            '{
                host: $host,
                port: $port,
                token: $token,
                loginRate: $loginRate,
                prefix: $prefix
            }')


        # --- 更新 JSON 文件 ---
        # 直接覆盖整个文件内容
        if echo "$new_webui_obj" | jq '.' > "$temp_file" 2> "$jq_stderr_file"; then
            # 检查写入临时文件是否成功且内容不为空
            if [[ -s "$temp_file" ]]; then
                 # 备份原始文件 (可选但推荐)
                 # cp "$config_file" "$config_file.bak"
                 # 用临时文件覆盖原始文件
                 if mv "$temp_file" "$config_file"; then
                     dialog --colors --msgbox "${FG_GREEN}WebUI 配置已成功更新！${RESET}" 8 50
                     # 成功后不再需要 trap，清理错误文件
                     rm -f "$jq_stderr_file"
                     trap - EXIT
                     return 0 # 成功退出函数
                 else
                     dialog --colors --msgbox "${FG_RED}错误：${RESET}无法更新配置文件 '$config_file'。权限问题？" 8 60
                     # 出错也清理错误文件
                     rm -f "$jq_stderr_file"
                     return 1 # 失败退出函数
                 fi
            else
                 # jq 成功执行但输出了空文件
                 local jq_error_output=$(<"$jq_stderr_file") # 读取 jq 的 stderr
                 dialog --colors --msgbox "${FG_RED}错误：${RESET}jq 处理后生成了空文件。请检查 jq 脚本和输入。\n\nJQ 输出(空):\n\n${FG_RED}JQ 错误:${RESET}\n$jq_error_output" 15 70
                 rm -f "$jq_stderr_file"
                 return 1 # 失败退出函数
            fi
        else
            # jq 命令执行失败
            local jq_error_output=$(<"$jq_stderr_file") # 读取 jq 的 stderr
            rm -f "$jq_stderr_file"
            dialog --colors --msgbox "${FG_RED}错误：${RESET}使用 jq 更新 JSON 时出错。\n\n${FG_RED}JQ 错误:${RESET}\n$jq_error_output\n\n请检查 JSON 文件格式或 jq 命令。" 15 70
            return 1 # 失败退出函数
        fi

        # 理论上不应执行到这里
        break
    done
}

# 函数：获取有效的QQ账号列表
get_qq_accounts() {
    local accounts=()
    # 确保目录存在
    if [[ ! -d "$CONFIG_DIR" ]]; then
        dialog --colors --msgbox "错误：配置目录 '$CONFIG_DIR' 不存在。" 8 50
        return 1
    fi
    shopt -s nullglob # 如果没有匹配的文件，则不报错
    for file in "$CONFIG_DIR"/onebot11_*.json; do
        local filename=$(basename "$file")
        # 提取文件名中的数字部分
        if [[ "$filename" =~ onebot11_([0-9]+)\.json ]]; then
            local qq="${BASH_REMATCH[1]}"
            # 检查QQ号长度是否大于3
            if [[ ${#qq} -gt 3 ]]; then
                accounts+=("$qq")
            fi
        fi
    done
    shopt -u nullglob
    # 返回空格分隔的列表
    echo "${accounts[@]}"
    return 0
}

# 函数：添加新账号
add_account() {
    while true; do
        NEW_QQ=$(dialog --colors --clear --backtitle "添加账号" \
                        --title "输入新QQ账号" \
                        --inputbox "请输入新增的QQ账号（至少4位数字）:" 10 40 \
                        2>&1 >/dev/tty)
        local exit_status=$?
        clear

        # 用户按了取消或ESC
        if [[ $exit_status -ne 0 ]]; then
            dialog --colors --msgbox "添加操作已取消。" 6 40
            return 1 # 表示取消
        fi

        # 验证输入是否为至少4位数字
        if [[ "$NEW_QQ" =~ ^[0-9]{4,}$ ]]; then
            local new_napcat_file="$CONFIG_DIR/napcat_${NEW_QQ}.json"
            local new_onebot_file="$CONFIG_DIR/onebot11_${NEW_QQ}.json"
            local temp_jq_file=$(mktemp) || { echo "无法创建临时文件"; exit 1; }
            trap 'rm -f "$temp_jq_file"' EXIT # 确保退出时删除临时文件

            # 检查配置文件是否已存在
            if [[ -f "$new_napcat_file" || -f "$new_onebot_file" ]]; then
                 dialog --colors --yesno "账号 $NEW_QQ 的配置文件已存在，是否覆盖？" 8 50 2>&1 >/dev/tty
                 if [[ $? -ne 0 ]]; then # 用户选择 "否"
                     rm -f "$temp_jq_file" # 清理临时文件
                     trap - EXIT
                     continue # 重新提示输入
                 fi
            fi

            # 检查基础配置文件是否存在
            if [[ ! -f "$BASE_NAPCAT_CONFIG" ]]; then
                dialog --colors --msgbox "错误：基础配置文件 '$BASE_NAPCAT_CONFIG' 不存在。" 8 60
                rm -f "$temp_jq_file"
                trap - EXIT
                return 2 # 表示基础文件缺失
            fi
             if [[ ! -f "$BASE_ONEBOT_CONFIG" ]]; then
                dialog --colors --msgbox "错误：基础配置文件 '$BASE_ONEBOT_CONFIG' 不存在。" 8 60
                rm -f "$temp_jq_file"
                trap - EXIT
                return 2 # 表示基础文件缺失
            fi

            # 复制文件
            if cp "$BASE_NAPCAT_CONFIG" "$new_napcat_file" && cp "$BASE_ONEBOT_CONFIG" "$new_onebot_file"; then
                # 初始化 onebot11_{QQ}.json 的 network 字段
                local jq_stderr_file=$(mktemp)
                trap 'rm -f "$temp_jq_file" "$jq_stderr_file"' EXIT # 更新 trap

                # 使用 jq 添加或确保 network 结构存在
                if jq '
                    .network //= {} |
                    .network.httpServers //= [] |
                    .network.httpSseServers //= [] |
                    .network.httpClients //= [] |
                    .network.websocketServers //= [] |
                    .network.websocketClients //= [] |
                    .network.plugins //= []
                ' "$new_onebot_file" > "$temp_jq_file" 2> "$jq_stderr_file"; then
                    if [[ -s "$temp_jq_file" ]]; then
                        if mv "$temp_jq_file" "$new_onebot_file"; then
                            dialog --colors --msgbox "账号 $NEW_QQ 添加成功！\nNapcat 配置: $new_napcat_file\nOneBot 配置: $new_onebot_file" 10 70
                            rm -f "$jq_stderr_file" # 清理 jq 错误文件
                            trap - EXIT # 清除 trap
                            return 0 # 表示成功
                        else
                            dialog --colors --msgbox "${FG_RED}错误：${RESET}无法覆盖 '$new_onebot_file'。权限问题？" 8 60
                            rm -f "$jq_stderr_file"
                            trap - EXIT
                            return 3 # 表示移动失败
                        fi
                    else
                        local jq_error=$(<"$jq_stderr_file")
                        dialog --colors --msgbox "${FG_RED}错误：${RESET}jq 处理 '$new_onebot_file' 后生成了空文件。\n\n${FG_RED}JQ 错误:${RESET}\n$jq_error" 15 70
                        rm -f "$jq_stderr_file"
                        trap - EXIT
                        return 4 # 表示 jq 处理失败
                    fi
                else
                    local jq_error=$(<"$jq_stderr_file")
                    dialog --colors --msgbox "${FG_RED}错误：${RESET}使用 jq 初始化 '$new_onebot_file' 时出错。\n\n${FG_RED}JQ 错误:${RESET}\n$jq_error" 15 70
                    rm -f "$jq_stderr_file"
                    trap - EXIT
                    return 4 # 表示 jq 执行失败
                fi
            else
                dialog --colors --msgbox "错误：复制文件时出错，请检查权限或磁盘空间。" 8 60
                rm -f "$temp_jq_file" # 清理临时文件
                trap - EXIT
                return 3 # 表示复制失败
            fi
        else
            dialog --colors --msgbox "输入无效！请输入至少4位数字。" 6 40
            # 循环继续，要求重新输入
        fi
    done
}




# 配置开机自启动
configure_autostart() {
    local qq_account=$1
    local init_script_name="nc_${qq_account}" # init.d 脚本名称
    local init_script_dir="/etc/init.d"
    local init_script_file="${init_script_dir}/${init_script_name}"
    local qq_exec_path="qq" # !! 确保这是正确的 QQ 可执行文件路径 !!
    # 构建执行命令 (无 sudo, 无后台符, 无手动重定向) - 将在 init 脚本内部使用
    # local exec_command="/usr/bin/xvfb-run -a ${qq_exec_path} --no-sandbox -q ${qq_account}"
    local log_file="/var/log/napcat_${qq_account}.log"
    local pid_file="/var/run/napcat.pid" # 单一 PID 文件
    # 工作目录，root 通常是 /root
    local work_dir="/root"
    # 指定 PATH 环境变量，供 init 脚本使用
    local service_path_env="PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin"

    # 检查 init.d 目录是否存在
    if [[ ! -d "$init_script_dir" ]]; then
        dialog --colors --msgbox "${FG_RED}错误：${RESET}init.d 目录 '$init_script_dir' 不存在。" 8 60
        return 1
    fi

    # 检查 update-rc.d 命令是否存在
    if ! command -v update-rc.d &> /dev/null; then
         dialog --colors --msgbox "${FG_RED}错误：${RESET}命令 'update-rc.d' 未找到。\n无法管理 SysVinit 启动脚本。" 8 60
         return 1
    fi

    # --- 1. 检查当前账号的自启动脚本是否已存在 ---
    # SysVinit 通常通过检查 /etc/rc*.d/ 中的符号链接来判断是否启用，但 update-rc.d 管理更可靠
    # 这里我们简化为检查 init.d 文件是否存在，因为 update-rc.d remove 会删除它
    if [[ -f "$init_script_file" ]]; then
        dialog --colors --title "取消自启动" --yesno "账号 ${BOLD}${FG_CYAN}$qq_account${RESET} 已配置开机自启动 (init.d脚本)。\n\n是否要取消该账号的开机自启动？" 10 70 2>&1 >/dev/tty
        local choice=$?
        clear
        if [[ $choice -eq 0 ]]; then # Yes - 取消自启动
            echo "正在禁用并移除 $init_script_name ..."
            # 尝试从运行级别中移除，然后删除文件
            if sudo update-rc.d -f "$init_script_name" remove &> /dev/null && sudo rm -f "$init_script_file"; then
                # update-rc.d remove 应该会处理符号链接，无需手动 daemon-reload
                dialog --colors --msgbox "账号 ${BOLD}${FG_CYAN}$qq_account${RESET} 的开机自启动已成功取消。" 8 50
            else
                # 如果 update-rc.d 失败，尝试仅删除文件
                if sudo rm -f "$init_script_file"; then
                     dialog --colors --msgbox "${FG_YELLOW}警告：${RESET}update-rc.d 移除失败，但启动脚本文件已删除。\n可能需要手动清理 /etc/rc*.d/ 中的链接。" 10 70
                else
                     dialog --colors --msgbox "${FG_RED}错误：${RESET}取消自启动失败。请检查权限或手动操作。" 8 60
                fi
            fi
        else # No - 保留
            dialog --colors --msgbox "操作已取消，保留现有自启动配置。" 6 50
        fi
        return 0 # 无论成功与否，处理完毕
    fi

    # --- 2. 检查是否存在其他账号的自启动脚本 ---
    # 由于 PID 文件共享，严格来说不允许多个账号同时启用
    local existing_script_file=""
    local other_qq=""
    shopt -s nullglob
    for file in "$init_script_dir"/nc_*; do
        # 跳过非脚本文件或目录等
        [[ ! -x "$file" ]] || [[ ! -f "$file" ]] && continue
        local filename=$(basename "$file")
        # 提取 QQ 号
        if [[ "$filename" =~ nc_([0-9]+) ]] && [[ "${BASH_REMATCH[1]}" != "$qq_account" ]]; then
            # 简单地假设文件存在即为已配置（因为上一步会处理当前账号的取消）
            existing_script_file="$file"
            other_qq="${BASH_REMATCH[1]}"
            break # 只处理找到的第一个冲突
        fi
    done
    shopt -u nullglob

    if [[ -n "$existing_script_file" ]]; then
        local existing_script_name=$(basename "$existing_script_file")
        local conflict_choice
        exec 3>&1
        conflict_choice=$(dialog --colors --clear --backtitle "自启动冲突" \
            --title "检测到冲突" \
            --menu "已存在账号 ${BOLD}${FG_CYAN}$other_qq${RESET} 的开机自启动脚本 (${existing_script_name})。\n由于使用共享 PID 文件，不建议同时启用多个。\n请选择操作:" 16 75 3 \
            1 "替换 (禁用 $other_qq, 启用 $qq_account)" \
            2 "取消添加 $qq_account" \
            3 "强制添加 $qq_account (强烈不推荐!)" \
        2>&1 1>&3)
        local conflict_exit_status=$?
        exec 3>&-
        clear

        if [[ $conflict_exit_status -ne 0 ]]; then
            dialog --colors --msgbox "操作已取消。" 6 40
            return 1
        fi

        case "$conflict_choice" in
            1) # 替换
                echo "正在禁用并移除旧脚本 $existing_script_name ..."
                if ! (sudo update-rc.d -f "$existing_script_name" remove &> /dev/null && sudo rm -f "$existing_script_file"); then
                     # 尝试仅删除文件作为后备
                     if ! sudo rm -f "$existing_script_file"; then
                         dialog --colors --msgbox "${FG_RED}错误：${RESET}禁用或移除旧脚本 '$existing_script_name' 失败。\n请检查权限或手动操作后重试。" 10 70
                         return 1
                     else
                         echo -e "${ANSI_YELLOW}警告：${ANSI_RESET}update-rc.d 移除旧脚本失败，但文件已删除。"
                     fi
                fi
                echo "旧脚本已移除，继续添加新脚本..."
                ;;
            2) # 取消
                dialog --colors --msgbox "添加账号 ${BOLD}${FG_CYAN}$qq_account${RESET} 的自启动已取消。" 6 50
                return 1
                ;;
            3) # 强制添加
                dialog --colors --infobox "${FG_YELLOW}警告：${RESET}强制添加多个自启动脚本，极可能导致 PID 文件冲突和管理混乱！" 6 70
                sleep 3
                ;;
            *) # 无效选择或意外情况
                dialog --colors --msgbox "无效的选择。" 6 40
                return 1
                ;;
        esac
    fi

    # --- 3. 添加新的自启动脚本 ---
    echo -e "正在为账号 ${ANSI_BOLD}${ANSI_CYAN}$qq_account${ANSI_RESET} 创建开机自启动脚本..."

    # 创建 init.d 脚本内容并直接写入文件
    # 使用 cat <<EOF，内部的 ${qq_account} 会被展开，而 \$ 开头的变量需要转义以防止展开
    sudo cat <<EOF > "$init_script_file"
#!/bin/bash
### BEGIN INIT INFO
# Provides:          nc_${qq_account}
# Required-Start:    \$network \$remote_fs \$syslog
# Required-Stop:     \$network \$remote_fs \$syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Manage nc_${qq_account} service
# Description:       Start of nc_${qq_account} service.
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:bin:/usr/sbin:/usr/bin
CMD="sudo /usr/bin/xvfb-run -a qq --no-sandbox -q ${qq_account}"
PID_FILE="/var/run/napcat.pid"
LOG_FILE="/var/log/napcat_${qq_account}.log"

start() {
    touch "\$PID_FILE"
    exec \$CMD >> "\$LOG_FILE" 2>&1 &
    echo \$! > "\$PID_FILE"
    echo "nc sucess"
}

case "\$1" in
    start)
        start
        ;;
    *)
        exit 1
        ;;
esac

exit 0
EOF
    if [[ $? -ne 0 ]]; then
        dialog --colors --msgbox "${FG_RED}错误：${RESET}无法创建启动脚本 '$init_script_file'。\n请检查权限。" 8 60
        return 1
    fi

    # 设置脚本权限为可执行
    sudo chmod +x "$init_script_file"
    if [[ $? -ne 0 ]]; then
        dialog --colors --msgbox "${FG_RED}错误：${RESET}无法设置启动脚本 '$init_script_file' 为可执行。\n请检查权限。" 8 60
        # 清理已创建的文件
        sudo rm -f "$init_script_file"
        return 1
    fi

    # 使用 update-rc.d 添加到默认运行级别
    echo "正在启用启动脚本 $init_script_name ..."
    sudo chmod +x /etc/init.d/nc_${qq_account}
    sudo update-rc.d nc_${qq_account} defaults
    if sudo update-rc.d "$init_script_name" defaults; then
        dialog --colors --msgbox "账号 ${BOLD}${FG_CYAN}$qq_account${RESET} 的开机自启动已成功配置！\n脚本将在下次系统启动时运行。\n日志文件: ${log_file}\nPID 文件: ${pid_file}" 13 70
        return 0
    else
        dialog --colors --msgbox "${FG_RED}错误：${RESET}启用启动脚本 '$init_script_name' 失败 (update-rc.d)。\n请检查脚本内容或系统日志。" 10 70
        # 清理失败时创建的文件
        sudo rm -f "$init_script_file"
        # 尝试移除 (以防万一 defaults 创建了部分链接)
        sudo update-rc.d -f "$init_script_name" remove &> /dev/null
        return 1
    fi
}

# 函数：显示网络服务配置菜单 (菜单2)
show_service_menu() {
    local qq_account=$1 # 虽然 WebUI 配置不直接用 qq_account，但保持函数签名一致
    local onebot_config_file="$CONFIG_DIR/onebot11_${qq_account}.json"
    local webui_config_file="$CONFIG_DIR/webui.json" # WebUI 配置文件路径

    while true; do
        # 检查 OneBot 配置文件是否存在
        if [[ ! -f "$onebot_config_file" ]] || [[ ! -r "$onebot_config_file" ]]; then
            dialog --colors --msgbox "${FG_RED}错误：${RESET}无法读取 OneBot 配置文件 '$onebot_config_file'。" 8 60
            return # 返回到账号选择菜单
        fi

        # --- 检查各项服务的配置状态和启用状态 ---

        # HTTP Server
        local http_server_config_status="${FG_RED}(未配置)${RESET}"
        local http_server_enable_status=""
        local http_server_config=$(jq -c '.network.httpServers[0] // null' "$onebot_config_file" 2>/dev/null)
        if [[ "$http_server_config" != "null" ]]; then
            http_server_config_status="${FG_GREEN}(已配置)${RESET}"
            if [[ $(echo "$http_server_config" | jq -r '.enable // false') == "true" ]]; then
                http_server_enable_status="${FG_GREEN}(已启用)${RESET}"
            else
                http_server_enable_status="${FG_RED}(未启用)${RESET}"
            fi
        fi

        # HTTP Client
        local http_client_config_status="${FG_RED}(未配置)${RESET}"
        local http_client_enable_status=""
        local http_client_config=$(jq -c '.network.httpClients[0] // null' "$onebot_config_file" 2>/dev/null)
        if [[ "$http_client_config" != "null" ]]; then
            http_client_config_status="${FG_GREEN}(已配置)${RESET}"
            if [[ $(echo "$http_client_config" | jq -r '.enable // false') == "true" ]]; then
                http_client_enable_status="${FG_GREEN}(已启用)${RESET}"
            else
                http_client_enable_status="${FG_RED}(未启用)${RESET}"
            fi
        fi

        # WebSocket Server
        local ws_server_config_status="${FG_RED}(未配置)${RESET}"
        local ws_server_enable_status=""
        local ws_server_config=$(jq -c '.network.websocketServers[0] // null' "$onebot_config_file" 2>/dev/null)
        if [[ "$ws_server_config" != "null" ]]; then
            ws_server_config_status="${FG_GREEN}(已配置)${RESET}"
            if [[ $(echo "$ws_server_config" | jq -r '.enable // false') == "true" ]]; then
                ws_server_enable_status="${FG_GREEN}(已启用)${RESET}"
            else
                ws_server_enable_status="${FG_RED}(未启用)${RESET}"
            fi
        fi

        # WebSocket Client
        local ws_client_config_status="${FG_RED}(未配置)${RESET}"
        local ws_client_enable_status=""
        local ws_client_config=$(jq -c '.network.websocketClients[0] // null' "$onebot_config_file" 2>/dev/null)
        if [[ "$ws_client_config" != "null" ]]; then
            ws_client_config_status="${FG_GREEN}(已配置)${RESET}"
            if [[ $(echo "$ws_client_config" | jq -r '.enable // false') == "true" ]]; then
                ws_client_enable_status="${FG_GREEN}(已启用)${RESET}"
            else
                ws_client_enable_status="${FG_RED}(未启用)${RESET}"
            fi
        fi

        # Music Signature (只有配置状态)
        local music_sig_status="${FG_RED}(未配置)${RESET}"
        # Check if the key exists, is not null, AND is not an empty string.
        if jq -e 'has("musicSignUrl") and (.musicSignUrl != null) and (.musicSignUrl != "")' "$onebot_config_file" >/dev/null 2>&1; then
             music_sig_status="${FG_GREEN}(已配置)${RESET}"
        fi

        # Autostart (只有启用状态)
        local autostart_script_name="nc_${qq_account}"
        local autostart_script_file="/etc/init.d/${autostart_script_name}"
        local autostart_status="${FG_RED}(未启用)${RESET}"
        if [[ -f "$autostart_script_file" ]]; then
             autostart_status="${FG_GREEN}(已启用)${RESET}"
        fi

        # WebUI (只有配置状态，基于 token)
        local webui_status="${FG_RED}(未配置)${RESET}"
        if [[ -f "$webui_config_file" ]] && [[ -r "$webui_config_file" ]]; then
            local webui_token=$(jq -r '.token // ""' "$webui_config_file" 2>/dev/null)
            if [[ "$webui_token" == "napcat" ]]; then
                webui_status="${FG_RED}(使用默认token)${RESET}" # 简化提示
            elif [[ -n "$webui_token" ]]; then
                webui_status="${FG_GREEN}(已配置)${RESET}"
            fi
        fi


        # 显示菜单，包含配置状态和启用状态
        SERVICE_CHOICE=$(dialog --colors --clear --backtitle "服务配置" \
                                --title "配置 $qq_account 的服务" \
                                --menu "请选择要配置的项目:" 20 85 7 \
                                1 "HTTP 服务端 (正向http) ${http_server_config_status}${http_server_enable_status}" \
                                2 "HTTP 客户端 (反向http) ${http_client_config_status}${http_client_enable_status}" \
                                3 "WebSocket 服务端 (正向ws) ${ws_server_config_status}${ws_server_enable_status}" \
                                4 "WebSocket 客户端 (反向ws) ${ws_client_config_status}${ws_client_enable_status}" \
                                5 "音乐签名配置 ${music_sig_status}" \
                                6 "WebUI 配置 ${webui_status}" \
                                7 "开机自启动 ${autostart_status}" \
                                HELP "我该如何选择网络服务？" \
                                2>&1 >/dev/tty)

        local exit_status=$?
        clear
        if [[ $exit_status -ne 0 ]]; then
            # 用户按了取消或ESC，返回到账号选择菜单
            return
        fi

        case "$SERVICE_CHOICE" in
            1)
                configure_http_server "$qq_account"
                ;;
            2)
                configure_reverse_http_client "$qq_account"
                ;;
            3)
                configure_ws_server "$qq_account"
                ;;
            4)
                configure_reverse_ws_client "$qq_account"
                ;;
            5)
                configure_music_signature "$qq_account"
                ;;
            6)
                configure_webui
                ;;
            7) # 新增处理自启动选项
                configure_autostart "$qq_account"
                ;;
            HELP)
                # ... (help text remains the same) ...
                local help_text=""
                help_text+="${BOLD}${FG_GREEN}HTTP 服务端${RESET}\n" # 标题：粗体绿色
                help_text+="  ${BOLD}${FG_CYAN}NapCat${RESET} 作为 HTTP 服务端，监听并接受 外部 发起的请求，处理后返回响应 (${BOLD}单向${RESET}：外部 -> ${BOLD}${FG_CYAN}NapCat${RESET})。\n\n" # NapCat: 粗体青色, 方向: 粗体
                help_text+="${BOLD}${FG_GREEN}HTTP 客户端${RESET}\n" # 标题：粗体绿色
                help_text+="  ${BOLD}${FG_CYAN}NapCat${RESET} 作为 HTTP 客户端，主动向 外部 接口发起请求，将内部事件推送给插件或应用框架 (${BOLD}单向${RESET}：${BOLD}${FG_CYAN}NapCat${RESET} -> 外部)。\n\n" # NapCat: 粗体青色, 方向: 粗体
                help_text+="${BOLD}${FG_GREEN}WebSocket 服务端${RESET}\n" # 标题：粗体绿色
                help_text+="  ${BOLD}${FG_CYAN}NapCat${RESET} 作为 WebSocket 服务端，与 客户端 保持 ${BOLD}双向${RESET} 长连接，既能被动接收 客户端 消息，也能主动推送事件。(${BOLD}双向${RESET}：${BOLD}${FG_CYAN}NapCat${RESET} <-> 客户端)。\n\n" # NapCat: 粗体青色, 方向: 粗体
                help_text+="${BOLD}${FG_GREEN}WebSocket 客户端${RESET}\n" # 标题：粗体绿色
                help_text+="  ${BOLD}${FG_CYAN}NapCat${RESET} 作为 WebSocket 客户端，主动向 外部 WebSocket 服务端 建立 ${BOLD}双向${RESET} 长连接，既能主动发送事件，也能响应 服务端 请求 (${BOLD}双向${RESET}：${BOLD}${FG_CYAN}NapCat${RESET} <-> 服务端)。\n\n\n" # NapCat: 粗体青色, 方向: 粗体
                help_text+="* ${BOLD}音乐签名配置:${RESET}\n  配置用于获取音乐分享链接签名的 API 地址。\n\n"
                help_text+="* ${BOLD}WebUI 配置:${RESET}\n  配置 Napcat Web 管理界面的访问参数。\n\n"
                help_text+="* ${BOLD}开机自启动:${RESET}\n  将当前选择的 QQ 账号配置为随系统启动而自动运行。\n  ${FG_YELLOW}注意：${RESET}通常只应为一个账号启用自启动。"

                help_text+="\n\n详细配置请参考：${FG_BLUE}https://napcat.napneko.icu/config/basic${RESET}" # 链接：蓝色

                dialog --colors --cr-wrap --title "如何选择网络服务？" --msgbox "$help_text"  31 100
                clear # 清理 msgbox 留下的屏幕内容
                ;;
            *)
                dialog --colors --msgbox "无效的选择: $SERVICE_CHOICE" 6 40
                ;;
        esac
        # 每次配置或查看帮助后循环会重新开始，状态会刷新
    done
}



delete_account() {
    local qq_account=$1
    local napcat_file="$CONFIG_DIR/napcat_${qq_account}.json"
    local onebot_file="$CONFIG_DIR/onebot11_${qq_account}.json"

    # 确认删除对话框
    dialog --colors --defaultno --title "确认删除账号" \
           --yes-label "确认删除！" --no-label "取消" \
           --yesno "${BOLD}${FG_RED}警告：删除操作不可逆！${RESET}\n\n您确定要删除账号 ${BOLD}${FG_CYAN}$qq_account${RESET} 的所有配置文件吗？\n\n文件将被永久删除:\n- ${FG_YELLOW}${napcat_file}${RESET}\n- ${FG_YELLOW}${onebot_file}${RESET}" 20 70 2>&1 >/dev/tty

    local choice=$?
    clear

    if [[ $choice -eq 0 ]]; then # 用户选择了 "确认删除！"
        echo "正在尝试删除账号 $qq_account 的配置文件..."
        local delete_failed=false
        # 尝试删除 napcat 文件
        if [[ -f "$napcat_file" ]]; then
            if sudo rm -f "$napcat_file"; then
                echo "已删除: $napcat_file"
            else
                echo "${FG_RED}错误：${RESET}删除 $napcat_file 失败。请检查权限。" >&2
                delete_failed=true
            fi
        else
            echo "文件不存在，跳过: $napcat_file"
        fi
        # 尝试删除 onebot 文件
        if [[ -f "$onebot_file" ]]; then
            if sudo rm -f "$onebot_file"; then
                echo "已删除: $onebot_file"
            else
                echo "${FG_RED}错误：${RESET}删除 $onebot_file 失败。请检查权限。" >&2
                delete_failed=true
            fi
        else
            echo "文件不存在，跳过: $onebot_file"
        fi

        if $delete_failed; then
             dialog --colors --msgbox "${FG_RED}错误：${RESET}删除过程中遇到问题。部分文件可能未被删除，请手动检查。" 8 60
        else
             dialog --colors --msgbox "账号 ${BOLD}${FG_CYAN}$qq_account${RESET} 的配置文件已成功删除。" 8 50
        fi
        return 0 # 表示执行了删除（无论成功与否）
    else # 用户选择了 "取消"
        dialog --colors --msgbox "删除操作已取消。" 6 40
        return 1 # 表示取消
    fi
}

# --- 主逻辑 ---

# 主循环，显示账号选择菜单 (菜单1)
while true; do
    ACCOUNTS_LIST=($(get_qq_accounts))
    if [[ $? -ne 0 ]]; then # 如果 get_qq_accounts 失败 (例如目录不存在)
        dialog --colors --msgbox "错误：无法获取账号列表，请检查配置目录 '$CONFIG_DIR'。" 8 60
        exit 1
    fi

    MENU_ITEMS=()
    for acc in "${ACCOUNTS_LIST[@]}"; do
        MENU_ITEMS+=("$acc" "配置 $acc")
    done
    MENU_ITEMS+=("ADD" "添加新账号")

    # 计算实际的菜单项数量 (账号数 + 添加项)
    num_entries=$(( ${#ACCOUNTS_LIST[@]} + 1 )) # 移除 local

    # 设置列表的期望显示高度 (例如，最多显示 8 行)
    list_height=$num_entries # 移除 local
    [[ $list_height -gt 8 ]] && list_height=8
    [[ $list_height -lt 1 ]] && list_height=1 # 确保至少为1

    # 计算对话框的总高度：列表高度 + 额外空间 (约 7 行)
    menu_height=$(( list_height + 7 )) # 移除 local
    [[ $menu_height -lt 10 ]] && menu_height=10 # 确保最小总高度


    CHOICE=$(dialog --colors --clear --backtitle "QQ账号管理" \
                    --title "选择QQ账号" \
                    --ok-label "配置服务" \
                    --cancel-label "退出" \
                    --extra-button --extra-label "删除账号" \
                    --menu "请选择账号进行操作，或添加新账号:" \
                    "$menu_height" 55 "$list_height" \
                    "${MENU_ITEMS[@]}" \
                    2>&1 >/dev/tty)

    exit_status=$?
    clear

    # 删除或注释掉下面这几行
    # if [[ $exit_status -ne 0 ]]; then
    #     echo "操作已取消或退出。"
    #     break
    # fi

    case $exit_status in
        0) # OK (配置服务)
            case "$CHOICE" in
                ADD)
                    # 调用添加函数
                    add_account
                    ;;
                *)
                    # 检查选择的是否是有效的账号
                    is_valid_account=false
                    for acc in "${ACCOUNTS_LIST[@]}"; do
                        if [[ "$CHOICE" == "$acc" ]]; then
                            is_valid_account=true
                            break
                        fi
                    done

                    if $is_valid_account; then
                        # 进入菜单2
                        show_service_menu "$CHOICE"
                    else
                         # 如果列表为空时按 OK，CHOICE 可能为空
                         if [[ -z "$CHOICE" ]] && [[ ${#ACCOUNTS_LIST[@]} -eq 0 ]]; then
                             dialog --colors --msgbox "当前没有可配置的账号，请先添加。" 6 50
                         else
                             dialog --colors --msgbox "出现意外错误，无效的选择: '$CHOICE'" 6 40
                         fi
                    fi
                    ;;
            esac
            ;;
        1) # Cancel (退出)
            echo "操作已取消或退出。"
            break # 退出主循环
            ;;
        3) # Extra button (删除账号)
            case "$CHOICE" in
                ADD)
                    dialog --colors --msgbox "无法删除 '添加新账号' 选项。\n请先在列表中选择一个要删除的账号。" 8 50
                    ;;
                *)
                    # 检查选择的是否是有效的账号
                    is_valid_account=false
                    for acc in "${ACCOUNTS_LIST[@]}"; do
                        if [[ "$CHOICE" == "$acc" ]]; then
                            is_valid_account=true
                            break
                        fi
                    done

                    if $is_valid_account; then
                        # 调用删除函数
                        delete_account "$CHOICE"
                        # 删除后，循环会自动重新开始，刷新列表
                    else
                         # 如果列表为空时按删除，CHOICE 可能为空
                         if [[ -z "$CHOICE" ]] && [[ ${#ACCOUNTS_LIST[@]} -eq 0 ]]; then
                             dialog --colors --msgbox "当前没有可删除的账号。" 6 40
                         else
                             # 可能是在空列表时按了删除按钮
                             dialog --colors --msgbox "请先在列表中选择一个要删除的账号。" 6 50
                         fi
                    fi
                    ;;
            esac
            # 注意：这里不需要 break，让循环继续以刷新列表
            ;;
        *) # Other (ESC etc.)
            echo "操作已取消或发生未知错误 (退出码: $exit_status)。"
            break # 退出主循环
            ;;
    esac
done

# 清理屏幕并退出