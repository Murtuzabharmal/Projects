import snap7
from snap7.server import Server
from ctypes import create_string_buffer
import time

# Define DB area (132 = S7AreaDB)
S7AreaDB = 0x84

# Create the server
server = Server()

# Allocate memory using ctypes buffer
db1 = create_string_buffer(1024)
db2 = create_string_buffer(1024)
db3 = create_string_buffer(1024)

# Register the memory areas
server.register_area(S7AreaDB, 1, db1)
server.register_area(S7AreaDB, 2, db2)
server.register_area(S7AreaDB, 3, db3)

# Start server
server.start()
print("✅ S7 server is running...")

try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    print("🛑 Stopping server...")
    server.stop()
    server.destroy()
