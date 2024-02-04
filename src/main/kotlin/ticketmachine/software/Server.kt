package ticketmachine.software

// Constant values
const val SERVER: String = "SERVER"

// This enum class will help declare all Server(SV) states on software test benches
enum class SV {
    INIT, // Indicates a process initialization
    INFO, // Displays important information for the user
    REQUEST, // Performs an assertive user request
    START, // Starts a test framework
    OUTPUT, // Displays output on the console log
    QUERY, // Performs an interrogative user request
    END, // Terminates a test framework
}
