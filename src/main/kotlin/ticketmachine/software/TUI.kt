package ticketmachine.software

import isel.leic.utils.Time

// Implements interaction between KBD and LCD objects
object TUI {
    // Constant values
    private const val MAX_COLUMNS: Int = 16
    // This enum class will help declare for which Position the user wants to align the text on LCD
    enum class Position {
        LEFT,
        MIDDLE,
        RIGHT,
    }
    fun init() {
        // This function is redundant, but it was kept in order to be coherent with the current
        // steps used in this application for OOP
    }
    // Function to align a string on the LCD module with a specified position and line
    fun alignStringPos(pos: Position, str: String, line: LCD.Line) {
        // Initialize a variable to store the length of the given string
        val length = str.length
        // Initialize a variable to store the new cursor column position
        val newcursor_xpos: Int
        // Evaluate given position
        when (pos) {
            Position.LEFT -> {
                // Move cursor to the chosen line start
                LCD.moveCursorToLineStart(line)
                // Write on the LCD the given String
                LCD.write(str)
            }
            Position.MIDDLE -> {
                // Calculate the new cursor position
                newcursor_xpos = ((MAX_COLUMNS - (length)) / 2)
                // Move cursor to the new position
                LCD.cursor(line.ordinal, newcursor_xpos)
                // Write on the LCD the given String
                LCD.write(str)
            }
            Position.RIGHT -> {
                // Calculate the new cursor position
                newcursor_xpos = MAX_COLUMNS - length
                // Move cursor to the new position
                LCD.cursor(line.ordinal, newcursor_xpos)
                // Write on the LCD the given String
                LCD.write(str)
            }
        }
    }
    /*****************************************************************
     * Display functions
     *****************************************************************/
    // Function to display a starting screen message and a progress bar upon initialization on LCD
    fun displayStartingScreen() {
        // First display message
        alignStringPos(Position.MIDDLE, "Ticket Machine", LCD.Line.UPPER)
        Time.sleep(DELAY_1S)
        alignStringPos(Position.MIDDLE, "Welcome", LCD.Line.LOWER)
        Time.sleep(DELAY_1S)
        // Clears LCD previous content
        LCD.clear()
        // Second display message
        alignStringPos(Position.MIDDLE, "Initializing", LCD.Line.UPPER)
        // Draws empty progress bar
        LCD.moveCursorToLineStart(LCD.Line.LOWER)
        LCD.writeCGRAMchar(LCD.LEFT_PROGRESSBAR_ICON)
        for (col in 1..10) {
            LCD.writeCGRAMchar(LCD.MIDDLE_EMPTY_PROGRESSBAR_ICON)
        }
        LCD.writeCGRAMchar(LCD.RIGHT_PROGRESSBAR_ICON)
        Time.sleep(DELAY_500MS)
        // Draws progress bar being filled in
        LCD.cursor(1, 1)
        for (col in 1..10) {
            Time.sleep(DELAY_250MS)
            alignStringPos(Position.RIGHT, "${col*10}%", LCD.Line.LOWER)
            LCD.cursor(LCD.Line.LOWER.ordinal, col)
            LCD.writeCGRAMchar(LCD.MIDDLE_FULL_PROGRESSBAR_ICON)
            if (col == 2) {
                Time.sleep(DELAY_1S)
            }
            if (col == 4) {
                Time.sleep(DELAY_500MS)
            }
            if (col == 7) {
                Time.sleep(DELAY_1S)
            }
            if (col == 8) {
                Time.sleep(DELAY_500MS)
            }
        }
        LCD.simulateLowerLineShift()
        alignStringPos(Position.MIDDLE, "Complete", LCD.Line.LOWER)
        Time.sleep(DELAY_1S)
    }
    // Function to display the home screen for the App on LCD
    fun displayHomeScreen() {
        // Clears LCD previous content
        LCD.clear()
        // Set App HomeScreen layout
        alignStringPos(Position.MIDDLE, "Ticket Machine", LCD.Line.UPPER)
        LCD.moveCursorToLineStart(LCD.Line.LOWER)
        LCD.writeCGRAMchar(LCD.RAIL_ICON)
        LCD.writeCGRAMchar(LCD.TRAIN_ICON)
        LCD.writeCGRAMchar(LCD.RAIL_ICON)
        alignStringPos(Position.MIDDLE, "Press #", LCD.Line.LOWER)
        LCD.cursor(1, 13)
        LCD.writeCGRAMchar(LCD.RAIL_ICON)
        LCD.writeCGRAMchar(LCD.TRAIN_ICON)
        LCD.writeCGRAMchar(LCD.RAIL_ICON)
    }
    // Function to display a printing ticket message on LCD
    fun displayPrintingTicketScreen() {
        // Clears LCD previous content
        LCD.clear()
        // Sets printing ticket message
        alignStringPos(Position.MIDDLE, "Printing", LCD.Line.UPPER)
        LCD.cursor(1, 4)
        LCD.write("Ticket ")
        LCD.writeCGRAMchar(LCD.TICKET_ICON)
    }
    // Function to display a reset message on LCD
    fun displayResetScreen(reset: Boolean) {
        // Evaluates given reset state
        if (!reset) {
            // Clears LCD previous content
            LCD.clear()
            // Sets reset counters message
            alignStringPos(Position.MIDDLE, "Resetting", LCD.Line.UPPER)
            LCD.cursor(1, 2)
            LCD.write("Counters")
            Time.sleep(DELAY_1S)
            for (i in 0..2) {
                LCD.write(".")
                Time.sleep(DELAY_1S)
            }
        } else {
            // Displays complete message
            LCD.simulateLowerLineShift()
            alignStringPos(Position.MIDDLE, "Complete", LCD.Line.LOWER)
            Time.sleep(DELAY_1S)
        }
    }
    // Function to display shutdown messages on LCD
    fun displayShutdownScreen(dataSent: Boolean) {
        // Evaluates given dataSent state
        if (!dataSent) {
            // Clears LCD previous content
            LCD.clear()
            // Sets shutdown screen before data was sent
            LCD.writeCGRAMchar(LCD.OUTLET_ICON)
            LCD.moveCursorToLineStart(LCD.Line.LOWER)
            LCD.writeCGRAMchar(LCD.CONNECTOR_ICON)
            alignStringPos(Position.MIDDLE, "Sending Data", LCD.Line.UPPER)
            LCD.cursor(0, 15)
            LCD.writeCGRAMchar(LCD.OUTLET_ICON)
            LCD.cursor(1, 15)
            LCD.writeCGRAMchar(LCD.CONNECTOR_ICON)
            alignStringPos(Position.MIDDLE, "to Server", LCD.Line.LOWER)
            Time.sleep(DELAY_2S)
        } else {
            // Sets shutdown screen after data was sent
            LCD.deleteText(LCD.Line.LOWER, 3, 11)
            alignStringPos(Position.MIDDLE, "Complete", LCD.Line.LOWER)
            Time.sleep(DELAY_1S)
            LCD.deleteText(LCD.Line.LOWER, 0, 0)
            LCD.deleteText(LCD.Line.LOWER, 15, 15)
            Time.sleep(DELAY_500MS)
            // Clears LCD previous content
            LCD.clear()
        }
    }
    // Function to display M starting screen on LCD
    fun displayMStartingScreen() {
        // Clears LCD previous content
        LCD.clear()
        // Sets M starting screen
        alignStringPos(Position.MIDDLE, "Maintenance", LCD.Line.UPPER)
        alignStringPos(Position.MIDDLE, "Mode", LCD.Line.LOWER)
        LCD.cursor(0, 15)
        LCD.writeCGRAMchar(LCD.LOCKOPEN_ICON)
        Time.sleep(DELAY_1S)
        drawMModeLock()
        Time.sleep(DELAY_1S)
    }
    // Function to display M complete screen on LCD
    fun displayMCompleteScreen() {
        // Clears LCD previous content
        LCD.clear()
        // Sets M complete screen
        alignStringPos(Position.MIDDLE, "Maintenance", LCD.Line.UPPER)
        alignStringPos(Position.MIDDLE, "Complete", LCD.Line.LOWER)
        drawMModeLock()
        Time.sleep(DELAY_1S)
        LCD.cursor(0, 15)
        LCD.writeCGRAMchar(LCD.LOCKOPEN_ICON)
        Time.sleep(DELAY_1S)
    }
    // Function to display Show State on LCD
    fun displayShowStateScreen() {
        alignStringPos(Position.LEFT, "Modes:", LCD.Line.UPPER)
        drawMModeLock()
    }
    /*****************************************************************
     * Draw on LCD functions
     *****************************************************************/
    // Function to draw an indication of the current selected KBD state on LCD
    fun drawKBDMode() {
        // Evaluates current KBD state
        when (KBD.currentState) {
            KBD.State.NUMERIC -> {
                // Erases KBD SELECTION state indication from LCD
                LCD.cursor(1, 2)
                LCD.write(":")
                LCD.deleteText(LCD.Line.LOWER, 3, 4)
            }
            KBD.State.SELECTION -> {
                LCD.cursor(1, 2)
                // Draws two arrows on the bottom left side to indicate KBD SELECTION mode is active
                LCD.writeCGRAMchar(LCD.UPWARDS_ARROW)
                LCD.writeCGRAMchar(LCD.DOWNWARDS_ARROW)
            }
        }
    }
    // Function to draw the current station ID on LCD
    fun drawStationID(stationID: Int) {
        LCD.moveCursorToLineStart(LCD.Line.LOWER)
        if (stationID in 0..9) {
            // Add a 0 to represent 2 digits for Station's IDs with only 1 digit
            // Example: "5" -> "05"
            LCD.write("0$stationID")
        } else {
            LCD.write("$stationID")
        }
    }
    // Function to draw the current coin ID on LCD
    fun drawCoinID(coinID: Int) {
        LCD.moveCursorToLineStart(LCD.Line.LOWER)
        LCD.write("0$coinID")
    }
    // Function to indicate current roundTrip selection on LCD
    fun drawRoundTripOnLCD(roundTrip: Boolean) {
        LCD.moveCursorToLineStart(LCD.Line.LOWER)
        // Evaluates roundTrip state
        if (!roundTrip) {
            LCD.writeCGRAMchar(LCD.UPWARDS_ARROW)
            LCD.write(" ")
        } else {
            LCD.writeCGRAMchar(LCD.UPWARDS_ARROW)
            LCD.writeCGRAMchar(LCD.DOWNWARDS_ARROW)
        }
    }
    // Function to convert given value in cents to price format in euros (€)
    // Example: value = 250 -> "2,50"
    private fun convertCentsToEuros(value: Int) = String.format("%.2f", value.toDouble()/100)
    // Function to draw the station correspondent ticket price on LCD
    fun drawTicketPrice(value: Int) {
        // Convert given value to a price format in euros (€)
        val price = convertCentsToEuros(value)
        // Draw price on LCD
        LCD.write(price)
        // Writes custom char (€) next to the price
        LCD.writeCGRAMchar(LCD.EURO_SIGN)
    }
    // Function to draw an indication that M Mode is activated on LCD
    fun drawMModeLock() {
        // Writes a lock icon custom character on the top right side of LCD to indicate M Mode is active
        LCD.cursor(LCD.Line.UPPER.ordinal, 15)
        LCD.writeCGRAMchar(LCD.LOCK_ICON)
    }
}