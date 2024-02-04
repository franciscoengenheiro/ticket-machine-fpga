package ticketmachine.software

import isel.leic.utils.Time

/**
  * Coins file format:
  * COIN;NUMBER
  * EXAMPLE:
  * 2;3
  * Means: 3 coins of 2€ are deposited in the Coin Deposit vault
**/
// Implements interaction with Coin Acceptor and the Coin Deposit vault
object CoinDeposit {
    // Constant values
    private const val CD_FILENAME: String = "CoinDeposit.txt"
    // Data class to caracterize a coin type
    data class Coin (val type: Int, var currentCount: Int, var ID: Int)
    // Initialize an array which will store all coin's information currently in the Coin Deposit vault
    var storedCoins: Array<Coin> = emptyArray()
    // Initialize an array which will store all coin's information during a ticket purchase
    var insertedCoins: Array<Coin> = emptyArray()
    // Creates a variable to indicate the first coin ID
    var firstCoinID: Int = 0
    // Creates a variable to indicate the last coin ID
    var lastCoinID: Int = 0
    // Initializes this class
    fun init() {
        // Loads Coin's file information
        loadStoredCoins()
        // Sets firstCoinID value
        firstCoinID = storedCoins.first().ID
        // Sets lastCoinID value
        lastCoinID = storedCoins.last().ID
        // Reset insertedCoins counters
        ejectInsertedCoins()
    }
    // Loads Coin's file information
    private fun loadStoredCoins() {
        // Retrieves data from Coin's file
        val dataArray = readFile(CD_FILENAME)
        // Initializes a mutable variable to set current Station ID
        var setCoinID: Int = 0
        for (line in dataArray.indices) {
            // Splits the current line in two halves: (COIN;NUMBER -> [0]COIN [1]NUMBER)
            val lineList = dataArray[line].split(";")
            // Sets Coin type
            val loadedCoinType = lineList[0].toInt()
            // Sets Coin count
            val loadedCoinCount = lineList[1].toInt()
            // Sets Station ID value
            val identification = setCoinID++
            // Initializes a variable to caracterize the current coin
            val coin1 = Coin(loadedCoinType, loadedCoinCount, identification)
            // Assigns previously created coin to storedCoins array
            storedCoins += coin1
            // Another instance of the same coin was created so that it can be referenced by the insertedCoins
            // array without altering previous created objects for the storedCoins array
            val coin2 = Coin(loadedCoinType, loadedCoinCount, identification)
            // Initially insertedCoins will mimic stored coins
            insertedCoins += coin2
        }
    }
    // Function to increment the current counter of the given type of coin
    fun add(type: Int) {
        for (index in insertedCoins.indices) {
            if (type == insertedCoins[index].type) {
                // Increments current counter for this coin type
                insertedCoins[index].currentCount++
                // Type was found, there's no need to keep searching
                break
            }
        }
    }
    // Function to collect all inserted stored coins into the Coin Deposit vault
    fun collectStoredCoins() {
        for (index in storedCoins.indices) {
            // The collected coins for this type will be the given by the current stored coins
            // plus the current inserted coins
            storedCoins[index].currentCount += insertedCoins[index].currentCount
        }
    }
    // Function to eject all inserted coins counters
    fun ejectInsertedCoins() {
        for (coin in insertedCoins) {
            // Resets current counter
            coin.currentCount = 0
        }
    }
    // Function to reset all stored coin counters
    fun resetCoinCounters() {
        for (coin in storedCoins) {
            // Resets current counter
            coin.currentCount = 0
        }
    }
    // Writes data to output file
    fun writeFile() {
        // Create an array to write all data lines to
        var outputArray: Array<String> = emptyArray()
        for (coin in storedCoins) {
            // Calculates the coin amount to store in the file for the current coin type
            val total: Int = coin.currentCount
            // Sets a new data line
            val data: String = "${coin.type};$total"
            // Adds current data line to outputArray
            outputArray += data
        }
        // Prints to file
        writeFile(fileName = CD_FILENAME, dataArray = outputArray)
    }
}

fun main () {
    CoinDeposit.init()
    CoinDeposit.resetCoinCounters()
    // Should not change the file
    CoinDeposit.add(0)
    // Adds a 0.05€ coin
    CoinDeposit.add(5)
    // Adds a 1€ coin
    CoinDeposit.add(100)
    // Adds a 0.20€ coin
    CoinDeposit.add(20)
    // Adds a 1€ coin
    CoinDeposit.add(100)
    // Writes File
    CoinDeposit.writeFile()
    Time.sleep(DELAY_5S)
    // Should not change the file
    CoinDeposit.add(0)
    // Adds a 0.05€ coin
    CoinDeposit.add(5)
    // Adds a 2€ coin
    CoinDeposit.add(200)
    // Adds a 0.20€ coin
    CoinDeposit.add(20)
    // Adds a 0.20€ coin
    CoinDeposit.add(20)
    // Should not change the file
    CoinDeposit.add(3)
    CoinDeposit.writeFile()
    Time.sleep(DELAY_5S)
    CoinDeposit.resetCoinCounters()
    Time.sleep(DELAY_5S)
    CoinDeposit.writeFile()
}
