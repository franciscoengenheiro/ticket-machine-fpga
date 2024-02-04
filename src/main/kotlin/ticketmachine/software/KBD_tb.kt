package ticketmachine.software

fun main () {
    // Initializes HAL object
    HAL.init()
    // Initializes KeyReceiver object
    KeyReceiver.init()
    // Initializes KeyBoardReader object
    KBD.init()
    while (true) {
        // Initialize a mutable variable to store user input
        var timeout: Long
        println("$SERVER: [${SV.START}]    Initializing test framework...")
        // Single Key Output test
        println("$SERVER: [${SV.INFO}]     Set a timeout for for the key input")
        do {
            timeout = readLong("$SERVER: [${SV.REQUEST}]  Timeout(in ms): ")
        } while ((timeout <= 0))
        println("$SERVER: [${SV.INFO}]     Retrieving data from Key Transmitter...")
        println("$SERVER: [${SV.INFO}]     Processing data...")
        // Wait for the key
        val key: Char = KBD.waitKey(timeout)
        // Evaluate received key
        if (key != KBD.NONE.toChar()) {
            println("\n$SERVER: [${SV.OUTPUT}]   Pressed Key: $key")
        } else {
            println("\n$SERVER: [${SV.OUTPUT}]   No key was pressed within specified time")
        }
        println("\n$SERVER: [${SV.END}]      Closing test framework...\n")
    }
}