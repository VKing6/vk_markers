"""
Builds a release of vk_markers using current build number in changelog.txt.
PBOs, signs, checks, packs, and zips.
"""

import datetime
import os
import time
"""
#import sys
#import shutil
#import zipfile
"""

uo = False
test = False

workDir = "p:/x/vk_mods/addons/Arma 3/"
keyDir = "p:/x/vk_mods/keys/"
releaseDir = "p:/x/vk_mods/Releases/Arma 3/"

name = "vk_markers_a3_test_{0:0>2}{1:0>2}{2:0>2}.pbo".format(
    datetime.datetime.now().day, datetime.datetime.now().hour, datetime.datetime.now().minute)

os.chdir(workDir)
os.system('makepbo -Z "any" -X "*.hpp" markers '+name)

"""
time.sleep(1)

    #Signing
    os.chdir("D:/Program Files (x86)/Bohemia Interactive/Tools/BinPBO Personal Edition/DSSignFile")
    os.system('dssignfile "'+keyDir+'vk_markers_a3.biprivatekey" "'+workDir+'vk_markers_a3.pbo"') 
    time.sleep(1)

    #Checking
    os.chdir("D:/Program Files (x86)/Bohemia Interactive/Tools/DSUtils")
    os.system('dschecksignatures "'+workDir+'" "'+keyDir+'"')

    #Packing
    os.chdir(workDir)
    shutil.move("vk_markers_a3.pbo", currentReleaseDir+"vk_markers_a3.pbo")
    shutil.move("vk_markers_a3.pbo.vk_markers_a3.bisign", currentReleaseDir+"vk_markers_a3.pbo.vk_markers_a3.bisign")
    shutil.copyfile(keyDir+"vk_markers_a3.bikey", currentReleaseDir+"keys/vk_markers_a3.bikey")

    with open(currentReleaseDir+"Readme.txt","w") as t:
        t.write(readme)

    #Zipping
    os.chdir(currentReleaseDir)
    zipName = "vk_markers_a3_{}.zip".format(version)

    if zipName in os.listdir():
        os.remove(zipName)
    
    zz = zipfile.ZipFile(zipName,"w")
    zz.write("keys/vk_markers_a3.bikey")
    for file in os.listdir():
        if ".zip" not in file:
            zz.write(file)
    zz.close()
"""
