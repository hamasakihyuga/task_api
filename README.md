# Task API – Ruby on Rails 課題実装

本リポジトリは、**エンジニア選考課題**として実装した「シンプルなタスク管理 API」です。  
Ruby on Rails（API モード）で構築し、RSpec による自動テストを導入することで、品質と保守性を重視した設計にしています。

---

## 🚀 プロジェクト概要

本 API はタスク（ToDo）管理を目的としたシンプルな RESTful API です。  
以下の機能を持ち、すべて **JSON ベース** で通信します：

- タスクの作成 / 取得 / 更新 / 削除（CRUD）
- `completed` のデフォルト値を DB レベルで `false` に設定
- JSON 形式以外のリクエストは 415 で拒否
- 不正 JSON やパースエラーは 400、存在しないリソースは 404 を返却
- RSpec によるモデル・リクエストレベルの自動テスト

---

## 🧰 開発環境

| 項目 | バージョン |
|------|------------|
| OS | Ubuntu 24.04 (WSL2) |
| Ruby | 3.3.4 |
| Rails | 8.0.3 |
| DB | SQLite3 |
| テスト | RSpec 6.1 / FactoryBot / shoulda-matchers |

---

## ⚙️ セットアップ手順

```bash
# 1. リポジトリをクローン
git clone https://github.com/hamasakihyuga/task_api.git
cd task_api

# 2. 依存関係のインストール
bundle install

# 3. DB 初期化
bin/rails db:setup   # db:create + db:migrate を実行

# 4. サーバ起動
bin/rails s   # http://localhost:3000 でAPIが利用可能
