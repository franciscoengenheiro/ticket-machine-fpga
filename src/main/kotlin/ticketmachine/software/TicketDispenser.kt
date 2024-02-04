package ticketmachine.software

// Controls the state of the mechanism for ticket printing
object TicketDispenser {
    // Initializes this class
    fun init() {
        // Since the hardware of the TicketDispenser doesn't need prior activation to enable its use,
        // this function is redundant, but it was kept in order to be coherent with the current
        // steps used in this application for OOP
    }
    // Sends a command to print and dispense a ticket
    fun print(destinyId: Int, originId: Int, roundTrip: Boolean) {
        // Starts a mutable variable that will hold the entire frame while it's being built
        // Step1: Shift Origin station code 4 bits to the left, in order to allocate space for the next instruction
        var data = originId.shl(4)
        // Step2: Perform a OR logic operation between the current frame and the Destiny station code,
        // to be able to add it to the frame
        data = data.or(destinyId)
        // Step3: Shift current frame 1 bit to the left, in order to allocate space for the next instruction
        data = data.shl(1)
        // Step4: Perform an OR logic operation between the current frame and the roundTrip bit,
        // to be able to add it to the frame
        // The boolean roundTrip identifies if a ticket is: a two-way ticket (true) or a one-way ticket (false)
        if (!roundTrip) {
            data = data.or(1)
        }
        // Send data to the Serial Emitter
        SerialEmitter.send(addr = SerialEmitter.Destination.TICKET_DISPENSER, data = data)
    }
}