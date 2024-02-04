package ticketmachine.software

// Auxiliary functions to store user input, organized by type
fun readString(question: String): String {
    print(question)
    return readln()
}

fun readChar(question: String): Char {
    print(question)
    return readln()[0]
}

fun readLong(question: String): Long {
    print(question)
    return readln().toLong()
}

fun readInt(question: String): Int {
    print(question)
    return readln().toInt()
}