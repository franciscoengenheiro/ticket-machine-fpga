package ticketmachine.software

const val MAXINT_9BITS = 511 // Max integer with 9 bits

fun main() {
    // Initializes HAL object
    HAL.init()
    // Initializes SerialEmitter object
    SerialEmitter.init()
    // Enables Serial Emitter to print on console output
    SerialEmitter.EN_PRINT = true
    while (true) {
        // Initialize mutable variables to store user input
        var data: Int
        var addr: Int
        // Prompts the user to write data to send to the Serial Emitter
        do {
            data = readInt("$SERVER: [${SV.REQUEST}]  Write data to send as an integer: ")
        } while (data > MAXINT_9BITS)
        println("$SERVER: [${SV.INFO}]     Avalaible Modules to send data to: ")
        println("$SERVER: [${SV.INFO}]     (0) - LCD ")
        println("$SERVER: [${SV.INFO}]     (1) - TicketDispenser ")
        // Prompts the user to write which module to send data to
        do {
            addr = readInt("$SERVER: [${SV.REQUEST}]  Module: ")
        } while ((addr != 0) && (addr != 1))
        println("$SERVER: [${SV.START}]    Initializing test framework...\n")
        println("$SERVER: [${SV.INFO}]     Processing data...")
        println("$SERVER: [${SV.INFO}]     Sending data to Serial Emitter...")
        println("$SERVER: [${SV.INFO}]     Waiting for busy signal deactivation...\n")
        // Send the previous data to Serial Emitter
        if (addr == 0) {
            SerialEmitter.send(addr = SerialEmitter.Destination.LCD, data = data)
        } else {
            SerialEmitter.send(addr = SerialEmitter.Destination.TICKET_DISPENSER, data = data)
        }
        println("\n$SERVER: [${SV.END}]      Closing test framework...\n")
    }
}

