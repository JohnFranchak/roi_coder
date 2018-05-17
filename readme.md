# Dynamic ROI Coder for Matlab v0.2

www.github.com/JohnFranchak/roi_coding  
John Franchak (franchak@gmail.com)  
www.padlab.ucr.edu  
updated 5-17-2018

## Features
User interface for annotating regions of interest (ROIs) on video frames for eye tracking or computer vision analysis. Included tool ('extract_frames.m') creates directory of video frames from quicktime-compatiable video files for coding. 

Feature list:
- Extract/read directories of sequential .jpg files
- Play/rewind/step through video frames
- Click/drag to create rectangular ROIs on frames
- Flexible keyboard controls for fine-tuning ROIs
- Save/load multiple .csv files for different ROI coding sets
- Autosave
- Visualization of coded/uncoded regions  

Full user guide: https://github.com/JohnFranchak/roi_coder/wiki

## Requirements
### Hardware/Software
Compatible with Matlab 2014a and greater on Windows and Mac (other versions/platforms may be compatible but have not been tested). Full-size keyboard (with number pad) is required for some keyboard-only commands, but the software is usable with a limited keyboard.

### Video/Image Files
The software reads a single directory of sequential .jpg files using one of the following naming schemes:

|Format 1|Format 2|Example|  
|---  |---  |--- |    
|1.jpg|\*\_1.jpg|subj1\_1.jpg|  
|2.jpg|\*\_2.jpg|subj1\_2.jpg|  
|3.jpg|\*\_3.jpg|subj1\_3.jpg|  

If you have a video file that needs to be converted to frames, use the included `extract_frames.m` tool to create a compatible frame directory. 

## Installation/Setup
Unzip and copy the 'roi_coding' directory to your system.
Open Matlab and navigate to the 'roi_coding' directory.
Run the coding software by entering the `roi_coder` command in the console. 
To shut down, simply close the figure (be sure to save data first).

## Limitations/Known Issues
- Only one type of ROI can be coded/visualized at a time
- Must close the software and reopen to switch between ROIs
- Only rectangular ROIs are supported
- Out of image coordinates are possible if users drag ROI boxes off the edge of an image
- Only standard definition images have been tested
- The application size is currently fixed and cannot be resized.

## Attribution/Legal
This software is open source. You are free to modify it to fit your needs and to use it for any purpose.   
If you choose to use this software in an academic project, please cite the project website: github.com/JohnFranchak/roi_coding

### License for this software
ROI Coder for Matlab by 
Copyright (C) 2018 by John Franchak

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see https://www.gnu.org/licenses/.

### License for third-party functions
Natural sort function `sort_nat.m`
Copyright (c) 2008, Douglas M. Schwarz 
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are 
met:

* Redistributions of source code must retain the above copyright 
notice, this list of conditions and the following disclaimer. 
* Redistributions in binary form must reproduce the above copyright 
notice, this list of conditions and the following disclaimer in 
the documentation and/or other materials provided with the distribution

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
