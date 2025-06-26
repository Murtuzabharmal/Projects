import snap7
from snap7.server import Server
import time

S7AreaDB = 0x84  # Represents Data Block area

server = Server()

data_blocks = (
    bytearray(1024),
    bytearray(1024),
    bytearray(1024)
)

server.register_area(S7AreaDB, 1, data_blocks[0])
server.register_area(S7AreaDB, 2, data_blocks[1])
server.register_area(S7AreaDB, 3, data_blocks[2])

server.start()
print("✅ S7 server is running...")

try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    print("🛑 Stopping server...")
    server.stop()
    server.destroy()
