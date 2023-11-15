%Assignment-2 INFO

clc,clf;

% code for setting up the environment, objects, and robots

h = surf([-2,-2;2,2] ...
,[2,2;2,2] ...
,[0 4; 0 4] ...
,'CData',imread('bedwall.jpg') ...
,'FaceColor','texturemap');


hold on;

h2 = surf([2,2;2,2] ...
,[2,2;-3,-3] ...
,[0 4; 0 4] ...
,'CData',imread('bookwall3.jpeg') ...
,'FaceColor','texturemap');


h3 = surf([-2,-2;2,2] ...
,[-3,2;-3,2] ...
,[0 0; 0 0] ...
,'CData',imread('lightwood.jpg') ...
,'FaceColor','texturemap');


dir = [1 0 0];
dir2 = [0 1 0];

rotate(h,dir2,90);

axis([-2 2 -3 2 0 4]); % Set x, y, and z-axis limits

% Set material properties to control the appearance of the objects
material([0.6 0.8 0.9 10 0.5]); % Ambient, Diffuse, Specular, Shininess, Strength

% Add additional light sources with increased brightness
light('Position', [0, 0, 5], 'Style', 'local', 'Color', [1 1 1]);
light('Position', [0, 0, -5], 'Style', 'local', 'Color', [1 1 1]);
lighting gouraud; % Use Gouraud shading for smooth appearance



table = PlaceObject('newtable2.ply',[-0.5,-1,0]);
shelf = PlaceObject('newshelf9.ply',[0.85,-2,0]);
button = PlaceObject('ebutton4.ply',[-1.2,-1.5,0.835]);
fire = PlaceObject('fireExtinguisher.ply',[1.2,-1.8,0]);
book = PlaceObject('book3.ply',[-0.5,-1.5,0.835]);

r = LinearUR3;
r2 = EC8;
% q = zeros(1,6);

% Move the robots to initial positions
r.model.base = r.model.base.T * transl(-1, 0.835, -0.4);
r.model.animate(r.model.getpos);
r2.model.base = r2.model.base.T * transl(-1.3, -0.5, 0.835)*trotz(pi);
r2.model.animate(r2.model.getpos);
% zlim([0 4]);

% pause to observe the initial robot positions and environment 
pause(2);


% Define the initial and final joint angles for the LinearUR3
q1 = zeros(1,8);
% q1 = r.model.qlim(:,1)';

T2 = transl(-0.5, -1.5, 0.845) * trotx(pi/2) * troty(pi/90) * trotz(pi/80);
q2 = r.model.ikcon(T2);

% Interpolate joint angles for movement - using trapezoidal velocity 
steps1 = 200;           % no. of steps in interpolation process
s1 = lspb(0, 1, steps1);             % generates trapezoidal velocity profile from 0 -> 1 through 200 steps
qMatrix = nan(steps1, 8);               % matrix of 200 rows and 8 columns of NaN. qMatrix will store the interpolated joint angles.
for i = 1:steps1
    qMatrix(i, :) = (1 - s1(i)) * q1 + s1(i) * q2;      % performs a linear interpolation between the joint angles q1 and q2
end

% Animate the LinearUR3 
for i = 1:length(qMatrix)
    r.model.animate(qMatrix(i,:));
    drawnow();
    pause(0.01);
end

% arm taking the book and moving it to new location
q3 = q2;
T3 = transl(0.8,0.3,0.8)*trotx(pi/20)*troty(pi)*trotz(pi/50);    %find a new pos                                                      
q4 = r.model.ikcon(T3); % try to add initial guess

step2 = 100;
s = lspb(0,1,step2);
qMatrix = nan(step2,8);
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
% T4 = transl(-0.2,-1.6,0.1)*trotx(pi/2)*troty(pi/90)*trotz(pi/2); 

% Compute joint positions for the new end-effector pose
% q5 = r.model.ikcon(T4, q4); % Use q4 as an initial guess for IK

q5 = zeros(1,8); % back to starting position 

% Interpolation for movement
steps = 100;
s = lspb(0, 1, steps);
qMatrix = nan(steps, 8);
for i = 1:steps
    qMatrix(i, :) = (1 - s(i)) * q4 + s(i) * q5;
end

% Animate the robot to the new position while keeping the book in place
for i = 1:length(qMatrix)
    r.model.animate(qMatrix(i, :));
    drawnow();
    pause(0);
end
