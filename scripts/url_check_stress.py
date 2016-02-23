import subprocess
for i in range (3071):
    cl = "curl http://11.11.11.4/dir-%04d/x" % (i)  +  " -X GET"
    print (cl)
    #subprocess.run(cl, stdout=subprocess.PIPE, shell=True) 
