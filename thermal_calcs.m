clear all; close all;

% syms phi;
phi = linspace(0,95,500)';

chassis_flag = 2;                       % Set to 1: ellipsoid
                                        % Set to 2: rectangular
i = 1;
for T_sc = [253 323]                    % Min and max spacecraft temp
    for orbit_flag = [1 2]
        j = 1;
        for phi=linspace(0,95,500)
            if orbit_flag == 1              % Aphelion parameters (min Q)
                gamma = 6278;               % Flux [w/m^2] @ aphelion
                r = 0.4667;                 % Mercury-Sun distance in AU
            else                            % Perehelion parameters (max Q)
                gamma = 14462;              % Flux [w/m^2] @ perihelion
                r = 0.3075;                 % Mercury-Sun distance in AU
            end
            R0 = 2439700;                   % Radius of Mercury [m]
            % Parameters
            epsilon = 0.9;                  % Emmisivity
            sigma = 5.7603*10^(-8);         % Stephan Boltzmann constant
            F = 1;                          % View factor
            k_wheel = 10;                   % Thermal conductivity [W/m*K], assume NiTi wheels
            dx = 0.5;                       % Length of wheel touching the ground [m]
            P_motors = 480;                 % TOTAL power input to all motors [W]
                                            % (as per power budget)
            motor_eta = 0.8;                % Motor efficiency
            Q_CDH = 20;                     % Heat produced by C&DH [W]

            T_subsolar = 407 + (8/r^0.5);   % Temperature at subsolar point [K]
                                            % ** This eqn is actually +/-, only
                                            % considering plus rn **
            T_terminator = 110;
            T_deepspace = 2.7;              % [K]

            n_wheel = 6;                    % Number of wheels
            w_wheel = 0.3;                  % Wheel width [m]
            d_wheel = 0.32;                 % Wheel diameter [m]
            C_wheel = pi*d_wheel;           % Wheel circumference [m]

            if phi <= 90
                h_shade = 0;
                T_mercury = T_subsolar*(cosd(phi)).^0.25 + T_terminator*(phi/(90)).^3;
            else        % phi > 90. ** See Saksham's Mechanical notes **
                R = R0/(sind(phi-90));
                h_shade = R - R0;
                T_mercury = 110;
            end

            if chassis_flag == 1
                a = 0.79; b = 0.41; c = 0.5;    % Chassis ellipsoid parameters [m]
                S = 4*pi*(((a*b)^1.6 + (a*c)^1.6 + (b*c)^1.6)/3)^(1/1.6);   % Total SA
                A_sun = S/4;
                A_deepspace = S/2;
                A_floor = pi*(a/2)*(b/2);
                A_wheel = w_wheel*0.2*C_wheel;  % Wheel area exposed to Mercury surface
            else
                l = 1; w = 0.5; h = 0.3;
                S = 2*(w*h + l*w + l*h);
                A_sun = w*(h-h_shade) + l*(h-h_shade);
                A_deepspace = S - l*w;
                A_floor = l*w;
                A_wheel = w_wheel*0.2*C_wheel;  % Wheel area exposed to Mercury surface
            end

            %% Heat calculations
            % syms T_sc
            % syms Q_active

            Q_sun(j,i) = gamma * A_sun;

            Q_deepspace(j,i) = epsilon*sigma*A_deepspace*(T_deepspace.^4 - T_sc.^4);

            Q_mercury(j,i) = epsilon*sigma*A_floor*F*((T_mercury.^4 - T_sc.^4));

            Q_conduction(j,i) = k_wheel*(n_wheel*A_wheel)*(T_mercury-T_sc)/dx;

            Q_motors = P_motors*(1-motor_eta);
            Q_gen(j,i) = Q_motors + Q_CDH;

            Q_total(j,i) = Q_sun(j,i) + Q_deepspace(j,i) + Q_mercury(j,i) + Q_conduction(j,i) + Q_gen(j,i);
            
            j=j+1;
        end
        i=i+1;
    end
end

% Plot
phiVals = linspace(0,95,500)';

figure(1)
plot (phiVals,Q_total(:,1),'LineWidth',3);
hold on; grid on;
plot (phiVals,Q_total(:,2),'LineWidth',3);
plot (phiVals,Q_total(:,3),'LineWidth',3);
plot (phiVals,Q_total(:,4),'LineWidth',3);
title("Rectangular Prism (Top not Exposed to Sun)");
xlabel("Phi [deg] (ie. position on Mercury)");
ylabel("Q required to maintain T_{sc} at given orbit position");
legend("T_{sc} = 253 K @ aphelion (far)", "T_{sc} = 253 K @ perehelion (close)", "T_{sc} = 323 K @ aphelion (far)", "T_{sc} = 323 K @ perehelion (close)");





