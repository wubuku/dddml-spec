# dddml-spec

[![DeepWiki](https://img.shields.io/badge/DeepWiki-Docs-blue?logo=read-the-docs)](https://deepwiki.com/wubuku/dddml-spec)

DDDML Specification. 

DDDML is Domain-Driven Design Modeling Language.


## 使用 JSON Schema 校验 YAML 文件

本节介绍两种常用工具，用于验证 YAML 文件是否符合 DDDML JSON Schema。

### AJV + js-yaml

AJV (Another JSON Validator) 是最流行的 JSON Schema 验证器之一，可以配合 js-yaml 使用来验证 YAML 文件。

#### 安装

需要先安装 Node.js 环境，然后执行：

```bash
# 全局安装
npm install -g ajv-cli js-yaml
```

#### 使用方法

```bash
# 基本使用
ajv validate -s schemas/dddml-schema.json -d "file.yaml" --all-errors

# 批量验证多个文件
ajv validate -s schemas/dddml-schema.json -d "*.yaml" --all-errors
```

### yajsv

yajsv 是一个基于 Go 的高性能 JSON Schema 验证工具，支持 YAML 文件验证。

#### 安装

确保已安装 Go 环境（1.16+），然后执行：

```bash
# 安装 yajsv 工具
go install github.com/neilpa/yajsv@latest
```

> **注意**：安装后，确保 `$GOPATH/bin` 目录已添加到你的系统 PATH 中。

#### 使用方法

```bash
# 验证单个文件
yajsv -s schemas/dddml-schema.json file.yaml

# 批量验证多个文件
yajsv -s schemas/dddml-schema.json *.yaml
```

### 使用批量验证脚本

本仓库提供了一个 Shell 脚本，使用 yajsv 工具批量验证 YAML 文件。

```bash
# 赋予执行权限
chmod +x validate_yaml.sh

# 执行验证
./validate_yaml.sh
```

这个脚本会：
- 自动安装所需工具（如果缺失）
- 验证仓库中所有示例 YAML 文件
- 生成详细的验证报告


