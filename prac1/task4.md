## Задача 4

Написать программу для вывода всех идентификаторов по правилам C/C++/Java в файле без повторений.

### Решение

```bash
```bash
#!/usr/bin/env bash

if (( $# != 1 )); then
    echo "Использование: $0 файл" >&2
    exit 1
fi

file=$1

if [[ ! -f $file ]]; then
    echo "Ошибка: файл '$file' не найден" >&2
    exit 1
fi

grep -oE '[A-Za-z_][A-Za-z0-9_]*' -- "$file" | sort -u | paste -sd ' ' -
echo
```
```

Пример запуска:

```bash
chmod +x identifiers
./identifiers hello.c
