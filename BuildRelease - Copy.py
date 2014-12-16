"""
Builds a release of vk_markers using current build number in changelog.txt.
PBOs, signs, checks, packs, and zips.
"""

import sys, re, os, time, shutil, zipfile, datetime

date = datetime.date.today().isoformat()
dtg = str(datetime.datetime.now().day)+str(datetime.datetime.now().hour)+str(datetime.datetime.now().minute)

uo = False
test = False

workDir = "p:/x/vk_mods/addons/Arma 3/"
keyDir = "p:/x/vk_mods/keys/"
releaseDir = "p:/x/vk_mods/Releases/Arma 3/"

#Preparing
print("UO, Public, or Test release?")
response = input().lower()
if response in {"u","uo"}:
    uo = True
elif response in {"t","te","tes","test"}:
    test = True

if uo or test:
    with open("CfgMarkers.hpp") as t:
        conf0 = t.read()
    line = re.search(r"^(.*)\n\t// Python insert here\n(.*)",conf0,re.MULTILINE).span()[0]+5
    conf1 = conf0[:line]
    conf2 = conf0[line:]
    with open("CfgMarkers.hpp","w") as t:
        t.write(conf1)
        t.write('\n\t#include "CfgMarkersUO.hpp"')
        t.write(conf2)
else:
    os.chdir(workDir)
    with open("markers/readme.txt") as t:
        readmeBase = t.read()
    with open("changelog.txt") as t:
        clog = t.read()
    readme = readmeBase + "\n\n"+clog
    version = re.findall(r"^([0-9]{3})", clog, re.MULTILINE)[-1]
    currentReleaseDir = releaseDir+"Release {} - {}/".format(version,date)
    
    if os.path.isdir(currentReleaseDir):
        print("Release directory for version {} already exists. Overwrite?".format(version))
        response = input().lower()
        if response not in {"yes","ye","y"}:
            sys.exit()
    else:
        os.mkdir(currentReleaseDir)

    if not os.path.isdir(currentReleaseDir+"keys"):
        os.mkdir(currentReleaseDir+"keys")

#PBOing
if test:
    name = "vk_markers_a3_test_{}.pbo".format(dtg)
else:
    name = "vk_markers_a3.pbo"
os.chdir(workDir)
os.system('makepbo -Z "any" markers '+name)
time.sleep(1)

if uo or test:
    with open("CfgMarkers.hpp","w") as t:
        t.write(conf0)
else:
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
