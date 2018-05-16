# Dynamic ROI Coder for Matlab

github.com/JohnFranchak/roi_coding
John Franchak (franchak@gmail.com)
padlab.ucr.edu
last updated 5-16-2018

## Features
User interface for annotating regions of interest (ROIs) on video frames for eye tracking or computer vision analysis. Included tool ('extract_frames.m') creates directory of video frames from quicktime-compatiable video files for coding. 

Current features:
- Load directories of numbered .jpg files
- Play/rewind/step through video frames
- Click/drag to create rectangular ROIs on frames
- Flexible keyboard controls for fine-tuning ROIs
- Save/load multiple .csv files for different ROI coding sets
- Autosave coding
- Visualization of coded/uncoded regions

## Requirements
Compatible with Matlab 2014a and greater on Windows and Mac (other versions/platforms may be compatible but have not been tested).

## Installation/Setup
Unzip and copy the 'roi_coding' directory to your system.
Open Matlab and navigate to the 'roi_coding' directory.
Run the coding software by entering the `ROICoder` command in the console. 
To shut down, simply close the figure (be sure to save data first).

## Limitations/Known Issues
Limitations
- Only one type of ROI can be coded/visualized at a time
- Must close the software and reopen to switch between ROIs
- Only rectangular ROIs are supported
- Out of image coordinates are possible if users drag ROI boxes off the edge of an image

Known issues
- User interface may not display correctly on Windows
- The application size is currently fixed and cannot be resized. This may make it not display correctly on smaller (e.g., laptop) screens.

## License/Legal


