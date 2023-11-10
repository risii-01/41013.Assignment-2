%%
clc,clf;
r = LinearUR3;
% q1 = [pi/90,-pi/2,pi/90,0,0,0, 0];

% r.model.animate(q1);
view(3);
axis equal;
camlight;
% 
hold on
book = PlaceObject('book3.ply',[-0.1,-0.5,0.01]);
q1 = r.model.qlim(:,1)';
% q1 = zeros(1,7);
% % q2 = r.model.qlim(:,2)';
T2 = transl(-0.2,-0.4,0.06)*trotx(pi/2)*troty(pi/90)*trotz(pi/40);                                             % Define a translation matrix            
q2 = r.model.ikcon(T2);
% qPath = jtraj(q1,q2,200);
% 
% for i = 1:length(qPath)
%     r.model.animate(qPath(i,:));
%     drawnow();
%     pause(0)
% end


% q3 = q2;
% % q2 = r.model.qlim(:,2)' 
% T3 = transl(0.4,0.4,0)*trotx(pi/20)*troty(pi/2)*trotz(pi/50);    %find a new pos                                               % Define a translation matrix            
% q4 = r.model.ikcon(T3); % try to add initial guess
% % q4 = r.model.ikcon(T3, 'q0', q3) % try to add initial guess
% qPath = jtraj(q3,q4,50);
% 
% for i = 1:length(qPath)
%     try 
%         delete(brick1_h)
%     end
%     tr = r.model.fkine(qPath(i,:)).T;
%     brick1_h = PlaceObject('book3.ply', tr(1:3,4)');
% 
%     r.model.animate(qPath(i,:));
%     drawnow();
%     pause(0)
% end

steps = 200;   
% 
% 
% 
s = lspb(0,1,steps);
qMatrix = nan(steps,7);
for i = 1:steps
   qMatrix(i,:) = (1-s(i))*q1 + s(i)*q2;
end

for i = 1:length(qMatrix)
    r.model.animate(qMatrix(i,:));
    drawnow();
    pause(0)
end

% Collision checking and animation
for i = 1:length(qMatrix)
    currentQ = qMatrix(i, :);
    
    % Perform collision checking
    if ~checkCollision(currentQ, r.model) % Implement checkCollision function
        % If there is no collision, animate the robot
        r.model.animate(currentQ);
        drawnow();
        pause(0);
    else
        % If there is a collision, handle it (e.g., adjust the trajectory)
        disp('Collision detected! Adjusting trajectory...');
        % Implement collision resolution logic here
    end
end


q3 = q2;
T3 = transl(0.8,0.6,0)*trotx(pi/20)*troty(pi)*trotz(pi/50);    %find a new pos                                               % Define a translation matrix            
q4 = r.model.ikcon(T3); % try to add initial guess

step2 = 100;
s = lspb(0,1,step2);
qMatrix = nan(step2,7);
for i = 1:step2
   qMatrix(i,:) = (1-s(i))*q3 + s(i)*q4;
end

for i = 1:length(qMatrix)
    try 
        delete(book)
    end
    tr = r.model.fkine(qMatrix(i,:)).T;
    book = PlaceObject('book3.ply', tr(1:3,4)');

    r.model.animate(qMatrix(i,:));
    drawnow();
    pause(0)
end

% Calculate new end-effector pose for the next position
T4 = transl(-0.2,-0.4,0.06)*trotx(pi/2)*troty(pi/90)*trotz(pi/40); 

% Compute joint positions for the new end-effector pose
q5 = r.model.ikcon(T4, q4); % Use q4 as an initial guess for IK

% Interpolation for movement
steps = 100;
s = lspb(0, 1, steps);
qMatrix = nan(steps, 7);
for i = 1:steps
    qMatrix(i, :) = (1 - s(i)) * q4 + s(i) * q5;
end

% Animate the robot to the new position while keeping the book in place
for i = 1:length(qMatrix)
    r.model.animate(qMatrix(i, :));
    % Update book position if necessary (assuming PlaceObject updates the book)
    % PlaceObject('book3.ply', tr(1:3, 4)');
    drawnow();
    pause(0);
end
