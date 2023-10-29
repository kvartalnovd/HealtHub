# Быстрый старт: Сборка и запуск программы

## Первый запуск

Клонируем репозиторий:

```bash
git clone https://github.com/kvartalnovd/HealtHub.git && cd HealtHub
```

Для управления Docker контейнерами создан ряд скриптов

Для простого запуска используем команду `./src/docker/bin/start`

> Первая загрузка может быть долгой из-за сборки образов

## Список команд для управления контейнерами
>Команды указаны после перехода в папку `/src/`

| Команда                           | Задача                                                              |
|-----------------------------------|---------------------------------------------------------------------|
| `./docker/bin/start`              | Запуск и сборка контейнеров                                         |
| `./docker/bin/stop`               | Остановка контейнеров                                               |
| `./docker/bin/status`             | Проверка состояния контейнеров (аналогична docker-compose ps)       |
| `./docker/bin/restart`            | Перезапуск контейнеров (`./docker/bin/start` + `./docker/bin/stop`) |
| `./docker/bin/attach [container]` | Вход в контейнер `[container]` (аналог docker exec)                 |

Лучше использовать данные скрипты, чем вручную запускать docker-compose, т.к скрипты автоматически подгрузят окружение

<br/>