// Define a class called HttpException that implements the Exception interface
class HttpException implements Exception {
  // Declare an instance variable called message
  final message;

  // Define a constructor for the HttpException class that takes a single argument and assigns it to the message instance variable
  HttpException(this.message);

  // Override the toString method of the Exception interface to return the message as a String
  @override
  String toString() {
    // TODO: Implement the toString method
    return message.toString();
  }
}
