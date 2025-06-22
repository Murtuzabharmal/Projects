PROGRAM tank_control
VAR
  level AT %IW0 : INT;         // Simulated tank level
  pump AT %QX0.0 : BOOL;       // Pump output
  inflow : INT;                // Water coming in
  outflow : INT := 5;          // Constant outflow
  temp_level : INT;           // Used for level calculations
END_VAR

// Determine inflow based on pump state
IF pump = TRUE THEN
  inflow := 10;
ELSE
  inflow := 0;
END_IF;

// Calculate new level (simulate tank behavior)
temp_level := level + inflow - outflow;

// Clamp value between 0 and 100
IF temp_level < 0 THEN
  temp_level := 0;
END_IF;

IF temp_level > 100 THEN
  temp_level := 100;
END_IF;

level := temp_level;

// Auto-control logic
IF level >= 90 THEN
  pump := FALSE;
END_IF;

IF level <= 30 THEN
  pump := TRUE;
END_IF;
