package ticketmachine.software

// Initialize a constant to represent the absent of a valid key code
const val INVALID_KEYCODE = -1

// Receives the frame given by the KeyBoard Reader
object KeyReceiver {
    // Constant values for the masks used in the inputport of UsbPort
    private const val RXD_MASK = 0b00000010 // inputPort(1) of UsbPort
    // Constant values for the masks used in the outputport of UsbPort
    private const val RXCLK_MASK = 0b00001000 // outputPort(3) of UsbPort
    // Constant values
    private const val MAX_CLOCKS = 7
    // Initialize a clock counter to ensure Key Receiver is syncronised with Key Transmitter after
    // TXD was set to logical '0'
    private var clockCounter = 0
    // Initializes this class
    fun init() {
        // Set RXCLK value with logical '0'
        HAL.clrBits(RXCLK_MASK)
    }
    // Receives a frame and returns the code of a key if it exists
    fun rcv(): Int {
        // Reset clock Counter
        clockCounter = 0
        // Create a mutable variable that will represent the code of a key
        // By default, is set to an invalid key code
        var keyCode: Int = INVALID_KEYCODE
        // Check if TXD value is set to logical '0', this way ensuring that RXCLK activation only
        // occurs when Key Transmitter is ready to send a key code
        if (!HAL.isBit(RXD_MASK)) {
            // Enables 1 clock cycle for RXCLK
            enableRXCLKCycle()
            // Check if TXD value is set to logical '1' (START BIT)
            if (HAL.isBit(RXD_MASK)) {
                // Enables 1 clock cycle for RXCLK
                enableRXCLKCycle()
                // Start keyCode set to zero
                keyCode = 0
                // Check TXD value in order to build the key code Key Transmitter is sending
                // Every key code is 4 bits long and Key Transmitter sends LSB->MSB
                for (i in 0..3) {
                    // Check if TXD value is set to logical '1'
                    if (HAL.isBit(RXD_MASK)) {
                        // Calculate the new bit position in the keyCode frame
                        val newBit: Int = 1.shl(bitCount = i)
                        // Add the new bit (K[i]) to the keyCode frame
                        keyCode = keyCode.or(newBit)
                    }
                    // Enables 1 clock cycle for RXCLK
                    enableRXCLKCycle()
                }
                // Check if TXD value is set to logical '0' (STOP BIT)
                if (!HAL.isBit(RXD_MASK)) {
                    // // Enables 1 clock cycle for RXCLK
                    enableRXCLKCycle()
                }
            }
            // While to ensure Key Transmitter has completed key code sending protocol
            while (clockCounter < MAX_CLOCKS) {
                // Enables 1 clock cycle for RXCLK
                enableRXCLKCycle()
            }
        }
        return keyCode
    }
    // Enables 1 clock cycle for RXCLK and increments clock counter by 1
    private fun enableRXCLKCycle() {
        // Set RXCLK value with logical '1'
        HAL.setBits(RXCLK_MASK)
        // Set RXCLK value with logical '0'
        HAL.clrBits(RXCLK_MASK)
        // Increments clock counter by 1
        clockCounter++
    }
}

