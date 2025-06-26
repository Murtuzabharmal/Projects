import snap7
from snap7.server import Server
import time

# Create a Snap7 server (S7-300/400)
server = Server()

# Memory size: simulate 1KB data blocks
data = (bytearray(1024), bytearray(1024), bytearray(1024))
server.register_area(snap7.types.areas['DB'], 1, data[0])
server.register_area(snap7.types.areas['DB'], 2, data[1])
server.register_area(snap7.types.areas['DB'], 3, data[2])

# Start server on default IP
server.start()
print("S7 Server is running...")

try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    print("Stopping server...")
    server.stop()
    server.destroy()
