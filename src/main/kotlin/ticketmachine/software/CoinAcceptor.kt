package ticketmachine.software

import isel.leic.utils.Time

// Constant values
const val DELAY2: Long = 2000

// Implements the iterface with the Coin Acceptor hardware module
object CoinAcceptor {
    // Constant values for the masks used in the inputport of UsbPort
    // CID stands for Coin ID
    private const val CID_MASK  = 0b00011100 // inputPort(4, 3, 2) of UsbPort
    private const val COIN_MASK = 0b00100000 // inputPort(5) of UsbPort
    // Constant values for the masks used in the outputport of UsbPort
    private const val COIN_EJECT_MASK   = 0b00010000 // outputPort(4) of UsbPort
    private const val COIN_COLLECT_MASK = 0b00100000 // outputPort(5) of UsbPort
    private const val COIN_ACCEPT_MASK  = 0b01000000 // outputPort(6) of UsbPort
    // Constant values
    private const val FIRST_CID = 0 // Index 0
    private const val LAST_CID = 6 // Actual last index is 5 but until keyword is exclusive, so it was
                                   // incremented to 6
    // Lists
    val coinCode_List: List<Int> = listOf(5, 10, 20, 50, 100, 200, 0, 0) // Coins in cents
    // Initializes this class
    fun init() {
        // Set COIN_ACCEPT value with logical '0'
        HAL.clrBits(COIN_ACCEPT_MASK)
        // Set COIN_EJECT value with logical '0'
        HAL.clrBits(COIN_EJECT_MASK)
        // Set COIN_COLLECT value with logical '0'
        HAL.clrBits(COIN_COLLECT_MASK)
    }
    // Returns true if a new coin was inserted
    fun hasCoin(): Boolean {
        return HAL.isBit(COIN_MASK)
    }
    // Returns the true value of the inserted coin
    fun getCoinValue(): Int {
        // Check if a coin was inserted
        if (hasCoin()) {
            // Create a mutable variable that will represent the true value of the inserted coin (value frame)
            val value = HAL.readBits(CID_MASK).shr(2)
            // Check if coin value is in the accepted coin range
            if (value in FIRST_CID until LAST_CID) {
                return coinCode_List[value]
            }
        }
        // No coin was inserted
        return 0
    }
    // Informs the CoinAcceptor that the coin was accounted for
    fun acceptCoin() {
        if (hasCoin()) {
            // Set COIN_ACCEPT value with logical '1'
            HAL.setBits(COIN_ACCEPT_MASK)
            // Checks if coin switch was returned to its original position
            while (hasCoin());
            // Set COIN_ACCEPT value with logical '0'
            HAL.clrBits(COIN_ACCEPT_MASK)
        }
    }
    // Returns all coins currently stored in the CoinAcceptor
    fun ejectCoins() {
        // Set COIN_EJECT value with logical '1'
        HAL.setBits(COIN_EJECT_MASK)
        // Ejects inserted coins
        CoinDeposit.ejectInsertedCoins()
        // Active only for 2 seconds
        Time.sleep(DELAY2)
        // Set COIN_EJECT value with logical '0'
        HAL.clrBits(COIN_EJECT_MASK)
    }
    // Collects all coins currently stored in the CoinAcceptor
    fun collectCoins() {
        // Set COIN_COLLECT value with logical '1'
        HAL.setBits(COIN_COLLECT_MASK)
        // Collects stored coins
        CoinDeposit.collectStoredCoins()
        // Active only for 2 seconds
        Time.sleep(DELAY2)
        // Set COIN_COLLECT value with logical '0'
        HAL.clrBits(COIN_COLLECT_MASK)
    }
}