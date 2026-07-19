> 状态：已批准  
> 版本：v1 + Revision 1  
> 来源任务：Task 02 · Workflow Design

# Brand System Builder Workflow

适用范围：仅定义 Brand System Builder Skill 的标准工作流，不涉及 `SKILL.md`、实现或测试。

## 1. 设计目标

Workflow 采用：

> 统一生命周期骨架 + 三种项目路径 + 阶段裁剪机制

这样既能保持标准化，也不会强迫所有项目完成全部阶段。

支持三类项目：

1. 新品牌：从零建立品牌。
2. 已有品牌：保留有效资产，完成升级或重构。
3. 已上线网站：将品牌系统接入现有网站，必要时同时完成品牌升级。

三类不是互斥标签。例如“边大夫口腔”可以同时属于“已有品牌 + 已上线网站”。

---

## 2. 核心原则

### 2.1 先诊断，后设计

不得在未确认项目类型、现状和目标前直接生成品牌方案。

### 2.2 保留优先

已有品牌或产品默认先识别可保留资产，不以“全部重做”为默认方案。

### 2.3 决策与产物分离

每个阶段先形成决策，再进入产物深化。未经批准的方向不得被当作正式品牌规范。

### 2.4 支持裁剪，但不得破坏依赖

阶段可以：

- Required：必须执行
- Conditional：根据诊断结果执行
- Reuse：复用已有成果，仅做确认
- Skip：明确记录理由后跳过

不得跳过后续阶段依赖的关键决策。

### 2.5 批准必须可追溯

所有 Approval Gate 都应明确记录：

- 批准了什么
- 批准人
- 日期或版本
- 保留意见
- 后续变更影响

---

## 3. 项目路径

| 路径 | 适用场景 | 默认策略 |
|---|---|---|
| N — New Brand | 没有成熟品牌资产 | 从定位、方向到系统完整建立 |
| U — Brand Upgrade | 已有品牌、产品或视觉资产 | 先审计，再决定保留、优化、替换 |
| W — Website Adoption | 已有上线网站，需要品牌接入 | 先审计网站约束，再建立品牌到界面的映射 |
| U+W — Upgrade & Adoption | 品牌升级并接入现有网站 | 同时管理品牌变更和网站迁移风险 |

---

## 4. 标准生命周期

```text
00 项目启动与路径判定
        ↓
01 现状发现与资产审计
        ↓
02 品牌战略基础
        ↓
03 品牌创意方向
        ↓
04 核心品牌系统
        ↓
05 应用与触点规则
        ↓
06 网站品牌接入
        ↓
07 品牌规范整合
        ↓
08 发布与迁移规划
        ↓
09 交付、治理与持续演进
```

阶段 00、07、09 原则上不可完全省略。其他阶段可根据项目类型复用、合并或跳过。

---

# 5. 阶段定义

## 阶段 00：项目启动与路径判定

目的：确认项目目标、边界、类型和本次需要执行的阶段。

### Input

- 项目简介
- 品牌、产品或网站现状
- 本次业务目标
- 已有资料和资产清单
- 目标受众
- 时间、渠道和组织约束
- 已知不可变条件

### Output

- Project Brief
- 项目路径：N、U、W 或 U+W
- 本次 Workflow 裁剪表
- 决策人及参与角色
- 明确的范围内、范围外事项
- 初始成功标准
- 风险与依赖清单

### Exit Criteria

- 项目类型已确定
- 每个阶段已标记 Required、Conditional、Reuse 或 Skip
- 关键决策人明确
- 目标和边界不存在影响启动的歧义
- 跳过阶段均有理由

### Approval Gate

**必须批准。**

批准内容：项目路径、范围、阶段裁剪和成功标准。

---

## 阶段 01：现状发现与资产审计

目的：建立事实基础，识别现有品牌、产品和网站中应保留、改善或替换的内容。

### Input

- 阶段 00 产物
- 现有 Logo、色彩、字体及图形资产
- 品牌文档和营销材料
- 产品界面或网站
- 内容样本
- 用户或业务反馈
- 竞品及行业参考
- 技术或渠道限制

### Output

- Current-State Audit
- 品牌资产清单
- 触点清单
- 一致性和可用性问题
- 保留 / 优化 / 替换建议
- 网站现状摘要（适用于 W、U+W）
- 缺失信息与风险清单
- 可复用资产结论

### Exit Criteria

- 主要资产和触点已覆盖
- 事实、问题和主观偏好已区分
- 已有资产的处理建议明确
- 没有阻碍后续方向判断的重大信息缺口

### Approval Gate

**条件批准。**

- N：通常只需确认事实，不需要正式方向批准。
- U、W、U+W：必须批准审计结论，尤其是保留、优化和替换边界。

---

## 阶段 02：品牌战略基础

目的：定义品牌应代表什么，以及后续品牌决策的判断依据。

### Input

- Project Brief
- Current-State Audit
- 业务目标
- 目标受众
- 产品或服务价值
- 市场及竞品信息
- 已有战略材料

### Output

按项目需要形成：

- 品牌核心命题
- 目标受众定义
- 定位陈述
- 核心价值与差异点
- 品牌属性
- 品牌承诺
- 个性与语气原则
- 战略决策约束

### Exit Criteria

- 能清楚回答“为谁、解决什么、为何选择该品牌”
- 战略内容能够指导视觉、语言和触点决策
- 各项战略表述之间没有明显冲突
- 已有战略被明确标记为复用、修订或替换

### Approval Gate

**必须批准战略变化。**

- N：必须批准完整战略基础。
- U：品牌定位或核心属性发生变化时必须批准。
- W：若直接复用既有战略，只需确认复用版本。

---

## 阶段 03：品牌创意方向

目的：将战略转化为可判断的品牌表达方向，但尚不形成完整规范。

### Input

- 已批准的战略基础
- 审计结论
- 必须保留的品牌资产
- 目标触点
- 渠道和可访问性约束
- 参考材料及禁用方向

### Output

- 2–3 个有实质差异的创意方向
- 每个方向的核心概念
- 视觉与语言表达原则
- 方向与战略的对应关系
- 优势、风险和适用场景
- 推荐方向
- 明确排除的方向

### Exit Criteria

- 方案之间是战略性差异，而非表面风格变化
- 每个方向均能追溯到已批准的战略
- 对现有资产的影响已经说明
- 已选定一个主方向
- 未解决分歧不会阻碍系统设计

### Approval Gate

**必须批准。**

批准的是品牌表达方向，不等于批准所有最终品牌资产。

---

## 阶段 04：核心品牌系统

目的：将已批准方向发展为可重复使用、内部一致的品牌系统。

### Input

- 已批准的创意方向
- 战略基础
- 保留资产清单
- 目标媒介和触点
- 可访问性、语言及技术约束

### Output

根据裁剪范围形成：

- 标志体系原则
- 色彩体系
- 字体体系
- 版式与层级原则
- 图形、图标、插画或影像原则
- 品牌语气与基础语言规则
- 核心 Design Tokens 或等价设计决策
- 正确与错误使用边界
- 旧资产到新系统的对应关系（U、U+W）

### Exit Criteria

- 核心元素之间不存在冲突
- 系统能覆盖已识别的主要触点
- 关键规则足够明确，不依赖设计者临场猜测
- 需要保留的资产已正确纳入
- 品牌升级的变化范围可以被清楚解释

### Approval Gate

**必须批准。**

批准核心品牌系统及品牌升级变更范围。

---

## 阶段 05：应用与触点规则

目的：证明核心系统能在真实业务触点中稳定工作，并明确适配方式。

### Input

- 核心品牌系统
- 触点优先级
- 真实内容样本
- 渠道和制作约束
- 已有产品或营销模板

### Output

按项目需要形成：

- 重点触点应用规则
- 典型场景示例
- 内容密度和层级规则
- 多渠道适配原则
- 模板需求清单
- 异常和边界场景
- 不在本次范围内的触点

### Exit Criteria

- 高优先级触点均有明确应用方式
- 系统在真实内容下保持可用
- 不同媒介间的变化规则明确
- 未覆盖场景有可推导的处理原则

### Approval Gate

**条件批准。**

高影响、公开或高频触点必须批准；低风险示例可随品牌规范整体批准。

---

## 阶段 06：网站品牌接入

目的：把品牌系统映射到现有网站结构和界面，而不是简单替换颜色与 Logo。

### Input

- 核心品牌系统
- 网站现状审计
- 网站信息架构
- 页面、组件和状态清单
- 现有设计系统或前端约束
- 内容、SEO、可访问性和兼容性要求
- 发布限制

### Output

- Brand-to-Web Mapping
- 品牌元素到网站层级的映射
- 页面和组件影响矩阵
- 网站设计变量映射
- 内容与品牌语气调整范围
- 保留 / 调整 / 重构分类
- 迁移优先级
- 品牌接入风险和兼容性约束
- 上线验收标准

### Exit Criteria

- 品牌系统与网站元素之间存在明确映射
- 关键页面、组件和交互状态均已纳入影响分析
- 已区分品牌变化与产品体验变化
- 已识别对内容、SEO、可访问性和发布的影响
- 接入范围可以独立进入后续执行规划

### Approval Gate

**W、U+W 必须批准。**

批准内容：接入范围、保留项、变化项、优先级和风险接受程度。

N、纯 U 项目无网站交付时可跳过。

---

## 阶段 07：品牌规范整合

目的：把已批准的分散决策整合为唯一可信的品牌系统说明。

### Input

- 所有已批准阶段产物
- 批准记录
- 例外决定
- 资产和版本信息
- 未覆盖事项

### Output

- Brand System Specification
- 决策摘要
- 规则与资产索引
- 使用边界
- 例外和已知限制
- 版本号与适用范围
- 待后续扩展清单

### Exit Criteria

- 规范与各批准结果一致
- 不存在相互冲突的规则
- 正式规则与探索材料已分离
- 使用者能找到所需决策及其适用范围
- 版本和权威来源明确

### Approval Gate

**必须批准。**

这是品牌系统成为正式基准的 Gate。

---

## 阶段 08：发布与迁移规划

目的：确定品牌从当前状态过渡到目标状态的顺序、依赖和风险控制。

### Input

- 已批准的品牌规范
- 触点及网站影响矩阵
- 旧资产清单
- 组织、供应商和发布约束
- 业务关键日期

### Output

- Rollout Plan
- 分阶段迁移范围
- 旧资产停用或共存规则
- 优先级和依赖关系
- 发布批次
- 责任分工
- 风险、回退和例外处理原则
- 发布准备条件

### Exit Criteria

- 每类资产和触点都有明确去向
- 新旧品牌共存边界明确
- 关键依赖与负责人明确
- 高风险变更具备回退原则
- 发布准备条件可以被客观判断

### Approval Gate

**公开发布或大范围迁移前必须批准。**

仅交付品牌方案、不负责发布的项目，可将本阶段裁剪为简版交接建议。

---

## 阶段 09：交付、治理与持续演进

目的：让品牌系统在项目结束后仍能被正确使用和持续维护。

### Input

- Brand System Specification
- Rollout Plan
- 正式资产清单
- 组织角色和维护约束
- 已知例外及待办事项

### Output

- 正式交付清单
- 品牌所有权与维护责任
- 版本管理规则
- 新需求和例外审批流程
- 变更记录机制
- 定期复审触发条件
- 后续阶段建议

### Exit Criteria

- 正式资产、规范和版本一致
- 品牌负责人及维护方式明确
- 新触点出现时有可执行的扩展流程
- 未完成事项已明确归属
- 项目可以结束而不依赖隐性知识

### Approval Gate

**必须完成交付确认。**

重大品牌变更继续沿用阶段 02–08 的相应 Gate；日常扩展按治理规则审批。

---

# 6. 三类项目的默认裁剪

| 阶段 | 新品牌 N | 品牌升级 U | 网站接入 W | 品牌升级并接入 U+W |
|---|---:|---:|---:|---:|
| 00 启动与路径判定 | Required | Required | Required | Required |
| 01 发现与审计 | Required | Required | Required | Required |
| 02 战略基础 | Required | Conditional / Reuse | Reuse / Conditional | Conditional |
| 03 创意方向 | Required | Required | Conditional / Reuse | Required |
| 04 核心品牌系统 | Required | Required | Reuse / Conditional | Required |
| 05 应用与触点 | Required | Required | Conditional | Required |
| 06 网站品牌接入 | Conditional | Conditional | Required | Required |
| 07 规范整合 | Required | Required | Required | Required |
| 08 发布与迁移 | Conditional | Required | Required | Required |
| 09 交付与治理 | Required | Required | Required | Required |

`Reuse` 不等于跳过：必须确认复用来源、版本和适用范围。

---

# 7. 裁剪规则

## 7.1 最小可行路径

任何项目至少保留：

1. 阶段 00：确认目标、路径和范围。
2. 阶段 01：获得足够事实依据。
3. 阶段 07：形成唯一可信版本。
4. 阶段 09：明确交付和维护责任。

如果复用既有战略或品牌系统，还必须记录其来源和版本。

## 7.2 合并阶段

小型项目可以合并：

- 00 + 01：启动与快速审计
- 02 + 03：战略校准与创意方向
- 04 + 05：核心系统与重点触点
- 07 + 09：规范交付与治理

合并不取消阶段的 Input、Output、Exit Criteria 或 Approval Gate。

## 7.3 跳过条件

阶段只有在以下条件全部满足时才能跳过：

- 存在可信且适用的既有产物
- 后续阶段不依赖新的决策
- 跳过不会隐藏重大风险
- 跳过理由已记录
- 需要时获得用户确认

## 7.4 回退条件

出现以下情况应回退到较早阶段：

- 业务目标或受众发生实质变化：回到阶段 02
- 创意方向无法覆盖关键触点：回到阶段 03
- 核心规则在真实场景中冲突：回到阶段 04
- 网站约束使品牌接入方案不可行：回到阶段 04 或 06
- 发布范围发生重大变化：回到阶段 08

回退不代表重新开始；只重开受影响的决策。

## 7.5 变更控制

Approval Gate 之后发生变更时，应记录：

- 变更原因
- 受影响阶段
- 受影响产物
- 是否需要重新批准
- 是否影响发布时间或既有资产

---

# 8. 真实项目映射

## 8.1 边大夫口腔

类型：`U+W`  
场景：已有网站，进行品牌升级并接入线上系统。

推荐路径：

```text
00 → 01 → 02（校准）→ 03 → 04 → 05 → 06 → 07 → 08 → 09
```

重点：

- 审计现有网站、品牌资产和患者触点
- 明确保留与替换范围
- 避免品牌升级破坏现有网站业务、内容和搜索表现
- 将品牌变化映射到页面、组件和内容语气
- 采用分阶段迁移，管理新旧资产共存

关键 Gate：

- 审计与保留范围
- 品牌方向
- 核心系统
- 网站接入范围
- 发布计划

## 8.2 乐可开源

类型：`N` 或“轻量 U”，由阶段 00 判定。  
场景：已有产品，但不等于已有成熟品牌系统。

推荐路径：

```text
00 → 01 → 02 → 03 → 04 → 05 → 06（如已有站点）→ 07 → 08 → 09
```

重点：

- 区分产品事实、社区认知与正式品牌资产
- 保留已有用户认知中有效的部分
- 建立适合开源社区、文档、代码仓库和产品界面的统一系统
- 不因已有产品而默认跳过品牌战略
- 网站接入根据现有站点状态裁剪

## 8.3 未来其他客户

统一从阶段 00 开始，根据客户现状组合路径：

- 初创企业：N
- 成熟品牌视觉更新：U
- 已有品牌规范，仅改造网站：W
- 品牌重塑并更新线上渠道：U+W
- 小型局部项目：保留最小可行路径，合并相关阶段

---

# 9. Gate 汇总

| Gate | 批准内容 | 是否强制 |
|---|---|---|
| G0 | 项目路径、范围、裁剪和成功标准 | 强制 |
| G1 | 审计及保留 / 优化 / 替换边界 | U、W、U+W 强制 |
| G2 | 品牌战略基础或战略变化 | N 及战略变化项目强制 |
| G3 | 品牌创意方向 | 进入新系统设计前强制 |
| G4 | 核心品牌系统 | 强制 |
| G5 | 高优先级触点规则 | 条件强制 |
| G6 | 网站接入范围与影响 | W、U+W 强制 |
| G7 | 正式品牌规范版本 | 强制 |
| G8 | 发布和迁移计划 | 涉及发布时强制 |
| G9 | 正式交付与治理责任 | 强制 |

---

# 10. Workflow 完成定义

一次 Workflow 可以在不同深度下完成，但必须满足：

- 项目路径和裁剪范围已获批准
- 所有纳入范围的阶段均达到 Exit Criteria
- 所有强制 Gate 均有明确结论
- 跳过和复用都有依据
- 正式决策与探索材料已分离
- 交付版本和维护责任明确
- 未完成事项不会被误认为已完成
- 后续扩展具有明确入口

---

## 11. 已批准的一致性修订

### 11.1 Revision constraints

This revision does not:

- change the approved Scope;
- change Test Scenarios;
- modify SKILL.md;
- add, remove, rename, split, or reorder Workflow Stages;
- change Approval Gates G0-G9;
- change project paths N, U, W, or U+W;
- enter Release.

All unchanged content in this Workflow remains effective. The following clauses add or clarify only the mappings required by Validation Report v1.

### 11.2 Canonical activity-to-stage mapping

The following mappings are normative. Activity names describe responsibilities that may span existing stages; they do not create additional Workflow Stages.

| Scope / SKILL activity | Owning Workflow Stage | Supporting Stage | Formal completion point |
|---|---|---|---|
| Identity Creation | Stage 04 - Core Brand System | Stage 03 - Brand Creative Direction | G4 |
| General Integration | Stage 05 - Application and Touchpoint Rules | Stage 04 provides the source brand system | Applicable Stage 05 Exit Criteria and G5 when required |
| Website Integration | Stage 06 - Website Brand Adoption | Stage 05 provides general application rules | G6 |
| System Freeze | Stage 07 - Brand Specification Consolidation | Stages 02-06 provide approved decisions | G7 |
| Delivery Freeze | Stage 09 - Delivery, Governance, and Evolution | Stage 08 provides rollout and migration decisions | G9 |
| Cross-Stage Validation | Every Stage Exit and every applicable Approval Gate | Stage 07 and Stage 09 perform cumulative checks | The current Gate; no new Gate is created |

### 11.3 Revision A - Identity Creation mapping

#### 11.3.1 Formal rule

`Identity Creation` is a two-stage activity with one owning stage:

- Stage 03 defines and approves the identity direction.
- Stage 04 creates, systematizes, and finalizes the identity system.
- Stage 04 is the formal owner of Identity Creation.

Stage 03 must not be treated as completion of Identity Creation. Its purpose is to select the conceptual and expressive direction that Stage 04 will develop into a usable system.

#### 11.3.2 Stage 03 clarification

Add the following responsibility to Stage 03:

> Translate approved strategy into candidate identity directions, evaluate their strategic fit and implications for retained assets, and select one direction for system creation in Stage 04.

Stage 03 Output additionally clarifies:

- selected identity direction;
- implications for existing identity assets;
- preliminary preserve / refine / replace decision for U and U+W projects;
- constraints that Stage 04 must follow.

Stage 03 Exit Criteria additionally require:

- the selected direction is specific enough for Stage 04 to create the identity system;
- approval at G3 does not imply that final identity assets or rules are approved.

#### 11.3.3 Stage 04 clarification

Add the following responsibility to Stage 04:

> Execute Identity Creation by converting the G3-approved direction into the coherent, reusable core identity system defined by the project's tailored scope.

Stage 04 Input explicitly includes:

- the G3 approval record;
- the selected identity direction;
- preserve / refine / replace decisions for existing identity assets.

Stage 04 Output explicitly includes, when in scope:

- the created or revised identity assets;
- the relationships and rules that make those assets a system;
- mappings from retained legacy identity assets to the approved system;
- unresolved exceptions that must be handled before G4.

Stage 04 Exit Criteria additionally require:

- every in-scope identity element is created, revised, retained, or explicitly excluded;
- each result is traceable to the approved Stage 03 direction;
- Identity Creation is not considered complete until G4 approves the core brand system.

### 11.4 Revision B - General Integration mapping

#### 11.4.1 Formal rule

`Integration` means applying the approved brand system to an existing product, service, channel, environment, or operational touchpoint. It is broader than website integration.

- Stage 05 owns General Integration.
- Stage 06 owns Website Integration as a specialized form of Integration.
- A project does not enter Stage 06 merely because Integration is required; Stage 06 applies only when a website is in scope.

#### 11.4.2 Stage 05 clarification

Rename nothing. Add the following responsibility to the existing Stage 05 definition:

> Define how the core brand system integrates with in-scope non-website touchpoints, including existing products, interfaces, documentation, communications, marketing channels, physical materials, and other operational environments selected during Workflow tailoring.

Stage 05 Input additionally includes:

- existing touchpoint or product constraints;
- current templates, interface conventions, content structures, or production rules;
- the Stage 01 preserve / optimize / replace assessment.

Stage 05 Output additionally includes:

- a general Brand-to-Touchpoint Mapping;
- integration classification for each in-scope touchpoint: retain, adapt, replace, or exclude;
- shared integration rules that apply across multiple channels;
- touchpoint-specific exceptions and ownership;
- identification of any website-specific work delegated to Stage 06.

Stage 05 Exit Criteria additionally require:

- every in-scope non-website touchpoint has an explicit integration disposition;
- general rules and channel-specific exceptions are distinguishable;
- integration does not silently expand into unrelated product or experience redesign;
- website-specific requirements are transferred to Stage 06 when W or U+W applies.

#### 11.4.3 Stage 06 boundary clarification

Stage 06 remains unchanged in identity and Gate. Add this boundary rule:

> Stage 06 specializes the Stage 05 integration model for an existing website. It does not replace General Integration and does not own non-website touchpoints.

If a project contains both general and website integration:

1. Stage 05 defines shared cross-channel rules and integration boundaries.
2. Stage 06 maps those rules to the website's pages, components, states, content, and technical constraints.
3. Conflicts found in Stage 06 return to the owning Stage 04 or Stage 05 decision rather than creating a website-only brand rule without reconciliation.

### 11.5 Revision C - Freeze mapping

#### 11.5.1 Formal rule

`Freeze` has two formally distinct states within the existing Workflow:

- Stage 07 establishes System Freeze at G7.
- Stage 09 establishes Delivery Freeze at G9.

Neither Freeze state creates a new Stage or Approval Gate.

#### 11.5.2 Stage 07 - System Freeze

At Stage 07, the Brand System Specification becomes the approved baseline.

System Freeze means:

- all approved decisions from applicable Stages 02-06 are consolidated;
- contradictory, exploratory, superseded, and unapproved material is excluded from the formal baseline;
- assets, rules, exceptions, version, and applicability are fixed for downstream rollout and delivery;
- changes after G7 must follow the existing change-control rule and may reopen the owning stage;
- Stage 08 and Stage 09 must reference the G7 baseline version.

Stage 07 Output additionally includes:

- the frozen system version identifier;
- a decision and exception register;
- an inventory of included and excluded assets;
- a record of any approved deferred items.

Stage 07 Exit Criteria additionally require:

- Cross-Stage Validation has passed cumulatively for all applicable Stages 00-07;
- the frozen specification has no unresolved blocking contradiction;
- every formal rule and asset has a versioned source and an owner;
- G7 explicitly records System Freeze approval.

#### 11.5.3 Stage 09 - Delivery Freeze

At Stage 09, the delivered package becomes the accepted operational snapshot.

Delivery Freeze means:

- delivered assets, specification, rollout references, governance rules, and ownership records agree with the G7 system baseline plus approved post-G7 changes;
- the authoritative delivery inventory and version are fixed;
- unresolved work is clearly separated from delivered work and assigned an owner;
- later evolution begins as a governed change or a new version, not as an undocumented alteration to the frozen delivery.

Stage 09 Output additionally includes:

- the delivery version identifier;
- the authoritative delivery inventory;
- a reconciliation record against the Stage 07 frozen baseline;
- all approved post-G7 changes;
- open items that are explicitly outside the frozen delivery.

Stage 09 Exit Criteria additionally require:

- cumulative Cross-Stage Validation has passed through Stage 09;
- delivery contents reconcile with the Stage 07 baseline and approved change records;
- governance ownership is active;
- G9 explicitly records Delivery Freeze and handoff acceptance.

### 11.6 Revision D - Cross-Stage Validation

#### 11.6.1 Formal rule

Cross-Stage Validation is a mandatory Workflow rule, not a separate Stage and not a new Approval Gate.

It must occur:

1. before a stage is marked complete;
2. before every applicable G0-G9 approval decision;
3. cumulatively before System Freeze at G7;
4. cumulatively before Delivery Freeze at G9;
5. whenever an approved upstream decision changes.

#### 11.6.2 Validation dimensions

Each check covers the dimensions relevant to the current stage:

| Dimension | Required question |
|---|---|
| Traceability | Can each output be traced to an approved input, decision, or recorded constraint? |
| Completeness | Are all in-scope requirements, paths, touchpoints, and exceptions accounted for? |
| Consistency | Does the output agree with approved upstream decisions and parallel outputs? |
| Boundary compliance | Has the stage stayed within Scope and the approved Workflow tailoring? |
| Approval integrity | Are only approved decisions treated as authoritative? |
| Version integrity | Are referenced inputs, assets, and baselines identified by the correct version? |
| Downstream readiness | Are the outputs sufficient and unambiguous for the next applicable stage? |

#### 11.6.3 Validation record

For each completed stage, the Workflow records:

- stage and project path;
- applicable validation dimensions;
- evidence or artifact references;
- result: Pass, Pass with Approved Exception, or Fail;
- approved exceptions and owners;
- affected upstream or downstream stages;
- whether reapproval is required.

This record may be lightweight, but it cannot be omitted.

#### 11.6.4 Failure and invalidation rules

- A stage with a `Fail` result cannot exit and cannot proceed through its Gate.
- `Pass with Approved Exception` is allowed only when the exception, impact, owner, and approval are recorded.
- A conflict is returned to the stage that owns the conflicting decision.
- When an approved upstream decision changes, downstream outputs that depend on it become provisionally invalid until revalidated.
- Revalidation is limited to affected stages and artifacts; it does not automatically restart the entire Workflow.
- A change to the G7 frozen baseline requires change control, impact analysis, and reapproval at every affected existing Gate.
- Stage 09 cannot freeze delivery while any blocking inconsistency or unapproved deviation remains.

### 11.7 Path behavior remains unchanged

The N / U / W / U+W paths and their existing Required, Conditional, Reuse, and Skip designations remain unchanged.

The new mappings apply as follows:

| Path | Identity Creation | General Integration | Website Integration | Freeze |
|---|---|---|---|---|
| N | Stage 03 direction, Stage 04 creation | Stage 05 when touchpoints are in scope | Stage 06 only when a website is in scope | Stage 07 System Freeze, Stage 09 Delivery Freeze |
| U | Stage 03 direction, Stage 04 retain / refine / replace execution | Stage 05 for existing products and touchpoints | Stage 06 only when a website is in scope | Stage 07 System Freeze, Stage 09 Delivery Freeze |
| W | Reuse or conditional identity work under existing tailoring | Stage 05 for shared integration rules | Stage 06 required as already defined | Stage 07 System Freeze, Stage 09 Delivery Freeze |
| U+W | Stage 03 direction, Stage 04 upgraded identity system | Stage 05 for cross-channel integration | Stage 06 required as already defined | Stage 07 System Freeze, Stage 09 Delivery Freeze |

Cross-Stage Validation applies to every path and only to the stages selected by that project's approved tailoring.

### 11.8 Revision acceptance criteria

Workflow Revision 1 is complete when:

- Identity Creation has an unambiguous Stage 03-04 mapping and Stage 04 ownership;
- General Integration is formally carried by Stage 05 without weakening Stage 06 website specialization;
- System Freeze maps to Stage 07 / G7 and Delivery Freeze maps to Stage 09 / G9;
- Cross-Stage Validation has mandatory timing, dimensions, records, and failure behavior;
- no Stage, Gate, path, Scope item, Test Scenario, or SKILL.md content has changed;
- Release remains paused.
