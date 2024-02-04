package ticketmachine.software

// Main function
fun main() {
    // Initializes Ticket Machine Application Software
    App.init()
    // Initialize a mutable variable to store user input key
    var key: Char
    // Initialize three mutable variables to store current values, in order to only update LCD
    // if these values are different from the actual correspondent ones, meaning a change was
    // made by the user
    var lastStationID: Int = 0
    var lastCoinAmount: Int = 0
    var lastCoinID: Int = 0
    // Initialize a boolean variable to indicate if price should or not appear on the LCD
    var showPrice: Boolean = false
    // Initialize a mutable variable to function has an index counter
    var cycleIndex: Int = 0
    // List of all avalaible Modes to show on LCD
    val listM_Modes: List<String> = listOf(
        "1-Ticket Test",
        "2-Ticket Cnt.",
        "3-Coins Cnt.",
        "4-Reset",
        "5-Shutdown"
    )
    // App state machine loop
    while (true) {
        // Evaluates current App Mode
        when (App.currentMode) {
            App.Mode.VENDING -> {
                // Evaluates current App State
                when (App.currentState) {
                    App.State.HOMESCREEN -> {
                        // Sets a new CGRAM custom character set
                        LCD.displayNewCGRAMset(App.VENDING_SET)
                        TUI.displayHomeScreen()
                        while (true) {
                            // Evaluates M state
                            if (!M.status()) {
                                // Wait for '#' key to be pressed
                                key = KBD.getKey()
                                // Start ticket purchase process if key '#' was pressed
                                if (key == '#') {
                                    // Reset variables
                                    App.resetVariables()
                                    // Reset lastStationID
                                    lastStationID = 0
                                    // Update current App state
                                    App.currentState = App.State.PURCHASE
                                    App.displayCurrentStationInfo()
                                    break
                                }
                            } else {
                                // Maintenance mode was activated:
                                // Sets a new CGRAM custom character set
                                LCD.displayNewCGRAMset(App.M_SET)
                                // Update current App mode
                                App.currentMode = App.Mode.M
                                break
                            }
                        }
                    }
                    App.State.PURCHASE -> {
                        // This check ensures the LCD is only written when the user changes to a different
                        // station ID than the one being currently displayed
                        if (lastStationID != App.currentStationID) {
                            App.displayCurrentStationInfo()
                        }
                        // Waits 5 seconds for a key to be pressed
                        key = KBD.waitKey(DELAY_5S)
                        when (key) {
                            '#' -> {
                                // A station was selected for a ticket purchase
                                App.displayPaymentScreen(mode = App.currentMode)
                                // Update current App state
                                App.currentState = App.State.PAYMENT
                            }
                            '*' -> {
                                // Switch KBD state if key '*' was pressed
                                when (KBD.currentState) {
                                    KBD.State.NUMERIC -> KBD.currentState = KBD.State.SELECTION
                                    KBD.State.SELECTION -> KBD.currentState = KBD.State.NUMERIC
                                }
                                TUI.drawKBDMode()
                            }
                            KBD.NONE.toChar() -> {
                                // Since no key was pressed, current App state is updated
                                App.currentState = App.State.HOMESCREEN
                            }
                            else -> {
                                // Updates lastStationID with the currentStationID value
                                lastStationID = App.currentStationID
                                // Evaluates a pressed key or the absence of one
                                App.evaluateKey(key)
                            }
                        }
                    }
                    App.State.PAYMENT -> {
                        // This check ensures the LCD is only written when the user inserts a valid coin
                        if (lastCoinAmount != App.coinAmount) {
                            App.displayPaymentScreen(mode = App.currentMode)
                        }
                        // Evaluates if ticket price was paid by the user
                        if (App.ticketleftToPayPrice <= 0) {
                            // Ticket price was paid in full
                            TUI.displayPrintingTicketScreen()
                            // Collects inserted coins and stores them in the Coin Deposit vault
                            CoinAcceptor.collectCoins()
                            // Sets inserted coins counters to zero
                            CoinDeposit.ejectInsertedCoins()
                            // Updates current App state
                            App.currentState = App.State.PRINT
                            continue
                        }
                        // Evaluates if a key was pressed
                        key = KBD.getKey()
                        if (key == '0') {
                            // Updates roundTrip value
                            App.roundTrip = !App.roundTrip
                            App.displayPaymentScreen(mode = App.currentMode)
                        } else if (key == '#') {
                            App.displayAbortedPurchaseScreen()
                            // Updates state since ticket purchase was aborted by the user
                            App.currentState = App.State.HOMESCREEN
                        }
                        // Updates lastCoinAmount
                        lastCoinAmount = App.coinAmount
                        // Initializes a variable to represent the actual value of the
                        // user inserted coin
                        val coin = CoinAcceptor.getCoinValue()
                        if (coin != 0) {
                            // Accepts coin if coin switch is still active (indicating a coin was inserted)
                            CoinAcceptor.acceptCoin()
                            // Adds inserted coin to Coin Deposit, but not the vault
                            CoinDeposit.add(coin)
                            // Updates coinAmount with the received coin
                            App.coinAmount += coin
                        }
                    }
                    App.State.PRINT -> {
                        App.displayPrintScreen(mode = App.currentMode, ticketCollected = false)
                        // Waits for the client to remove the printed ticket
                        TicketDispenser.print(destinyId = App.currentStationID, originId = 0, App.roundTrip)
                        App.displayPrintScreen(mode = App.currentMode, ticketCollected = true)
                        Stations.addTicket(stationID = App.currentStationID)
                    }
                    else -> {
                        // Default VENDING Mode state
                        App.currentState = App.State.HOMESCREEN
                    }
                }
            }
            App.Mode.M -> {
                when (App.currentState) {
                    App.State.SHOW -> {
                        // Sets a new CGRAM custom character set
                        LCD.displayNewCGRAMset(App.M_SET)
                        // Clears LCD previous content
                        LCD.clear()
                        App.resetVariables()
                        // Resets lastStationID value
                        lastStationID = 0
                        TUI.displayShowStateScreen()
                        while (true) {
                            // Evaluates M state
                            if (M.status()) {
                                // Retrieves a pressed key
                                key = KBD.getKey()
                                if (key == KBD.NONE.toChar()) {
                                    TUI.alignStringPos(TUI.Position.LEFT, listM_Modes[cycleIndex++], LCD.Line.LOWER)
                                    if (cycleIndex == listM_Modes.lastIndex + 1) {
                                        // Resets cycleIndex value
                                        cycleIndex = 0
                                    }
                                    LCD.simulateLowerLineShift()
                                } else {
                                    // Evaluates a pressed key or the absence of one
                                    App.evaluateKey(key)
                                }
                            } else {
                                TUI.displayMCompleteScreen()
                                // Updates current App state, since M mode was deactivated
                                App.currentMode = App.Mode.VENDING
                                break
                            }
                            if (App.currentState != App.State.SHOW) {
                                if (App.currentState == App.State.COINS_CNT) {
                                    // Sets a new CGRAM custom character set
                                    LCD.displayNewCGRAMset(App.VENDING_SET)
                                    App.displayCurrentCoinInfo()
                                }
                                break
                            }
                        }
                    }
                    App.State.TICKET_TEST -> {
                        // Sets a new CGRAM custom character set
                        LCD.displayNewCGRAMset(App.VENDING_SET)
                        // Enables showPrice flag since in this state ticket price is displayed
                        showPrice = true
                        App.displayCurrentStationInfo(mode = App.currentMode, price = showPrice)
                        // Updates current App state
                        App.currentState = App.State.PURCHASE
                    }
                    App.State.TICKET_CNT -> {
                        // Sets a new CGRAM custom character set
                        LCD.displayNewCGRAMset(App.VENDING_SET)
                        // Disables showPrice flag since in this state ticket price isn't displayed
                        showPrice = false
                        App.displayCurrentStationInfo(mode = App.currentMode, price = showPrice)
                        // Updates current App state
                        App.currentState = App.State.PURCHASE
                    }
                    App.State.PURCHASE -> {
                        // This check ensures the LCD is only written when the user changes to a different
                        // station ID than the one being currently displayed
                        if (lastStationID != App.currentStationID) {
                            App.displayCurrentStationInfo(mode = App.currentMode, price = showPrice)
                        }
                        // Waits 5 seconds for a key to be pressed
                        key = KBD.waitKey(DELAY_5S)
                        when (key) {
                            '#' -> {
                                // Evaluates showPrice flag
                                if (showPrice) {
                                    App.displayPaymentScreen(App.currentMode)
                                    // Updates current App state
                                    App.currentState = App.State.PAYMENT
                                } else {
                                    // Updates current App state
                                    App.currentState = App.State.SHOW
                                }
                            }
                            '*' -> {
                                // Switch KBD state if key '*' was pressed
                                when (KBD.currentState) {
                                    KBD.State.NUMERIC -> KBD.currentState = KBD.State.SELECTION
                                    KBD.State.SELECTION -> KBD.currentState = KBD.State.NUMERIC
                                }
                                TUI.drawKBDMode()
                            }
                            KBD.NONE.toChar() -> {
                                // Since no key was pressed, current App state is updated
                                App.currentState = App.State.SHOW
                            }
                            else -> {
                                // Updates lastStationID with the currentStationID value
                                lastStationID = App.currentStationID
                                // Evaluates a pressed key or the absence of one
                                App.evaluateKey(key)
                            }
                        }
                    }
                    App.State.PAYMENT -> {
                        // Retrieves a pressed key
                        key = KBD.getKey()
                        when (key) {
                            '0' -> {
                                // Updates roundTrip
                                App.roundTrip = !App.roundTrip
                                App.displayPaymentScreen(App.currentMode)
                            }
                            '#' -> {
                                App.displayAbortedPurchaseScreen()
                                // Updates state since ticket purchase was aborted by the user
                                App.currentState = App.State.SHOW
                            }
                            '*' -> {
                                // Updates state since ticket purchase was completed by the user
                                App.currentState = App.State.PRINT
                            }
                        }
                    }
                    App.State.PRINT -> {
                        App.displayPrintScreen(mode = App.currentMode, ticketCollected = false)
                        // Wait for ticket removal
                        TicketDispenser.print(destinyId = App.currentStationID, originId = 0, App.roundTrip)
                        App.displayPrintScreen(mode = App.currentMode, ticketCollected = true)
                    }
                    App.State.COINS_CNT -> {
                        // This check ensures the LCD is only written when the user changes to a different
                        // coin ID than the one being currently displayed
                        if (lastCoinID != App.currentCoinID) {
                            App.displayCurrentCoinInfo()
                        }
                        // Waits 5 seconds for a key to be pressed
                        key = KBD.waitKey(DELAY_5S)
                        when (key) {
                            '#' -> {
                                // Updates current App state
                                App.currentState = App.State.SHOW
                            }
                            '*' -> {
                                // Switch KBD state if key '*' was pressed
                                when (KBD.currentState) {
                                    KBD.State.NUMERIC -> KBD.currentState = KBD.State.SELECTION
                                    KBD.State.SELECTION -> KBD.currentState = KBD.State.NUMERIC
                                }
                                TUI.drawKBDMode()
                            }
                            KBD.NONE.toChar() -> {
                                // Since no key was pressed, current App state is updated
                                App.currentState = App.State.SHOW
                            }
                            else -> {
                                // Updates lastCoinID with the currentCoinID value
                                lastCoinID = App.currentCoinID
                                // Evaluates a pressed key or the absence of one
                                App.evaluateKey(key)
                            }
                        }
                    }
                    App.State.RESET -> {
                        App.displayQueryRequestScreen(state = App.currentState)
                        // Waits 5 seconds for a key to be pressed
                        key = KBD.waitKey(DELAY_5S)
                        // Evaluates a pressed key or the absence of one
                        App.evaluateKey(key)
                    }
                    App.State.SHUTDOWN -> {
                        // Sets a new CGRAM custom character set
                        LCD.displayNewCGRAMset(App.M_SET)
                        App.displayQueryRequestScreen(state = App.currentState)
                        // Waits 5 seconds for a key to be pressed
                        key = KBD.waitKey(DELAY_5S)
                        // Evaluates a pressed key or the absence of one
                        App.evaluateKey(key)
                    }
                    else -> {
                        TUI.displayMStartingScreen()
                        // Default M Mode state
                        App.currentState = App.State.SHOW
                    }
                }
            }
        }
    }
}