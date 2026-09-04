import java.util.Scanner;
public class asciiToDecimalConverterHw1 {
    public static void main(String[] args) {
    // Build an ASCII-to-decimal converter.
    Scanner scnr = new Scanner(System.in);
    System.out.println("ASCII-to-decimal converter: Enter what you want to convert.");
        String s1 = scnr.nextLine();

        for (Character c : s1.toCharArray()) {
            System.out.println((int)c);
        }
    }    
}
