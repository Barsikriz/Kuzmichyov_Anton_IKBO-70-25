## Задача 3

Написать программу `banner` средствами Bash для вывода текста в рамке. Размер рамки должен автоматически зависеть от длины текста.

### Решение

```bash
#!/usr/bin/env bash

if (( $# != 1 )); then
    echo "Использование: $0 \"текст\"" >&2
    exit 1
fi

text=$1
width=$((${#text} + 2))
printf -v border '%*s' "$width" ''
border=${border// /-}

printf '+%s+\n' "$border"
printf '| %s |\n' "$text"
printf '+%s+\n' "$border"
```

Пример запуска:

```bash
chmod +x banner
./banner "Hello from RTU MIREA!"
