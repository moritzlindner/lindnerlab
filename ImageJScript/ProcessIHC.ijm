var dir = "D:\\Projekte\\KCNE2\\IHC\\Figures\\tmp";
var resolution = 300
var target = 471

path = File.openDialog("Select Input image");
open(path);
dir = File.directory();
fn = substring(getTitle(),0,indexOf(getTitle(),"."));
prev=getTitle();
run("Arrange Channels...");
waitForUser("Drop poor quality sections and then close this dialog.");
run("32-bit");
//run("Z Project...", "projection=[Sum Slices]");
//close(prev);
run("Brightness/Contrast...");
waitForUser("Adjust brightness and contrast and then close this dialog.");
prev=getTitle();
run("Make Composite");
waitForUser("Brightness and contrast OK?");
run("Stack to RGB");
close(prev);
setTool("rectangle");
waitForUser("Select cropping area if required and then close this dialog.");
//if(is("area")==true){
//	run("Crop");
//	}
// general settings
prev=getTitle();
run("Scale...", "x=- y=- width="+target+" height="+target+" interpolation=Bilinear average create");
close(prev);
run("Scale Bar...", "width=10 height=4 font=14 color=White background=None location=[Lower Right] bold hide overlay");
run("Flatten");
run("Set Scale...", "distance="+resolution+" known=1 pixel=1 unit=inch");
saveAs("Tiff", dir+"\\"+fn+"_full.tif");
close();
run("RGB Stack");
run("Stack to Images");
selectWindow("Blue");
close("Blue");
selectWindow("Red");
run("16-bit");
run("Red");
run("Scale Bar...", "width=10 height=4 font=14 color=White background=None location=[Lower Right] bold hide overlay");
run("Flatten");
run("Set Scale...", "distance="+resolution+" known=1 pixel=1 unit=inch");
saveAs("Tiff", dir+"\\"+fn+"_Red.tif");
close(fn+"_Red.tif");
close("Red");
selectWindow("Green");
run("16-bit");
run("Green");
run("Scale Bar...", "width=10 height=4 font=14 color=White background=None location=[Lower Right] bold hide overlay");
run("Flatten");
run("Set Scale...", "distance="+resolution+" known=1 pixel=1 unit=inch");
saveAs("Tiff", dir+"\\"+fn+"_Green.tif");
close(fn+"_Green.tif");
close("Green");