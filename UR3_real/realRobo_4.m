% code for using the UR3 using joint angles to pick up a book and place it on a shelf

%% from starting to target
rosshutdown;

% Initialize ROS connection and subscriber
rosinit('192.168.27.1'); % Initialize ROS with the correct IP address

input('enter')

jointStateSubscriber = rossubscriber('joint_states','sensor_msgs/JointState');
pause(2); % Pause to allow time for a message to appear

[gripperPub, gripperMsg] = rospublisher('/onrobot_rg2/joint_position_controller/command');

% Define joint names
jointNames = {'shoulder_pan_joint', 'shoulder_lift_joint', 'elbow_joint', 'wrist_1_joint', 'wrist_2_joint', 'wrist_3_joint'};

targetJointPosition = deg2rad([-24.68 -71.84 120.14 -87.96 -32.3 124.96]); 

midjoint = deg2rad([-15.11 -66.48 120.16 -97.8 -22.9 128.27]);

nextJoint=deg2rad([90,-90,0,-90,0,0]);

% Create a goal to send to the robot
    [client, goal] = rosactionclient('/scaled_pos_joint_traj_controller/follow_joint_trajectory');
    goal.Trajectory.JointNames = jointNames;
    goal.Trajectory.Header.Seq = 1;
goal.Trajectory.Header.Stamp = rostime('Now','system'); % Set the timestamp to the current time
    goal.GoalTimeTolerance = rosduration(0.05);

    bufferSeconds = 1; % Buffer time for sending the message (adjust based on network latency)
    durationSeconds = 5; % Duration of the movement in seconds


% Set the joint angles for the initial and target positions
    startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
currentJointState = jointStateSubscriber.LatestMessage.Position;
currentJointState_321456 = [currentJointState(3:-1:1), currentJointState(4:6)];
startJointSend.Positions = currentJointState_123456;

    startJointSend.TimeFromStart = rosduration(0);

    endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
endJointSend.Positions = targetJointPosition;
endJointSend.TimeFromStart = rosduration(durationSeconds); % Duration of the movement

% Send the trajectory points to the robot
goal.Trajectory.Points = [startJointSend; endJointSend];

gripperMsg.Data = 0.5;   % -0.5 to 0.7
send(gripperPub,gripperMsg);

input('enter')


% Set the goal's timestamp to the latest joint state's timestamp plus buffer time
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds);

% Send the goal to the robot
sendGoal(client, goal);

%towards book 
input('enter')

pause(1)
goal.Trajectory.Header.Stamp = rostime('Now','system');

% currentJointState = jointStateSubscriber.LatestMessage.Position;
% currentJointState_321456 = [currentJointState(3:-1:1), currentJointState(4:6)];

startJointSend.Positions = targetJointPosition;

endJointSend.Positions = midjoint;

endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend];


input('enter')

% Set the goal's timestamp to the latest joint state's timestamp plus buffer time
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds);

% Send the goal to the robot
sendGoal(client, goal);


%from down to up 
input('enter')
pause(1)
goal.Trajectory.Header.Stamp = rostime('Now','system');

% currentJointState = jointStateSubscriber.LatestMessage.Position;
% currentJointState_321456 = [currentJointState(3:-1:1), currentJointState(4:6)];

startJointSend.Positions = midjoint;

endJointSend.Positions = nextJoint;

endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend];


gripperMsg.Data = 0.7;   % -0.5 to 0.7
send(gripperPub,gripperMsg);


input('enter')
% Set the goal's timestamp to the latest joint state's timestamp plus buffer time
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds);

% Send the goal to the robot
sendGoal(client, goal);
