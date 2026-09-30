#!/usr/bin/env python3
from __future__ import annotations

import re

REPOSITORY = {
    "root": {
        "1.0.0": {"foo": "^1.0.0", "target": "^2.0.0"},
    },
    "foo": {
        "1.1.0": {"left": "^1.0.0", "right": "^1.0.0"},
        "1.0.0": {},
    },
    "left": {
        "1.0.0": {"shared": ">=1.0.0"},
    },
    "right": {
        "1.0.0": {"shared": "<2.0.0"},
    },
    "shared": {
        "2.0.0": {},
        "1.0.0": {"target": "^1.0.0"},
    },
    "target": {
        "2.0.0": {},
        "1.0.0": {},
    },
}

ROOT = ("root", "1.0.0")


def version_tuple(text: str) -> tuple[int, int, int]:
    parts = text.split(".")
    if len(parts) != 3 or not all(p.isdigit() for p in parts):
        raise ValueError(f"Поддерживается только MAJOR.MINOR.PATCH: {text}")
    return tuple(map(int, parts))  # type: ignore[return-value]


def compare(v: tuple[int, int, int], op: str, rhs: tuple[int, int, int]) -> bool:
    return {
        "=": v == rhs,
        "==": v == rhs,
        ">": v > rhs,
        ">=": v >= rhs,
        "<": v < rhs,
        "<=": v <= rhs,
    }[op]


def satisfies(version: str, spec: str) -> bool:
    """Минимальный SemVer-парсер для ^, >, >=, <, <= и точной версии."""
    v = version_tuple(version)
    spec = spec.strip()

    if spec.startswith("^"):
        base = version_tuple(spec[1:])
        major, minor, patch = base
        if major > 0:
            upper = (major + 1, 0, 0)
        elif minor > 0:
            upper = (0, minor + 1, 0)
        else:
            upper = (0, 0, patch + 1)
        return base <= v < upper

    # Разрешаем несколько ограничений через пробел: >=1.0.0 <2.0.0
    tokens = spec.split()
    if len(tokens) > 1:
        return all(satisfies(version, token) for token in tokens)

    match = re.fullmatch(r"(>=|<=|>|<|==|=)?(\d+\.\d+\.\d+)", spec)
    if not match:
        raise ValueError(f"Неизвестный формат ограничения: {spec}")

    op = match.group(1) or "="
    return compare(v, op, version_tuple(match.group(2)))


def ident(package: str, version: str) -> str:
    safe_pkg = re.sub(r"[^A-Za-z0-9_]", "_", package)
    safe_ver = version.replace(".", "_")
    return f"p_{safe_pkg}_{safe_ver}"


def main() -> None:
    variables: list[tuple[str, str, str]] = []
    for package, versions in REPOSITORY.items():
        for version in versions:
            variables.append((package, version, ident(package, version)))

    print("% Сгенерировано generate_dependencies_model.py")
    print("% Каждая bool-переменная означает выбор конкретной версии пакета.\n")

    for package, version, var in variables:
        print(f"var bool: {var}; % {package} {version}")

    print()

    # Не более одной версии каждого пакета.
    for package, versions in REPOSITORY.items():
        vars_for_package = [ident(package, v) for v in versions]
        expr = " + ".join(f"bool2int({v})" for v in vars_for_package)
        print(f"constraint {expr} <= 1;")

    # Корневой пакет фиксирован.
    print(f"constraint {ident(*ROOT)};")

    # Зависимости строятся автоматически из словаря.
    for package, versions in REPOSITORY.items():
        for version, dependencies in versions.items():
            source = ident(package, version)
            for dep_package, spec in dependencies.items():
                candidates = [
                    ident(dep_package, candidate_version)
                    for candidate_version in REPOSITORY[dep_package]
                    if satisfies(candidate_version, spec)
                ]
                if candidates:
                    rhs = " \\/ ".join(candidates)
                    print(
                        f"constraint {source} -> ({rhs}); "
                        f"% {package} {version} -> {dep_package} {spec}"
                    )
                else:
                    # Если подходящей версии нет, эта версия исходного пакета невозможна.
                    print(
                        f"constraint not {source}; "
                        f"% нет версии {dep_package}, удовлетворяющей {spec}"
                    )

    # Минимизируем число выбранных пакетов, чтобы solver не выбирал лишние версии.
    objective = " + ".join(f"bool2int({var})" for _, _, var in variables)
    print(f"\nsolve minimize {objective};\n")

    print("output [")
    for i, (package, version, var) in enumerate(variables):
        comma = "," if i + 1 < len(variables) else ""
        print(
            f'  if {var} then "{package} {version}\\n" else "" endif{comma}'
        )
    print("];")



if __name__ == "__main__":
    main()
