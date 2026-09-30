## Задача 10

Написать программу, которая выводит названия всех пустых текстовых файлов в указанной директории. Директория передаётся параметром.

### Решение

```bash
#!/usr/bin/env bash

if (( $# != 1 )); then
    echo "Использование: $0 каталог" >&2
    exit 1
fi

dir=$1

if [[ ! -d $dir ]]; then
    echo "Ошибка: каталог '$dir' не найден" >&2
    exit 1
fi

find "$dir" -maxdepth 1 -type f -name '*.txt' -empty -printf '%f\n'
```

Пример запуска:

```bash
chmod +x empty_text_files
./empty_text_files .
```
