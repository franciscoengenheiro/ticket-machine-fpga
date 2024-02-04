package ticketmachine.software

const val MAXINT_4BITS = 15 // Max integer with 4 bits

fun main() {
    // Initiate all objects
    HAL.init()
    SerialEmitter.init()
    TicketDispenser.init()
    while (true) {
        // Initialize mutable variables to store user input
        var test: Int
        var destinyID: Int
        var originID: Int
        var roundTrip: Int
        var collectTicket: Char
        println("$SERVER: [${SV.INFO}]      Avalaible Tests: ")
        println("$SERVER: [${SV.INFO}]      (0) - Specific Test ")
        println("$SERVER: [${SV.INFO}]      (1) - Brute Force Test ")
        // Prompts the user to choose a test framework
        do {
            test = readInt("$SERVER: [${SV.REQUEST}]   Test: ")
        } while ((test != 0) && (test != 1))
        println("$SERVER: [${SV.START}]     Initializing test framework...")
        // Checks what test was chosen by the user
        when (test) {
            // Specific Test
            0 -> {
                // Prompts the user to type a Destiny Station ID
                do {
                    destinyID = readInt("$SERVER: [${SV.REQUEST}]   Destiny Station ID: ")
                } while (destinyID > MAXINT_4BITS)
                // Prompts the user to type an Origin Station ID
                do {
                    originID = readInt("$SERVER: [${SV.REQUEST}]   Origin Station ID: ")
                } while (originID > MAXINT_4BITS)
                println("$SERVER: [${SV.INFO}]      Avalaible tickets to buy: ")
                println("$SERVER: [${SV.INFO}]      (0) - Two-way ticket ")
                println("$SERVER: [${SV.INFO}]      (1) - One-way ticket ")
                // Prompts the user to choose a ticket type
                do {
                    roundTrip = readInt("$SERVER: [${SV.REQUEST}]   Ticket: ")
                } while ((roundTrip != 0) && (roundTrip != 1))
                // Sends user data to TicketDispenser printer
                println("\n$SERVER: [${SV.INFO}]      Processing data...")
                println("$SERVER: [${SV.INFO}]      Sending data to Serial Emitter...")
                println("$SERVER: [${SV.INFO}]      Waiting for busy signal deactivation...")
                if (roundTrip == 0) {
                    TicketDispenser.print(destinyID, originID, true)
                } else {
                    TicketDispenser.print(destinyID, originID, false)
                }
                println("\n$SERVER: [${SV.INFO}]      Printing ticket...")
                // Prompts the user for specific input
                do {
                    collectTicket = readChar("$SERVER: [${SV.QUERY}]     Was the ticket retrieved by the client? (Y/N): ")
                } while (collectTicket != 'Y' && collectTicket != 'y')
            }
            // Brute Force Test
            1 -> {
                // Checks all avalaible combinations
                for (i in 0..15){
                    for (j in 0..15){
                        for (k in 0..1) {
                            val trip: Boolean = if(k == 0) true else false
                            TicketDispenser.print(destinyId = i, originId = j, roundTrip = trip)
                            println("$SERVER: [${SV.INFO}]      DestinyID:$i  OriginID:$j  roundTrip:$trip")
                        }
                    }
                }
            }
        }
        println("$SERVER: [${SV.END}]       Closing test framework...\n")
    }
}

