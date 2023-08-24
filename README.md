# Memoアプリ

## 必要な構成
 - Ruby 3.1.4

## インストール手順
Gemのインストール
```
bundle install
```

DatabaseとTableの作成
```
psql postgres

CREATE DATABASE memo_app;

CREATE TABLE memos (
  id SERIAL PRIMARY KEY,
  title VARCHAR(128) NOT NULL,
  description VARCHAR(256) NOT NULL
);
```

## 実行方法
```
bundle exec ruby app.rb
```

http://127.0.0.1:4567 へアクセスする。
