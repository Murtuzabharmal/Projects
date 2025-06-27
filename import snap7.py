import logging
from pymodbus.server.async_io import StartTcpServer
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

if __name__ == "__main__":
    print("✅ Modbus TCP server (pymodbus 3.6.9) is running on port 502...")
    StartTcpServer(context, address=("0.0.0.0", 502))
