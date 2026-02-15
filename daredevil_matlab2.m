function daredevil_matlab2()
    % ---------------- CONFIGURATION ----------------
    % Simulation Arena
    arenaSize = 400; % 400cm x 400cm
    numObstacles = 50;
    
    % Sensor Settings (matching your hardware)
    maxSensorRange = 200; % cm
    
    
    % Logic Thresholds (Direct copy from your C++ code)
    thresh_Far = 120;
    thresh_Med = 80;
    thresh_Near = 50;
    thresh_Crit = 25;
    
    % ---------------- INITIALIZATION ----------------
    f = figure('Name', 'Smart Cap Simulator', 'Color', 'w', ...
        'NumberTitle', 'off', 'WindowStyle', 'normal');
    axis([0 arenaSize 0 arenaSize]);
    hold on; grid on;
    xlabel('Distance (cm)'); ylabel('Distance (cm)');
    title('Move Mouse to Control the Smart Cap');
    
    % Generate Random Obstacles
    obsX = rand(1, numObstacles) * arenaSize;
    obsY = rand(1, numObstacles) * arenaSize;
    plot(obsX, obsY, 'k.', 'MarkerSize', 15); % Draw obstacles
    
    % Graphic Handles
    hCap = patch('Vertices', [0 0; -10 -20; 10 -20], 'Faces', [1 2 3], 'FaceColor', 'b');
    hRayF = plot([0 0], [0 0], 'g-', 'LineWidth', 1.5);
    hRayL = plot([0 0], [0 0], 'g-', 'LineWidth', 1.5);
    hRayR = plot([0 0], [0 0], 'g-', 'LineWidth', 1.5);
    
    % Motor Indicators (Visual Haptics)
    % [Left, Front, Right]
    hMotL = rectangle('Position', [10, 10, 30, 30], 'Curvature', 1, 'FaceColor', [0.8 0.8 0.8]);
    hMotF = rectangle('Position', [50, 10, 30, 30], 'Curvature', 1, 'FaceColor', [0.8 0.8 0.8]);
    hMotR = rectangle('Position', [90, 10, 30, 30], 'Curvature', 1, 'FaceColor', [0.8 0.8 0.8]);
    
    text(15, 25, 'L', 'Color', 'k');
    text(55, 25, 'F', 'Color', 'k');
    text(95, 25, 'R', 'Color', 'k');
    
    % State Variables
    capPos = [arenaSize/2, arenaSize/2];
    lastPulse = tic;
    motorState = false;
    
    % ---------------- MAIN LOOP ----------------
    while ishandle(f)
        % 1. Get Mouse Position (Target)
        try
            pt = get(gca, 'CurrentPoint');
            targetPos = pt(1, 1:2);
        catch
            break; 
        end
        
        % Move Cap towards mouse (Smoothing)
        diff = targetPos - capPos;
        distToMouse = norm(diff);
        if distToMouse > 5
            dir = diff / distToMouse;
            capPos = capPos + dir * 5; % Speed
        end
        
        % Calculate Heading (Rotation)
        heading = atan2(diff(2), diff(1));
        
        % 2. SENSOR SIMULATION (Ray Casting)
        % Angles: Front (0), Left (+45 deg), Right (-45 deg)
        [dF, pF] = castRay(capPos, heading, 0, obsX, obsY, maxSensorRange);
        [dL, pL] = castRay(capPos, heading, pi/4, obsX, obsY, maxSensorRange);
        [dR, pR] = castRay(capPos, heading, -pi/4, obsX, obsY, maxSensorRange);
        
        % Update Visuals
        updateCapGraphic(hCap, capPos, heading);
        updateRay(hRayF, capPos, pF, dF < thresh_Far);
        updateRay(hRayL, capPos, pL, dL < thresh_Far);
        updateRay(hRayR, capPos, pR, dR < thresh_Far);
        
        % 3. LOGIC CONTROLLER (Exact C++ Logic)
        minDist = min([dF, dL, dR]);
        activeMotor = 0; % 0=None, 1=Left, 2=Front, 3=Right
        interval = -1;
        
        if minDist < thresh_Far
            % Determine Interval (Pulse Speed)
            if minDist > thresh_Med
                interval = 0.8; % 800ms
            elseif minDist > thresh_Near
                interval = 0.4; % 400ms
            elseif minDist > thresh_Crit
                interval = 0.15; % 150ms
            else
                interval = 0;   % Constant On
            end
            
            % Determine Which Motor
            if minDist == dL
                activeMotor = 1;
            elseif minDist == dF
                activeMotor = 2;
            else
                activeMotor = 3;
            end
        end
        
        % 4. MOTOR ACTUATION (Non-blocking Timer)
        currentTime = toc(lastPulse);
        
        % Reset all motors visually first
        set(hMotL, 'FaceColor', [0.8 0.8 0.8]);
        set(hMotF, 'FaceColor', [0.8 0.8 0.8]);
        set(hMotR, 'FaceColor', [0.8 0.8 0.8]);
        
        if activeMotor > 0
            isOn = false;
            
            if interval == 0
                isOn = true; % Constant vibration
            else
                % Toggle logic
                if currentTime >= interval
                    motorState = ~motorState;
                    lastPulse = tic; % Reset timer
                end
                isOn = motorState;
            end
            
            % If the "Vibration" is currently active, color the motor RED
            if isOn
                color = [1 0 0]; % RED = VIBRATING
                if activeMotor == 1, set(hMotL, 'FaceColor', color); end
                if activeMotor == 2, set(hMotF, 'FaceColor', color); end
                if activeMotor == 3, set(hMotR, 'FaceColor', color); end
            end
        else
             motorState = false; % Reset state if no obstacle
        end
        
        drawnow limitrate;
    end
end

% ---------------- HELPER FUNCTIONS ----------------

function [dist, hitPoint] = castRay(pos, heading, offsetAngle, obsX, obsY, maxRange)
    rayAngle = heading + offsetAngle;
    
    % Default: Ray hits max range (no obstacle)
    hitPoint = pos + [cos(rayAngle), sin(rayAngle)] * maxRange;
    dist = maxRange;
    
    % Simple Euclidean distance check to all points (Simulating sensor echo)
    % In real life, this is time-of-flight. Here, it's geometry.
    dx = obsX - pos(1);
    dy = obsY - pos(2);
    
    % Rotate obstacles into sensor frame to check "Field of View"
    % This ensures the sensor only sees things in front of it, not behind.
    localX = dx * cos(rayAngle) + dy * sin(rayAngle);
    localY = -dx * sin(rayAngle) + dy * cos(rayAngle);
    
    % Check constraints:
    % 1. Must be in front (localX > 0)
    % 2. Must be within narrow beam width (abs(localY) < width)
    % 3. Must be closest one
    validIdx = find(localX > 0 & localX < maxRange & abs(localY) < 15);
    
    if ~isempty(validIdx)
        [minD, idx] = min(sqrt(dx(validIdx).^2 + dy(validIdx).^2));
        realIdx = validIdx(idx);
        dist = minD;
        hitPoint = [obsX(realIdx), obsY(realIdx)];
    end
end

function updateCapGraphic(h, pos, theta)
    % Rotate triangle vertices
    R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    v = [0 0; -10 -20; 10 -20] * 1.5; % Scale up slightly
    vRot = (R * v')';
    set(h, 'Vertices', vRot + pos);
end

function updateRay(h, startPos, endPos, isHit)
    set(h, 'XData', [startPos(1), endPos(1)], 'YData', [startPos(2), endPos(2)]);
    if isHit
        set(h, 'Color', 'r', 'LineWidth', 2);
    else
        set(h, 'Color', 'g', 'LineWidth', 1);
    end
end