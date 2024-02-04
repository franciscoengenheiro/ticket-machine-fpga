package ticketmachine.software

import isel.leic.utils.Time
import kotlin.system.exitProcess

// Time constant values (in ms)
const val DELAY_250MS: Long = 250
const val DELAY_500MS: Long = 500
const val DELAY_1S: Long = 1000
const val DELAY_2S: Long = 2000
const val DELAY_5S: Long = 5000

// Implements Ticket Machine App Interface
object App {
    // Constant values
    private const val EMPTY_CHAR: Char = ' '
    private const val ZERO_CODE: Int = '0'.code
    private const val FIVE_CODE: Int = '5'.code
    const val VENDING_SET: Int = 1 // Represents a specific set of CGRAM custom characters
    const val M_SET: Int = 2 // Represents a specific set of CGRAM custom characters
    // This enum class will help declare which mode Ticket Machine App is currently at
    enum class Mode {
        VENDING, // Vending Mode
        M, // Maintenance mode
    }
    // This enum class will help declare which state Ticket Machine App is currently at
    enum class State {
        /******************************************************************************
         *  Mode VENDING Avalaible States
         ******************************************************************************/
        HOMESCREEN, // Represents the default state for this mode
                    // Displays a default message before a purchase process is initiated by the user
        PURCHASE, // Prompts the user to choose a station to buy a ticket to. Stations can be searched
                  // by its corresponding ID or with KBD.SELECTION mode toggled
        PAYMENT, // Allows the user to buy the selected ticket and choose between a one-way or a two-way ticket,
                 // and the price reflects the change in this last selection
        PRINT, // Prints selected ticket and displays important information for the user
        /******************************************************************************
         *  Mode M Avalaible States
         ******************************************************************************/
        SHOW, // Represents the default state for this mode
              // Shows all avalaible Maintenance Modes to select from on LCD
        TICKET_TEST, // Allows the consultation and sale of a ticket without inserting any of its corresponding
                     // currencies and without this transaction being counted as an acquisition
        TICKET_CNT, // Allows the visualization of every ticket printed for a specified station and the
                    // listing of all stations can be done with KBD.SELECTION mode toggled
        COINS_CNT, // Allows the visualization of every coin counter and the listing of all coin
                   // counters can be done with KBD.SELECTION mode toggled
        RESET, // Sets the coins and ticket counters to zero, starting a new counting cycle
        SHUTDOWN // System shutdown command. Writes all information regarding coin amount stored
                 // and tickets sold in their corresponding files
    }
    // Initialize a mutable variable to represent the current selected Mode of the Ticket Machine App
    var currentMode: Mode = Mode.VENDING
    // Initialize a mutable variable to represent the current state of the Ticket Machine App
    var currentState: State = State.HOMESCREEN
    // Initialize a mutable variable to represent the current Station ID
    var currentStationID: Int = 0
    // Initialize a mutable variable to represent the current Coin ID
    var currentCoinID: Int = 0
    // Initialize a boolean variable to represent roundTrip selection:
    // RoundTrip identifies if a ticket is: a two-way ticket (true) or a one-way ticket (false)
    var roundTrip: Boolean = false
    // Initialize a mutable variable to represent the last key pressed by the user
    var lastKeyPressed: Char = EMPTY_CHAR
    // Initialize a mutable variable to represent the current ticket left to pay price
    var ticketleftToPayPrice: Int = 0
    // Initialize a mutable variable to represent the current total true value of the coins inserted by the user
    var coinAmount: Int = 0
    // Initializes this class
    fun init() {
        // Initializes HAL object
        HAL.init()
        // Initializes SerialEmitter object
        SerialEmitter.init()
        // Initializes KeyReceiver object
        KeyReceiver.init()
        // Initializes KeyBoardReader object
        KBD.init()
        // Initializes LCD module
        LCD.init()
        // Initializes TicketDispenser object
        TicketDispenser.init()
        // Initializes TUI object
        TUI.init()
        // Initializes CoinAcceptor object
        CoinAcceptor.init()
        // Initializes CoinDeposit object
        CoinDeposit.init()
        // Initializes Stations object
        Stations.init()
        // Initializes M object
        M.init()
        // Sets default Ticket Machine App mode to VENDING
        currentMode = Mode.VENDING
        // Sets default Ticket Machine App state to HOMESCREEN
        currentState = State.HOMESCREEN
        // Disables LCD cursor
        LCD.enableCursor(false)
        // Displays starting screen
        TUI.displayStartingScreen()
    }
    /*****************************************************************
     * Display functions
     *****************************************************************/
    // Function to display the current station information on LCD, depending on the current App mode
    // and a boolean to indicate if the price is shown or not
    fun displayCurrentStationInfo(mode: Mode = Mode.VENDING, price: Boolean = true) {
        // Clears LCD previous content
        LCD.clear()
        // Initializes a variable to represent the current station
        val station = Stations.stationsInfo[currentStationID]
        TUI.alignStringPos(TUI.Position.MIDDLE, station.name, LCD.Line.UPPER)
        // Draws station ID in the bottom left corner
        TUI.drawStationID(stationID = currentStationID)
        if (mode == Mode.M && !price) {
            // Draws a ticket icon in the upper right corner
            LCD.cursor(0, 15)
            LCD.writeCGRAMchar(LCD.TICKET_ICON)
            // Initializes a variable to represent the current ticket count for this station
            val ticketCount: Int = station.currentTicketCount
            TUI.alignStringPos(TUI.Position.RIGHT, "$ticketCount", LCD.Line.LOWER)
        } else {
            // Draws ticket price in the bottom right corner of the screen
            LCD.cursor(1, 11)
            TUI.drawTicketPrice(station.price)
        }
        TUI.drawKBDMode()
    }
    // Function to display the current coin selected information on LCD
    fun displayCurrentCoinInfo() {
        // Clears LCD previous content
        LCD.clear()
        LCD.cursor(0, 5)
        // Initializes a variable to represent the current selected coin type
        val coinType = CoinDeposit.storedCoins[currentCoinID].type
        // Draws selected coin in the middle of the upper line
        TUI.drawTicketPrice(coinType)
        // Draws a coin in the upper right corner
        LCD.cursor(0, 15)
        LCD.writeCGRAMchar(LCD.COIN_ICON)
        // Draws coin ID in the bottom left corner
        TUI.drawCoinID(coinID = currentCoinID)
        // Initializes a variable to represent the current selected coin counter
        val coinCount: Int = CoinDeposit.storedCoins[currentCoinID].currentCount
        TUI.alignStringPos(TUI.Position.RIGHT, "$coinCount", LCD.Line.LOWER)
        TUI.drawKBDMode()
    }
    // Function to display an abort purchase message
    fun displayAbortedPurchaseScreen() {
        // Clears LCD previous content
        LCD.clear()
        // Displays message
        TUI.alignStringPos(TUI.Position.MIDDLE, "Vending", LCD.Line.UPPER)
        TUI.alignStringPos(TUI.Position.MIDDLE, "Was aborted", LCD.Line.LOWER)
        // Returns inserted coins to the user
        CoinAcceptor.ejectCoins()
    }
    // Function to display Payment information on LCD
    fun displayPaymentScreen(mode: Mode) {
        // Clears LCD previous content
        LCD.clear()
        // Initializes a variable to represent the current selected station
        val station = Stations.stationsInfo[currentStationID]
        TUI.alignStringPos(TUI.Position.MIDDLE, station.name, LCD.Line.UPPER)
        // Draws current roundTrip indication in the bottom left corner
        TUI.drawRoundTripOnLCD(roundTrip = roundTrip)
        if (mode == Mode.VENDING) {
            LCD.cursor(1, 5)
            // Initializes a variable to represent the price to be paid by the user
            val price = if (roundTrip) {
                // Double price variable value
                station.price * 2
            } else {
                station.price
            }
            // Update ticketleftToPayPrice
            ticketleftToPayPrice = price - coinAmount
            // Draw left to pay ticket price in the middle of the lower line
            TUI.drawTicketPrice(value = ticketleftToPayPrice)
        } else {
            TUI.alignStringPos(TUI.Position.MIDDLE, "*-To Print", LCD.Line.LOWER)
        }
    }
    // Function to display Ticket Printing information on LCD
    fun displayPrintScreen(mode: Mode, ticketCollected: Boolean) {
        // Evaluates if the ticket was collected
        if (!ticketCollected) {
            // Clears LCD previous content
            LCD.clear()
            // Initializes a variable to represent the current selected station
            val station = Stations.stationsInfo[currentStationID]
            // Display message
            TUI.alignStringPos(TUI.Position.MIDDLE, "Dst: ${station.name}", LCD.Line.UPPER)
            TUI.alignStringPos(TUI.Position.MIDDLE, "Collect Ticket", LCD.Line.LOWER)
        } else {
            // Clears LCD previous content
            LCD.clear()
            // First display message
            TUI.alignStringPos(TUI.Position.MIDDLE, "Printing", LCD.Line.UPPER)
            TUI.alignStringPos(TUI.Position.MIDDLE, "Receipt", LCD.Line.LOWER)
            Time.sleep(DELAY_2S)
            // Second display message
            TUI.alignStringPos(TUI.Position.MIDDLE, "Consult Train", LCD.Line.UPPER)
            TUI.alignStringPos(TUI.Position.LEFT, " Departures ", LCD.Line.LOWER)
            LCD.writeCGRAMchar(LCD.DEPARTURE_ICON)
            LCD.writeCGRAMchar(LCD.DEPARTURE_ICON)
            LCD.writeCGRAMchar(LCD.DEPARTURE_ICON)
            Time.sleep(DELAY_2S)
            // Update state depending on current App mode
            currentState = if (mode == Mode.M) {
                State.SHOW
            } else {
                State.HOMESCREEN
            }
        }
    }
    // Function to display a query request screen depending on the given state
    fun displayQueryRequestScreen(state: State) {
        // Clears LCD previous content
        LCD.clear()
        // Draws a lock custom character on the top right side of LCD to indicate M Mode is active
        TUI.drawMModeLock()
        // Writes display message based on the given state
        if (state == State.RESET) {
            TUI.alignStringPos(TUI.Position.LEFT, "Reset Counters", LCD.Line.UPPER)
            TUI.alignStringPos(TUI.Position.LEFT, "5-Yes Other-No", LCD.Line.LOWER)
        } else if (state == State.SHUTDOWN) {
            TUI.alignStringPos(TUI.Position.MIDDLE, "Shutdown", LCD.Line.UPPER)
            TUI.alignStringPos(TUI.Position.MIDDLE, "5-Yes Other-No", LCD.Line.LOWER)
        }
    }
    /*****************************************************************
     * Auxiliary functions
     *****************************************************************/
    // Function to reset App variables before starting a new state
    fun resetVariables() {
        // Sets KBD mode to NUMERIC
        KBD.currentState = KBD.State.NUMERIC
        // Sets currentStationID counter to first station ID
        currentStationID = Stations.firstStationID
        // Sets currentCoinID counter to first coin ID
        currentCoinID = CoinDeposit.firstCoinID
        // Sets roundTrip default choice to false (One-way)
        roundTrip = false
        // Resets user input coin amount
        coinAmount = 0
        // Resets ticket price value
        ticketleftToPayPrice = 0
    }
    // Function to enable currentCoinID variable to be updated if the key received actual value is a valid CID
    private fun updateCurrentCoinID(key: Char) {
        // Initialize a variable to place in a string the given key
        val value = key.toString()
        // Evaluates if this value is within the accepted coin IDs
        if (value.toInt() in CoinDeposit.firstCoinID..CoinDeposit.lastCoinID) {
            // Update currentCoinID with an actual value
            currentCoinID = value.toInt()
        }
    }
    // Function to evaluate a key according to the current App state
    fun evaluateKey(key: Char) {
        when (currentState) {
            State.PURCHASE -> {
                when (key) {
                    '2' -> {
                        // Evaluates current KBD state
                        when (KBD.currentState) {
                           KBD.State.NUMERIC -> {
                               // Evaluates last key pressed:
                               if (lastKeyPressed == EMPTY_CHAR) {
                                   // Initializes a variable to place in a string the given key
                                   val value = key.toString()
                                   // Updates currentStationID with an actual value
                                   currentStationID = value.toInt()
                               } else {
                                   // Initializes a variable to store both keys as a string
                                   val num: String = lastKeyPressed.toString() + key
                                   // Updates currentStationID with an actual value
                                   currentStationID = num.toInt()
                                   // Updates lastKeyPressed
                                   lastKeyPressed = EMPTY_CHAR
                               }
                           }
                           KBD.State.SELECTION -> {
                               if (currentStationID == Stations.lastStationID) {
                                   // If the currentStation counter reaches the last station correspondent ID it
                                   // resets to the first station ID
                                   currentStationID = Stations.firstStationID
                               } else {
                                   // Increases currentStation counter
                                   currentStationID++
                               }
                           }
                        }
                    }
                    '8' -> {
                        // Evaluates current KBD state
                        when (KBD.currentState) {
                            KBD.State.NUMERIC -> {
                                // Initialize a variable to place in a string the given key
                                val value = key.toString()
                                // Update currentStationID with an actual value
                                currentStationID = value.toInt()
                                // Update lastKeyPressed
                                lastKeyPressed = EMPTY_CHAR
                            }
                            KBD.State.SELECTION -> {
                                if (currentStationID == Stations.firstStationID) {
                                    // If the currentStationID counter reaches the first station correspondent ID it
                                    // resets to the last station ID
                                    currentStationID = Stations.lastStationID
                                } else {
                                    // Decreases currentStation counter
                                    currentStationID--
                                }
                            }
                        }
                    }
                    '1' -> {
                        // If KBD NUMERIC is selected:
                        if (KBD.currentState == KBD.State.NUMERIC) {
                            // Evaluates last key pressed:
                            if (lastKeyPressed == EMPTY_CHAR) {
                                // Initializes a variable to place in a string the given key
                                val value = key.toString()
                                // Updates currentStationID with an actual value
                                currentStationID = value.toInt()
                                // Updates lastKeyPressed
                                lastKeyPressed = key
                            } else {
                                // Initializes a variable to store both keys as a string
                                val num: String = lastKeyPressed.toString() + key
                                // Updates currentStationID with an actual value
                                currentStationID = num.toInt()
                                // Updates lastKeyPressed
                                lastKeyPressed = EMPTY_CHAR
                            }
                        }
                    }
                    else -> {
                        // If KBD NUMERIC is selected
                        if (KBD.currentState == KBD.State.NUMERIC) {
                            // Evaluates last key pressed:
                            if (lastKeyPressed == EMPTY_CHAR) {
                                // Initializes a variable to place in a string the given key
                                val value = key.toString()
                                // Updates currentStationID with an actual value
                                currentStationID = value.toInt()
                                // Updates lastKeyPressed
                                lastKeyPressed = EMPTY_CHAR
                            } else if (key.code in ZERO_CODE..FIVE_CODE) {
                                // Initializes a variable to store both keys as a string
                                val num: String = lastKeyPressed.toString() + key
                                // Updates currentStationID with an actual value
                                currentStationID = num.toInt()
                                // Updates lastKeyPressed
                                lastKeyPressed = EMPTY_CHAR
                            }
                        }
                    }
                }
            }
            State.SHOW -> {
                // Updates currentState
                currentState = when (key) {
                    '1' -> State.TICKET_TEST
                    '2' -> State.TICKET_CNT
                    '3' -> State.COINS_CNT
                    '4' -> State.RESET
                    '5' -> State.SHUTDOWN
                    else -> State.SHOW
                }
            }
            State.COINS_CNT -> {
                when (key) {
                    '2' -> {
                        // Evaluates current KBD state
                        when (KBD.currentState) {
                            KBD.State.NUMERIC -> {
                                // Updates Current Coin ID if given key actual value is a valid CID
                                updateCurrentCoinID(key = key)
                            }
                            KBD.State.SELECTION -> {
                                if (currentCoinID == CoinDeposit.lastCoinID) {
                                    // If the currentCoinID counter reaches the last coin correspondent
                                    // ID it resets to the first coin ID
                                    currentCoinID = CoinDeposit.firstCoinID
                                } else {
                                    // Increases currentCoinID counter
                                    currentCoinID++
                                }
                            }
                        }
                    }
                    '8' -> {
                        when (KBD.currentState) {
                            KBD.State.NUMERIC -> {
                                // Updates Current Coin ID if given key actual value is a valid CID
                                updateCurrentCoinID(key = key)
                            }
                            KBD.State.SELECTION -> {
                                if (currentCoinID == CoinDeposit.firstCoinID) {
                                    // If the currentCoinID counter reaches the first coin correspondent
                                    // ID it resets to the last coin ID
                                    currentCoinID = CoinDeposit.lastCoinID
                                } else {
                                    // Decreases currentCoinID counter
                                    currentCoinID--
                                }
                            }
                        }
                    }
                    else -> {
                        // Updates Current Coin ID if given key actual value is a valid CID
                        updateCurrentCoinID(key = key)
                    }
                }
            }
            State.RESET -> {
                when (key) {
                    '5' -> {
                        // Displays a message letting the user know the reset is yet to be completed
                        TUI.displayResetScreen(reset = false)
                        // Resets every station ticket counter
                        Stations.resetTicketCounters()
                        // Resets every coin type counter
                        CoinDeposit.resetCoinCounters()
                        // Displays a message letting the user know the reset has been completed
                        TUI.displayResetScreen(reset = true)
                        // Updates currentState
                        currentState = State.SHOW
                    }
                    else -> currentState = State.SHOW // Updates currentState
                }
            }
            State.SHUTDOWN -> {
                when (key) {
                    '5' -> {
                        // Displays a message letting the user know the shutdown process is yet to be completed
                        TUI.displayShutdownScreen(dataSent = false)
                        // Writes run-time modifications to Stations file
                        Stations.writeFile()
                        // Writes run-time modifications to CoinDeposit file
                        CoinDeposit.writeFile()
                        // Displays a message letting the user know the shutdown process has been completed
                        TUI.displayShutdownScreen(dataSent = true)
                        // Closes Application
                        exitProcess(0)
                    }
                    else -> currentState = State.SHOW
                }
            }
            // If other state calls this function, no changes are made
            else -> {}
        }
    }
}