package ticketmachine.software

import java.io.BufferedReader
import java.io.FileReader
import java.io.PrintWriter

// Function to read from a specified file and return data as an Array of Strings
fun readFile(fileName: String): Array<String> {
    // Creates a reader
    val reader = BufferedReader(FileReader(fileName))
    // Creates an array to store all data lines
    var dataArray: Array<String> = emptyArray()
    // Creates a mutable variable to store the current line that bufferedReader is reading
    var currentLine = reader.readLine()
    while (currentLine != null) {
        // Adds data line to the array
        dataArray += currentLine
        // Moves to next data line
        currentLine = reader.readLine()
    }
    // Closes reader
    reader.close()
    return dataArray
}

// Function to write given data as an Array of Strings to a specified file
fun writeFile(fileName: String, dataArray: Array<String>) {
    // Creates a writer
    val writer = PrintWriter(fileName)
    for (data in dataArray) {
        // Writes the current data line
        writer.println(data)
    }
    // Closes writer
    writer.close()
}

