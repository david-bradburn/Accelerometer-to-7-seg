//Header file for types declarations
`ifndef TYPES
    `define TYPES
    typedef enum { IDLE = 0, 
                START = 1, 
                SEND_DEVICE_ADDRESS = 2,
                DEV_ADDRESS_ACK = 3,
                SEND_REGISTER_ADDRESS = 4,
                REG_ADDRESS_ACK = 5,
                SEND_WRITE_DATA = 6,
                RESTART = 7,
                SEND_DEVICE_ADDRESS_AGAIN = 8,
                DEV_ADDRESS_ACK_AGAIN = 9,
                RECEIVE_READ_DATA = 10,
                SEND_NACK = 11,
                STOP = 12,

                WRITE_DATA_ACK = 13,
                ERROR = 255 } i2c_state_e; // might want to rename some of these state names cause they aren't great
    

    typedef struct packed {
        logic [7:0] op_code;
        logic [7:0] device_address; // but only 7 bits are used
        logic [7:0] register_address;
        logic [7:0] write_value;
    } st_instructionData;
`endif


