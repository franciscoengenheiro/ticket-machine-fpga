package ticketmachine.software

fun main() {
    // Initializes HAL object
    HAL.init()
    // Console log
    while (true) {
        // Prompts the user for specific input
        do {
            val userInput: Char = readChar("$SERVER: [${SV.QUERY}]    Is the correct input inserted on the console? (Y/N): ")
        } while (userInput != 'Y' && userInput != 'y')
        println("$SERVER: [${SV.INFO}]     Avalaible Test functions:")
        println("$SERVER: [${SV.INFO}]     -> isBitFalse")
        println("$SERVER: [${SV.INFO}]     -> isBitTrue")
        println("$SERVER: [${SV.INFO}]     -> readBits1Bit")
        println("$SERVER: [${SV.INFO}]     -> readBits4Bits")
        println("$SERVER: [${SV.INFO}]     -> readBitsAllBits")
        println("$SERVER: [${SV.INFO}]     -> writeBits1Bit")
        println("$SERVER: [${SV.INFO}]     -> writeBits4Bits")
        println("$SERVER: [${SV.INFO}]     -> writeBitsAllBits")
        println("$SERVER: [${SV.INFO}]     -> setBits1Bit")
        println("$SERVER: [${SV.INFO}]     -> setBits4Bits")
        println("$SERVER: [${SV.INFO}]     -> setBitsAllBits")
        println("$SERVER: [${SV.INFO}]     -> clrBits1Bit")
        println("$SERVER: [${SV.INFO}]     -> clrBits4Bits")
        println("$SERVER: [${SV.INFO}]     -> clrBitsAllBits")
        // Prompts the user to write the function to test
        val testFunction: String = readString("$SERVER: [${SV.REQUEST}]  Test function: ")
        println("$SERVER: [${SV.START}]    Initializing test framework...\n")
        // Evaluate which test Function was chosen by the user
        when (testFunction) {
            "isBitFalse" -> isBitFalse()
            "isBitTrue" -> isBitTrue()
            "readBits1Bit" -> readBits1Bit()
            "readBits4Bits" -> readBits4Bits()
            "readBitsAllBits" -> readBitsAllBits()
            "writeBits1Bit" -> writeBits1Bit()
            "writeBits4Bits" -> writeBits4Bits()
            "writeBitsAllBits" -> writeBitsAllBits()
            "setBits1Bit" -> setBits1Bit()
            "setBits4Bits" -> setBits4Bits()
            "setBitsAllBits" -> setBitsAllBits()
            "clrBits1Bit" -> clrBits1Bit()
            "clrBits4Bits" -> clrBits4Bits()
            "clrBitsAllBits" -> clrBitsAllBits()
            else -> println("$SERVER: [${SV.OUTPUT}]    Test function not found")
        }
        println("\n$SERVER: [${SV.END}]      Closing test framework...\n")
    }
}

// Test functions
fun isBitFalse() {
    // Place this input on the application
    val currentInput: Int = 0b11110000
    // Create a mask for the bit we want to evaluate
    val mask: Int = 0b00000001
    println("$SERVER: [${SV.OUTPUT}]   ${HAL.isBit(mask)}")
    /** Expected output: false, since the bit represented by the mask is set to logical '0', on the currentInput **/
}
fun isBitTrue() {
    // Place this input on the application
    val currentInput: Int = 0b11110000
    // Create a mask for the bit we want to evaluate
    val mask: Int = 0b00010000
    println("$SERVER: [${SV.OUTPUT}]   ${HAL.isBit(mask)}")
    /** Expected output: true, since the bit represented by the mask is set to logical '1', on the currentInput **/
}
fun readBits1Bit() {
    // Place this input on the application
    val currentInput: Int = 0b11101000
    // Create a mask for the bits we want to read
    val mask: Int = 0b00001000
    println("$SERVER: [${SV.OUTPUT}]   ${HAL.readBits(mask)}")
    /** Expected output: 0b00001000 in binary, 8 in decimal **/
}
fun readBits4Bits() {
    // Place this input on the application
    val currentInput: Int = 0b11101000
    // Create a mask for the bits we want to read
    val mask: Int = 0b10010110
    println("$SERVER: [${SV.OUTPUT}]   ${HAL.readBits(mask)}")
    /** Expected output: 0b10000000 in binary, 128 in decimal **/
}
fun readBitsAllBits() {
    // Place this input on the application
    val currentInput: Int = 0b11101000
    // Create a mask for the bits we want to read
    val mask: Int = 0b11111111
    println("$SERVER: [${SV.OUTPUT}]   ${HAL.readBits(mask)}")
    /** Expected output: 0b11101000 in binary, 232 in decimal **/
}
fun writeBits1Bit() {
    val currentOutput: Int = 0b10101101
    // Create a mask for the bits we want to write
    val mask: Int = 0b00001000
    // Create a value to override the bits represented by the mask
    val value: Int = 0b00000000
    HAL.writeBits(mask, value)
    println("$SERVER: [${SV.INFO}]     Test Function with no return value, check application output instead")
    /** Expected output: 0b10100101 in binary, 165 in decimal **/
}
fun writeBits4Bits() {
    val currentOutput: Int = 0b10100011
    // Create a mask for the bits we want to write
    val mask: Int = 0b00111100
    // Create a value to override the bits represented by the mask
    val value: Int = 0b00111000
    HAL.writeBits(mask, value)
    println("$SERVER: [${SV.INFO}]    Test Function with no return value, check application output instead")
    /** Expected output: 0b10111011 in binary, 187 in decimal **/
}
fun writeBitsAllBits() {
    val currentOutput: Int = 0b11101000
    // Create a mask for the bits we want to write
    val mask: Int = 0b11111111
    // Create a value to override the bits represented by the mask
    val value: Int = 0b01010101
    HAL.writeBits(mask, value)
    println("$SERVER: [${SV.INFO}]     Test Function with no return value, check application output instead")
    /** Expected output: 0b01010101 in binary, 85 in decimal **/
}
fun setBits1Bit() {
    val currentOutput: Int = 0b10101101
    // Create a mask for the bits we want to set
    val mask: Int = 0b00000010
    HAL.setBits(mask)
    println("$SERVER: [${SV.INFO}]     Test Function with no return value, check application output instead")
    /** Expected output: 0b10101111 in binary, 175 in decimal **/
}
fun setBits4Bits() {
    val currentOutput: Int = 0b10000001
    // Create a mask for the bits we want to set
    val mask: Int = 0b00001111
    HAL.setBits(mask)
    println("$SERVER: [${SV.INFO}]     Test Function with no return value, check application output instead")
    /** Expected output: 0b10001111 in binary, 143 in decimal **/
}
fun setBitsAllBits() {
    val currentOutput: Int = 0b01110001
    // Create a mask for the bits we want to set
    val mask: Int = 0b11111111
    HAL.setBits(mask)
    println("$SERVER: [${SV.INFO}]     Test Function with no return value, check application output instead")
    /** Expected output: 0b11111111 in binary, 113 in decimal **/
}
fun clrBits1Bit() {
    val currentOutput: Int = 0b10101101
    // Create a mask for the bits we want to clear
    val mask: Int = 0b00000001
    HAL.clrBits(mask)
    println("$SERVER: [${SV.INFO}]     Test Function with no return value, check application output instead")
    /** Expected output: 0b10101100 in binary, 172 in decimal **/
}
fun clrBits4Bits() {
    val currentOutput: Int = 0b10111101
    // Create a mask for the bits we want to clear
    val mask: Int = 0b00111100
    HAL.clrBits(mask)
    println("$SERVER: [${SV.INFO}]     Test Function with no return value, check application output instead")
    /** Expected output: 0b10000001 in binary, 129 in decimal **/
}
fun clrBitsAllBits() {
    val currentOutput: Int = 0b11101110
    // Create a mask for the bits we want to clear
    val mask: Int = 0b11111111
    HAL.clrBits(mask)
    println("$SERVER: [${SV.INFO}]     Test Function with no return value, check application output instead")
    /** Expected output: 0b00000000 in binary, 0 in decimal **/
}