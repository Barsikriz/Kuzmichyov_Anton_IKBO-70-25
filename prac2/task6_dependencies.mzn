% Кодирование версий:
% 0  = пакет не выбран
% 10 = 1.0.0
% 11 = 1.1.0
% 20 = 2.0.0
var {10, 11}: foo;
var {0, 10}: left;
var {0, 10}: right;
var {0, 10, 20}: shared;
var {10, 20}: target;
constraint target = 20;
constraint (foo = 11) -> (left = 10 /\ right = 10);

constraint (foo = 10) -> (left = 0 /\ right = 0);
constraint (left = 10) -> (shared = 10 \/ shared = 20);
constraint (right = 10) -> (shared = 10);
constraint (shared = 10) -> (target = 10);

constraint (left = 0 /\ right = 0) -> (shared = 0);

solve satisfy;

output [
    "root 1.0.0\n",
    "foo ", if foo = 11 then "1.1.0" else "1.0.0" endif, "\n",
    if left = 10 then "left 1.0.0\n" else "" endif,
    if right = 10 then "right 1.0.0\n" else "" endif,
    if shared = 10 then "shared 1.0.0\n"
    elseif shared = 20 then "shared 2.0.0\n"
    else "" endif,
    "target ", if target = 20 then "2.0.0" else "1.0.0" endif, "\n"
];
