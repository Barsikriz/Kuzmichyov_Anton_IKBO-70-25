## Задача 8

Написать программу, которая находит все файлы с указанным расширением в заданном каталоге и архивирует их в архив `tar`.

### Решение

```bash
#!/usr/bin/env bash

if (( $# != 3 )); then
    echo "Использование: $0 каталог расширение архив.tar" >&2
    exit 1
fi

dir=$1
extension=${2#.}
archive=$3

if [[ ! -d $dir ]]; then
    echo "Ошибка: каталог '$dir' не найден" >&2
    exit 1
fi

mapfile -d '' files < <(find "$dir" -type f -name "*.${extension}" -print0)

if (( ${#files[@]} == 0 )); then
    echo "Файлы с расширением .$extension не найдены" >&2
    exit 1
fi

printf '%s\0' "${files[@]}" | tar --null -T - -cf "$archive"

echo "Создан архив: $archive"
```

Пример запуска:

```bash
chmod +x archive_ext
./archive_ext . txt texts.tar
```
