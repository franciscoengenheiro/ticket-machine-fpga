package ticketmachine.software

fun main() {
    // Initializes HAL object
    HAL.init()
    // Initializes SerialEmitter object
    SerialEmitter.init()
    // Initializes LCD module
    LCD.init()
    // Initializes KeyReceiver object
    KeyReceiver.init()
    // Initializes KeyBoardReader object
    KBD.init()
    // Initializes TUI object
    TUI.init()
    println("$SERVER: [${SV.INIT}]      Initializing LCD module...")
    while (true) {
        // Initialize mutable variables to store user input
        var input: String
        var align: String
        var inputLine: Int
        var test: Int
        println("$SERVER: [${SV.INFO}]      Avalaible Tests: ")
        println("$SERVER: [${SV.INFO}]      (0) - Write from KBD to LCD (up to 32 inputs)")
        println("$SERVER: [${SV.INFO}]      (1) - Align Text on LCD")
        // Prompts the user to choose a test framework
        do {
            test = readInt("$SERVER: [${SV.REQUEST}]   Test: ")
        } while ((test != 0) && (test != 1))
        println("\n$SERVER: [${SV.START}]     Initializing test framework...")
        // Checks what test was chosen by the user
        when (test) {
            // Write from KBD to LCD (up to 32 inputs)
            0 -> {
                println("$SERVER: [${SV.INFO}]      Clearing LCD previous written input...")
                LCD.clear()
                println("$SERVER: [${SV.INFO}]      The default timeout for every key input is 5 seconds")
                // Initialize a mutable variable to store the input characters up to 32 (2 lines each with 16)
                for (i in 1..32) {
                    // Wait for the key
                    val key: Char = KBD.waitKey(DELAY_5S)
                    // Evaluate if a key was pressed within specified time
                    if (key != KBD.NONE.toChar()) {
                        // Move to lower line
                        if (i == 17) {
                            LCD.moveCursorToLineStart(LCD.Line.LOWER)
                        }
                        // Write key on LCD
                        LCD.write(key)
                    } else {
                        println("\n$SERVER: [${SV.OUTPUT}]    No key was pressed within specified time\n")
                        break
                    }
                }
            }
            // Align Text on LCD
            1 -> {
                println("$SERVER: [${SV.INFO}]      Clearing LCD previous written input...")
                LCD.clear()
                println("$SERVER: [${SV.INFO}]      Input has a character limitation of 16 with spaces included")
                // Prompts the user to write input
                do {
                    input = readString("$SERVER: [${SV.REQUEST}]   Input: ")
                } while (input.length > CHARACTER_LIMIT)
                println("$SERVER: [${SV.INFO}]      Avalaible Alignments: ")
                println("$SERVER: [${SV.INFO}]      -> Left ")
                println("$SERVER: [${SV.INFO}]      -> Middle ")
                println("$SERVER: [${SV.INFO}]      -> Right ")
                // Prompts the user to choose an alignment
                do {
                    align = readString("$SERVER: [${SV.REQUEST}]   Align: ")
                } while ((align != "Left") && (align != "Middle") && ((align != "Right")))
                println("$SERVER: [${SV.INFO}]      Avalaible Lines: ")
                println("$SERVER: [${SV.INFO}]      (0) - Upper ")
                println("$SERVER: [${SV.INFO}]      (1) - Lower ")
                // Prompts the user to choose a line
                do {
                    inputLine = readInt("$SERVER: [${SV.REQUEST}]   Line: ")
                } while ((inputLine != 0) && (inputLine != 1))
                println("\n$SERVER: [${SV.INFO}]      Processing data...")
                println("$SERVER: [${SV.INFO}]      Sending data to Serial Emitter...")
                var line: LCD.Line = LCD.Line.UPPER
                // Evaluates user chosen line
                when (inputLine) {
                    0 -> line = LCD.Line.UPPER
                    1 -> line = LCD.Line.LOWER
                }
                // Evaluates user chosen alignment
                when (align) {
                    "Left" -> TUI.alignStringPos(TUI.Position.LEFT, input, line)
                    "Middle" -> TUI.alignStringPos(TUI.Position.MIDDLE, input, line)
                    "Right" -> TUI.alignStringPos(TUI.Position.RIGHT, input, line)
                }
                println("$SERVER: [${SV.INFO}]      Writing input with the specified alignment on LCD module...")
            }
        }
        println("$SERVER: [${SV.END}]       Closing test framework...\n")
    }
}