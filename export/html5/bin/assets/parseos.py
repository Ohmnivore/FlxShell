import json, os, sys

parentdir = os.path.dirname(os.path.abspath(sys.argv[0]))
sys.path.insert(0,parentdir)
mypath = os.path.normpath(os.path.dirname(os.path.abspath(sys.argv[0])))

fs = {"FlxOS": {}}

def list_files(startpath):
    for root, dirs, files in os.walk(startpath):
        level = root.replace(startpath, '').count(os.sep)
        indent = ' ' * 4 * (level)
        print('{}{}/'.format(indent, os.path.basename(root)))
        subindent = ' ' * 4 * (level + 1)
        for f in files:
            print('{}{}'.format(subindent, f))


def list_files2(startpath):
    for dirname, dirnames, filenames in os.walk(startpath):
        # print path to all subdirectories first.
        #for subdirname in dirnames:
        #print os.path.join(dirname)
        #if len(os.path.normpath(dirname).split(os.sep)) > 1:
        #print os.path.basename(os.path.normpath(dirname))
        #print dirname[len(mypath)+1:-len(os.path.basename(os.path.normpath(dirname)))]
        getparent(dirname[len(mypath)+1:-len(os.path.basename(os.path.normpath(dirname)))])[os.path.basename(os.path.normpath(dirname))] = {}

        # print path to all filenames.
        for filename in filenames:
            #print os.path.join(dirname, filename)
            #fs[dirname] = filename
            getparent(dirname[len(mypath)+1:])[filename] = open(os.path.join(dirname, filename), 'r').read()


def getparent(path):
    global fs
    comp = os.path.normpath(path).split(os.sep)
    #print comp
    p = fs
    x = 1
    if len(comp) > 1:
        while x < len(comp):
            p = p[comp[x]]
            x += 1
    #print p
    return p


list_files2(os.path.join(mypath, "FlxOS"))

json.dump(fs, open(os.path.join(mypath, 'FlxOSjson.txt'), 'w'))
print 'Succeeded!'