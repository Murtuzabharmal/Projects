import snap7
from snap7.server import Server
import time

# Constants (manually defined areas)
S7AreaDB = 0x84  # 132 = S7AreaDB in snap7

# Create server
server = Server()

# Allocate data blocks (e.g., DB1, DB2, DB3 with 1024 bytes each)
data_blocks = (bytearray(1024), bytearray(1024), bytearray(1024))

# Register data areas
server.register_area(S7AreaDB, 1, data_blocks[0])
server.register_area(S7AreaDB, 2, data_blocks[1])
server.register_area(S7AreaDB, 3, data_blocks[2])

# Start the server
server.start()
print("✅ S7 server is running...")

try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    print("🛑 Server stopped.")
    server.stop()
    server.destroy()
