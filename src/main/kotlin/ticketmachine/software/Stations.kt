package ticketmachine.software

import isel.leic.utils.Time

/**
  * Stations file format:
  * PRICE;NUMBER;STATION_NAME
  * EXAMPLE:
  * 100;2;Porto
  * Means: 2 tickets to Porto (each 1€) were sold
**/
// Implements interaction with Stations current information
object Stations {
    // Constant values
    private const val STATIONS_FILENAME: String = "Stations.txt"
    // Data class to caracterize a station
    data class Station (var price: Int, var currentTicketCount: Int, var name: String, var ID: Int)
    // Initialize an array which will store all station's information
    var stationsInfo: Array<Station> = emptyArray()
    // Creates a variable to indicate the first station ID
    var firstStationID: Int = 0
    // Creates a variable to indicate the last station ID
    var lastStationID: Int = 0
    // Initializes this class
    fun init() {
        // Loads Station's file information
        loadStationsInfo()
        // Sets firstStationID value
        firstStationID = stationsInfo.first().ID
        // Sets lastStationID value
        lastStationID = stationsInfo.last().ID
    }
    // Loads Station's file information
    private fun loadStationsInfo() {
        // Retrieves data from Station's file
        val dataArray = readFile(STATIONS_FILENAME)
        // Initializes a mutable variable to set current Station ID
        var setStationID: Int = 0
        for (line in dataArray.indices) {
            // Splits the current line in three halves: (PRICE;NUMBER;STATION_NAME -> [0]PRICE [1]NUMBER [2]STATION_NAME)
            val lineList = dataArray[line].split(";")
            // Sets Station ticket price value
            val loadedTicketPrice: Int = lineList[0].toInt()
            // Sets Station ticket count value
            val loadedTicketCount: Int = lineList[1].toInt()
            // Sets Station name
            val loadStationName: String = lineList[2]
            // Sets Station ID value
            val identification = setStationID++
            // Initializes a variable to caracterize the current station
            val station = Station(loadedTicketPrice, loadedTicketCount, loadStationName, identification)
            // Assigns previously created station to stationsInfo array
            stationsInfo += station
        }
    }
    // Function to increment the current ticket counter for a given station ID
    fun addTicket(stationID: Int) {
        for (index in stationsInfo.indices) {
            // Search for the corresponding station
            if (stationID == stationsInfo[index].ID) {
                // Increment its current ticket counter by 1
                stationsInfo[index].currentTicketCount++
            }
        }
    }
    // Function to reset all station's ticket counters
    fun resetTicketCounters() {
        for (index in stationsInfo.indices) {
            // Resets current ticket counter
            stationsInfo[index].currentTicketCount = 0
        }
    }
    // Writes data to output file
    fun writeFile() {
        // Create an array to write all data lines to
        var outputArray: Array<String> = emptyArray()
        for (station in stationsInfo) {
            // Calculates the ticket amount to store in the file for the current station
            val total: Int = station.currentTicketCount
            // Sets a new data line
            val data: String = "${station.price};$total;${station.name}"
            // Adds current data line to outputArray
            outputArray += data
        }
        // Prints to file
        writeFile(fileName = STATIONS_FILENAME, dataArray = outputArray)
    }
}

fun main() {
    // Reads stored information from Stations File
    Stations.init()
    // Resets all station's ticket counters
    Stations.resetTicketCounters()
    // Writes in Stations File
    Stations.writeFile()
    Time.sleep(DELAY_5S)
    // Adds a ticket which was sold for the station with ID: 3
    Stations.addTicket(3)
    // Adds a ticket which was sold for the station with ID: 7
    Stations.addTicket(7)
    Stations.writeFile()
    // Writes in Stations File
    Time.sleep(DELAY_5S)
    // Resets all station's ticket counters
    Stations.resetTicketCounters()
    Stations.writeFile()
}