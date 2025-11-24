---
description: 從 Laravel Web 專案產生 OpenAPI 規格，並同步更新 Flutter 專案的 API Client
---

1. 進入 Web 專案並產生 OpenAPI 規格
cd A126-kompraa_web && docker-compose -f ../../laradock/docker-compose.yml exec -w /var/www/a126/A126-kompraa_web workspace php artisan scribe:generate --force

2. 複製 openapi.yaml 到 Flutter 專案
cp A126-kompraa_web/public/docs/openapi.yaml a126_kompraa_flutter/openapi.yaml

3. 進入 Flutter 專案並重新產生 API Client
cd a126_kompraa_flutter && flutter pub run build_runner build --delete-conflicting-outputs
