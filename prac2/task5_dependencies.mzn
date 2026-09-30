% Задача 5. Зависимости пакетов по схеме PubGrub.
%
% Кодирование версий:
% menu:     10=1.0.0, 11=1.1.0, ..., 15=1.5.0
% dropdown: 18=1.8.0, 20=2.0.0, ..., 23=2.3.0
% icons:    10=1.0.0, 20=2.0.0
var {10, 11, 12, 13, 14, 15}: menu;
var {18, 20, 21, 22, 23}: dropdown;
var {10, 20}: icons;
constraint icons = 10;
constraint (menu >= 11) -> (dropdown >= 20);
constraint (menu = 10) -> (dropdown = 18);
constraint (dropdown >= 20) -> (icons = 20);

solve satisfy;

output [
    "root\n",
    "menu ",
    if menu = 15 then "1.5.0"
    elseif menu = 14 then "1.4.0"
    elseif menu = 13 then "1.3.0"
    elseif menu = 12 then "1.2.0"
    elseif menu = 11 then "1.1.0"
    else "1.0.0" endif,
    "\n",
    "dropdown ",
    if dropdown = 23 then "2.3.0"
    elseif dropdown = 22 then "2.2.0"
    elseif dropdown = 21 then "2.1.0"
    elseif dropdown = 20 then "2.0.0"
    else "1.8.0" endif,
    "\n",
    "icons ", if icons = 20 then "2.0.0" else "1.0.0" endif, "\n"
];
