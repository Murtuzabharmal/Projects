import snap7
from snap7.server import Server
from snap7 import types
import time

server = Server()
data = (bytearray(1024), bytearray(1024), bytearray(1024))

server.register_area(type.areas['DB'], 1, data[0])
server.register_area(type.areas['DB'], 2, data[1])
server.register_area(type.areas['DB'], 3, data[2])

server.start()
print("S7 Server is running...")

try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    print("Stopping server...")
    server.stop()
    server.destroy()
