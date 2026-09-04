# Assignment 1: Converter and Pixel System (CS 240)

## Overview

In Assignment 1, we were tasked with programming and testing four tasks: building an ASCII-to-decimal converter, building a number-base converter supporting binary, decimal, octal, and hexadecimal values, writing a program that reads an image and prints its pixel values, and writing a program that takes in pixel values and converts it into an image. 

## ASCII-to-Decimal Converter

When the ASCII-to-decimal converter is initially run, the terminal first asks the user what they want to convert from ASCII to decimal, whether it is a letter, number, sentence, phrase, etc. The converter will then proceed to give out the decimal values of each character line-by-line in the given input.

## Number-Base Converter

With the number-base converter, the terminal first requests the user what base they want to convert from, whether it is binary, decimal, octal, or hexadecimal. Similarly in the next step, the terminal asks the user what base they want to convert to. Following that, the user will then input the actual number they want to convert between number-bases and the program will then output the number in the converted form. If the user enters an invalid base, an IOException will occur, and if the user enters an invalid number for the selected base, a NumberFormatException will occur.

## Image-to-Pixel Converter

When run, the image-to-pixel converter begins by asking the user to input the file name of the image they want to pull the pixels from. An important thing to note is that before proceeding, the user should first change the directory into the folder that their desired image is located in. The program will then read the image and write the hex code of every single pixel in the image in a newly created output .txt file.

## Pixel-to-Image Converter

The pixel-to-image converter essentially runs the opposite way of the image-to-pixel converter. The terminal first asks the user to input their desired width of the output image, and then immediately after, their desired height as well. The program also prompts the user for the name of the existing .txt file containing all of the hexcode values being translated into an image and as well as the desired filename for the output .png image. When finished, the program will produce a .png image as specified by the user and input .txt file.

## Test Evidence/Screenshots/Generated Images
## ASCII-to-Decimal Converter:
<p align="left"> <img width="467" height="198" alt="ASCII-to-Decimal Converter in Action" src="https://github.com/user-attachments/assets/00beb2f1-2d7f-4aaf-ada5-e2a4b036e34c" /> </p>
## Number-Base Converter:
Binary to Decimal:
<p align="left"> <img width="722" height="100" alt="Binary to Decimal Conversion" src="https://github.com/user-attachments/assets/db9ef8f2-b3ec-4504-83e3-b02f0aed67ca" /> </p>
Hexadecimal to Octal:
<p align="left"> <img width="719" height="101" alt="Hexadecimal to Octal Conversion" src="https://github.com/user-attachments/assets/e5e7b4e4-0822-4969-85b0-9c394f6829ae" /> </p>
Zero (Octal to Decimal):
<p align="left"> <img width="721" height="99" alt="Zero (0) Conversion from Octal to Decimal" src="https://github.com/user-attachments/assets/e38726a0-0596-40d8-97ae-bc16209840c7" /> </p>
Largest Supported Unsigned Value (4294967295, Decimal to Binary):
<p align="left"> <img width="721" height="99" alt="Largest Support Unsigned Value (4294967295) Conversion from Decimal to Binary" src="https://github.com/user-attachments/assets/1d6593d8-f133-4019-91e3-6cce2d3f1d79" /> </p>
Negative Two’s-Complement Value (-1, Decimal to Hexadecimal):
<p align="left"> <img width="719" height="101" alt="Negative Two's-Complement Value (-1) Conversion from Decimal to Hexadecimal" src="https://github.com/user-attachments/assets/5aace721-5510-468c-b866-0265160802ef" /> </p>
## Image-to-Pixel Converter:
<p align="left"> <img width="688" height="80" alt="Image-to-Pixel Converter in Action" src="https://github.com/user-attachments/assets/94a3c89e-6bf9-473f-844e-58fe4948dc33" /> </p>
Input Image (blue.png (5x5)):
<p align="left"> <img width="693" height="267" alt="blue.png, the input image" src="https://github.com/user-attachments/assets/dc7542ad-78a7-4067-9fe9-ae166008c6b1" /> </p>
Output File (bluepixels.txt):
<p align="left"> <img width="629" height="402" alt="bluepixels.txt, the output file" src="https://github.com/user-attachments/assets/178ba553-eea1-43a4-aed0-e41f0d33b03a" /> </p>
## Pixel-to-Image Converter:
<p align="left"> <img width="691" height="114" alt="Pixel-to-Image Converter in Action" src="https://github.com/user-attachments/assets/6cd1b0f6-2fd1-46c5-8cbb-c55042085c3d" /> </p>
Input File (bluepixels.txt):
<p align="left"> <img width="636" height="411" alt="bluepixels.txt, the input image" src="https://github.com/user-attachments/assets/e87e0f1c-d08f-44b3-a6cd-6b6e6591a634" /> </p>
Output Image (bluenew.png (5x5)):
<p align="left"> <img width="691" height="268" alt="bluenew.png, the output image" src="https://github.com/user-attachments/assets/b7d70b1b-8157-4ed9-9815-10fef4b5a937" /> </p>

## AI Acknowledgement
