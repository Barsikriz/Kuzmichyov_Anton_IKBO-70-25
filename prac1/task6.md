## Задача 6

Написать программу для проверки наличия комментария в первой строке файлов с расширениями `.c`, `.js` и `.py`.

### Решение

```bash
#!/usr/bin/env bash

if (( $# > 1 )); then
    echo "Использование: $0 [каталог]" >&2
    exit 1
fi

dir=${1:-.}

if [[ ! -d $dir ]]; then
    echo "Ошибка: каталог '$dir' не найден" >&2
    exit 1
fi

while IFS= read -r -d '' file; do
    IFS= read -r first_line < "$file" || first_line=''

    case $file in
        *.py)
            if [[ $first_line =~ ^[[:space:]]*# ]]; then
                echo "$file: комментарий есть"
            else
                echo "$file: комментария нет"
            fi
            ;;
        *.c|*.js)
            if [[ $first_line =~ ^[[:space:]]*(//|/\*) ]]; then
                echo "$file: комментарий есть"
            else
                echo "$file: комментария нет"
            fi
            ;;
    esac
done < <(find "$dir" -type f \( -name '*.c' -o -name '*.js' -o -name '*.py' \) -print0)
```

Пример запуска:

```bash
chmod +x check_comments
./check_comments .
```
