#!/bin/bash

# 使用命令行工具应用 JSON Schema 校验 YAML 文件

# 首先检查是否安装了 yajsv 工具
if command -v yajsv &>/dev/null; then
    echo "已安装 yajsv 工具，继续执行..."
else
    echo "未安装 yajsv 工具，需要安装..."

    # 检查是否安装了 Go 环境
    if command -v go &>/dev/null; then
        echo "安装 yajsv 工具中..."
        go install github.com/neilpa/yajsv@latest

        # 验证安装是否成功
        if ! command -v yajsv &>/dev/null; then
            echo "错误: yajsv 安装失败。请确保 $GOPATH/bin 在您的 PATH 中。"
            echo "您也可以手动安装: go install github.com/neilpa/yajsv@latest"
            exit 1
        fi

        echo "yajsv 安装成功。"
    else
        echo "错误: 未安装 Go 环境。请安装 Go 后再运行此脚本。"
        echo "可以从 https://golang.org/dl/ 下载安装。"
        exit 1
    fi
fi

echo "正在初始化和更新子模块..."
git submodule update --init --recursive

# 获取当前目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
SCHEMA_PATH="$SCRIPT_DIR/schemas/dddml-schema.json"

# 检查 schema 文件是否存在
if [ ! -f "$SCHEMA_PATH" ]; then
    echo "错误: 未找到 schema 文件: $SCHEMA_PATH"
    exit 1
fi

echo "使用 JSON Schema 验证 YAML 文件..."

# 所有需要校验的 pattern
patterns=(
    "$SCRIPT_DIR/@example-repos/infinite-sea/dddml/*.yaml"
    "$SCRIPT_DIR/@example-repos/A-AO-Demo/dddml/a-ao-demo.yaml"
    "$SCRIPT_DIR/@example-repos/A-AO-Demo/dddml/blog.yaml"
    "$SCRIPT_DIR/@example-repos/AI-Assisted-AO-Dapp-Example/dddml/blog.yaml"
    "$SCRIPT_DIR/@example-repos/AI-Assisted-AO-Dapp-Example/dddml/InventoryItem.yaml"
    "$SCRIPT_DIR/@example-repos/hello-mud/dddml/*.yaml"
    "$SCRIPT_DIR/@example-repos/aptos-infinite-seas/dddml/*.yaml"
    "$SCRIPT_DIR/@example-repos/sui-interface-demo/dddml/*.yaml"
    "$SCRIPT_DIR/@example-repos/sui-flex-swap/dddml/*.yaml"
    "$SCRIPT_DIR/@example-repos/Dapp-LCDP-Demo/domain-model/**/*.yaml"
    "$SCRIPT_DIR/@example-repos/CLM/dddml/*.yaml"
)

ALL_FILES=()
PASSED_FILES=()
FAILED_FILES=()
FAILED_MESSAGES=()

for pattern in "${patterns[@]}"; do
    files=()
    # 用 glob 匹配所有文件
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(find ${pattern%/*} -type f -name "${pattern##*/}" -print0 2>/dev/null)

    if [ ${#files[@]} -eq 0 ]; then
        echo "警告: 找不到匹配的文件: $pattern"
        continue
    fi

    for file in "${files[@]}"; do
        ALL_FILES+=("$file")
        output=$(yajsv -s "$SCHEMA_PATH" "$file" 2>&1)
        if [[ "$output" == *"pass"* ]]; then
            PASSED_FILES+=("$file")
            echo "$file: pass"
        else
            FAILED_FILES+=("$file")
            FAILED_MESSAGES+=("$file: $output")
            echo "$file: fail"
        fi
    done

done

echo "===== 验证结果汇总 ====="
echo "验证总文件数: ${#ALL_FILES[@]}"
echo "通过验证文件数: ${#PASSED_FILES[@]}"
echo "失败验证文件数: ${#FAILED_FILES[@]}"

if [ ${#FAILED_FILES[@]} -eq 0 ]; then
    echo "验证完成，所有 YAML 文件均符合 schema 规范。"
    exit 0
else
    echo "验证完成，部分 YAML 文件不符合 schema 规范。"
    echo ""
    echo "===== 验证失败详情 ====="
    for msg in "${FAILED_MESSAGES[@]}"; do
        echo "$msg"
        echo "-------------------"
    done
    exit 1
fi

