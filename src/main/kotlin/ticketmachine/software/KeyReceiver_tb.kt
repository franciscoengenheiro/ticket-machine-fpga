package ticketmachine.software

import ticketmachine.software.SerialEmitter.checkLSB

fun main () {
    // Initializes HAL object
    HAL.init()
    // Initializes KeyReceiver object
    KeyReceiver.init()
    println("$SERVER: [${SV.INFO}]      This test only works in debug mode")
    println("$SERVER: [${SV.INFO}]      A breakpoint must be placed on the last line")
    // Initialize a mutable variable to store user input
    var keyCode: Int
    println("$SERVER: [${SV.INFO}]      An input KeyCode is required in order to assert the correct TXD values")
    do {
        keyCode = readInt("$SERVER: [${SV.REQUEST}]   KeyCode: ")
    } while (keyCode > MAXINT_4BITS)
    println("$SERVER: [${SV.START}]     Initializing test framework...")
    println("$SERVER: [${SV.INFO}]      Processing data...\n")
    println("$SERVER: [${SV.OUTPUT}]    TXD: 0 (INIT)")
    println("$SERVER: [${SV.OUTPUT}]    TXD: 1 (START BIT)")
    // Check every bit in the keyCode frame (4 bits)
    for (i in 0..3) {
        // Check if the LSB bit is either 1 (true) or 0 (false)
        if (keyCode.checkLSB()) {
            println("$SERVER: [${SV.OUTPUT}]    TXD: 1 K[${i}]")
        } else {
            println("$SERVER: [${SV.OUTPUT}]    TXD: 0 K[${i}]")
        }
        // Shift keyCode frame 1 bit to the right, this way discarding the LSB
        keyCode = keyCode.shr(1)
    }
    println("$SERVER: [${SV.OUTPUT}]    TXD: 0 (STOP BIT)\n")
    println("$SERVER: [${SV.END}]       Closing test framework...")
    println("$SERVER: [${SV.INFO}]      TXD values will be inserted by the user on the SimDig application")
    println("$SERVER: [${SV.INFO}]      TXD was previously set to inputport(1) of UsbPort")
    // Insert breakpoint here:
    KeyReceiver.rcv()
}