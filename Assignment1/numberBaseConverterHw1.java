import java.util.Scanner;
public class numberBaseConverterHw1 {
    public static void main(String[] args) {
    // Build a number-base converter supporting binary, decimal, octal, and hexadecimal.
        Scanner scnr = new Scanner(System.in);
        System.out.println("Number-base converter: Enter the base you want to convert from (binary, decimal, octal, hexadecimal)");
        String fromType = scnr.nextLine();
        System.out.println("Number-base converter: Enter the type you want to convert to (binary, decimal, octal, hexadecimal)");
        String toType = scnr.nextLine();
        System.out.println("Number-base converter: Enter the number you want to convert");
        String toConvert = scnr.nextLine();
        if (fromType.equalsIgnoreCase("binary") || fromType.equalsIgnoreCase("decimal") || fromType.equalsIgnoreCase("octal") || fromType.equalsIgnoreCase("hexadecimal")) {
            if (toType.equalsIgnoreCase("binary") || toType.equalsIgnoreCase("decimal") || toType.equalsIgnoreCase("octal") || toType.equalsIgnoreCase("hexadecimal")) {
                try { 
                    if (fromType.equalsIgnoreCase(toType)) {
                        System.out.println(toConvert);
                    } else if (fromType.equalsIgnoreCase("binary") && toType.equalsIgnoreCase("decimal")) {
                        long binDec = Long.parseLong(toConvert, 2);
                        System.out.println(binDec);
                    } else if (fromType.equalsIgnoreCase("binary") && toType.equalsIgnoreCase("octal")) {
                        long output = Long.parseLong(toConvert, 2); 
                        String binOct = Long.toOctalString(output);
                        System.out.println(binOct);
                    } else if (fromType.equalsIgnoreCase("binary") && toType.equalsIgnoreCase("hexadecimal")) {
                        long output = Long.parseLong(toConvert, 2);
                        String binHex = Long.toHexString(output);
                        System.out.println(binHex);
            
                    } else if (fromType.equalsIgnoreCase("decimal") && toType.equalsIgnoreCase("binary")) {
                        long output = Long.parseLong(toConvert, 10);
                        if (output < 0) {
                            output = output & 0xFFFFFFFFL;
                        } 
                        String decBin = Long.toBinaryString(output);
                        System.out.println(decBin);
                    } else if (fromType.equalsIgnoreCase("decimal") && toType.equalsIgnoreCase("octal")) {
                        long output = Long.parseLong(toConvert, 10); 
                        if (output < 0) {
                            output = output & 0xFFFFFFFFL;
                        } 
                        String decOct = Long.toOctalString(output);
                        System.out.println(decOct);
                    } else if (fromType.equalsIgnoreCase("decimal") && toType.equalsIgnoreCase("hexadecimal")) {
                        long output = Long.parseLong(toConvert, 10);
                        if (output < 0) {
                            output = output & 0xFFFFFFFFL;
                        } 
                        String decHex = Long.toHexString(output);
                        System.out.println(decHex);

                    } else if (fromType.equalsIgnoreCase("octal") && toType.equalsIgnoreCase("binary")) {
                        long output = Long.parseLong(toConvert, 8);
                        String octBin = Long.toBinaryString(output);
                        System.out.println(octBin);
                    } else if (fromType.equalsIgnoreCase("octal") && toType.equalsIgnoreCase("decimal")) {
                        long octDec = Long.parseLong(toConvert, 8); 
                        System.out.println(octDec);
                    } else if (fromType.equalsIgnoreCase("octal") && toType.equalsIgnoreCase("hexadecimal")) {
                        long output = Long.parseLong(toConvert, 8);
                        String octHex = Long.toHexString(output);
                        System.out.println(octHex);
                
                    } else if (fromType.equalsIgnoreCase("hexadecimal") && toType.equalsIgnoreCase("binary")) {
                        long output = Long.parseLong(toConvert, 16);
                        String hexBin = Long.toBinaryString(output);
                        System.out.println(hexBin);
                    } else if (fromType.equalsIgnoreCase("hexadecimal") && toType.equalsIgnoreCase("decimal")) {
                        long hexDec = Long.parseLong(toConvert, 16); 
                        System.out.println(hexDec);
                    } else if (fromType.equalsIgnoreCase("hexadecimal") && toType.equalsIgnoreCase("octal")) {
                        long output = Long.parseLong(toConvert, 16);
                        String hexOct = Long.toOctalString(output);
                        System.out.println(hexOct);
                    } else {
                        System.out.println("Invalid base. Please enter binary, decimal, octal, or hexadecimal.");
                    }
                } catch (NumberFormatException e) {
                    System.out.println("Invalid number for the selected base");
                }
            } else {
                System.out.println("Invalid base. Enter binary, decimal, octal, or hexadecimal");
            }
        } else {
            System.out.println("Invalid base. Enter binary, decimal, octal, or hexadecimal");
        }
    }
}
