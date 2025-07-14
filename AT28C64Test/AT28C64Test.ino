#include "MCP23S17.h"

// SPI Pins:
#define MOSI 11
#define MISO 12
#define SCK  13
#define N_CS 10

// AT28C64 Pins:
#define N_OE 8
#define N_WE 9

 MCP23S17 MCP_A (N_CS, 0);   //  HW SPI, address 0, Address[15:0]
 MCP23S17 MCP_DL(N_CS, 2);   //  HW SPI, address 2, Data[15:0]
 MCP23S17 MCP_DH(N_CS, 3);   //  HW SPI, address 3, Data[31:16]

// uint8_t codeLength = 32;
// uint32_t code[] = {
//   0x00100093,
//   0x00000133,
//   0x00208133,
//   0x002080b3,
//   0x00208133,
//   0x002080b3,
//   0x00208133,
//   0x002080b3,
//   0x00208133,
//   0x002080b3,
//   0x00208133,
//   0x002080b3,
//   0x00208133,
//   0x002080b3,
//   0x00208133,
//   0x002080b3,
//   0x00208133,
//   0x002080b3,
//   0x00208133,
//   0x002080b3,
//   0x00208133,
//   0x002080b3,
//   0x00208133,
//   0x002080b3,
//   0x00208133,
//   0x002080b3,
//   0x00208133,
//   0x002080b3,
//   0x00208133,
//   0x002080b3,
//   0x00208133,
//   0x002080b3
// };

uint8_t codeLength = 10;
uint32_t code[] = {
  0x00000000, // NOP - first write doesn't seem to work, so this is a dummy op
  0x01fff2b3,
  0x40008fb3,
  0xffffff93,
  0x0641af83,
  0xffffafa3,
  0xffffffe3,
  0xffffffb7,
  0xffffffef,
  0xabc88813
};

void setAddress(uint16_t a) {
  MCP_A.write16(a);
}

void setData(uint32_t d) {
  MCP_DH.write16((uint16_t)(d>>16));
  MCP_DL.write16((uint16_t)(d&0xffff));
}

uint32_t readData() {
  return (((uint32_t)MCP_DH.read16()) << 16) | ((uint32_t)MCP_DL.read16());
}

uint32_t readROM(uint16_t address) {
  setAddress(address);
  delay(1);
  return readData();
}

int testConnection(MCP23S17 & mcp)
{
  uint16_t magic_test_number = 0xABCD;

  //  Read the current polarity config to restore later
  uint16_t old_value;
  if (! mcp.getPolarity16(old_value)) return -1;

  //  Write the magic number to polarity register
  if (! mcp.setPolarity16(magic_test_number)) return -2;

  //  Read back the magic number from polarity register
  uint16_t temp;
  if (! mcp.getPolarity16(temp)) return -3;

  //  Write old config to polarity register
  if (! mcp.setPolarity16(old_value)) return -4;

  //  Check the magic connection test
  if (temp != magic_test_number) return -5;

  return 0;  //  OK
}

void writeROM32(uint32_t address, uint32_t data) {
  digitalWrite(N_OE, HIGH); // Disable output
  setAddress(address); // Set address and enable chip
  delay(1); // Ensure setup times
  digitalWrite(N_WE, LOW); // Enable write
  setData(data);
  delayMicroseconds(1); // Write pulse width 100 - 1000ns
  digitalWrite(N_WE, HIGH); // Disable write
  delay(1); // ensure data hold time
}

void setup() {
  // UART/Logging Setup:
  Serial.println("Initialising UART");
  Serial.begin(115200);

  // MCP23S17 Setup:
  Serial.println("Initialising SPI/MCP23S17");
  SPI.begin();

  MCP_A.begin();
  MCP_A.enableHardwareAddress();
  MCP_A.pinMode16(0); // Output
  MCP_DL.begin();
  MCP_DL.enableHardwareAddress();
  MCP_DL.pinMode16(0); // Output
  MCP_DH.begin();
  MCP_DH.enableHardwareAddress();
  MCP_DH.pinMode16(0); // Output

  Serial.print("Testing MCP_A. Result: ");
  Serial.println(testConnection(MCP_A));
  Serial.print("Testing MCP_DL. Result: ");
  Serial.println(testConnection(MCP_DL));
  Serial.print("Testing MCP_DH. Result: ");
  Serial.println(testConnection(MCP_DH));

  // ROM Setup:
  pinMode(N_OE, OUTPUT);
  digitalWrite(N_OE, HIGH); // Disable output

  pinMode(N_WE, OUTPUT);
  digitalWrite(N_WE, HIGH); // Disable write

  // Write data:
  Serial.println("Writing data...");
  uint32_t data;
  for(uint32_t address = 0; address < codeLength; ++address) {
    data = code[address];//(address << 24) | (address << 16) | (address << 8) | address;
    Serial.print("Writing 0x");
    Serial.print(data, HEX);
    Serial.print(" to address 0x");
    Serial.println(address, HEX);
    writeROM32(address, data);
    delay(10);
  }
  Serial.println("Data write complete.");

  // Enable read:
  MCP_DL.pinMode16(0xffff); // Input
  MCP_DH.pinMode16(0xffff); // Input
  digitalWrite(N_OE, LOW); // Enable output

  // Test data:
  for(uint8_t address = 0; address < codeLength; ++address) {
    Serial.print(address);
    Serial.print(": 0x");
    Serial.println(readROM(address), HEX);
  }

  delay(100);
}

// uint16_t address = 1;
void loop() {
  // Serial.println(readData(), HEX);
  // setAddress(address++);
  delay(1000);
}


/******* Direct to ROM functions when not using SPI: *******/

// void ROMSetup() {
//   pinMode(N_CE, OUTPUT);
//   digitalWrite(N_CE, LOW); // Enable chip
// 
// // Data pins, initialise to zero and for writing:
// for(int i = 2; i <= 9; ++i) {
//   pinMode(i, OUTPUT);
//   digitalWrite(i, 0);
// }
// 
// // Data pins, set for reading:
// for(int i = 2; i <= 9; ++i) {
//   pinMode(i, INPUT);
// }
// }

// void setROMData(uint8_t d) {
//   for(int i = 0; i <= 7; ++i) {
//     digitalWrite(i+2, d & (1 << i) ? HIGH : LOW);
//   }
// }

// uint8_t readROMData() {
//   uint8_t d = 0;
//   for(int i = 0; i <= 7; ++i) {
//     d += digitalRead(i+2) << i;
//   }
//   return d;
// }
