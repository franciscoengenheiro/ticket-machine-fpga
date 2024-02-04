package ticketmachine.software

import isel.leic.utils.Time

// Read keys. Methods return ‘0’..’9’,’#’,’*’ or NONE
object KBD {
    // This enum class will help declare which state KBD is currently at
    enum class State {
        NUMERIC, // Disables Arrow Keys Selection
        SELECTION // Enables Arrow Keys Selection
    }
    // Initialize a constant to represent the absence of a valid key
    const val NONE = 0
    // Initialize a mutable variable to represent the current state of KBD
    var currentState: State = State.NUMERIC
    // Create an array to store the all avalaible keys on KBD.
    // The index of a key correspond to its codification given by the Key Decode hardware module
    private val KEY_CODE: List<Char> = listOf('1','4','7','*','2','5','8','0','3','6','9','#')
    // Initializes this class
    fun init() {
        // Sets default KBD state to NUMERIC
        currentState = State.NUMERIC
    }
    // Implements the serial interaction with Key Transmitter
    private fun getKeySerial(): Char {
        // Get a Key code from Key Transmitter hardware module
        val keyCode = KeyReceiver.rcv()
        return if (keyCode != INVALID_KEYCODE || keyCode in KEY_CODE.indices) {
            // Returns the Key which the keyCode corresponds to in the KEY_CODE array
            KEY_CODE[keyCode]
        } else {
            NONE.toChar()
        }
    }
    // Returns the pressed Key or NONE if no key is currently being pressed
    fun getKey(): Char {
       return getKeySerial()
    }
    // Returns when a key is pressed or NONE after a timeout, in milliseconds, as occurred
    fun waitKey(timeout: Long): Char {
        // Create a variable to store the current time plus the timeout time
        val stopTime = Time.getTimeInMillis() + timeout
        // Get a Key from Key Receiver
        var key = getKey()
        // Active flag for when the key is found
        var found: Boolean = false
        while (Time.getTimeInMillis() < stopTime && !found) {
            // If a Key was pressed within the timeout time:
            if (key != NONE.toChar()) {
                // A valid key was found
                found = true
            } else {
                // Keep searching for the key
                key = getKey()
            }
        }
        return key
    }
}