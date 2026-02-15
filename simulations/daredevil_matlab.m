clc;
clear;
close all;

% ---------------- SETUP ----------------
% "Tactical HUD" Dark Theme
f = figure('Name', 'Daredevil: Tactical Awareness System', 'Color', [0.05 0.05 0.05], ...
    'Units', 'normalized', 'Position', [0.05 0.05 0.9 0.85]);

% Layout
t = tiledlayout(2, 3, 'Padding', 'compact', 'TileSpacing', 'loose');
title(t, 'PROJECT DAREDEVIL: TACTICAL & ASSISTIVE NAVIGATION', ...
    'Color', [0 1 0], 'FontSize', 22, 'FontName', 'FixedWidth', 'FontWeight', 'bold');

% Helper for "Heads-Up Display" styling
hud_style = @(ax) set(ax, 'Color', [0.1 0.1 0.1], 'XColor', [0 0.8 0], ...
    'YColor', [0 0.8 0], 'GridColor', [0 1 0], 'GridAlpha', 0.15, 'LineWidth', 1.2, ...
    'FontName', 'FixedWidth', 'Box', 'on');

%% =================================================
% PLOT 1: SILENT HAPTIC COMM (Stealth Mode)
% Pitch: "Silent communication for stealth ops or blind users."
% =================================================
nexttile
hold on;
t_sig = linspace(0, 6, 500);
y_sig = zeros(size(t_sig));

% Logic: Safe -> Warning (Pulse) -> Danger (Solid)
% 2-4s: Pulse
mask_warn = (t_sig>=2 & t_sig<4);
y_sig(mask_warn) = 0.5 * (square(2*pi*4*(t_sig(mask_warn))) + 1)/2; 
% 4s+: Solid
y_sig(t_sig>=4) = 1.0;                                                

area(t_sig, y_sig, 'FaceColor', [0 1 0], 'FaceAlpha', 0.3, 'EdgeColor', [0 1 0]);

xline(2, '--g', 'Target Acquired (120cm)');
xline(4, '--r', 'Proximity Breach (50cm)');

text(1, 0.5, 'NO SIG', 'Color', [0.5 0.5 0.5], 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth');
text(3, 0.8, {'STEALTH', 'PULSE'}, 'Color', [0 1 0], 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth', 'FontWeight', 'bold');
text(5, 0.8, {'COLLISION', 'LOCK'}, 'Color', [1 0.2 0.2], 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth', 'FontWeight', 'bold');

title('1. HAPTIC FEEDBACK (SILENT OPS)', 'Color', 'w', 'FontName', 'FixedWidth');
ylabel('Motor Actuation', 'Color', 'g');
xlabel('Time (s)', 'Color', 'g');
ylim([-0.1 1.2]);
hud_style(gca);

%% =================================================
% PLOT 2: PERIMETER COVERAGE (No Blind Spots)
% Pitch: "Full 180-degree protection for patrolling."
% =================================================
nexttile
hold on;
% Draw Operator
plot(0, 0, 'go', 'MarkerSize', 10, 'LineWidth', 2);
text(0, -15, 'OPERATOR', 'Color', 'w', 'HorizontalAlignment', 'center', 'FontSize', 8, 'FontName', 'FixedWidth');

% Draw Overlapping Scan Sectors
draw_sector = @(angle, color) fill([0, 120*cosd(angle-30), 120*cosd(angle+30)], ...
    [0, 120*sind(angle-30), 120*sind(angle+30)], color, 'FaceAlpha', 0.2, 'EdgeColor', color, 'LineStyle', '-');

draw_sector(45, 'c');   % Left Sector
draw_sector(0, 'g');    % Front Sector
draw_sector(-45, 'y');  % Right Sector

title('2. FIELD OF VIEW', 'Color', 'w', 'FontName', 'FixedWidth');
axis equal; xlim([-100 130]); ylim([-50 130]);
axis off; % Clean Look

%% =================================================
% PLOT 3: ENVIRONMENTAL FILTERING (Rain/Dust)
% Pitch: "Works in rain, fog, and dust where cameras fail."
% =================================================
nexttile
hold on;
x = 1:60;
clean_path = 150 * ones(size(x)); 
% Simulate "Rain/Dust" noise spikes
noise = randn(1, 60) * 10; 
noise([10, 25, 40, 55]) = [-100, -120, -90, -110]; % False "Close" readings (Rain drops)
raw_signal = clean_path + noise;
filtered_signal = medfilt1(raw_signal, 5); % Heavy filtering

plot(x, raw_signal, 'r-', 'LineWidth', 0.5); 
plot(x, filtered_signal, 'g-', 'LineWidth', 2.5);

legend({'Env. Noise (Rain/Dust)', 'Tactical Filter'}, 'Location', 'southwest', ...
    'Color', 'none', 'TextColor', 'w', 'Box', 'off');
title('3. SIGNAL INTEGRITY (ANTI-JAMMING)', 'Color', 'w', 'FontName', 'FixedWidth');
ylabel('Range (cm)', 'Color', 'g');
hud_style(gca);

%% =================================================
% PLOT 4: TACTICAL REACTION WINDOW
% Pitch: "Ensures soldiers stop before contact."
% =================================================
nexttile
hold on;
dist = 0:150;
march_speed = 120; % cm/s (Brisk patrol pace)
time_to_contact = dist / march_speed;

% Zones
fill([0, 80, 80, 0], [0, 0, 1.5, 1.5], 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
fill([80, 150, 150, 80], [0, 0, 1.5, 1.5], 'g', 'FaceAlpha', 0.1, 'EdgeColor', 'none');

plot(dist, time_to_contact, 'w-', 'LineWidth', 2);
yline(0.5, '--y', 'Human Reaction (0.5s)', 'LabelHorizontalAlignment', 'left');
xline(80, '--r', 'CRITICAL STOP DISTANCE');

text(40, 1.0, {'CONTACT', 'INEVITABLE'}, 'Color', 'r', 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth');
text(115, 1.0, {'SAFE', 'MANEUVER'}, 'Color', 'g', 'HorizontalAlignment', 'center', 'FontName', 'FixedWidth');

title('4. SAFETY & REACTION PHYSICS', 'Color', 'w', 'FontName', 'FixedWidth');
xlabel('Detection Range (cm)', 'Color', 'g');
ylabel('Time to Contact (s)', 'Color', 'g');
hud_style(gca);

%% =================================================
% PLOT 5: MISSION RUNTIME (Battery)
% Pitch: "Long-lasting for extended patrols."
% =================================================
nexttile
hold on;
% Battery drain curve
hours = 0:5;
capacity = 100 - (hours * 20); % Efficient drain
plot(hours, capacity, 'c-', 'LineWidth', 2);
yline(20, '--r', 'Low Batt Warning');

area(hours, capacity, 'FaceColor', 'c', 'FaceAlpha', 0.1);

text(2, 40, {'4-5 HOUR', 'OPERATION'}, 'Color', 'w', 'FontWeight', 'bold', 'FontName', 'FixedWidth');

title('5. MISSION ENDURANCE', 'Color', 'w', 'FontName', 'FixedWidth');
xlabel('Patrol Time (Hours)', 'Color', 'g');
ylabel('Battery (%)', 'Color', 'g');
ylim([0 100]);
hud_style(gca);

%% =================================================
% PLOT 6: SITUATIONAL AWARENESS HUD
% Pitch: "What the system 'sees' in real-time."
% =================================================
nexttile
hold on;
% Radar Rings
theta = linspace(0, 2*pi, 100);
for r = [40, 80, 120]
    plot(r*cos(theta), r*sin(theta), 'Color', [0 0.4 0]);
end
% Crosshairs
plot([-130 130], [0 0], 'Color', [0 0.4 0]);
plot([0 0], [-130 130], 'Color', [0 0.4 0]);

% Targets
% Target 1: Close Left (Danger)
plot(-30, 40, 'rs', 'MarkerSize', 12, 'LineWidth', 2); 
text(-40, 55, 'OBS_01 (40cm)', 'Color', 'r', 'FontSize', 8, 'FontName', 'FixedWidth');

% Target 2: Far Right (Warning)
plot(60, 90, 'ys', 'MarkerSize', 8, 'LineWidth', 2);
text(65, 105, 'OBS_02 (100cm)', 'Color', 'y', 'FontSize', 8, 'FontName', 'FixedWidth');

title('6. LIVE TACTICAL DISPLAY', 'Color', 'w', 'FontName', 'FixedWidth');
axis equal; axis off;