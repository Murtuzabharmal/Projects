
PROGRAM tank_control
VAR
    tank_full_sensor AT %IX0.3 : BOOL;    // High level sensor (input)
    pump            AT %QX0.2 : BOOL;    // Pump control (output)
END_VAR

// Logic to control pump
IF tank_full_sensor THEN
    pump := FALSE;  // Turn OFF pump if tank is full
ELSE
    pump := TRUE;   // Turn ON pump if tank is not full
END_IF;
END_PROGRAM
