PROGRAM tank_control
VAR
  level AT %IW0 : INT;          // Tank level (0–100%)
  pump AT %QX0.0 : BOOL;        // Pump control output
  inflow : INT := 0;            // Flow rate into tank
  outflow : INT := 5;           // Constant outflow rate
END_VAR

// Increase level if pump is ON
IF pump THEN
  inflow := 10;
ELSE
  inflow := 0;
END_IF;

// Simulate level dynamics
level := level + inflow - outflow;

// Clamp tank level to 0–100
IF level < 0 THEN
  level := 0;
END_IF;
IF level > 100 THEN
  level := 100;
END_IF;

// Auto shut-off pump if tank is full
IF level >= 90 THEN
  pump := FALSE;
END_IF;

// Auto-start pump if tank is low
IF level <= 30 THEN
  pump := TRUE;
END_IF;
