import asyncio
import logging

from pymodbus.server.async_io import ModbusTcpServer
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

context = ModbusServerContext(slaves={0x01: store}, single=True)

async def main():
    print("✅ Modbus TCP server (pymodbus 3.6.9) is running on port 5020...")
    server = ModbusTcpServer(context, address=("0.0.0.0", 5020))
    await server.serve_forever()

if __name__ == "__main__":
    asyncio.run(main())
