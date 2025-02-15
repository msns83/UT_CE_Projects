clc;
clear;
close all;

syms t s x(t) y(t)


x(t) = 5 * heaviside(t);
eq = diff(y, t, 2) + 3 * diff(y, t, 1) + 2 * y(t) == x(t);

first_condition = y(0) == 1;
second_condition = subs(diff(y, t), t, 0) == 1;

y(t) = dsolve(eq, first_condition, second_condition);

y(t) = subs(y(t), sign(t), 1);
y(t) = simplify(y(t));

disp(y(t));

fplot(y, [0, 10]);
