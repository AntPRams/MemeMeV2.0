# MemeMe V2.0

A project required by Udacity that serves the purpose of making a meme through a photo from the album or, if the device has the a camera available, through a photo.
The project was approved for the 3th module of the course.
It is a second version of the app with the additions of the UITableView and UICollectionView.

## Getting Started

This is the project of the 3th module in the Udacity iOS Dev Nanodegree to atest our capabilities of dealing with UIKit essentials.

The intentionality of the project served to learn how to define and know the purpose of delegates, tab bar controller, navigation controller and all essential components in the development of the user interface.

The app is used to make a Meme through a camera or a album photo and then share it using the UIActivityViewController

## UI Details

<img src=Images/MemeMeUI.png>

- **Root Screen**: There are four icons on screen, on the toolbar the user can choose between a UITableView or a UICollectionView to see the collection. The navigation bar has a icon disable in the top left corner, that icon is used to edit the collection (move and delete cells). The plus icon, is used to generate a new meme.

- **Meme Generator**: In the toolbar there are four icons, in the center the user can change the font, in the right the user can pick a image from the album and in the left use the camera to take a photo. In the navigation bar the meme generator can be dismissed with the left icon and in the right corner the share button will be enabled when the user selects a picture. 

- **Collection Views**: A example of both views with memes already saved.

- **Edit Meme Screen**: When the user tap a cell in a collection he will be presented with the option of editing the meme, as you can see, the camera and the album button is hidden because the option of editing a meme resides on editing the text and font. Also, when the user finishes he can choose between sharing the new meme and update the meme that’s already in the collection or just update it. The alert view that presented the options is a custom alert made with a ViewController.

### Prerequisites

Mac OS X 10.14

xCode 10.xx

### Installing

Use **Git Clone** to copy the project:

```

git clone https://github.com/Ardevlp/MemeMeV2.0.git
cd ../MemeMeV2.0
open MemeMeV2.0.xcodeproj

```


## Know issues 

- When the user have the iPhone in landscape mode if he pick an image it will not fit perfectly between the toolbar and the navigation bar, the user needs to change it to portrait and then to landscape again to center the image.

## Built With

* [xCode 10.2](https://developer.apple.com/xcode/) 

## License

This project is licensed under the GNU General Public License v3.0 License - see the [LICENSE.md](LICENSE.md) file for details
 
