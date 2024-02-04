package ticketmachine.software

import isel.leic.utils.Time

const val CHARACTER_LIMIT = 16

fun main() {
    // Initializes HAL object
    HAL.init()
    // Initializes SerialEmitter object
    SerialEmitter.init()
    // Initializes LCD module
    LCD.init()
    println("$SERVER: [${SV.INIT}]      Initializing LCD module...")
    while (true) {
        // Initialize mutable variables to store user input
        var test: Int
        var input: String
        var line: Int
        var column: Int
        println("$SERVER: [${SV.INFO}]      Avalaible Tests: ")
        println("$SERVER: [${SV.INFO}]      (0) - Write Test")
        println("$SERVER: [${SV.INFO}]      (1) - Move Cursor Test")
        println("$SERVER: [${SV.INFO}]      (2) - Draw custom characters loaded on CGRAM")
        // Prompts the user to choose a test framework
        do {
            test = readInt("$SERVER: [${SV.REQUEST}]   Test: ")
        } while ((test != 0) && (test != 1) && (test != 2))
        println("\n$SERVER: [${SV.START}]     Initializing test framework...")
        // Checks what test was chosen by the user
        when (test) {
            // Write Test
            0 -> {
                println("$SERVER: [${SV.INFO}]      Clearing LCD previous written input...")
                LCD.clear()
                println("$SERVER: [${SV.INFO}]      Input has a character limitation of 16 with spaces included")
                // Prompts the user to write specified input
                do {
                    input = readString("$SERVER: [${SV.REQUEST}]   Input: ")
                } while ((input.length > CHARACTER_LIMIT))
                println("$SERVER: [${SV.INFO}]      Processing data...")
                println("$SERVER: [${SV.INFO}]      Sending data to Serial Emitter...")
                // Write on LCD the user input string
                LCD.write(input)
                println("$SERVER: [${SV.INFO}]      Writing input on the LCD module...")
            }
            // Move Cursor Test
            1 -> {
                println("$SERVER: [${SV.INFO}]      Clearing LCD previous written input...")
                LCD.clear()
                println("$SERVER: [${SV.INFO}]      Lines range from: 0 (upper) and 1 (lower)")
                // Prompts the user to write a line number
                do {
                    line = readInt("$SERVER: [${SV.REQUEST}]   Line: ")
                } while ((line != 0) && (line != 1))
                println("$SERVER: [${SV.INFO}]      Columns range from: 0 to 15")
                // Prompts the user to write a column number
                do {
                    column = readInt("$SERVER: [${SV.REQUEST}]   Column: ")
                } while (column < 0 || column > 15)
                println("$SERVER: [${SV.INFO}]      Processing data...")
                println("$SERVER: [${SV.INFO}]      Sending data to Serial Emitter...")
                // Sets LCD cursor to new location
                LCD.cursor(line, column)
                println("$SERVER: [${SV.INFO}]      Moving LCD cursor to specified location...")
            }
            // Draw custom characters loaded on CGRAM
            2 -> {
                println("$SERVER: [${SV.INFO}]      Clearing LCD previous written input...")
                LCD.clear()
                println("$SERVER: [${SV.INFO}]      Writing CGRAM stored custom characters on the LCD module...")
                // Displays CGRAM stored custom characters for Set 1
                LCD.writeCGRAM(1)
                for (i in 0..7) {
                    LCD.cursor(LCD.Line.UPPER.ordinal, i)
                    LCD.writeCGRAMchar(i)
                    Time.sleep(DELAY_1S)
                }
                // Displays CGRAM stored custom characters for Set 2
                LCD.writeCGRAM(2)
                for (i in 0..7) {
                    LCD.cursor(LCD.Line.LOWER.ordinal, i)
                    LCD.writeCGRAMchar(i)
                    Time.sleep(DELAY_1S)
                }
            }
        }
        println("$SERVER: [${SV.END}]       Closing test framework...\n")
    }
}


