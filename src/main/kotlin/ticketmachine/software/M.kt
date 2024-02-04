package ticketmachine.software

// Implements M (Maintenance Mode) Interface
object M {
    // Constant values for the masks used on the inputport of UsbPort
    private const val M_MASK = 0b10000000 // inputPort(7) of UsbPort
    fun init() {
        // This function is redundant, but it was kept in order to be coherent with the current
        // steps used in this application for OOP
    }
    // Check if M Mode was actived (true) or disabled (false)
    fun status(): Boolean = HAL.isBit(M_MASK)
}