import asyncio
import logging

from pymodbus.server import ServerTcp
from pymodbus.datastore import (
    ModbusServerContext,
    ModbusSlaveContext,
    ModbusSequentialDataBlock
)

# Setup logging
logging.basicConfig()
log = logging.getLogger()
log.setLevel(logging.INFO)

# Setup Modbus datastore
store = ModbusSlaveContext(
    di=ModbusSequentialDataBlock(0, [0]*100),
    co=ModbusSequentialDataBlock(0, [0]*100),
    hr=ModbusSequentialDataBlock(0, [0]*100),
    ir=ModbusSequentialDataBlock(0, [0]*100)
)

context = ModbusServerContext(slaves={0x00: store}, single=True)

# Define server coroutine
async def run_server():
    server = ServerTcp(context)
    print("✅ Modbus TCP server is running on port 502...")
    await server.serve_forever()

# ENTRY POINT
if __name__ == "__main__":
    asyncio.run(run_server())

