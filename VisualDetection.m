 
%% Create dialog box to fill in subject's details
 
 namecheck = 0;
while ~ namecheck
    question1 = {'Please fill in your subject number', 'Please fill in session number', 'Please fill in your age'};
    dialogtitle = 'Participant Information';
    boxsize = [1 58];

    BoxAnswer = inputdlg(question1,dialogtitle,boxsize);
 
    SubjectNumber = BoxAnswer{1};  % Converting subject number, session and age into strings
    SubjectNumber = str2double(SubjectNumber); % Converting subject number, session and age into numerical
    SessionNo = BoxAnswer{2};
    SessionNo = str2double(SessionNo);
    SubjectAge = BoxAnswer{3};
    SubjectAge = str2double(SubjectAge);
    
    % Show an error in case dialogue inputs are not numbers
    if isnan(SubjectNumber) || isnan(SessionNo) || isnan(SubjectAge)   
    Errorname = warndlg(sprintf('Invalid input, please fill answers using numbers'), 'Error', 'modal');
    uiwait(Errorname);
    else 
    namecheck = 1;
    end
end


%% Setup for screen presentation

AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 1);
screens = Screen('Screens');
screenNumber = max(screens);
spacebar1=0;
spacebar2=0;
Priority(1);
HideCursor;

% Set up black and white
white0 = WhiteIndex(screenNumber);  
black = BlackIndex(screenNumber);

% Change the colour of the screen to black
[window, windowRect] = Screen('OpenWindow', screenNumber, black); 

%% Programme constants that will stay fixed

FlipInterval = Screen('GetFlipInterval', window); % Get the timing of 1 refresh rate of the screen
TargetTime = FlipInterval .* 1 ;  % Timing of the stimulus
MaskTime = FlipInterval .* 3;  % Timing of the mask

% Number of trials
Trials = 15; 

% Set up a vector of stimulus-onset-asynchrony timings between presentation of target and mask
SOAS = [FlipInterval.*1 FlipInterval.*2 FlipInterval.*3]; 

PositionResponse = zeros(Trials,1); % Creating a vector to store participant's responses
PositionTarget = zeros(Trials,1);  % Creating a vector to store actual target positions
SOA = zeros(Trials,1); % Creating a vector to store SOA

% Assigning variables to choice keys
LeftArrow = KbName('left');   
RightArrow = KbName('right');  
DownArrow = KbName('down');

% Constant to be used to name the output data file
fileending = '_visualdetection.xlsx'; 

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window); 

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect); 

 
% Setup for size and position of squares used for stimulus and mask

% Size of squares
StimWidth = 0.035 .*sqrt(screenXpixels .* screenYpixels); 

% Assigning white colour to all mask squares
white = [255 255 255]; 

% Assigning a dim green colour for the targets as used in the original paradigm (note that original RGB values are unknown)
green = [21 40 22]; 
                 

% Create coordinates for a square
% Square position (east)
M1Rect = [0 0 StimWidth StimWidth]; 
M1Rect = CenterRectOnPointd(M1Rect, screenXpixels * 0.35, screenYpixels * 0.5); 

% Square position (north)
M2Rect = [0 0 StimWidth StimWidth]; 
M2Rect = CenterRectOnPointd(M2Rect, screenXpixels * 0.5, screenYpixels * 0.24); 

% Square position (south)
M3Rect = [0 0 StimWidth StimWidth];
M3Rect = CenterRectOnPointd(M3Rect, screenXpixels * 0.5, screenYpixels * 0.76); 

% Square position (west)
M4Rect = [0 0 StimWidth StimWidth]; 
M4Rect = CenterRectOnPointd(M4Rect, screenXpixels * 0.65, screenYpixels * 0.5); 

% Square position (north-east)
M5Rect = [0 0 StimWidth StimWidth]; 
M5Rect = CenterRectOnPointd(M5Rect, screenXpixels * 0.39, screenYpixels * 0.32); 

% Square position (north-west)
M6Rect = [0 0 StimWidth StimWidth];
M6Rect = CenterRectOnPointd(M6Rect, screenXpixels * 0.61, screenYpixels * 0.32); 

% Square position (south-east)
M7Rect = [0 0 StimWidth StimWidth]; 
M7Rect = CenterRectOnPointd(M7Rect, screenXpixels * 0.39, screenYpixels * 0.68); 

% Square position (south-west)
M8Rect = [0 0 StimWidth StimWidth]; 
M8Rect = CenterRectOnPointd(M8Rect, screenXpixels * 0.61, screenYpixels * 0.68); 

% Grouping the mask squares in one matrix
Mask = [M1Rect; M2Rect; M3Rect; M4Rect; M5Rect; M6Rect; M7Rect; M8Rect]; 

% Creating a matrix variable for the stimulus' coordinates
Stimulus = [M5Rect; M7Rect; M6Rect; M8Rect]; 

%% Creating random order
rng('shuffle');

% Creating two vectors for the left targets
Left1 = ones(1,floor(Trials./5));   
Left2 = ones(1,floor(Trials./5)) .* 2; 
% Creating two vectors for the right targets
Right1 = ones(1,floor(Trials./5)) .* 3; 
Right2 = ones(1,floor(Trials./5)) .* 4;
% Creating a vector for no-target trials
NoInvalid = ones(1, Trials-(length(Left1)+length(Left2)+length(Right1)+length(Right2))).*5; 

% Combining all vectors in a variable called RandOrder which has the length of all trials and then randomising it
RandOrder = [Left1 Left2 Right1 Right2 NoInvalid]; 
RandOrder = RandOrder(randperm(length(RandOrder)));  

% Same as the targets, but now for the stimulus-onset-asynchrony (blank screen between target/no-target and mask)
soa1 = ones(1,ceil(Trials./3));  
soa2 = ones(1,ceil(Trials./3)).*2;
soa3 = ones(1, Trials-(length(soa1)+length(soa2))).*3;

RandSoas = [soa1 soa2 soa3];
RandSoas = RandSoas(randperm(length(RandSoas)));

%% instructions screen

Screen('TextSize',window,17);
DrawFormattedText(window, 'In this experiment, a green target will be presented on the left or right side of the screen \n followed by a circle of white squares. Indicate the position of the target by pressing one of the following keys:', 'center', screenYpixels .* 0.37, white,0,0,0,2);
Screen('TextSize',window,17);
DrawFormattedText(window, 'Left side = left arrow, Right side = right arrow, No target = down arrow' , 'center', 'center', white );
Screen('TextSize',window,10);
DrawFormattedText(window, 'Press the spacebar to continue', 'center', screenYpixels .* 0.75, white );
Screen('Flip',window);
 
% Press the space key to proceed to the experiment
 while ~ spacebar1  
    [~,~,space] = KbCheck(-1);
    key = find(space == 1);
    if key == 32
      spacebar1 = 1; 
    end
 end
 
%% Main programme loop

for i = 1:Trials
    
    % Draw a fixation cross for 800ms before stimulus presents
    Screen('TextSize',window,40);  
    DrawFormattedText(window, '+', 'center', 'center', white);
    Screen('Flip',window);
    WaitSecs(0.8);
    
    % Present the target
    if RandOrder(i) < 5
        
        T1 = GetSecs();
        T2 = GetSecs()+TargetTime;
        
        while T1<T2  % As long as T2 in larger than T1, while loop will execute
            Screen('FillRect',window,green,Stimulus(RandOrder(i),:)); %Paint the square on 
            T1=Screen('Flip',window);    %the screen in one of target positions in a random order
        end
        
    else
        Screen('Flip',window);
        WaitSecs(TargetTime);
        
    end
    
    
    % Present blank screen between target and mask for random and varying times according to the SOAS
    if RandSoas(i) < 4 
        
       T1 = GetSecs();
       T2 = GetSecs()+ SOAS(:,RandSoas(i)); % Note that the actual SOA timing is equal to the randomly assigned SOA plus the time it takes matlab to process the lines within the loop
    
       while T1<T2 
            T1 = Screen('Flip',window);  
       end       
    
    else 
        Screen('Flip',window);
        WaitSecs(TargetTime);
    end
    
        T1 = GetSecs();
        T2 = GetSecs()+ MaskTime;

   % Present the Mask
   while T1<T2 
        Screen('FillRect',window,white,Mask'); 
        T1=Screen('Flip',window); 
   end
   
   if RandSoas(i) == 1
        soa = SOAS(1);
   elseif RandSoas(i) == 2
        soa = SOAS(2);
   else
        soa = SOAS(3);
   end

   SOA(i) = soa; % Record the stimulus onset asynchrony for each trial into the variable soa 
   %(I put this set of code here, instead of putting it with the rest of the 'recording variables', because it didn't record the actual SOA)
   
   % Instructions for participants to make a response
   Screen('TextSize',window,20);  
   DrawFormattedText(window, 'Left target = Left arrow, Right target = Right arrow, No target = Down arrow', 'center', 'center', white );
   Screen('Flip',window);
   
   
   % Wait for keyboard response and assign desired keys to responses
   bs=0;
   
   while ~ bs  
    [~,~,space] = KbCheck(-1);
    key = find(space == 1);
    
        if key == LeftArrow
            Response = 1; 
            bs = 1;
        elseif key == RightArrow
            Response = 2;
            bs = 1;
        elseif key == DownArrow
            Response = 3;
            bs = 1;
        else 
            bs = 0;
        end
    
    end
    
PositionResponse(i) = Response; % Record the response in the variable PositionResponse
   
    if RandOrder(i) < 3
        Position = 1;
    elseif RandOrder(i) == 5
        Position = 3;
    else 
        Position = 2;
    end
 
PositionTarget(i) = Position; % Record the actual target position in the variable PositionTarget

end

%% Create output excel file

SNumber= ones(Trials,1).*SubjectNumber; % Creating a vector to store the Subject Number
Session = ones(Trials,1).*SessionNo; % Creating a vector to store Session number
SAge = ones(Trials,1).*SubjectAge; % Creating a vector to store Subject's age
data = table(SNumber, Session, SAge, PositionResponse, PositionTarget, SOA); % Creating a matrix to store desired data
filename = strcat(BoxAnswer{1}, BoxAnswer{2},fileending); % Adding subject number and session number strings to the filename
writetable(data,filename); % writetable creates the desired .xlsx output file

%% Ending the experiment and closing the screen

Screen('TextSize',window,17);
DrawFormattedText(window, 'This session has ended. Thank you for participating.', 'center', 'center', white);
Screen('TextSize',window,10);
DrawFormattedText(window, 'Press any key to exit.', 'center', screenYpixels .*0.75, white);
Screen('Flip',window);

% Wait for a key press to exit
KbStrokeWait; 

% Clear the screen and end psychtoolbox
Screen('CloseAll') 