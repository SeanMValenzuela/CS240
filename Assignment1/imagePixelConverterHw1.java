import java.io.File;
import java.io.IOException;
import java.util.Scanner;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.PrintWriter;
public class imagePixelConverterHw1 {
    public static void main(String[] args) {
    // Write a program that reads an image and prints its pixel values.
        Scanner scnr = new Scanner(System.in);
        try {
            System.out.println("Image to pixel converter: Enter filename of desired image you want to convert");
            String fileName = scnr.next();
            File imageFile = new File (fileName);
            System.out.println("Image to pixel converter: Enter desired filename of .txt output file (include .txt at the end)");
            String outputName = scnr.next();
            PrintWriter writer = new PrintWriter(outputName);
            BufferedImage image = ImageIO.read(imageFile);
            int imgHeight = image.getHeight();
            int imgWidth = image.getWidth();
            for (int i = 0; i < imgWidth; i++) {
                for (int j = 0; j < imgHeight; j++) {
                    int pixelColor = image.getRGB (i, j);
                    String hexColor = String.format("%08X", pixelColor);
                    writer.print(hexColor);
                    writer.print (" ");
                }
                writer.print("\n");
            }
            writer.close();
        } catch (IOException e) {
            System.out.println("Unable to read file. Try again.");
        }
    }    
}
