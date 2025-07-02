## todo アプリ

サイト URL:https://todo-rails-application.onrender.com/

![Image](https://github.com/user-attachments/assets/36286428-ef3a-4270-9fd6-b553d02723e5)

## 概要

このアプリは、Ruby on Rails の学習の一環として作成した ToDo 管理アプリです。  
Rails チュートリアル修了後のアウトプットとして、一人で CRUD 機能の実装や認証機能の導入、テスト技法の実践を目的に開発しました。

## 主な機能

- ユーザー認証（Devise 使用、Google OAuth 対応）
- ToDo の作成・編集・削除・コピー（CRUD）
- Turbo stream を使用した **非同期 UI の実装**
- ソフトウェアテスト技法(同値クラステスト、境界値テスト、ディシジョンテーブル、状態遷移テスト)
- カバレッジ(C0,C1)を導入。(Line Coverage: 77.37% (212 / 274) Branch Coverage: 53.23% (33 / 62))
- ステータス別（未完了/完了）での分類表示
- 期限によるタスクの分類（今日、近日、期限切れなど）
- 統合テストの導入（Minitest）

## 使用技術

| カテゴリ       | 技術                                         |
| -------------- | :------------------------------------------- |
| フロントエンド | Turbo / Stimulus / Tailwind CSS / Preline UI |
| バックエンド   | Ruby on Rails 8.0.4                          |
| データベース   | PostgreSQL 15                                |
| テスト         | Minitest                                     |
| 認証           | Devise / OmniAuth (Google OAuth2)            |
| 環境構築       | Docker / Devcontainer（VSCode）              |
| CI/CD          | Github Actions(CI)                           |
| インフラ       | Render(App) , Neon(DB)                       |
| その他         | ESLint / rubocop / SimpleCov                 |

## ライセンス

このアプリは学習目的で作成されたものであり、商用利用は想定していません。
