//: Playground - noun: a place where people can play

/*
Instructions

In this assignment you will be creating customizable photo filters. The filters will be applied to a sample image that has been provided for you.
    
Instructions
Your Playground code should fulfill the following project requirements:

Be able to apply a filter formula to each pixel of the image.
The formula should have parameters that can be modified so that the filter can have a small or large effect on the image.
Be able to apply several different filters to the image, in a specific order (e.g. a ‘pipeline of filters’). These could be different formulas (e.g. brightness vs. contrast) or could be the same formula with different parameters.
Have some method or interface to apply default filter formulas and parameters that can be accessed by name.

The fun part is that you may decide for yourself exactly what type of calculations you would like to apply to the image pixels – e.g. brightness, contrast, gray-scale, etc. You may want to look up more advance calculations on the Internet for ideas. But a simple formula like the one covered in the Image Processing lecture is fine.

You must also decide on the exact architecture of the ‘app'. Try to break up the code into logical functional parts using structs and classes, wherever you think it’s most appropriate. To get you started, we recommend you think about implementing an ImageProcessing class/struct that can manage and apply your Filter class/struct instances to the image.


DONE - STEP 1: We provide an image and starter code
• In this assignment we are providing the starter code.
• Download the starter project (download link will be provided in the peer assessment section)

DONE - STEP 2: Create a simple filter
• Start by writing some code to apply a basic filter formula to each pixel in the image and test it.

STEP 3: Create the image processor
• Encapsulate your chosen Filter parameters and/or formulas in a struct/class definition.
• Create and test an ImageProcessor class/struct to manage an arbitrary number Filter instances to apply to an image. It should allow you to specify the order of application for the Filters.
    
STEP 4: Create predefined filters
• Create five reasonable default Filter configurations (e.g. "50% Brightness”, “2x Contrast”), and provide an interface to access instances of such defaults by name. (e.g. could be custom subclasses of a Filter class, or static instances of Filter available in your ImageProcessor interface, or a Dictionary of Filter instances). There is no requirement to do this in a specific manner, but it’s good to think about the different ways you could go about it.

STEP 5: Apply predefined filters
• In the ImageProcessor interface create a new method to apply a predefined filter giving its name as a String parameter. The ImageProcessor interface should be able to look up the filter and apply it.


SUBMISSION: Zip your .playground file and upload it to your submission. Your peer reviewers will download your zipped file and test in their playground.

TIP: Playgrounds are a safe space, they can only access the files within the playground (you cannot access files outside of the playground).


Review Criteria
To evaluate your peers in the best way possible, you should briefly review the work of your peers using the buttons near the top of this screen before giving scores and feedback on any of them. This will help open your eyes to what others have done.

You will be asked to provide feedback to your peers in the following areas:


DONE Does the playground code apply a filter to each pixel of the image? Maximum of 2 pts

DONE Are there parameters for each filter formula that can change the intensity of the effect of the filter? Maximum of 2 pts

Is there an interface to specify the order and parameters for an arbitrary number of filter calculations that should be applied to an image? Maximum of 2 pts

Is there an interface to apply specific default filter formulas/parameters to an image, by specifying each configuration’s name as a String? Maximum of 2 pts


LANGUAGE: Submissions must be in English.
*/

/////////////////////////////////////////////
/////////////////////////////////////////////

import UIKit

let image = UIImage(named: "sample.png")!

// Process the image!

// first, let's convert the file to an RGBAImage so we can make changes that we want: 

var myRGBA = RGBAImage(image : image)!

// next, i need to keep track of where I am in the image. i'll use a row-major index, meaning row 1 has index 0 - 74, row 2 has index 75-149, and so on

let x = 10
let y = 10
let index = y * myRGBA.width + x

// the pixel we are on is given by our index in myRGBA
var pixel = myRGBA.pixels[index]

// the red, green, and blue value of each pixel is given: 
pixel.red
pixel.green
pixel.blue

// I'll implement all of my filters by extending the RGBAImage class to include all of the defined filters that follow

// So I'd like to make a black and white filter. But our image is an RGBA image. It has three values representing the color of a pixel. I'd like to take those values and somehow merge them into one. There are a few ways of doing this. The most logical way would be to just average all the values and report that as a grayscale value. Another way is to filter by channel - meaning I select either the red, green, or blue channel and set that channel as the grayscale value for the pixel.

// I'll first start with the averaging method. For each pixel, I need to find the average of the channels, and then set ALL the channels to this average. The reason I'm setting all the channels to the same value is that this is how you produce a shade of gray.

// added a second parameter intensity to somehow account for how aggressive the averaging filter is

func averagingBWfilter(image : RGBAImage) -> RGBAImage
{
    
    for y in 0..<myRGBA.height
    {
        for x in 0..<myRGBA.width
        {
            let index = y * myRGBA.width + x // tracks which pixel we're on in the image
            var pixel = myRGBA.pixels[index]
            let averageBrightness = (Int(pixel.red) + Int(pixel.green) + Int(pixel.blue)) / 3
            pixel.red = UInt8(averageBrightness)
            pixel.green = UInt8(averageBrightness)
            pixel.blue = UInt8(averageBrightness)
            myRGBA.pixels[index] = pixel
        
        }
    }
    return myRGBA
}

// that worked out pretty nicely! next, lets make a BW filter based on the red channel alone:

func redBWfilter(image : RGBAImage) -> RGBAImage
{
    for y in 0..<myRGBA.height
    {
        for x in 0..<myRGBA.width
        {
            let index = y * myRGBA.width + x // tracks which pixel we're on in the image
            var pixel = myRGBA.pixels[index]
            pixel.green = pixel.red
            pixel.blue = pixel.red
            myRGBA.pixels[index] = pixel
        }
    }
    return myRGBA
}

// next, lets filter based on the green channel alone

func greenBWfilter(image : RGBAImage) -> RGBAImage
{
    
    for y in 0..<myRGBA.height
    {
        for x in 0..<myRGBA.width
        {
            let index = y * myRGBA.width + x // tracks which pixel we're on in the image
            var pixel = myRGBA.pixels[index]
            pixel.red = pixel.green
            pixel.blue = pixel.green
            myRGBA.pixels[index] = pixel
        }
    }
    return myRGBA
}

// finally lets filter on the blue channel alone

func blueBWfilter(image : RGBAImage) -> RGBAImage
{
    for y in 0..<myRGBA.height
    {
        for x in 0..<myRGBA.width
        {
            let index = y * myRGBA.width + x // tracks which pixel we're on in the image
            var pixel = myRGBA.pixels[index]
            pixel.red = pixel.blue
            pixel.green = pixel.blue
            myRGBA.pixels[index] = pixel
        }
    }
    return myRGBA
}

// Now let's write a function that will allow you to control each channel independently
// the user can enter whatever integer values greater than or equal to 0 for relative weighting, and the program will automatically weight the image according to the user input

func adjustableBWfilter(inputImage : RGBAImage, var redWeight : Int, var greenWeight : Int, var blueWeight : Int) -> RGBAImage
{
    // first, i need to account for invalid integers
    if (redWeight < 0)
    {
        redWeight = 0
    }
    
    if (greenWeight < 0)
    {
        greenWeight = 0
    }
    
    if (blueWeight < 0)
    {
        blueWeight = 0
    }
    
    let total = redWeight + greenWeight + blueWeight
    
    
    for y in 0..<inputImage.height
    {
        for x in 0..<inputImage.width
        {
            let index = y * inputImage.width + x // tracks which pixel we're on in the image
            var pixel = inputImage.pixels[index]
            let finalWeight = (Int(pixel.red) * redWeight + Int(pixel.green) * greenWeight + Int(pixel.blue) * blueWeight) / (total)
            pixel.red = UInt8(finalWeight)
            pixel.green = UInt8(finalWeight)
            pixel.blue = UInt8(finalWeight)
            inputImage.pixels[index] = pixel
        }
    }
    return inputImage
    
}

func yAxisEdgeDetection(inputImage : RGBAImage) -> RGBAImage
{
    // first convert to black and white
    averagingBWfilter(inputImage)
    
    // initializes an output image. Starts with a fresh copy of sample.png
    var outputImage = UIImage(named: "sample.png")
        
    // differentiates each adjacent pixel. Since each pixel is a height of 1, I omitted the division process here (I'd just be dividing the pixelDifference by 1)
    for y in 0..<(inputImage.height)
    {
        let index = y * inputImage.width + x // tracks which pixel we're on in the image
        let pixelValueInt32 = Int(inputImage.pixels[index].value)
        let nextPixelValueInt32 = Int(inputImage.pixels[index + 1].value)
        let pixelDifference = abs(nextPixelValueInt32 - pixelValueInt32)
//        pixel.red = UInt8(pixelDifference)
//        pixel.green = UInt8(pixelDifference)
//        pixel.blue = UInt8(pixelDifference)
    }
    
    outputImage = RGBAImage(image: inputImage)!c
    return outputImage
}

// Not sure what the issue is with the edge detection function here. I tried casting as a UInt32 and then doing the subtraction within abs() but I still get this same error. I should try rebuilding the function line by line to isolate the error next.
yAxisEdgeDetection(myRGBA)

averagingBWfilter(myRGBA)
let averageBWImage = myRGBA.toUIImage()

myRGBA = RGBAImage(image : image)!
redBWfilter(myRGBA)
let redBWImage = myRGBA.toUIImage()

myRGBA = RGBAImage(image : image)!
greenBWfilter(myRGBA)
let greenBWImage = myRGBA.toUIImage()

myRGBA = RGBAImage(image : image)!
blueBWfilter(myRGBA)
let blueBWImage = myRGBA.toUIImage()

myRGBA = RGBAImage(image : image)!
adjustableBWfilter(myRGBA, redWeight: 1, greenWeight: 1, blueWeight: 1)
let adjustableBWImage = myRGBA.toUIImage()

myRGBA = RGBAImage(image : image)!
adjustableBWfilter(myRGBA, redWeight: 1, greenWeight: 0, blueWeight: 0)
let adjustableBWImageRed = myRGBA.toUIImage()

myRGBA = RGBAImage(image : image)!
adjustableBWfilter(myRGBA, redWeight: 0, greenWeight: 1, blueWeight: 0)
let adjustableBWImageGreen = myRGBA.toUIImage()

myRGBA = RGBAImage(image : image)!
adjustableBWfilter(myRGBA, redWeight: 0, greenWeight: 0, blueWeight: 1)
let adjustableBWImageBlue = myRGBA.toUIImage()
