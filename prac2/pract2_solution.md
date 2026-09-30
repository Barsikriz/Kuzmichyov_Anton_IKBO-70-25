# Задача 1. matplotlib

Нужно вывести служебную информацию о Python-пакете `matplotlib`, разобрать метаданные и показать получение исходников непосредственно из репозитория.

### Установка в отдельное виртуальное окружение

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install matplotlib
```

### Основная служебная информация

```bash
python -m pip show matplotlib
```

Ожидаемые поля:

- `Name` — имя пакета;
- `Version` — установленная версия;
- `Summary` — краткое описание;
- `Home-page`/project URLs — адрес проекта;
- `Author` — авторы/сопровождающие;
- `License` — лицензия;
- `Location` — каталог установки;
- `Requires` — прямые зависимости;
- `Required-by` — установленные пакеты, которым нужен matplotlib.

Полный список установленных файлов:

```bash
python -m pip show -f matplotlib
```

### Чтение Python METADATA

Wheel/installed distribution содержит каталог вида `matplotlib-X.Y.Z.dist-info`. В нём находится файл `METADATA`.

Удобно прочитать его через стандартный модуль Python:

```bash
python - <<'PY'
from importlib.metadata import distribution

d = distribution("matplotlib")
print(d.read_text("METADATA"))
PY
```

Основные элементы `METADATA`:

- `Metadata-Version` — версия стандарта метаданных;
- `Name` — имя distribution;
- `Version` — версия;
- `Summary` — описание;
- `License`/`License-Expression` — лицензия;
- `Requires-Python` — допустимые версии Python;
- `Requires-Dist` — зависимости и их ограничения;
- `Classifier` — классификаторы PyPI;
- `Project-URL` — документация, исходники, bug tracker и т.д.

### Получение без менеджера пакетов, прямо из Git

```bash
git clone https://github.com/matplotlib/matplotlib.git
cd matplotlib
```

Для получения определённой версии можно checkout'нуть tag:

```bash
git tag --list | tail
git checkout v3.11.2
```

`git clone` получает исходный код непосредственно из Git-репозитория, то есть на этом шаге `pip` как средство получения пакета не используется.

---

# Задача 2. express

```bash
mkdir -p express-demo
cd express-demo
npm init -y
npm install express
```

### Служебная информация из registry

```bash
npm view express
```

Более удобный JSON:

```bash
npm view express --json
```

Только основные поля:

```bash
npm view express name version description license repository dependencies engines
```

### Файл package.json установленного пакета

```bash
cat node_modules/express/package.json
```

Основные элементы `package.json`:

- `name` — имя пакета;
- `version` — версия;
- `description` — описание;
- `license` — лицензия;
- `repository` — Git-репозиторий;
- `homepage` — сайт;
- `main` — основной JS-файл;
- `dependencies` — runtime-зависимости;
- `devDependencies` — зависимости для разработки/тестов;
- `engines` — поддерживаемые версии Node.js;
- `scripts` — команды `npm run ...`;
- `files` — что входит в публикуемый npm-пакет.

### Получение Express напрямую из репозитория

```bash
git clone https://github.com/expressjs/express.git
cd express
cat package.json
```

При необходимости можно выбрать tag:

```bash
git tag --list | tail
git checkout 5.2.1
```

---

# Задача 3. Graphviz-графы зависимостей

Установка Graphviz:

```bash
sudo apt install graphviz
```

Получение PNG:

```bash
dot -Tpng matplotlib.dot -o matplotlib.png
dot -Tpng express.dot -o express.png
```

---

# Задача 4. Счастливый билет в MiniZinc

Счастливый шестизначный билет удовлетворяет условию:

```text
d1 + d2 + d3 = d4 + d5 + d6
```

Дополнительно все шесть цифр различны. Нужно минимизировать сумму одной половины.

Файл `lucky_ticket.mzn`:

```minizinc
include "alldifferent.mzn";

array[1..6] of var 0..9: d;

constraint all_different(d);
constraint d[1] + d[2] + d[3] = d[4] + d[5] + d[6];

var 0..27: s = d[1] + d[2] + d[3];

solve minimize s;

output [
    "ticket = ", concat([show(d[i]) | i in 1..6]),
    "\nsum = ", show(s), "\n"
];
```

Запуск:

```bash
minizinc lucky_ticket.mzn
```

Минимальная сумма:

```text
8
```

Один из допустимых оптимальных билетов:

```text
026134
```

Проверка:

```text
0 + 2 + 6 = 8
1 + 3 + 4 = 8
```

Все цифры `0, 2, 6, 1, 3, 4` различны.

---

# Задача 5. Зависимости с рисунка pubgrub.png

На схеме показаны четыре пакета: `root`, `menu`, `dropdown` и `icons`.

Доступные версии:

```text
menu:     1.5.0, 1.4.0, 1.3.0, 1.2.0, 1.1.0, 1.0.0
dropdown: 2.3.0, 2.2.0, 2.1.0, 2.0.0, 1.8.0
icons:    2.0.0, 1.0.0
```

Зависимости, представленные на рисунке:

```text
root -> menu >=1.0.0
root -> icons <2.0.0
menu >=1.1.0 -> dropdown >=2.0.0
menu 1.0.0 -> dropdown >=1.0.0 <2.0.0
dropdown >=2.0.0 -> icons >=2.0.0
```

Для удобства версии кодируются числами:

```text
menu:     10=1.0.0, 11=1.1.0, ..., 15=1.5.0
dropdown: 18=1.8.0, 20=2.0.0, ..., 23=2.3.0
icons:    10=1.0.0, 20=2.0.0
```

Основные ограничения:

```minizinc
var {10, 11, 12, 13, 14, 15}: menu;
var {18, 20, 21, 22, 23}: dropdown;
var {10, 20}: icons;

constraint icons = 10;
constraint (menu >= 11) -> (dropdown >= 20);
constraint (menu = 10) -> (dropdown = 18);
constraint (dropdown >= 20) -> (icons = 20);

solve satisfy;
```

Запуск:

```bash
minizinc task5_dependencies.mzn
```

Получаем единственное совместимое сочетание:

```text
root
menu 1.0.0
dropdown 1.8.0
icons 1.0.0
```

---

# Задача 6. Разрешение заданных зависимостей

Дано:

```text
root 1.0.0 -> foo ^1.0.0, target ^2.0.0
foo 1.1.0 -> left ^1.0.0, right ^1.0.0
foo 1.0.0 -> нет зависимостей
left 1.0.0 -> shared >=1.0.0
right 1.0.0 -> shared <2.0.0
shared 2.0.0 -> нет зависимостей
shared 1.0.0 -> target ^1.0.0
target 2.0.0 / 1.0.0 -> нет зависимостей
```


Запуск:

```bash
minizinc task6_dependencies.mzn
```

Решение:

```text
root 1.0.0
foo 1.0.0
target 2.0.0
```

---

# Задача 7. Общая форма задачи


```python
REPOSITORY = {
    "foo": {
        "1.1.0": {"left": "^1.0.0"},
        "1.0.0": {},
    },
    ...
}
```

Программа должна автоматически выполнить следующие шаги:

1. получить список пакетов и доступных версий;
2. получить зависимости каждой версии;
3. создать переменную выбора для каждой пары `(package, version)`;
4. добавить ограничение «не более одной версии одного пакета»;
5. зафиксировать корневой пакет;
6. для каждой зависимости определить версии, удовлетворяющие SemVer-диапазону;
7. автоматически создать implication вида `selected_A -> (B1 or B2 ...)`;
8. передать полученную систему solver'у.

Запуск:

```bash
python3 generate_dependencies_model.py > generated.mzn
minizinc generated.mzn
```

Генератор сам превращает словарь метаданных в MiniZinc constraints. Например запись:

```python
"root": {
    "1.0.0": {"foo": "^1.0.0", "target": "^2.0.0"}
}
```

автоматически превращается в ограничения примерно такого вида:

```minizinc
constraint p_root_1_0_0 -> (p_foo_1_1_0 \/ p_foo_1_0_0);
constraint p_root_1_0_0 -> (p_target_2_0_0);
```

То есть данные о пакетах отделены от алгоритма разрешения зависимостей. Именно так концептуально действует реальный менеджер пакетов: зависимости приходят из метаданных, а resolver строит систему ограничений уже на их основе.

---

# Что показать преподавателю

Для защиты полезно уметь объяснить:

1. чем пакет отличается от менеджера пакетов;
2. что хранится в `METADATA` и `package.json`;
3. что означает `MAJOR.MINOR.PATCH`, `^`, `>=`, `<`;
4. почему зависимости образуют ориентированный граф;
5. почему выбор версии — задача удовлетворения ограничений;
6. что делает `all_different` в MiniZinc;
7. почему в задаче 6 `foo 1.1.0` создаёт конфликт по `target`;
8. чем задача 7 отличается от 5–6: constraints больше не записаны вручную, а генерируются из метаданных.
