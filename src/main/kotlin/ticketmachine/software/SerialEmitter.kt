package ticketmachine.software

// Send frames for the different modules of the Serial Receiver
object SerialEmitter {
    // Constant values for the masks used in the inputport of UsbPort
    private const val BUSY_MASK = 0b00000001 // inputPort(0) of UsbPort
    // Constant values for the masks used in the outputport of UsbPort
    private const val SDX_MASK  = 0b00000001 // outputPort(0) of UsbPort
    private const val SCLK_MASK = 0b00000010 // outputPort(1) of UsbPort
    private const val SS_MASK   = 0b00000100 // outputPort(2) of UsbPort
    // This enum class will help declare for which module we want to send the frames
    enum class Destination { LCD, TICKET_DISPENSER }
    // Initializes a default mask to always target the first bit (bit 0)
    private const val LSB_MASK = 0b00000001
    // Initialize a flag to indicate when printing on console is required
    var EN_PRINT: Boolean = false
    // Initializes this class
    fun init() {
        // Set SDX value with logical '0'
        HAL.clrBits(SDX_MASK)
        // Set SCLK value with logical '0'
        HAL.clrBits(SCLK_MASK)
        // Set SS value with logical '1'
        HAL.setBits(SS_MASK)
        // Disables this function to print on console
        EN_PRINT = false
    }
    // Sends a frame to SerialReceiver identifying the destination with "addr" and the
    // bits containing the data with "data", which has a total of 9 bits
    fun send(addr: Destination, data: Int) {
        // Waits for Busy signal to be disabled
        while (isBusy());
        // Set SS value with logical '0'
        HAL.clrBits(SS_MASK)
        // Build frame with 10 bits while making Destination bit LSB
        val din = (data.shl(1)).or(addr.ordinal)
        // Find parity bit
        val parityBit = findParityBit(din)
        // Full frame with MSB as the parity Bit
        var frame: Int = (parityBit.shl(10)).or(din)
        // With the full frame built, start a for loop to send each bit in every ascending transition of SCLK
        for (i in 10 downTo 0) {
            // Evaluate if a frame has at least one bit set to logical '1'
            if (frame >= 1) {
                // Use checkLSB extension function to evaluate if the LSB of the frame
                // is set to either '1' (true) or '0' (false)
                if (frame.checkLSB()) {
                    // Set SDX value with logical '1'
                    HAL.setBits(SDX_MASK)
                    if (EN_PRINT) println("SDX: 1")
                } else {
                    // Set SDX value with logical '0'
                    HAL.clrBits(SDX_MASK)
                    if (EN_PRINT) println("SDX: 0")
                }
                // Shift frame 1 bit to the right, this way discarding the LSB
                frame = frame.shr(1)
            } else {
                // Set SDX value with logical '0'
                HAL.clrBits(SDX_MASK)
                if (EN_PRINT) println("SDX: 0")
            }
            // Enables 1 clock cycle for SCLK
            enableSCLKCycle()
        }
        // Set SS value with logical '1'
        HAL.setBits(SS_MASK)
    }
    // Enables 1 clock cycle for SCLK
    private fun enableSCLKCycle() {
        // Set SCLK value with logical '1'
        HAL.setBits(SCLK_MASK)
        // Set SCLK value with logical '0'
        HAL.clrBits(SCLK_MASK)
    }
    // Returns true if busy, hardware output, is set to logical '1'
    fun isBusy(): Boolean = HAL.isBit(BUSY_MASK)
    // All the bits set to logical '1' in din have to be checked in order to assert the
    // parity bit (MSB of the frame) with either 0 or 1, this way preserving the agreed even parity.
    // This algorithm, which is generic, will find the parity bit while consecutively compressing the initial number
    // with unassigned right shifts which will become smaller and smaller until the end of din is reached
    // At that point, the parity bit can be found at the LSB
    // Time complexity: O(log(n)), whereas n is the number of bits of din
    private fun findParityBit(din: Int): Int {
        var d: Int = din
        // d = d xor (d.ushr(32))
        d = d xor (d.ushr(16))
        d = d xor (d.ushr(8))
        d = d xor (d.ushr(4))
        d = d xor (d.ushr(2))
        d = d xor (d.ushr(1))
        return (d and 1)
    }
    // Extension function to check if the LSB bit is either 1 (true) or 0 (false)
    fun Int.checkLSB(): Boolean {
        return this.and(LSB_MASK) == 1
    }
}
