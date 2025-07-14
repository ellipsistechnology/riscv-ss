#include <MCP23017.h>
#include <Wire.h>

#define STATUS0 8
#define STATUS1 9
#define STATUS2 10
#define STATUS3 11
#define STATUS4 12
#define STATUS5 13
#define STATUS6 4
#define STATUS7 5

#define RESET_N 6

#define CLK     2
#define NCLK    3

// MCP pin addreses:      Index  Pin
const uint8_t CON0[2]  = {0,     7};
const uint8_t CON1[2]  = {0,     15};
const uint8_t CON2[2]  = {1,     7};
const uint8_t CON3[2]  = {1,     15};
const uint8_t CON4[2]  = {2,     7};
const uint8_t CON5[2]  = {2,     15};
const uint8_t CON6[2]  = {3,     7};
const uint8_t CON7[2]  = {3,     15};
const uint8_t CON8[2]  = {4,     7};
const uint8_t CON9[2]  = {4,     15};
const uint8_t CON10[2] = {5,     7};
const uint8_t CON11[2] = {5,     15};
const uint8_t CON12[2] = {6,     7};
const uint8_t CON13[2] = {6,     15};
const uint8_t CON14[2] = {7,     7};
const uint8_t CON15[2] = {7,     15};

const uint8_t GEN0[2]  = {6,     0};
const uint8_t GEN1[2]  = {6,     1};
const uint8_t GEN2[2]  = {6,     2};
const uint8_t GEN3[2]  = {6,     3};
const uint8_t GEN4[2]  = {6,     4};
const uint8_t GEN5[2]  = {6,     5};
const uint8_t GEN6[2]  = {6,     6};
const uint8_t GEN7[2]  = {7,     6};
const uint8_t GEN8[2]  = {6,     8};
const uint8_t GEN9[2]  = {6,     9};
const uint8_t GEN10[2] = {6,     10};
const uint8_t GEN11[2] = {6,     11};
const uint8_t GEN12[2] = {6,     12};
const uint8_t GEN13[2] = {6,     13};
const uint8_t GEN14[2] = {6,     14};
const uint8_t GEN15[2] = {7,     14};

// Pin aliases:
#define RAM_RW              CON0
#define BYTE                CON1
#define JMP                 CON1
#define HALFWORD            CON2
#define ALU0                CON3
#define ARITHMETIC          CON3
#define ALU1                CON4
#define RIGHT               CON4
#define UNSIGNED            CON4
#define ALU2                CON5
#define SUB                 CON5
#define LEFT                CON5
#define ALU3                CON6
#define ALU4                CON7

#define A_SRC_EN            CON8
#define A_SRC               CON9
#define B_SRC_EN            CON10
#define B_SRC               CON11
#define N_WRITE_RD          CON12
#define RD_SRC              CON13
#define PC_INC              CON14
#define JMP_REG             CON15

#define RS1_0               GEN0
#define N_OEA               GEN0
#define RS1_1               GEN1
#define N_OEB               GEN1
#define RS1_2               GEN2
#define RS1_3               GEN3
#define RS1_4               GEN4
#define RS2_0               GEN5
#define ALU_OP_0            GEN5
#define RS2_1               GEN6
#define ALU_OP_1            GEN6
#define RS2_2               GEN7
#define ALU_OP_2            GEN7
#define SUB                 GEN7

#define RS2_3               GEN8
#define ALU_OP_3            GEN8
#define RS2_4               GEN9
#define N_ADD_SUB_EN        GEN9
#define ALU_OP_4            GEN9
#define RD_0                GEN10
#define ALU_OP_5            GEN10
#define RD_1                GEN11
#define ALU_OP_6            GEN11
#define RD_2                GEN12
#define RD_3                GEN13
#define SUM31               GEN13
#define RD_4                GEN14
#define CARRY               GEN14

// int state = LOW;

// void dump(MCP23017 &mcp) {	
// 	uint8_t conf = mcp.readRegister(MCP23017Register::IODIR_A);
// 	Serial.print("IODIR_A : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();
	
// 	conf = mcp.readRegister(MCP23017Register::IODIR_B);
// 	Serial.print("IODIR_B : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::IPOL_A);
// 	Serial.print("IPOL_A : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::IPOL_B);
// 	Serial.print("IPOL_B : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::GPINTEN_A);
// 	Serial.print("GPINTEN_A : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::GPINTEN_B);
// 	Serial.print("GPINTEN_B : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::DEFVAL_A);
// 	Serial.print("DEFVAL_A : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::DEFVAL_B);
// 	Serial.print("DEFVAL_B : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::INTCON_A);
// 	Serial.print("INTCON_A : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::INTCON_B);
// 	Serial.print("INTCON_B : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::IOCON);
// 	Serial.print("IOCON : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	//conf = mcp.readRegister(IOCONB);
// 	//Serial.print("IOCONB : ");
// 	//Serial.print(conf, BIN);
// 	//Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::GPPU_A);
// 	Serial.print("GPPU_A : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::GPPU_B);
// 	Serial.print("GPPU_B : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::INTF_A);
// 	Serial.print("INTF_A : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::INTF_B);
// 	Serial.print("INTF_B : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::INTCAP_A);
// 	Serial.print("INTCAP_A : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::INTCAP_B);
// 	Serial.print("INTCAP_B : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::GPIO_A);
// 	Serial.print("GPIO_A : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::GPIO_B);
// 	Serial.print("GPIO_B : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::OLAT_A);
// 	Serial.print("OLAT_A : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();

// 	conf = mcp.readRegister(MCP23017Register::OLAT_B);
// 	Serial.print("OLAT_B : ");
// 	Serial.print(conf, BIN);
// 	Serial.println();
// }

void _pinMode(uint8_t pin, uint8_t mode) {
  pinMode(pin, mode);
}

void _digitalWrite(uint8_t pin, uint8_t state) {
  digitalWrite(pin, state);
}

class EllipsisConnector {
  // private:
  public:
  MCP23017 mcp[8] = {
    MCP23017(0x20),
    MCP23017(0x21),
    MCP23017(0x22),
    MCP23017(0x23),
    MCP23017(0x24),
    MCP23017(0x25),
    MCP23017(0x26),
    MCP23017(0x27)
  };

  public:
  EllipsisConnector() {
    // Configure common MCP reset:
    _pinMode(RESET_N, OUTPUT);
    _digitalWrite(RESET_N, HIGH); // Don't reset.
  }

  void init() {
    // Setup MCPs as output by default:
    for(int i = 0; i < 8; ++i) {
      mcp[i].init();
      mcp[i].portMode(MCP23017Port::A, 1); // Port A as input
      mcp[i].portMode(MCP23017Port::B, 1); // Port B as input
      //mcp[i].writeRegister(MCP23017Register::GPIO_A, 0x00);  //Reset port A 
      //mcp[i].writeRegister(MCP23017Register::GPIO_B, 0x00);  //Reset port B
    }
  }

  void pinMode(const uint8_t (&pin)[2], uint8_t mode) {
    mcp[pin[0]].pinMode(pin[1], mode);
  }

  void digitalWrite(const uint8_t (&pin)[2], uint8_t state) {
    mcp[pin[0]].digitalWrite(pin[1], state);
  }
  
  uint8_t read(const uint8_t (&pin)[2]) {
    return mcp[pin[0]].digitalRead(pin[1]);
  }

  void portAMode(uint8_t mode) {
    for(int i = 0; i <= 6; ++i) {
      mcp[0].pinMode(i, mode); // A0 - A6:   MCP0 pins 0 - 6
      mcp[1].pinMode(i, mode); // A16 - A22: MCP1 pins 0 - 6
    }

    for(int i = 8; i <= 14; ++i) {
      mcp[0].pinMode(i, mode); // A8 - A14:  MCP0 pins 8 - 14
      mcp[1].pinMode(i, mode); // A24 - A30: MCP1 pins 8 - 14
    }

    mcp[7].pinMode(0, mode); // A7:        MCP7 pin  0
    mcp[7].pinMode(8, mode); // A15:       MCP7 pin  8
    mcp[7].pinMode(1, mode); // A23:       MCP7 pin  1
    mcp[7].pinMode(9, mode); // A31:       MCP7 pin  9
  }

  void portBMode(uint8_t mode) {
    for(int i = 0; i <= 6; ++i) {
      mcp[2].pinMode(i, mode); // B0 - B6:   MCP2 pins 0 - 6
      mcp[3].pinMode(i, mode); // B16 - B22: MCP3 pins 0 - 6
    }

    for(int i = 8; i <= 14; ++i) {
      mcp[2].pinMode(i, mode); // B8 - B14:  MCP2 pins 8 - 14
      mcp[3].pinMode(i, mode); // B24 - B30: MCP3 pins 8 - 14
    }

    mcp[7].pinMode(2, mode);  // B7:       MCP7 pin  2
    mcp[7].pinMode(10, mode); // B15:      MCP7 pin  10
    mcp[7].pinMode(3, mode);  // B23:      MCP7 pin  3
    mcp[7].pinMode(11, mode); // B31:      MCP7 pin  11
  }

  void portCMode(uint8_t mode) {
    for(int i = 0; i <= 6; ++i) {
      mcp[4].pinMode(i, mode); // C0 - C6:   MCP4 pins 0 - 6
      mcp[5].pinMode(i, mode); // C16 - C22: MCP5 pins 0 - 6
    }

    for(int i = 8; i <= 14; ++i) {
      mcp[4].pinMode(i, mode); // C8 - C14:  MCP4 pins 8 - 14
      mcp[5].pinMode(i, mode); // C24 - C30: MCP5 pins 8 - 14
    }

    mcp[7].pinMode(4, mode);  // C7:        MCP7 pin  4
    mcp[7].pinMode(12, mode); // C15:       MCP7 pin  12
    mcp[7].pinMode(5, mode);  // C23:       MCP7 pin  5
    mcp[7].pinMode(13, mode); // C31:       MCP7 pin  13
  }

  void generalMode(uint8_t mode) {
    for(int i = 0; i <= 6; ++i) {
      mcp[6].pinMode(i, mode); // MCP6 pins 0 - 6
    }

    for(int i = 8; i <= 14; ++i) {
      mcp[6].pinMode(i, mode); // MCP6 pins 8 - 14
    }

    mcp[7].pinMode(6, mode);  // general 7:  MCP7 pin  6
    mcp[7].pinMode(14, mode); // general 15: MCP7 pin  14
  }

  uint8_t readRd() {
    return 
      read(RD_4) << 4 |
      read(RD_3) << 3 |
      read(RD_2) << 2 |
      read(RD_1) << 1 |
      read(RD_0);
  }

  uint8_t readRs1() {
    return 
      read(RS1_4) << 4 |
      read(RS1_3) << 3 |
      read(RS1_2) << 2 |
      read(RS1_1) << 1 |
      read(RS1_0);
  }

  uint8_t readRs2() {
    return 
      read(RS2_4) << 4 |
      read(RS2_3) << 3 |
      read(RS2_2) << 2 |
      read(RS2_1) << 1 |
      read(RS2_0);
  }

  /**
  * The 32 bits of port A are connected to the MCP23017 chips as follows:
  * A0 - A6:   MCP0 pins 0 - 6
  * A7:        MCP7 pin  0
  * A8 - A14:  MCP0 pins 8 - 14
  * A15:       MCP7 pin  8
  * A16 - A22: MCP1 pins 0 - 6
  * A23:       MCP7 pin  1
  * A24 - A30: MCP1 pins 8 - 14
  * A31:       MCP7 pin  9
  */
  void writeA(uint32_t A) {
    uint16_t currentMCP0 = mcp[0].read();
    mcp[0].write(
      currentMCP0 & 0x8080 // Preserve bits 7 & 15 since these are connected to control lines.
      | A & 0x7f7f         // Select only bits A0 - A6 and A8 - A14.
    );

    uint16_t currentMCP1 = mcp[1].read();
    mcp[1].write(
      currentMCP1 & 0x8080 // Preserve bits 7 & 15 since these are connected to control lines.
      | (A>>16) & 0x7f7f   // Select only bits A16 - A22 and A24 - A30.
    );

    mcp[7].digitalWrite(0, (A >> 7)&1);
    mcp[7].digitalWrite(8, (A >> 15)&1);
    mcp[7].digitalWrite(1, (A >> 23)&1);
    mcp[7].digitalWrite(9, (A >> 31)&1);
  }

  /**
  * The 32 bits of port B are connected to the MCP23017 chips as follows:
  * B0 - B6:   MCP2 pins 0 - 6
  * B7:        MCP7 pin  2
  * B8 - B14:  MCP2 pins 8 - 14
  * B15:       MCP7 pin  10
  * B16 - B22: MCP3 pins 0 - 6
  * B23:       MCP7 pin  3
  * B24 - B30: MCP3 pins 8 - 14
  * B31:       MCP7 pin  11
  */
  void writeB(uint32_t B) {
    uint16_t currentMCP2 = mcp[2].read();
    mcp[2].write(
      currentMCP2 & 0x8080 // Preserve bits 7 & 15 since these are connected to control lines.
      | B & 0x7f7f         // Select only bits B0 - B6 and B8 - B14.
    );

    uint16_t currentMCP3 = mcp[3].read();
    mcp[3].write(
      currentMCP3 & 0x8080 // Preserve bits 7 & 15 since these are connected to control lines.
      | (B>>16) & 0x7f7f   // Select only bits B16 - B22 and B24 - B30.
    );

    mcp[7].digitalWrite(2,  (B >> 7)&1);
    mcp[7].digitalWrite(10, (B >> 15)&1);
    mcp[7].digitalWrite(3,  (B >> 23)&1);
    mcp[7].digitalWrite(11, (B >> 31)&1);
  }

  /**
  * The 32 bits of port C are connected to the MCP23017 chips as follows:
  * C0 - C6:   MCP4 pins 0 - 6
  * C7:        MCP7 pin  4
  * C8 - C14:  MCP4 pins 8 - 14
  * C15:       MCP7 pin  12
  * C16 - C22: MCP5 pins 0 - 6
  * C23:       MCP7 pin  5
  * C24 - C30: MCP5 pins 8 - 14
  * C31:       MCP7 pin  13
  */
  void writeC(uint32_t C) {
    uint16_t currentMCP4 = mcp[4].read();
    mcp[4].write(
      currentMCP4 & 0x8080 // Preserve bits 7 & 15 since these are connected to control lines.
      | C & 0x7f7f         // Select only bits B0 - B6 and B8 - B14.
    );

    uint16_t currentMCP5 = mcp[5].read();
    mcp[5].write(
      currentMCP5 & 0x8080 // Preserve bits 7 & 15 since these are connected to control lines.
      | (C>>16) & 0x7f7f   // Select only bits B16 - B22 and B24 - B30.
    );

    mcp[7].digitalWrite(4,  (C >> 7)&1);
    mcp[7].digitalWrite(12, (C >> 15)&1);
    mcp[7].digitalWrite(5,  (C >> 23)&1);
    mcp[7].digitalWrite(13, (C >> 31)&1);
  }

  /**
  * The 32 bits of port A are connected to the MCP23017 chips as follows:
  * A0 - A6:   MCP0 pins 0 - 6
  * A7:        MCP7 pin  0
  * A8 - A14:  MCP0 pins 8 - 14
  * A15:       MCP7 pin  8
  * A16 - A22: MCP1 pins 0 - 6
  * A23:       MCP7 pin  1
  * A24 - A30: MCP1 pins 8 - 14
  * A31:       MCP7 pin  9
  */
  uint32_t readA() {
    return 
      (mcp[0].read() & 0x7f7f)                   | // low order bits
      ((uint32_t)(mcp[1].read() & 0x7f7f) << 16) | // high order bits
      ((uint32_t)mcp[7].digitalRead(0)    << 7 ) |
      ((uint32_t)mcp[7].digitalRead(8)    << 15) |
      ((uint32_t)mcp[7].digitalRead(1)    << 23) |
      ((uint32_t)mcp[7].digitalRead(9)    << 31);
  }

  /**
  * The 32 bits of port B are connected to the MCP23017 chips as follows:
  * B0 - B6:   MCP2 pins 0 - 6
  * B7:        MCP7 pin  2
  * B8 - B14:  MCP2 pins 8 - 14
  * B15:       MCP7 pin  10
  * B16 - B22: MCP3 pins 0 - 6
  * B23:       MCP7 pin  3
  * B24 - B30: MCP3 pins 8 - 14
  * B31:       MCP7 pin  11
  */
  uint32_t readB() {
    return 
      (mcp[2].read() & 0x7f7f)                   | // low order bits
      ((uint32_t)(mcp[3].read() & 0x7f7f) << 16) | // high order bits
      ((uint32_t)mcp[7].digitalRead(2)    << 7 ) |
      ((uint32_t)mcp[7].digitalRead(10)   << 15) |
      ((uint32_t)mcp[7].digitalRead(3)    << 23) |
      ((uint32_t)mcp[7].digitalRead(11)   << 31);
  }

  /**
  * The 32 bits of port C are connected to the MCP23017 chips as follows:
  * C0 - C6:   MCP4 pins 0 - 6
  * C7:        MCP7 pin  4
  * C8 - C14:  MCP4 pins 8 - 14
  * C15:       MCP7 pin  12
  * C16 - C22: MCP5 pins 0 - 6
  * C23:       MCP7 pin  5
  * C24 - C30: MCP5 pins 8 - 14
  * C31:       MCP7 pin  13
  */
  uint32_t readC() {
    return 
      (mcp[4].read() & 0x7f7f)                   | // low order bits
      ((uint32_t)(mcp[5].read() & 0x7f7f) << 16) | // high order bits
      ((uint32_t)mcp[7].digitalRead(4)    << 7 ) |
      ((uint32_t)mcp[7].digitalRead(12)   << 15) |
      ((uint32_t)mcp[7].digitalRead(5)    << 23) |
      ((uint32_t)mcp[7].digitalRead(13)   << 31);
  }
};

EllipsisConnector conn;

uint32_t A = 0;
uint32_t B = 0;
uint32_t C = 1;

void clockPos() {
  digitalWrite(CLK, HIGH);
  delay(100);
  digitalWrite(CLK, LOW);
}

void clockNeg() {
  digitalWrite(CLK, LOW);
  delay(100);
  digitalWrite(CLK, HIGH);
}

void setup_register() { 
  pinMode(CLK, OUTPUT);
  digitalWrite(CLK, LOW);

  conn.pinMode(N_OEA, OUTPUT);
  conn.digitalWrite(N_OEA, LOW); // Enable A

  conn.pinMode(N_OEB, OUTPUT);
  conn.digitalWrite(N_OEB, LOW); // Enable B

  conn.portAMode(INPUT);
  conn.portBMode(INPUT);
  conn.portCMode(OUTPUT);
}

void loop_register() {
  A = conn.readA();
  B = conn.readB();

  Serial.print(A, HEX);
  Serial.print(", ");
  Serial.print(B, HEX);
  Serial.print(", ");
  Serial.print(C, HEX);
  Serial.println();

  C *= 2;
  // C = 0x4000;
  // C = 0xfffffffe;

  if(C == 0) {
    C = 1;
  }

  conn.writeC(C);
  delay(10);
  digitalWrite(CLK, HIGH);
  delay(100);
  digitalWrite(CLK, LOW);
  delay(500);
}

void setup_regfile() {
  conn.pinMode(N_WRITE_RD, OUTPUT);
  conn.digitalWrite(N_WRITE_RD, HIGH); // Don't write

  pinMode(CLK, OUTPUT);
  digitalWrite(CLK, LOW);

  conn.pinMode(RS1_0, OUTPUT);
  conn.pinMode(RS1_1, OUTPUT);
  conn.pinMode(RS1_2, OUTPUT);
  conn.pinMode(RS1_3, OUTPUT);
  conn.pinMode(RS1_4, OUTPUT);

  conn.pinMode(RS2_0, OUTPUT);
  conn.pinMode(RS2_1, OUTPUT);
  conn.pinMode(RS2_2, OUTPUT);
  conn.pinMode(RS2_3, OUTPUT);
  conn.pinMode(RS2_4, OUTPUT);

  conn.pinMode(RD_0, OUTPUT);
  conn.pinMode(RD_1, OUTPUT);
  conn.pinMode(RD_2, OUTPUT);
  conn.pinMode(RD_3, OUTPUT);
  conn.pinMode(RD_4, OUTPUT);

  conn.portAMode(INPUT);
  conn.portBMode(INPUT);
  conn.portCMode(OUTPUT);
}

int rd_0  = LOW;
int rd_1  = HIGH;

void loop_regfile() {
  // RS1:
  conn.digitalWrite(RS1_0, HIGH);
  conn.digitalWrite(RS1_1, LOW);
  conn.digitalWrite(RS1_2, LOW);
  conn.digitalWrite(RS1_3, LOW);
  conn.digitalWrite(RS1_4, LOW);

  // RS2:
  conn.digitalWrite(RS2_0, LOW);
  conn.digitalWrite(RS2_1, HIGH);
  conn.digitalWrite(RS2_2, LOW); // Also ADD/SUB module's SUB signal: Set to ADD when LOW.
  conn.digitalWrite(RS2_3, LOW);
  conn.digitalWrite(RS2_4, LOW); // Also ADD/SUB module's EN signal: Set to enable output when LOW.

  // RD:
  conn.digitalWrite(RD_0, rd_0);
  conn.digitalWrite(RD_1, rd_1);
  conn.digitalWrite(RD_2, LOW);
  conn.digitalWrite(RD_3, LOW);
  conn.digitalWrite(RD_4, LOW);

  delay(10); // Ensure reg numbers are stable.

  // Output value to C:
  C = C << 1;
  if(C == 0) {
    C = 1;
  }
  conn.writeC(C);

  // Read values from A & B:
  A = conn.readA();
  B = conn.readB();

  // Cycle rd:
  int tmp = rd_0;
  rd_0 = rd_1;
  rd_1 = tmp;

  // Log:
  Serial.print(A, HEX);
  Serial.print(", ");
  Serial.print(B, HEX);
  Serial.print(", ");
  Serial.print(C, HEX);
  Serial.println();

  // Write:
  conn.digitalWrite(N_WRITE_RD, LOW); // Enable write.
  delay(10);
  digitalWrite(CLK, HIGH);
  delay(100);
  digitalWrite(CLK, LOW);
  conn.digitalWrite(N_WRITE_RD, HIGH);
  delay(500);
}

void loop_addsub() {
  conn.writeA(A);
  conn.writeB(B);
  C = conn.readC();

  Serial.print(A, HEX);
  Serial.print("(");
  Serial.print(A);
  Serial.print(")");
  Serial.print(" + ");
  Serial.print(B, HEX);
  Serial.print("(");
  Serial.print(B);
  Serial.print(")");
  Serial.print(" = ");
  Serial.print(C, HEX);
  Serial.print("(");
  Serial.print(C);
  Serial.print(")");

  if(C != (A+B)) {
    Serial.print("   ERROR");
  }
  
  Serial.println();

  A = B;
  B = C;

  // count_B = count_B << 1;

  if(B >= 2971215073 || B == 0) {
    B = 1;
    A = 1;
  }

  delay(500);
}

void setup_addsub() {
  // conn.mcp[6].pinMode(13, INPUT);
  conn.pinMode(SUM31, INPUT); // mcp[6].pinMode(13, INPUT); // General[13] (Sum[31]) as input - avoid short circuit.
  conn.pinMode(CARRY, INPUT); // mcp[6].pinMode(14, INPUT); // General[13] (carry) as input - avoid short circuit.
  conn.pinMode(SUB, OUTPUT); // mcp[2].pinMode(15, OUTPUT); // Sub is an output.
  conn.digitalWrite(SUB, LOW); //mcp[2].digitalWrite(15, LOW); // Add
  conn.pinMode(ALU_OP_4, OUTPUT); // Output enable
  conn.digitalWrite(ALU_OP_4, LOW); // Enable output to C

  conn.portCMode(INPUT);
}

void resetReg1AndReg2() {
  // Set RS1 to zero register so nothing is driving A output:
  conn.digitalWrite(RS1_0, LOW);
  conn.digitalWrite(RS1_1, LOW);
  conn.digitalWrite(RS1_2, LOW);
  conn.digitalWrite(RS1_3, LOW);
  conn.digitalWrite(RS1_4, LOW);

  // Set RS2 to zero register so nothing is driving B output:
  conn.digitalWrite(RS2_0, LOW);
  conn.digitalWrite(RS2_1, LOW);
  conn.digitalWrite(RS2_2, LOW);
  conn.digitalWrite(RS2_3, LOW);
  conn.digitalWrite(RS2_4, LOW);

  // Temporarily write to these - reset later to inputs:
  conn.portAMode(OUTPUT);
  conn.portBMode(OUTPUT);
  conn.pinMode(RD_3, OUTPUT);
  conn.pinMode(RD_4, OUTPUT);

  // Write 0 to A/reg1:
  conn.digitalWrite(RD_0, HIGH);
  conn.digitalWrite(RD_1, LOW);
  conn.digitalWrite(RD_2, LOW);
  conn.digitalWrite(RD_3, LOW);
  conn.digitalWrite(RD_4, LOW);

  conn.writeA(0);
  conn.writeB(0);
  conn.digitalWrite(N_WRITE_RD, LOW); // Enable write
  clockNeg(); // Write A + B = C => reg1
  conn.digitalWrite(N_WRITE_RD, HIGH); // Enable write
  Serial.println("Writing 1 to A");

  // Write 1 to B/reg2:
  conn.digitalWrite(RD_0, LOW);
  conn.digitalWrite(RD_1, HIGH);
  conn.digitalWrite(RD_2, LOW);
  conn.digitalWrite(RD_3, LOW);
  conn.digitalWrite(RD_4, LOW);

  conn.writeB(1);
  conn.digitalWrite(N_WRITE_RD, LOW); // Enable write
  clockNeg(); // Write A + B = C => reg2
  conn.digitalWrite(N_WRITE_RD, HIGH); // Enable write
  Serial.println("Writing 1 to B");

  // These must come from the add/sub module:
  conn.pinMode(RD_3, INPUT);
  conn.pinMode(RD_4, INPUT);
  conn.portAMode(INPUT);
  conn.portBMode(INPUT);
}

void setup_addsubwithregfile() {
  conn.pinMode(SUM31, INPUT);          // GEN13 - mcp[6].pinMode(13, INPUT); // General[13] (Sum[31]) as input - avoid short circuit.
  conn.pinMode(CARRY, INPUT);          // GEN13 - mcp[6].pinMode(14, INPUT); // General[13] (carry) as input - avoid short circuit.
  
  conn.pinMode(SUB, OUTPUT);           // CON5  - mcp[2].pinMode(15, OUTPUT); // Sub is an output.
  conn.digitalWrite(SUB, LOW);         // Add

  conn.pinMode(ALU_OP_4, OUTPUT);      // GEN9 - Output enable
  conn.digitalWrite(ALU_OP_4, LOW);    // Enable output to C

  conn.pinMode(N_WRITE_RD, OUTPUT);    // CON12
  conn.digitalWrite(N_WRITE_RD, HIGH); // Disable write initially

  pinMode(CLK, OUTPUT);
  digitalWrite(CLK, HIGH); // We want to activate on the negative edge for a write.

  conn.pinMode(RS1_0, OUTPUT);
  conn.pinMode(RS1_1, OUTPUT);
  conn.pinMode(RS1_2, OUTPUT);
  conn.pinMode(RS1_3, OUTPUT);
  conn.pinMode(RS1_4, OUTPUT);

  conn.pinMode(RS2_0, OUTPUT);
  conn.pinMode(RS2_1, OUTPUT);
  conn.pinMode(RS2_2, OUTPUT);
  conn.pinMode(RS2_3, OUTPUT);
  conn.pinMode(RS2_4, OUTPUT); // GEN9 - same as ALU_OP_4, both are outputs

  conn.pinMode(RD_0, OUTPUT);
  conn.pinMode(RD_1, OUTPUT);
  conn.pinMode(RD_2, OUTPUT);
  // conn.pinMode(RD_3, OUTPUT); // GEN13 - same as SUM31 so must remain input
  // conn.pinMode(RD_4, OUTPUT); // GEN13 - same as CARRY, so must remain input

  conn.portCMode(INPUT);

  // Write initial values to reg 1 & reg 2:
  resetReg1AndReg2();
}

void loop_addsubwithregfile() {
  A = conn.readA();
  B = conn.readB();
  C = conn.readC();

  if(A > 0x10000000 || B > 0x10000000) {
    resetReg1AndReg2();
  }

  // Log:
  Serial.print(A, HEX);
  Serial.print(", ");
  Serial.print(B, HEX);
  Serial.print(", ");
  Serial.print(C, HEX);
  Serial.println();

  // RS1:
  conn.digitalWrite(RS1_0, HIGH);
  conn.digitalWrite(RS1_1, LOW);
  conn.digitalWrite(RS1_2, LOW);
  conn.digitalWrite(RS1_3, LOW);
  conn.digitalWrite(RS1_4, LOW);

  // RS2:
  conn.digitalWrite(RS2_0, LOW);
  conn.digitalWrite(RS2_1, HIGH);
  conn.digitalWrite(RS2_2, LOW); // Also ADD/SUB module's SUB signal: Set to ADD when LOW.
  conn.digitalWrite(RS2_3, LOW);
  conn.digitalWrite(RS2_4, LOW); // Also ADD/SUB module's EN signal: Set to enable output when LOW.

  // RD:
  conn.digitalWrite(RD_0, rd_0);
  conn.digitalWrite(RD_1, rd_1);
  conn.digitalWrite(RD_2, LOW);
  conn.digitalWrite(RD_3, LOW);
  conn.digitalWrite(RD_4, LOW);

  delay(500);

  // Cycle rd:
  int tmp = rd_0;
  rd_0 = rd_1;
  rd_1 = tmp;

  // Clock pulse:
  conn.digitalWrite(N_WRITE_RD, LOW); // Enable write
  clockNeg();
  conn.digitalWrite(N_WRITE_RD, HIGH); // Enable write
}

uint8_t inst_length = 10;
void setup_rom() {
  conn.portBMode(OUTPUT); // Address
  conn.portCMode(INPUT); // Instruction

  for(int address = 0; address < 10; ++address) {
    conn.writeB(address);
    delay(1);
    Serial.print(address, HEX);
    Serial.print(": ");
    Serial.println(conn.readC(), HEX);
    delay(1);
  }
}

void loop_rom() {
  delay(1000);
}

void setup_decode() {
  conn.portAMode(INPUT);  // Immediate in.
  conn.portBMode(OUTPUT); // Address out.
  conn.portCMode(INPUT);  // Instruction in.
  conn.generalMode(INPUT);

  // for(int address = 0; address < 32; ++address) {
  //   conn.writeB(address);
  //   delay(10);
  //   Serial.print(address, HEX);
  //   Serial.print(": 0x");
  //   Serial.print(conn.readC(), HEX);
  //   Serial.print(", immediate: 0x");
  //   Serial.println(conn.readA(), HEX);
  //   delay(10);
  // }

  // conn.portCMode(OUTPUT);  // Instruction out.
}

const uint8_t INST_LEN = 10;
const char* assembly[] = {
  "nop",
  "and x5 x6 x7",
  "sub x31, x1, x0",
  "andi x31, x31, -1",
  "lw x31, 100(x3)",
  "sw x31, -1(x31)",
  "bgeu x31, x31, -2",
  "lui x31, 0xfffff",
  "jal x31, -2",
  "addi x16, x17, 0xabc"
};

const uint32_t instructions[] = {
              //     opcode,   rs1,  rs2,  rd,   funt3, funct7,   immediate, asm
  0x00000000, // NOP
  0x01fff2b3, // R - 011 0011, 0x  , 0x07, 0x05, 111,   0x000000,          , and x5, x31, x31
  0x40008fb3, // R - 011 0011, 0x  , 0x00, 0x01, 000,   0x010000,          , sub x31, x1, x0
  0xffffff93, // I - 001 0011, 0x1f,     , 0x1f, 111,           , 0xfff    , andi x31, x31, -1
  0x0641af83, // I - 000 0011, 0x03,     , 0x02, 010,           , 0x064    , lw x31, 100(x3)
  0xffffafa3, // S - 010 0011, 0x  , 0x  ,     , 010,           , 0xf9c    , sw x31, -1(x31)
  0xffffffe3, // B - 110 0011, 0x03, 0x04,     , 111,           , 0xffd    , bgeu x31, x31, -2
  0xffffffb7, // U - 011 0111, 0x  , 0x  , 0x03,                , 0xfffff  , lui x31, 0xfffff
  0xffffffef, // J - 110 1111, 0x  , 0x  , 0x01,                , 0x1fffec , jal x31, -2
  0xabc88813, // I - 001 0011, 0x17,     , 0x16, 000,           , 0xabc    , addi x16, x17, 0xabc
};

int inst_idx = 1;
void loop_decode() {

  //conn.writeC(instructions[inst_idx]);
  conn.writeB(inst_idx); // Write address.

  Serial.print("add: 0x");
  Serial.print(inst_idx, HEX);
  Serial.print(", inst: 0x");
  Serial.print(conn.readC(), HEX);
  Serial.print(", rs1: ");
  Serial.print(conn.readRs1());
  Serial.print(", rs2: ");
  Serial.print(conn.readRs2());
  Serial.print(", rd: ");
  Serial.print(conn.readRd());
  Serial.print(", immediate: ");
  Serial.print(conn.readA(), HEX);
  Serial.print(", ");
  Serial.print(assembly[inst_idx]);
  Serial.println("");
  delay(1000);
  
  // int address = 0x0;
  // conn.writeB(address);
  // delay(10);
  // Serial.print(address, HEX);
  // Serial.print(": 0x");
  // Serial.print(conn.readC(), HEX);
  // Serial.print(", immediate: 0x");
  // Serial.println(conn.readA(), HEX);
  // delay(10);

  inst_idx++;
  if(inst_idx >= INST_LEN) {
    inst_idx = 1;
  }
}

void setup() {
  // I2C setup:
  Serial.println("Initialising UART");
  Wire.begin();
  Serial.begin(115200);

  Serial.println("Initialising MCP23017s");
  conn.init();

  Serial.println("Configuring I/O");

  pinMode(STATUS0, INPUT);
  pinMode(STATUS1, INPUT);
  pinMode(STATUS2, INPUT);
  pinMode(STATUS3, INPUT);
  pinMode(STATUS4, INPUT);
  pinMode(STATUS5, INPUT);
  pinMode(STATUS6, INPUT);
  pinMode(STATUS7, INPUT);

  // setup_addsub();
  // setup_register();
  // setup_regfile();
  // setup_addsubwithregfile();
  // setup_rom();
  setup_decode();

  Serial.println("Configuration complete.");
}

void loop() {
  // loop_addsub();
  // loop_register();
  // loop_regfile();
  // loop_addsubwithregfile();
  // loop_rom();
  loop_decode();
}