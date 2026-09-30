## Задача 7

Написать программу для нахождения файлов-дубликатов по заданному пути и его подкаталогам.

### Решение

```bash
#!/usr/bin/env bash

if (( $# != 1 )); then
    echo "Использование: $0 путь" >&2
    exit 1
fi

root=$1

if [[ ! -d $root ]]; then
    echo "Ошибка: каталог '$root' не найден" >&2
    exit 1
fi

declare -A count
declare -A files

while IFS= read -r -d '' file; do
    hash_line=$(sha256sum -- "$file")
    hash=${hash_line%% *}

    (( count["$hash"] += 1 )) || true
    files["$hash"]+=$'\n'"$file"
done < <(find "$root" -type f -print0)

found=0
for hash in "${!count[@]}"; do
    if (( count["$hash"] > 1 )); then
        found=1
        printf 'Дубликаты (SHA-256: %s):%s\n\n' "$hash" "${files[$hash]}"
    fi
done

if (( found == 0 )); then
    echo "Дубликаты не найдены"
fi
