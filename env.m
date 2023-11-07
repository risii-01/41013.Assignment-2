clc,clf;

hold on;

% workspace = [-2 2 -3 2 0 4];                                       
% scale = 0.5;        
% % q = zeros(1,3);                                                  
% q = [0 0 0 0 0 0];

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

table = PlaceObject('newtable2.ply',[-0.5,-1,0.1]);
shelf = PlaceObject('newshelf9.ply',[1.2,-1.2,0.1]);
button = PlaceObject('ebutton4.ply',[-1.2,-1.5,0.935]);
fire = PlaceObject('fireExtinguisher.ply',[1.2,-1.8,0.1]);


xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
