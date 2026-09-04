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
# ASCII-to-Decimal Converter:
# Number-Base Converter:
# Image-to-Pixel Converter:
# Pixel-to-Image Converter:

## AI Acknowledgement
