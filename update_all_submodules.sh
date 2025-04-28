#!/bin/bash

# 批量更新 @example-repos 下所有子模块到 main 分支的最新 commit

set -e

REPOS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/@example-repos"

updated=()

for submodule in "$REPOS_DIR"/*; do
    if [ -d "$submodule/.git" ] || [ -f "$submodule/.git" ]; then
        name=$(basename "$submodule")
        echo "\n进入 $name ..."
        cd "$submodule"
        # 检查 main 分支是否存在，否则尝试 master
        if git show-ref --verify --quiet refs/heads/main; then
            git checkout main
            git pull
        elif git show-ref --verify --quiet refs/heads/master; then
            git checkout master
            git pull
        else
            echo "$name: main/master 分支都不存在，跳过"
            cd - >/dev/null
            continue
        fi
        cd - >/dev/null
        updated+=("@example-repos/$name")
    fi
done

if [ ${#updated[@]} -eq 0 ]; then
    echo "没有检测到需要更新的子模块。"
    exit 0
fi

echo "\n已更新以下子模块："
for u in "${updated[@]}"; do
    echo "  $u"
done

echo "\n将子模块指针变更添加到主仓库..."
git add ${updated[@]}
echo "\n请手动执行 git commit -m 'Update submodules' 和 git push 完成提交。" 