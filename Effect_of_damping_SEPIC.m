%% SEPIC EET Example
% Frequency responses and damping os SEPIC

s = tf('s');

% Circuit Parameters

Vg = 18; % input voltage
V =24; % output voltage
C1 = 22e-6; % capacitance C1
C2 = 220e-6; % capacitance C2
L1 = 100e-6; % Inductance L1
L2 = 50e-6; % Inductance L2
R = 5; % load voltage
D = V/(V+Vg); % duty cycle

% Old transfer function, with C1 open-circuited

wold = 1/sqrt(C2*(L2+L1*(D/(1-D))^2));
Qold = R*sqrt(C2/(L2+L1*(D/(1-D))^2));
wz = (R/L1)*((1-D)/D)^2; % RHP zero
Gd0 = Vg/(1-D)^2;
Gvdbb = Gd0*(1-s/wz)/(1 + (1/Qold)*(s/wold) + (s/wold)^2);

% Impedances

Z = 1/(s*C1);
L12 = L1*L2/(L1+L2);
wzN = (R/L12)*(1-D)^2/D;
ZN = s*(L1+L2)*(1-s/wzN)/(1-s/wz);
wozD = (1-D)/sqrt(C2*L12);
QzD = R*(1-D)*sqrt(C2/L12);
ZD = s*(L1+L2)*(1 + (1/QzD)*(s/wozD) + (s/wozD)^2)/(1 + (1/Qold)*(s/wold) + (s/wold)^2);

% Damping
Cd = 100e-6; % damping capacitance
Rd = 2; % damping resistance
Rdtf = tf(Rd,1);
Zd = Rd+ 1/s/Cd;
Zdamp = minreal(Z * Zd)/(Z + Zd);

% Correction factor
Correction = minreal((1 + ZN/Z)/(1 + ZD/Z));
CorrectionDamped = minreal((1 +ZN/Zdamp)/(1 + ZD/Zdamp));

% Transfer function with C1 as extra element

Gvd = minreal(Gvdbb * Correction);
Gvd_damp = minreal(Gvdbb * CorrectionDamped);

fmin = 100; % minimum frequency = 100 Hz
fmax = 100e3; % maximum frequency = 100 kHz

% Set Bode plot options
BodeOptions = bodeoptions;
BodeOptions.FreqUnits = 'Hz'; % we prefer Hz ratehr than rad/s
BodeOptions.Xlim = [fmin fmax];
BodeOptions.Ylim = {[-30,40];[-90,90]}; % magnitude and phase axes limits
BodeOptions.Grid = 'on'; % include grid

% Define frequency-response plot title for impedance plots
BodeOptions.Title.String = 'ZN, ZD, Z and Zdamp';
% Plot magnitude and phase resposnes of ZN, ZD and Zdamp

Zfigure = figure(1);
bode(ZN,BodeOptions,'g');
hold on;
bode(Rdtf,BodeOptions,'b');
bode(ZD,BodeOptions,'c');
bode(Z,BodeOptions,'r');
bode(Zdamp,BodeOptions,'k');
hold off;

% Make the plots look better

h = findobj(gcf,'type','line');
set(h,'LineWidth',2);
Axis_handles = get(Zfigure,'Children');
axes(Axis_handles(3));
ax= gca;
ax.LineWidth = 1;
ax.GridAlpha = 0.4;
axes(Axis_handles(2));
ax = gca;
ax.LineWidth = 1;
ax.GridAlpha = 0.4;

legend('ZN','Rbtf','ZD','Z','Zdamp','Location','northwest');

% Frequency response plot title and limits for G plots
BodeOptions.Title.String = 'Gvdbbb, Gvd and Gvd with damping';
BodeOptions.Ylim = {[-60,80];[-720,0]};
BodeOptions.PhaseMatching = 'on'; % turns on the phase matching feature
BodeOptions.PhaseMatchingFreq = 1; % specifies the frequency at which the phase matching is to be performed. In this case, it is set to 1 Hz
BodeOptions.PhaseMatchingValue = 0; % specifies the value of the phase matching that is required. In this case, it is set to 0 degrees, which means that the phase of the output signal should match the phase of the input signal at the specified frequency

% Plot magnitude and phase responses for Gold and G

Gfigure = figure(2);
bode(Gvdbb,BodeOptions,'k');
hold on;
bode(Gvd,BodeOptions,'b');
bode(Gvd_damp,BodeOptions,'g');
hold off;

% Make the plots look better

h = findobj(gcf,'type','line');
set(h,'LineWidth',2);
Axis_handles = get(Gfigure,'Children');
axes(Axis_handles(3));
ax= gca;
ax.LineWidth = 1;
ax.GridAlpha = 0.4;
axes(Axis_handles(2));
ax = gca;
ax.LineWidth = 1;
ax.GridAlpha = 0.4;

legend('Gvd-bb','Gvd','Gvd with damping','Location','southwest');










