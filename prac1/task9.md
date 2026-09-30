## Задача 9

Написать программу, которая заменяет последовательности из четырёх пробелов на символ табуляции. Входной и выходной файлы задаются аргументами.

### Решение

```bash
#!/usr/bin/env bash

if (( $# != 2 )); then
    echo "Использование: $0 входной_файл выходной_файл" >&2
    exit 1
fi

input=$1
output=$2

if [[ ! -f $input ]]; then
    echo "Ошибка: файл '$input' не найден" >&2
    exit 1
fi

if [[ $input == "$output" ]]; then
    temp=$(mktemp)
    trap 'rm -f "$temp"' EXIT
    sed $'s/    /\t/g' -- "$input" > "$temp"
    cat "$temp" > "$output"
else
    sed $'s/    /\t/g' -- "$input" > "$output"
fi
```

Пример запуска:

```bash
chmod +x spaces_to_tabs
./spaces_to_tabs input.txt output.txt
```
