import java.util.Scanner;
import java.io.File;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
public class pixelImageConverterHw1 {
    public static void main(String[] args) {
        // Write a program that consumes pixel values and creates an image.
        Scanner scnr = new Scanner(System.in);
        System.out.println("Pixel to image converter: Enter desired image width");
        int width = scnr.nextInt();
        System.out.println("Pixel to image converter: Enter desired image height");
        int height = scnr.nextInt();
        System.out.println("Pixel to image converter: Enter filename of .txt file containing hexadecimal values");
        String inputFileName = scnr.next();
        File inputFile = new File(inputFileName);
        System.out.println("Pixel to image converter: Enter desired output file name");
        String outputFileName = scnr.next();
        File outputFile = new File(outputFileName);
        BufferedImage outputImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
        try {
            Scanner fileScnr = new Scanner(inputFile);
            for (int i = 0; i < width; i++) {
                for (int j = 0; j < height; j++) {
                    String pixelColor = fileScnr.next();
                    int rgb = Integer.parseUnsignedInt(pixelColor, 16);
                    outputImage.setRGB(i, j, rgb);
                }   
            }
            fileScnr.close();
            ImageIO.write(outputImage, "png", outputFile);
        } catch (FileNotFoundException e) {
            System.out.println("File cannot be found. Please try again.");
        } catch (IOException e) { 
            System.out.println("Cannot create image file.");
        }
    }   
}
