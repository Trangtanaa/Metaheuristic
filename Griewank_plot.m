clc; clear; close all;

% Khoảng giá trị của x và y
x = linspace(-10, 10, 100);
y = linspace(-10, 10, 100);

[X, Y] = meshgrid(x, y);

% Tính giá trị của hàm Griewank
Z = (X.^2 + Y.^2) / 4000 - cos(X) .* cos(Y / sqrt(2)) + 1;

% Vẽ đồ thị 3D
figure;
surf(X, Y, Z);
shading interp;
colormap jet;
colorbar;
xlabel('x');
ylabel('y');
zlabel('f(x, y)');
title('Griewank Function');

% Vẽ đường đồng mức (contour)
figure;
contourf(X, Y, Z, 20);
colormap jet;
colorbar;
xlabel('x');
ylabel('y');
title('Contour Plot of Griewank Function');
