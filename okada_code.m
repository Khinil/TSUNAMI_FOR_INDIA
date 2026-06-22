clc;
clear;
close all;

%% ============================================================
%  SCENARIO 1 : MAKRAN TSUNAMI SOURCE
%  Mw = 8.1
%% ============================================================

% ------------------------------------------------------------
% FAULT PARAMETERS
% ------------------------------------------------------------

Mw      = 8.1;

depth   = 15;          % km
strike  = 246;         % degrees
dip     = 7;          % degrees
rake    = 90;          % reverse fault

L       = 200;     % km
W       = 100;      % km

slip    = 7;       % m
open    = 0;           % tensile opening

%% ============================================================
% COMPUTATIONAL DOMAIN
%% ============================================================

xmin = -500;
xmax = 500;

ymin = -500;
ymax = 500;

dx = 5;

[E,N] = meshgrid(xmin:dx:xmax,...
                 ymin:dx:ymax);

%% ============================================================
% RUN OKADA MODEL
%% ============================================================

[uE,uN,uZ] = okada85_modified( ...
    E,...
    N,...
    depth,...
    strike,...
    dip,...
    L,...
    W,...
    rake,...
    slip,...
    open);

%% ============================================================
% MAXIMUM DEFORMATION
%% ============================================================

max_uplift = max(uZ(:));
max_subsidence = min(uZ(:));

fprintf('\n');
fprintf('Mw = %.1f\n',Mw);
fprintf('Maximum uplift     = %.3f m\n',max_uplift);
fprintf('Maximum subsidence = %.3f m\n',max_subsidence);

%% ============================================================
% PLOT VERTICAL DEFORMATION
%% ============================================================

figure;

surf(E,N,uZ,...
    'EdgeColor','none');

view(2);

axis equal tight;

colorbar;

xlabel('East (km)');
ylabel('North (km)');

title('Vertical Seafloor Deformation');

colormap(jet);

%% ============================================================
% 3D VIEW
%% ============================================================

figure;

surf(E,N,uZ);

shading interp;

xlabel('East (km)');
ylabel('North (km)');
zlabel('Displacement (m)');

title('3D Seafloor Deformation');

colorbar;

view(45,30);

%% ============================================================
% CONTOUR MAP
%% ============================================================

figure;

contourf(E,N,uZ,30,...
    'LineColor','none');

axis equal;

colorbar;

xlabel('East (km)');
ylabel('North (km)');

title('Initial Tsunami Surface');

%% ============================================================
% SAVE RESULTS
%% ============================================================

X = E(:);
Y = N(:);
Z = uZ(:);

Result = table(X,Y,Z);

writetable(Result,...
    'Scenario1_Mw81_Deformation.csv');

disp('CSV file saved.');