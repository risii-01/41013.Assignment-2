%% This is just a practice code from Lab Assignment 1 to help us understand and get things running

r = LinearUR3;

%% pick up brick
hold on
brick1_h = PlaceObject('HalfSizedRedGreenBrick.ply',[-0.5,-0.42,0.1]);
q1 = r.model.qlim(:,1)'
% q2 = r.model.qlim(:,2)' 
T2 = transl(-0.5,-0.42,0.1);                                                   % Define a translation matrix            
q2 = r.model.ikine(T2)
qPath = jtraj(q1,q2,200);

for i = 1:length(qPath)
    r.model.animate(qPath(i,:));
    drawnow();
    pause(0)
end


%% go to drop off from brick pick up
q3 = q2;
% q2 = r.model.qlim(:,2)' 
T3 = transl(0.3,0.3,0.1)*trotx(pi/2);    %find a new pos                                               % Define a translation matrix            
q4 = r.model.ikcon(T3)     % try to add initial guess
% q4 = r.model.ikcon(T3, 'q0', q3)     % try to add initial guess
qPath = jtraj(q3,q4,50);

for i = 1:length(qPath)
    try 
        delete(brick1_h)
    end
    tr = r.model.fkine(qPath(i,:)).T;
    brick1_h = PlaceObject('HalfSizedRedGreenBrick.ply', tr(1:3,4)');

    r.model.animate(qPath(i,:));
    drawnow();
    pause(0)
end

for i = 1:size(bricks,3)

    t1 = bricks(:,:,i)

end

%r.model.base = transl(0.1,0.1,0)* trotx(pi/2)
