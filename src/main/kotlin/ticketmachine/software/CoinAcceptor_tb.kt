package ticketmachine.software

fun main () {
    // Initializes HAL object
    HAL.init()
    // Initializes Coin Acceptor object
    CoinAcceptor.init()
    while (true) {
        // Console log
        println("$SERVER: [${SV.INFO}]     Avalaible Tests: ")
        println("$SERVER: [${SV.INFO}]     (0) - Get coin value")
        println("$SERVER: [${SV.INFO}]     (1) - Eject coins")
        println("$SERVER: [${SV.INFO}]     (2) - Collect coins")
        // Initialize mutable variables to store user input
        var test: Int
        var input: Char
        var coin: Int
        // Prompts the user to choose a test framework
        do {
            test = readInt("$SERVER: [${SV.REQUEST}]  Test: ")
        } while ((test != 0) && (test != 1) && (test != 2))
        println("\n$SERVER: [${SV.START}]    Initializing test framework...")
        // Evaluate which test was chosen by the user
        when (test) {
            // Get coin value Test
            0 -> {
                println("$SERVER: [${SV.REQUEST}]  Insert coin amount on the board")
                // Prompts the user for specific input
                do {
                    input = readChar("$SERVER: [${SV.QUERY}]    Is the coin inserted? (Y/N): ")
                } while (input != 'Y' && input != 'y')
                // Retrieve inserted coin
                coin = CoinAcceptor.getCoinValue()
                println("$SERVER: [${SV.INFO}]     Retrieving data from Coin Acceptor Module...")
                println("$SERVER: [${SV.INFO}]     Processing data...")
                if (coin != 0) {
                    if (coin == 100 || coin == 200) {
                        println("\n$SERVER: [${SV.OUTPUT}]   Inserted coin was: ${coin/100}€\n")
                    } else {
                        println("\n$SERVER: [${SV.OUTPUT}]   Inserted coin was: $coin cents\n")
                    }
                    // Accept valid coin
                    CoinAcceptor.acceptCoin()
                    println("$SERVER: [${SV.INFO}]     COIN_ACCEPT LED should be lit on the board")
                } else {
                    println("\n$SERVER: [${SV.OUTPUT}]   Invalid coin amount\n")
                    println("$SERVER: [${SV.END}]      Closing test framework...\n")
                    continue
                }
                // Prompts the user for specific input
                do {
                    input = readChar("$SERVER: [${SV.QUERY}]    Is the coin insertion signal/switch disabled? (Y/N): ")
                } while (input != 'Y' && input != 'y')
                CoinAcceptor.acceptCoin()
                println("$SERVER: [${SV.INFO}]     COIN_ACCEPT LED should be disabled")
            }
            // Eject coins Test
            1 -> {
                CoinAcceptor.ejectCoins()
                println("$SERVER: [${SV.INFO}]     Ejecting stored coins in Coin Acceptor...")
            }
            // Collect coins Test
            2 -> {
                CoinAcceptor.collectCoins()
                println("$SERVER: [${SV.INFO}]     Collecting stored coins in Coin Acceptor...")
            }
        }
        println("$SERVER: [${SV.END}]      Closing test framework...\n")
    }
}