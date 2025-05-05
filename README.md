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


## 提示词

我们可以使用 AI 帮助修改 DDDML Schema。

### 使用 YAML 示例文件更新 `dddml-schema.json` 文件

```markdown
# DDDML Schema 自动更新指南

## 任务目标
分析引用的 YAML 示例文件，并更新 `dddml-schema.json` 文件，确保其能兼容最新的 DDDML 特性。

## 分析重点
1. **元素结构**: 识别并捕获所有新的顶级元素、嵌套结构和属性
2. **命名风格**: 特别收集所有 `camelCase` 风格的键
3. **元数据字段**: 详细分析各元素的 `metadata` 对象中的所有键(无论命名风格)

## 更新指南
1. **位置准确性**: 将 `metadata` 相关属性直接添加到对应元素(如 aggregate、method 等)的 schema 定义中，而非通用 metadata 定义中；
2. **兼容处理**: `metadata` 字段必须支持 null 值；
3. **增量更新**: 除非确认冲突，不要删除已有键或结构；
4. **文档化**: 为新增的属性添加适当的描述，以便 IDE 提供更好的自动完成提示。

## 预期结果
更新后的 schema 应能通过所有示例 YAML 文件的验证，并在 IDE 中为用户提供准确的代码补全建议，特别是针对 metadata 属性。

## 验证方法
更新完成后，使用上述验证工具对示例YAML文件进行验证，确保无错误报告。
```

### 基于 POCO 类定义更新 JSON Schema

```markdown
# 基于 POCO 类定义更新 JSON Schema

## 任务描述
根据提供的 C# POCO 类定义，更新 `dddml-schema.json` 文件中关于 {目标对象} 的 Schema 定义部分。

## POCO 代码

`{POCO 代码片段}`

## 更新要点
1. **属性映射**: 每个 POCO 属性应在 Schema 中有对应的定义
2. **命名转换**: POCO使用 `PascalCase` 命名，但 JSON/YAML 使用 `camelCase`
   - 例如: C#的 `PropertyName` → JSON的 `propertyName`
3. **类型映射**: 正确映射C#类型到JSON Schema类型
   - `string` → `"type": "string"`
   - `int/long` → `"type": "integer"`
   - `bool` → `"type": "boolean"`
   - `DateTime` → `"type": "string", "format": "date-time"`
   - 对象类型 → `"type": "object"`
   - 集合类型 → `"type": "array"`
4. **特殊属性处理**:
   - 对具有特殊数据注解的属性(如`[Required]`)，添加相应 Schema 约束
   - 对可为空的属性类型，确保 Schema 允许 null 值

## 预期输出
更新后的 Schema 应能正确验证从 POCO 序列化的 JSON/YAML 数据，并在 IDE 中提供准确的代码补全。
```

