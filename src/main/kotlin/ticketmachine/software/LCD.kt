package ticketmachine.software

import isel.leic.utils.Time

// Writes to the LCD module using the 8 bit interface
object LCD {
    // Constant values
    private const val RS_VALUE = 1
    private const val DDRAM_DEFAULT_ADDR = 0x80
    private const val FIRST_ADDRESS_LOWER_LINE = 0x40
    private const val FIRST_COLUMN = 0
    // LCD initialization command values
    private const val INIT_SET = 0x30
    private const val INIT_SET_2 = 0x38
    private const val DISPLAY_OFF = 0x08
    private const val DISPLAY_CLEAR = 0x01
    private const val ENTRY_MODE_SET = 0x06 // 0x07 (To Enable S (LSB) Bit for Display Shift)
    // LCD command values
    private const val CURSOR_OFF = 0x0C
    private const val CURSOR_ON = 0x0F
    private const val DISPLAY_ON = 0x0C
    // CGRAM starting addresses (64 bytes (8 avalaible cells each with 8 bytes) of internal memory which means 8
    // starting addresses for a max of 8 custom characters that can be stored at the same time in this memory)
    data class CGRAM_CELL(val addr: Int, val cell_n: Int)
    private val CGRAM_CELLS: List<CGRAM_CELL> = listOf(
        CGRAM_CELL(0x40, 0),
        CGRAM_CELL(0x48, 1),
        CGRAM_CELL(0x50, 2),
        CGRAM_CELL(0x58, 3),
        CGRAM_CELL(0x60, 4),
        CGRAM_CELL(0x68, 5),
        CGRAM_CELL(0x70, 6),
        CGRAM_CELL(0x78, 7)
    )
    // CGRAM character codes (Set #1)
    const val EURO_SIGN: Int = 0
    const val DOWNWARDS_ARROW: Int = 1
    const val UPWARDS_ARROW: Int = 2
    const val TRAIN_ICON: Int = 3
    const val RAIL_ICON: Int = 4
    const val TICKET_ICON: Int = 5
    const val COIN_ICON: Int = 6
    const val DEPARTURE_ICON: Int = 7
    // CGRAM character codes (Set #2)
    const val LOCK_ICON: Int = 0
    const val LOCKOPEN_ICON: Int = 1
    const val CONNECTOR_ICON: Int = 2
    const val OUTLET_ICON: Int = 3
    const val LEFT_PROGRESSBAR_ICON: Int = 4
    const val MIDDLE_FULL_PROGRESSBAR_ICON: Int = 5
    const val MIDDLE_EMPTY_PROGRESSBAR_ICON: Int = 6
    const val RIGHT_PROGRESSBAR_ICON: Int = 7
    // CGROM character codes
    const val RIGHT_ARROW = 0x7E
    const val LEFT_ARROW  = 0x7F
    const val LEFT_PARANTHESIS = 0x5B
    const val RIGHT_PARANTHESIS = 0x5D
    // Time values (in ms)
    private const val DELAY_5MS: Long = 5
    private const val DELAY_1MS: Long = 1
    // Custom Characters Patterns for CGRAM set #1:
    // Euro Sign (€)
    private val euroSignPatternList: List<Int> =
        listOf(0b00110, 0b01001, 0b11100, 0b01000, 0b11100, 0b01001, 0b00110, 0b00000)
    // Downwards Arrow
    private val downwardsArrowPatternList: List<Int> =
        listOf(0b00100, 0b00100, 0b00100, 0b00100, 0b10101, 0b01110, 0b00100, 0b00000)
    // Upwards Arrow
    private val upwardsArrowPatternList: List<Int> =
        listOf(0b00100, 0b01110, 0b10101, 0b00100, 0b00100, 0b00100, 0b00100, 0b00000)
    // Train Icon
    private val trainIconPatternList: List<Int> =
        listOf(0b11111, 0b10001, 0b10001, 0b11111, 0b10101, 0b11111, 0b01010, 0b11111)
    // Rail Icon
    private val railIconPatternList: List<Int> =
        listOf(0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b11111, 0b10101)
    // Ticket Icon
    private val ticketIconPatternList: List<Int> =
        listOf(0b10111, 0b11001, 0b11101, 0b10001, 0b10111, 0b11001, 0b10011, 0b11101)
    // Coin Icon
    private val coinIconPatternList: List<Int> =
        listOf(0b01110, 0b10001, 0b10011, 0b10011, 0b10011, 0b10011, 0b10101, 0b01110)
    // Departure Icon
    private val departureIconPatternList: List<Int> =
        listOf(0b11111, 0b11000, 0b00111, 0b00000, 0b11111, 0b11000, 0b00111, 0b00000)
    // Custom Characters Patterns for CGRAM set #2:
    // Lock Icon
    private val lockIconPatternList: List<Int> =
        listOf(0b01110, 0b10001, 0b10001, 0b11111, 0b11011, 0b11011, 0b11111, 0b00000)
    // Lock Open Icon
    private val lockOpenIconPatternList: List<Int> =
        listOf(0b01110, 0b10000, 0b10001, 0b11111, 0b11011, 0b11011, 0b11111, 0b00000)
    // Connector Open Icon
    private val connectorIconPatternList: List<Int> =
        listOf(0b01010, 0b01010, 0b11111, 0b10001, 0b11011, 0b01110, 0b00100, 0b00100)
    // Connector Open Icon
    private val outletIconPatternList: List<Int> =
        listOf(0b00100, 0b00100, 0b00100, 0b00100, 0b01110, 0b11111, 0b10101, 0b10101)
    // Left Progress Bar Icon
    private val leftProgressBarIconPatternList: List<Int> =
        listOf(0b01111, 0b11000, 0b10011, 0b10111, 0b10111, 0b10011, 0b11000, 0b01111)
    // Middle Progress Full Bar Icon
    private val middleProgressBarFullIconPatternList: List<Int> =
        listOf(0b11111, 0b00000, 0b11011, 0b11011, 0b11011, 0b11011, 0b00000, 0b11111)
    // Middle Progress Empty Bar Icon
    private val middleProgressBarEmptyIconPatternList: List<Int> =
        listOf(0b11111, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b11111)
    // Right Progress Bar Icon
    private val rightProgressBarFullIconPatternList: List<Int> =
        listOf(0b11110, 0b00011, 0b11001, 0b11101, 0b11101, 0b11001, 0b00011, 0b11110)
    // This enum class will help declare for which line we want to send data to
    enum class Line {
        UPPER,
        LOWER
    }
    // Writes a byte of command/data to the LCD module
    private fun writeByte(rs: Boolean, data: Int) {
        /** RS stands for register select:
            0 - IR (Instruction Register)
            1 - DR (Data Register)
        */
        if (rs) {
            // Sends a frame to the Serial Emitter with RS set to one
            SerialEmitter.send(addr = SerialEmitter.Destination.LCD, data = (data.shl(1)).or(RS_VALUE))
        } else {
            // Sends a frame to the Serial Emitter with RS set to zero
            SerialEmitter.send(addr = SerialEmitter.Destination.LCD, data = data.shl(1))
        }
    }
    // Writes a command to the LCD module
    private fun writeCMD(data: Int) {
        writeByte(false, data)
    }
    // Writes data to the LCD module
    private fun writeDATA(data: Int) {
        writeByte(true, data)
    }
    // Sends initialization sequence to the LCD module
    fun init() {
        /**
          *  INITIALIZE PROCESS
          *   7   6   5   4   3   2   1   0 (LSB)
          *  DB7 DB6 DB5 DB4 DB3 DB2 DB1 DB0
          *   0   0   1   1   *   *   *   *     FUNCTION SET
          *  -----WAIT MORE THAN 4.1 MS-----
          *   0   0   1   1   *   *   *   *     FUNCTION SET
          *  -----WAIT MORE THAN 100 uS-----
          *   0   0   1   1   *   *   *   *     FUNCTION SET
          *  -------------------------------
          *   0   0   1   1   N   F   *   *     FUNCTION SET
          *   0   0   0   0   1   0   0   0     DISPLAY OFF
          *   0   0   0   0   0   0   0   1     DISPLAY CLEAR
          *   0   0   0   0   0   1  I/D  S     ENTRY MODE SET

          N = 1 (2 lines) / 0 (1 line)
          F = 1 (5x10 dots) / 0 (5x8 dots)
          I/D = 1 (Increments the DDRAM address by 1 when a character code is written into or read from DDRAM
              = 0 (Decrements, which means write in reverse order)
          S = 1 (Accompanies display shift)
        **/
        writeCMD(INIT_SET)
        //---WAIT MORE THAN 4.1 MS---
        Time.sleep(DELAY_5MS)
        writeCMD(INIT_SET)
        //---WAIT MORE THAN 100 uS---
        Time.sleep(DELAY_1MS)
        writeCMD(INIT_SET)
        //---------------------------
        writeCMD(INIT_SET_2)
        writeCMD(DISPLAY_OFF)
        writeCMD(DISPLAY_CLEAR)
        writeCMD(ENTRY_MODE_SET)
        //-----------Cursor----------
        writeCMD(CURSOR_ON)
        // Loads custom characters to CGRAM (set #2 by default)
        writeCGRAM(set = 2)
        // Sets DDRAM to address 0 since AC (Address Counter) was changed in the previous command
        // to a CGRAM address
        cursor(0,0)
    }
    // Writes a character on the current cursor position
    fun write(c: Char) {
        writeDATA(c.code)
    }
    // Writes a string in the current cursor position
    fun write(text: String) {
        /**
          * Function explanation:
          * Reads the string char by char and send them individually to write(char)
        **/
        text.forEach { write(it) }
    }
    // Writes a CGROM character in the current cursor position
    fun writeCGROMchar(addr: Int) {
        writeDATA(addr)
    }
    // Writes a CGRAM character in the current cursor position
    fun writeCGRAMchar(addr: Int) {
        writeDATA(addr)
    }
    // Sends a command to place the cursor at a specific position (‘line’:0..LINES-1 , ‘column’:0..COLS-1)
    fun cursor(line: Int, column: Int) {
        /**
          * Function explanation:
          * To access DDRAM, DB7 must be set to logical '1', so we need to add this
          * value to data before using writeCMD function
          * If line == 1 (lower line) that means the user wants to put the cursor in the lower line, so we need to
          * add 0x40 to the address cursor, since the first address of the lower line is 0x40.
        **/
        var data = column.or(DDRAM_DEFAULT_ADDR)
        if (line == Line.LOWER.ordinal) data = data.or(FIRST_ADDRESS_LOWER_LINE)
        writeCMD(data)
    }
    // Enables or disables cursor and cursor blinking on LCD
    fun enableCursor(status: Boolean) {
        if (status) {
            writeCMD(CURSOR_ON)
        } else {
            writeCMD(CURSOR_OFF)
        }
    }
    // Enables or disables LCD display
    private fun enableDisplay(status: Boolean) {
        if (status) {
            writeCMD(DISPLAY_ON)
        } else {
            writeCMD(DISPLAY_OFF)
        }
    }
    // Displays a new CGRAM custom character set
    fun displayNewCGRAMset(set: Int) {
        enableDisplay(status = false)
        writeCGRAM(set)
        enableDisplay(status = true)
    }
    // Sends a command to clear the LCD screen and places the cursor on the position (0,0)
    fun clear() {
        writeCMD(DISPLAY_CLEAR)
    }
    // Function to set a cursor to the start of a specified line
    fun moveCursorToLineStart(line: Line) {
        when (line) {
            Line.UPPER -> cursor(Line.UPPER.ordinal, FIRST_COLUMN)
            Line.LOWER -> cursor(Line.LOWER.ordinal, FIRST_COLUMN)
        }
    }
    // Function to delete text on LCD within a specified line and column range.
    fun deleteText(line: Line, col1: Int, col2: Int) {
        var str: String = ""
        // Create a string with length col2 - col1
        for (i in col1..col2) {
            str += " "
        }
        // Move cursor to specified location
        cursor(line.ordinal, col1)
        // Write on LCD
        write(str)
    }
    // Function to simulate LCD lower line shift
    fun simulateLowerLineShift() {
        Time.sleep(DELAY_1S)
        deleteText(Line.LOWER, 0, 15)
    }
    // Writes on CGRAM all created custom characters
    fun writeCGRAM(set: Int) {
        // Writes first set of custom characters
        if (set == 1) {
            loadEuroSign()
            loadDownwardsArrow()
            loadUpwardsArrow()
            loadTrainIcon()
            loadRailIcon()
            loadTicketIcon()
            loadCoinIcon()
            loadDepartureIcon()
        } else {
            loadLockIcon()
            loadLockOpenIcon()
            loadConnectorIcon()
            loadOutletIcon()
            loadLeftProgressBarIcon()
            loadMiddleFullProgressBarIcon()
            loadMiddleEmptyProgressBarIcon()
            loadRightProgressBarIcon()
        }
    }
    /*****************************************************************
     * First Set of custom CGRAM characters
     *****************************************************************/
    private fun loadEuroSign() {
        // Specify CGRAM address (Selected CGRAM cell #0)
        writeCMD(CGRAM_CELLS[0].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in euroSignPatternList) {
            writeDATA(pattern)
        }
    }
    private fun loadDownwardsArrow() {
        // Specify CGRAM address (Selected CGRAM cell #2)
        writeCMD(CGRAM_CELLS[1].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in downwardsArrowPatternList) {
            writeDATA(pattern)
        }
    }
    private fun loadUpwardsArrow() {
        // Specify CGRAM address (Selected CGRAM cell #3)
        writeCMD(CGRAM_CELLS[2].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in upwardsArrowPatternList) {
            writeDATA(pattern)
        }
    }
    private fun loadTrainIcon() {
        // Specify CGRAM address (Selected CGRAM cell #4)
        writeCMD(CGRAM_CELLS[3].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in trainIconPatternList) {
            writeDATA(pattern)
        }
    }
    private fun loadRailIcon() {
        // Specify CGRAM address (Selected CGRAM cell #4)
        writeCMD(CGRAM_CELLS[4].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in railIconPatternList) {
            writeDATA(pattern)
        }
    }
    private fun loadTicketIcon() {
        // Specify CGRAM address (Selected CGRAM cell #5)
        writeCMD(CGRAM_CELLS[5].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in ticketIconPatternList) {
            writeDATA(pattern)
        }
    }
    private fun loadCoinIcon() {
        // Specify CGRAM address (Selected CGRAM cell #6)
        writeCMD(CGRAM_CELLS[6].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in coinIconPatternList) {
            writeDATA(pattern)
        }
    }
    private fun loadDepartureIcon() {
        // Specify CGRAM address (Selected CGRAM cell #7)
        writeCMD(CGRAM_CELLS[7].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in departureIconPatternList) {
            writeDATA(pattern)
        }
    }
    /*****************************************************************
    * Second Set of custom CGRAM characters
    *****************************************************************/
    private fun loadLockIcon() {
        // Specify CGRAM address (Selected CGRAM cell #0)
        writeCMD(CGRAM_CELLS[0].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in lockIconPatternList) {
            writeDATA(pattern)
        }
    }
    private fun loadLockOpenIcon() {
        // Specify CGRAM address (Selected CGRAM cell #1)
        writeCMD(CGRAM_CELLS[1].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in lockOpenIconPatternList) {
            writeDATA(pattern)
        }
    }
    private fun loadConnectorIcon() {
        // Specify CGRAM address (Selected CGRAM cell #2)
        writeCMD(CGRAM_CELLS[2].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in connectorIconPatternList) {
            writeDATA(pattern)
        }
    }
    private fun loadOutletIcon() {
        // Specify CGRAM address (Selected CGRAM cell #3)
        writeCMD(CGRAM_CELLS[3].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in outletIconPatternList) {
            writeDATA(pattern)
        }
    }
    private fun loadLeftProgressBarIcon() {
        // Specify CGRAM address (Selected CGRAM cell #4)
        writeCMD(CGRAM_CELLS[4].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in leftProgressBarIconPatternList) {
            writeDATA(pattern)
        }
    }
    private fun loadMiddleFullProgressBarIcon() {
        // Specify CGRAM address (Selected CGRAM cell #5)
        writeCMD(CGRAM_CELLS[5].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in middleProgressBarFullIconPatternList) {
            writeDATA(pattern)
        }
    }
    private fun loadMiddleEmptyProgressBarIcon() {
        // Specify CGRAM address (Selected CGRAM cell #6)
        writeCMD(CGRAM_CELLS[6].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in middleProgressBarEmptyIconPatternList) {
            writeDATA(pattern)
        }
    }
    private fun loadRightProgressBarIcon() {
        // Specify CGRAM address (Selected CGRAM cell #7)
        writeCMD(CGRAM_CELLS[7].addr)
        // Write to CGRAM all patterns for this custom character
        for (pattern in rightProgressBarFullIconPatternList) {
            writeDATA(pattern)
        }
    }
}