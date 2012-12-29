#!/usr/bin/python
# example usage:
# mylib.rename("/home/assaf/Downloads/Mad Men Season 4","*.avi","%s", 0 [2,3])
import glob, os

def rename(dir, pattern, titlePattern, do_rename=False, num_list=[]):
    print "Rename-util - " + ("dry run" if do_rename==False else "real run") + "\n"
    index=0
    for pathAndFilename in sorted(glob.glob(os.path.join(dir, pattern))):
        title, ext = os.path.splitext(os.path.basename(pathAndFilename))
        from_str = titlePattern % title + ext
        if num_list ==[]:
            to_str = 'madmen5%02d.avi' % (index+1)
        else:
            to_str = 'madmen5%02d.avi' % num_list[index]
        index+=1
        print 'FROM: '+ (from_str).ljust(75) + 'TO:' + (to_str).rjust(30)
        if do_rename==True:
            os.rename(os.path.join(dir, from_str), os.path.join(dir, to_str))

