# File-Integrity-Monitoring
Performed the following tasks:

Created a custom/proof of concept File Integrity Monitor (FIM)

Continuously made comparison on actual files vs baseline, raised alerts if any deviations occurred.

Sent alert x-alert via y-means to allow further investigation on potential compromise.

Ask user what they want to do:  Collect new baseline or begin monitoring files with saved Baseline. Collect new Baseline: Calculate HASH value from target files.

Store the file/hash pairs in baseline.txt

Begin monitoring files with saved Baseline: Load file: hash pairs from baseline.txt
Continuously monitor file integrity Loop through each file target file, calculate the hash, and compare the file/hash to what is baseline.txt.

Notify the user if a file is changed or deleted. If a file's actual hash is different that what is recorded in the baseline, print to the screen,
if a  file has been changed or deleted → integrity compromise.


