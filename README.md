# DaVinci-Resolve-Converter
A script you can run if you have FFMPEG installed which converts all files in a folder of your choosing to a codec & audio format which DaVinci Resolve Studio can read.

Specifically, it converts to h.265, and .WAV. This was all vibe-coded with Gemini 2.5 Flash and GPT-OSS-20b. Here are it's features:

- It automatically detects the quality of the clip and matches it for you. No need need to adjust any settings!
- The files it outputs exactly match the sizes of the inputted files.
- It finds the input folder and loops through each video file within it, until it has transcoded all files. It transfers it all into the folder of your choosing.
- There are trackers for the percentage of the clip completed and how many clips are left to complete.
- You can make it generate a log file if you want.
- The input and output files are easy to change. You can do this at the top of file.

NOTE - I'm 99% sure this doesn't work with regular DaVinchi Resolve. You'll need to ask an LLM to convert it to DNxHD for that and, what can I say? Have fun with that file size.

Either run it as a .bash file, or simply copy-paste in Konsole. I do not know if it works on Windows, nor am I ever going to test that. This is very much a take it and use it how it is or leave it type of deal. Or, if you're interested in tinkering with this because you understand FFMPEG and Konsole lingo, don't let me stop you. Happy converting!
