import sys
import os

#TODO possible arg : custom package search path
#TODO possible arg : suppress print


# for default - add run direcory to path :
try:
    pp = os.path.abspath(os.path.dirname(sys.argv[0]))
    print(" ### add to sys path " + pp)
    sys.path.append(pp)
except:
    try:
        print("Failed add run directory to path : " + sys.argv[0])
    except:
        print("Failed add run directory to path")

print( " ### run with sys path : " + str(sys.path))
