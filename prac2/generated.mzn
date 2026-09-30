% Сгенерировано generate_dependencies_model.py
% Каждая bool-переменная означает выбор конкретной версии пакета.

var bool: p_root_1_0_0; % root 1.0.0
var bool: p_foo_1_1_0; % foo 1.1.0
var bool: p_foo_1_0_0; % foo 1.0.0
var bool: p_left_1_0_0; % left 1.0.0
var bool: p_right_1_0_0; % right 1.0.0
var bool: p_shared_2_0_0; % shared 2.0.0
var bool: p_shared_1_0_0; % shared 1.0.0
var bool: p_target_2_0_0; % target 2.0.0
var bool: p_target_1_0_0; % target 1.0.0

constraint bool2int(p_root_1_0_0) <= 1;
constraint bool2int(p_foo_1_1_0) + bool2int(p_foo_1_0_0) <= 1;
constraint bool2int(p_left_1_0_0) <= 1;
constraint bool2int(p_right_1_0_0) <= 1;
constraint bool2int(p_shared_2_0_0) + bool2int(p_shared_1_0_0) <= 1;
constraint bool2int(p_target_2_0_0) + bool2int(p_target_1_0_0) <= 1;
constraint p_root_1_0_0;
constraint p_root_1_0_0 -> (p_foo_1_1_0 \/ p_foo_1_0_0); % root 1.0.0 -> foo ^1.0.0
constraint p_root_1_0_0 -> (p_target_2_0_0); % root 1.0.0 -> target ^2.0.0
constraint p_foo_1_1_0 -> (p_left_1_0_0); % foo 1.1.0 -> left ^1.0.0
constraint p_foo_1_1_0 -> (p_right_1_0_0); % foo 1.1.0 -> right ^1.0.0
constraint p_left_1_0_0 -> (p_shared_2_0_0 \/ p_shared_1_0_0); % left 1.0.0 -> shared >=1.0.0
constraint p_right_1_0_0 -> (p_shared_1_0_0); % right 1.0.0 -> shared <2.0.0
constraint p_shared_1_0_0 -> (p_target_1_0_0); % shared 1.0.0 -> target ^1.0.0

solve minimize bool2int(p_root_1_0_0) + bool2int(p_foo_1_1_0) + bool2int(p_foo_1_0_0) + bool2int(p_left_1_0_0) + bool2int(p_right_1_0_0) + bool2int(p_shared_2_0_0) + bool2int(p_shared_1_0_0) + bool2int(p_target_2_0_0) + bool2int(p_target_1_0_0);

output [
  if p_root_1_0_0 then "root 1.0.0\n" else "" endif,
  if p_foo_1_1_0 then "foo 1.1.0\n" else "" endif,
  if p_foo_1_0_0 then "foo 1.0.0\n" else "" endif,
  if p_left_1_0_0 then "left 1.0.0\n" else "" endif,
  if p_right_1_0_0 then "right 1.0.0\n" else "" endif,
  if p_shared_2_0_0 then "shared 2.0.0\n" else "" endif,
  if p_shared_1_0_0 then "shared 1.0.0\n" else "" endif,
  if p_target_2_0_0 then "target 2.0.0\n" else "" endif,
  if p_target_1_0_0 then "target 1.0.0\n" else "" endif
];
