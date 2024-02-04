package ticketmachine.software

import isel.leic.UsbPort

// Virtualizes the access for the UsbPort system
object HAL {
    // Creates a mutable variable to store the value of the last output written
    private var lastOutput = 0
    // Initializes this class, which means to have a predefied output when UsbPort.write is executed
    fun init() {
        // Writes lastOutput value on the output of the board
        UsbPort.write(lastOutput)
    }
    // Returns true when a bit we want to evaluate is set to logical '1'
    fun isBit(mask: Int): Boolean {
        // Reads the current input on the board
        val currentInput = UsbPort.read()
        // Performs an AND logic operation, bit by bit, with the current input and the received mask
        // If it returns the mask (true), means that the bit we want to evaluate is indeed set to logical '1'
        // otherwise returns false, indicating that bit is set to logical '0'
        return currentInput.and(mask) == mask
    }
    // Returns the values of the bits represented by the mask in the UsbPort
    fun readBits(mask: Int): Int {
        // Reads the current input on the board
        val currentInput = UsbPort.read()
        // Returns the result of an AND logic operation, bit by bit, between the currentInput and the mask
        return currentInput.and(mask)
    }
    // Writes in the bits represented by the mask the given value
    fun writeBits(mask: Int, value: Int) {
        // Inverts mask bits
        val invertedMask: Int = mask.inv()
        // This secondMask variable will have the bits we want to keep and the bits we want to
        // change set to logical '0'
        val secondMask: Int = lastOutput.and(invertedMask)
        // For the output, we want to merge the bits represented by the value with the bits in secondMask
        lastOutput = secondMask.or(value)
        UsbPort.write(lastOutput)
    }
    // Sets bits represented by the mask as logical '1'
    fun setBits(mask: Int) {
        // Writes on the output of the board the result of an OR logic operation, bit by bit,
        // between the lastOutput and the mask
        lastOutput = lastOutput.or(mask)
        UsbPort.write(lastOutput)
    }
    // Sets bits represented by the mask as logical '0'
    fun clrBits(mask: Int) {
        // Inverts mask bits
        val invertedMask: Int = mask.inv()
        // Writes on the output of the board the result of an AND logic operation, bit by bit,
        // between the lastOutput and the invertedMask
        lastOutput = lastOutput.and(invertedMask)
        UsbPort.write(lastOutput)
    }
}