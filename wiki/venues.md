---
name: venues
description: 探索対象の学会・ジャーナル一覧．サーベイ skill が論文を探す際の中心ターゲット
type: reference
source: https://github.com/Wakayama-SocSEL/Lab-all/wiki/学会リスト (2026-04-13 取得)
---

# 学会・ジャーナル探索リスト

サーベイ・論文 ingest・関連研究調査の **中心的探索対象**．Wakayama-SocSEL Lab の学会リストをベースに，国内のみの venue を除外したもの．

> **注意**: このリストは SE (Software Engineering) 系に強く偏っている．本研究 (JS 性能書換規則の条件抽出 + プログラム合成) は **PL (Programming Languages) 系**の venue (POPL, PLDI, OOPSLA, ECOOP, ICFP) も同等以上に重要．§補足 を参照．

---

## ジャーナル (海外)

| レベル | 略称 | フルネーム |
|---|---|---|
| 師範代 | TSE | IEEE Transactions on Software Engineering |
| 超絶級 | EMSE | Empirical Software Engineering |
| 超絶級 | TOSEM | ACM Transactions on Software Engineering and Methodology |
| 超級 | JSS | Journal of Systems and Software |
| 超級 | IST | Information and Software Technology |
| 超級 | JSME | Journal of Software: Evolution and Process |
| - | IEEE Software | IEEE Software |

---

## 国際会議 (SE 系)

| レベル | 略称 | フルネーム / 分野 |
|---|---|---|
| 師範代 | **ICSE** | International Conference on Software Engineering — SE 全般 |
| 師範代 | **FSE** (ESEC/FSE) | ACM SIGSOFT International Symposium on Foundations of Software Engineering — SE 全般 |
| 師範代 | **ASE** | International Conference on Automated Software Engineering — ソフトウェア自動化 |
| 師範代 | RE | Requirements Engineering Conference — 要求工学 |
| 超絶級 | **MSR** | Mining Software Repositories — リポジトリマイニング |
| 超絶級 | ESEM | International Symposium on Empirical Software Engineering and Measurement |
| 超絶級 | ICSME | International Conference on Software Maintenance and Evolution — 保守 |
| 超絶級 | SANER | International Conference on Software Analysis, Evolution and Reengineering |
| 超級 | ISSRE | International Symposium on Software Reliability Engineering — 信頼性 |
| 超級 | ICPC | International Conference on Program Comprehension — プログラム理解 |
| 超級 | OSS | International Conference on Open Source Systems — OSS 工学 |
| 超級 | QRS | International Conference on Software Quality, Reliability and Security |
| 超級 | Promise | International Conference on Predictive Models and Data Analytics in Software Engineering |
| - | ICGSE | International Conference on Global Software Engineering — 分散開発 |
| - | Profes | International Conference on Product-Focused Software Process Improvement |
| - | APSEC | Asia-Pacific Software Engineering Conference — Asia-Pacific 持ち回り |

---

## 補足: PL / Verification 系国際会議 

上記 SE リストには含まれていないが，**本研究 (rewrite rule inference / equivalence / program synthesis / weakest precondition) では SE 会議と同等以上に重要**な venue:

| レベル | 略称 | フルネーム / 分野 |
|---|---|---|
| 師範代 | **POPL** | ACM SIGPLAN Symposium on Principles of Programming Languages |
| 師範代 | **PLDI** | ACM SIGPLAN Conference on Programming Language Design and Implementation |
| 師範代 | **OOPSLA** | ACM SIGPLAN Conference on Object-Oriented Programming, Systems, Languages, and Applications |
| 師範代 | **ICFP** | ACM SIGPLAN International Conference on Functional Programming |
| 超絶級 | **ECOOP** | European Conference on Object-Oriented Programming |
| 超絶級 | **CAV** | International Conference on Computer Aided Verification |
| 超絶級 | **CGO** | International Symposium on Code Generation and Optimization |
| 超絶級 | **CC** | International Conference on Compiler Construction |
| 超級 | **TACAS** | Tools and Algorithms for the Construction and Analysis of Systems |
| 超級 | **VMCAI** | Verification, Model Checking, and Abstract Interpretation |
| 超級 | **FMCAD** | Formal Methods in Computer-Aided Design |
| 超級 | **SAS** | Static Analysis Symposium |
| 超級 | **APLAS** | Asian Symposium on Programming Languages and Systems |

**論拠**: Hydra (OOPSLA 2024), PEC (PLDI 2009), egg (POPL 2021), Ruler (OOPSLA 2021), Enumo (OOPSLA 2023), Alive2 (PLDI 2021), Bi-abduction (POPL 2009 / JACM 2011), Alive-Infer (PLDI 2017) など，本研究の直接の先行研究はすべてこの PL/Verification 系から出ている．

---

## サーベイ時の探索ガイドライン

サーベイ skill / Agent が文献調査を行う際は **以下を中心**に探索する:

### Tier 1 (必ず確認)
- **PL 系**: POPL, PLDI, OOPSLA, ICFP, ECOOP
- **SE 系**: ICSE, FSE, ASE
- **Verification 系**: CAV
- **Compiler 系**: CGO, CC

### Tier 2 (テーマに応じて)
- **SE 系**: MSR, ICSME, SANER, ESEM, ICPC
- **PL 系**: TACAS, VMCAI, FMCAD, SAS, APLAS

### Tier 3 (補完)
- **Journal**: TSE, TOSEM, EMSE, JSS, IST, JSME, IEEE Software, TOPLAS (PL 系の超絶級 journal)
- **arxiv**: cs.PL, cs.SE — 特に未刊行の preprint, 直近 2 年

### 探索の順序
1. **DBLP** で venue 別に最新号の目次を直接走査 (検索バイアスを回避)
2. **Google Scholar** で本研究の主要先行 (Hydra, Alive-Infer, Ruler 等) の被引用追跡
3. **arxiv** で年指定検索 (cs.PL + cs.SE の直近 2 年)

---

## 除外したもの (メモ)

以下は元リストから除外:
- 日本国内のみの venue: 電子情報通信学会, 情報処理学会, ソフトウェア科学会, FOSE, SES, ウィンターワークショップ, SIGSE, SIGSS, DICOMO, GN
- IWESEP (奈良開催ベースの workshop)

将来日本国内 venue が必要になった場合は元の Wakayama wiki を参照．
