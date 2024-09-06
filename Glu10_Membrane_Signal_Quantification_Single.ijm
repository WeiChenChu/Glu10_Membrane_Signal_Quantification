/* ImageJ Macro written by Wei-Chen CHU
    ICOB Imaging Core, Academia Sinica
 	2022.5.31
 */

Erode_Cycle=10;

roiManager("reset");
run("Set Measurements...", "area mean min centroid center integrated display redirect=None decimal=2");

input=getTitle();
title_length = lengthOf(input);
main_file_name= substring(input, 0, title_length-4);
output=getDirectory("Choose folder for the result output");

//run("Enhance Contrast...", "saturated=0.35");
run("Duplicate...", "duplicate channels=1");
run("Z Project...", "projection=[Sum Slices]");
rename(main_file_name + "_SUM");
run("Enhance Contrast...", "saturated=0.35");
run("Duplicate...", "title=Mask_1");
run("Gaussian Blur...", "sigma=2");
setAutoThreshold("Huang dark");
//run("Threshold...");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Fill Holes");
run("Analyze Particles...", "size=50-Infinity show=Masks clear");
selectWindow("Mask of Mask_1");
rename("Mask_C");

run("Duplicate...", "title=Mask_2");
//run("Control Panel...");

for (i=0; i<Erode_Cycle;i++){
	run("Erode");
}
	
imageCalculator("Subtract create", "Mask_C","Mask_2");

selectWindow("Result of Mask_C");
run("Create Selection");
roiManager("Add");
selectWindow("Result of Mask_C");
roiManager("Select", 0);
roiManager("Rename", "Cell_membrane");


selectWindow("Mask_C");
run("Create Selection");
roiManager("Add");
roiManager("Select", 1);
roiManager("Rename", "Whole_Cell");


selectWindow("Mask_2");
run("Create Selection");
roiManager("Add");
roiManager("Select", 2);
roiManager("Rename", "Cytosol");


selectWindow(main_file_name + "_SUM");
roiManager("Deselect");
roiManager("Measure");
roiManager("save", output + main_file_name + ".zip");
saveAs("results", output + main_file_name + ".csv");


selectWindow("Mask_1");
close();
selectWindow("Mask_2");
close();
selectWindow("Mask_C");
close();
selectWindow("Result of Mask_C");
close();
